import streamlit as st
from db import get_connection
import pandas as pd
import json
from billing_utils import calculate_gst, generate_invoice_pdf

# ----- PAGE CONFIG -----
st.set_page_config(page_title="Customer Portal", layout="wide")
st.sidebar.title("📱 Customer Portal")

# ----- SESSION STATE -----
if 'customer_id' not in st.session_state:
    st.session_state.customer_id = None

# ----- AUTH TABS -----
if st.session_state.customer_id is None:
    tab1, tab2 = st.tabs(["🔐 Login", "📝 Sign Up"])

    # ----- LOGIN PAGE -----
    with tab1:
        st.title("🔐 Customer Login")
        with st.form("login_form"):
            email = st.text_input("Email")
            phone = st.text_input("Phone Number")
            submitted = st.form_submit_button("Login")

            if submitted:
                conn = get_connection()
                cursor = conn.cursor()
                cursor.execute("""
                    SELECT customer_id, name 
                    FROM Customer 
                    WHERE email = %s AND phone_number = %s
                """, (email, phone))
                result = cursor.fetchone()

                if result:
                    st.session_state.customer_id = result[0]
                    st.success(f"✅ Welcome, {result[1]}!")
                    st.rerun()
                else:
                    st.error("❌ Invalid login credentials.")

    # ----- SIGNUP PAGE -----
    with tab2:
        st.subheader("New Customer Sign Up")
        with st.form("signup_form"):
            name = st.text_input("Full Name")
            email = st.text_input("Email (must be unique)")
            phone = st.text_input("Phone Number")
            address = st.text_area("Address")

            conn = get_connection()
            plans = pd.read_sql("SELECT plan_id, name FROM Subscription_Plan", conn)
            plan_names = dict(zip(plans['name'], plans['plan_id']))
            plan_choice = st.selectbox("Select a Plan", list(plan_names.keys()))

            register = st.form_submit_button("Register")

            if register:
                plan_id = plan_names[plan_choice]
                cursor = conn.cursor()
                try:
                    cursor.execute("""
                        INSERT INTO Customer (plan_id, name, email, phone_number, address)
                        VALUES (%s, %s, %s, %s, %s)
                    """, (plan_id, name, email, phone, address))
                    conn.commit()
                    st.success("✅ Account created! You can now log in from the Login tab.")
                except Exception as e:
                    st.error(f"❌ Could not register: {e}")

# ----- DASHBOARD PAGE -----
def dashboard_page():
    conn = get_connection()
    customer_id = st.session_state.customer_id

    query = """
    SELECT c.name, c.email, c.phone_number, c.address, sp.name AS plan_name,
           sp.data_limit, sp.call_limit, sp.sms_limit, sp.price
    FROM Customer c
    JOIN Subscription_Plan sp ON c.plan_id = sp.plan_id
    WHERE c.customer_id = %s
    """
    df = pd.read_sql(query, conn, params=[customer_id])

    if df.empty:
        st.error("Customer data not found.")
        return

    customer = df.iloc[0]
    st.title(f"👋 Hello, {customer['name']}")
    st.markdown("### 🧾 Customer Information")

    col1, col2 = st.columns(2)
    col1.write(f"**📧 Email:** {customer['email']}")
    col1.write(f"**📞 Phone:** {customer['phone_number']}")
    col2.write(f"**🏠 Address:** {customer['address']}")
    col2.write(f"**💼 Plan:** {customer['plan_name']}")

    st.markdown("### 📦 Plan Limits")
    kpi = st.columns(4)
    kpi[0].metric("Data (MB)", customer['data_limit'])
    kpi[1].metric("Calls", customer['call_limit'])
    kpi[2].metric("SMS", customer['sms_limit'])
    kpi[3].metric("₹ Price", customer['price'])

    usage_query = """
    SELECT usage_date, usage_summary
    FROM Usage_Data
    WHERE customer_id = %s
    ORDER BY usage_date DESC
    LIMIT 1
    """
    usage_df = pd.read_sql(usage_query, conn, params=[customer_id])

    if not usage_df.empty:
        usage = json.loads(usage_df['usage_summary'][0])
        st.markdown("### 📈 Last Usage Summary")
        col_u = st.columns(3)
        
        # Updated to match your actual JSON structure
        col_u[0].metric("Calls", f"{usage.get('call_count', 0)} ({usage.get('duration_minutes', 0)} min)")
        col_u[1].metric("SMS", usage.get('sms_count', 0))
        col_u[2].metric("Data (MB)", usage.get('mb_used', 0))
    else:
        st.info("No usage data found for you yet.")

#----- BILLING PAGE-----
def billing_page():
    st.title("🧾 My Billing History")
    customer_id = st.session_state.customer_id
    conn = get_connection()

    try:
        query = """
        SELECT bill_id, billing_month, total_amount
        FROM Billing
        WHERE customer_id = %s
        ORDER BY billing_month DESC
        """
        bills = pd.read_sql(query, conn, params=[customer_id])

        if bills.empty:
            st.info("You have no bills yet.")
            return

        for index, row in bills.iterrows():
            bill_id = row['bill_id']
            bill_month = row['billing_month']
            base_amount = float(row['total_amount'])
            gst_amount, total_amount = calculate_gst(base_amount)

            with st.expander(f"📅 {bill_month}"):
                st.write(f"**Base Amount:** ₹{base_amount}")
                st.write(f"**GST (18%):** ₹{gst_amount}")
                st.write(f"**Total Payable:** ₹{total_amount}")

                if st.button(f"📄 Generate Invoice PDF – {bill_month}", key=bill_id):
                    cursor = conn.cursor()
                    cursor.execute("SELECT name FROM Customer WHERE customer_id = %s", (customer_id,))
                    customer_name = cursor.fetchone()[0]

                    path = generate_invoice_pdf(customer_name, bill_month, base_amount, gst_amount, total_amount, bill_id)

                    with open(path, "rb") as f:
                        st.download_button(
                            label="⬇️ Download Invoice",
                            data=f,
                            file_name=f"invoice_{bill_id}.pdf",
                            mime="application/pdf"
                        )
    except Exception as e:
        st.error(f"❌ Failed to load billing info: {e}")
# ----- SUPPORT PAGE -----
def support_page():
    st.title("📩 Raise a Support Ticket")
    customer_id = st.session_state.customer_id
    conn = get_connection()

    st.markdown("Please describe your issue below. Our team will follow up as soon as possible.")

    with st.form("support_form"):
        issue = st.text_area("Describe your issue", placeholder="Example: My data usage was not reset this month.")
        submitted = st.form_submit_button("Submit Ticket")

        if submitted:
            if not issue.strip():
                st.warning("❗ Issue description cannot be empty.")
            else:
                try:
                    cursor = conn.cursor()
                    cursor.execute("""
                        INSERT INTO Customer_Support (customer_id, issue, status)
                        VALUES (%s, %s, 'Open')
                    """, (customer_id, issue))
                    conn.commit()
                    st.success("✅ Ticket submitted successfully!")
                except Exception as e:
                    st.error(f"❌ Failed to submit ticket: {e}")

    st.markdown("---")
    st.subheader("📜 Your Previous Tickets")

    df = pd.read_sql("""
        SELECT ticket_id, issue, status, created_at
        FROM Customer_Support
        WHERE customer_id = %s
        ORDER BY created_at DESC
    """, conn, params=[customer_id])

    if df.empty:
        st.info("No previous tickets found.")
    else:
        st.dataframe(df)

# ----- MAIN ROUTING -----
if st.session_state.customer_id is not None:
    page = st.sidebar.radio("Navigate", ["📊 Dashboard", "🧾 Billing", "📩 Support", "🚪 Logout"])

    if page == "📊 Dashboard":
        dashboard_page()
    elif page == "🧾 Billing":
        billing_page()
    elif page == "📩 Support":
        support_page()
    elif page == "🚪 Logout":
        st.session_state.customer_id = None
        st.rerun()
