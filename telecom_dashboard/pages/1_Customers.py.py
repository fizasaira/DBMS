import streamlit as st
import mysql.connector
import pandas as pd

# --- Database Connection ---
@st.cache_resource
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="welcome",
        database="telecom_provider_db"
    )

conn = get_connection()
cursor = conn.cursor(dictionary=True)

st.title("📋 Customer Management")

# --- Load Subscription Plans ---
cursor.execute("SELECT plan_id, name FROM Subscription_Plan")
plans = cursor.fetchall()
plan_options = {plan["name"]: plan["plan_id"] for plan in plans}

# --- Load Customers ---
cursor.execute("""
    SELECT c.customer_id, c.name, c.email, c.phone_number, c.address, s.name AS plan_name
    FROM Customer c
    JOIN Subscription_Plan s ON c.plan_id = s.plan_id
""")
customers = cursor.fetchall()

df = pd.DataFrame(customers)

# --- Filters ---
with st.expander("🔍 Filter"):
    name_filter = st.text_input("Search by Name")
    plan_filter = st.selectbox("Filter by Plan", ["All"] + list(plan_options.keys()))

filtered_df = df.copy()
if name_filter:
    filtered_df = filtered_df[filtered_df["name"].str.contains(name_filter, case=False)]
if plan_filter != "All":
    filtered_df = filtered_df[filtered_df["plan_name"] == plan_filter]

# --- Export Button ---
st.download_button("⬇️ Export to CSV", filtered_df.to_csv(index=False).encode("utf-8"), file_name="customers.csv")

# --- Display Table ---
st.subheader("📑 Customers")
for index, row in filtered_df.iterrows():
    with st.container():
        st.markdown(f"**{row['name']}** ({row['email']})")
        st.write(f"📞 {row['phone_number']} | 🏠 {row['address']} | 📦 {row['plan_name']}")
        col1, col2 = st.columns([1, 1])

        # --- Edit Button ---
        with col1:
            if st.button(f"✏️ Edit {row['name']}", key=f"edit_{row['customer_id']}"):
                st.session_state[f"edit_mode_{row['customer_id']}"] = True

        # --- Delete Button ---
        with col2:
            if st.button(f"🗑️ Delete {row['name']}", key=f"delete_{row['customer_id']}"):
                try:
                    cursor.execute("DELETE FROM Customer WHERE customer_id = %s", (row['customer_id'],))
                    conn.commit()
                    st.success(f"✅ Deleted {row['name']}")
                    st.rerun()
                except mysql.connector.Error as e:
                    st.error(f"❌ Deletion failed: {e.msg}")

        # --- Edit Form ---
        if st.session_state.get(f"edit_mode_{row['customer_id']}", False):
            with st.form(f"form_{row['customer_id']}"):
                new_name = st.text_input("Name", row["name"])
                new_email = st.text_input("Email", row["email"])
                new_phone = st.text_input("Phone Number", row["phone_number"])
                new_address = st.text_area("Address", row["address"])
                new_plan_name = st.selectbox("Subscription Plan", list(plan_options.keys()), index=list(plan_options.keys()).index(row["plan_name"]))

                submitted = st.form_submit_button("💾 Save Changes")
                if submitted:
                    new_plan_id = plan_options[new_plan_name]
                    try:
                        cursor.execute("""
                            UPDATE Customer
                            SET name = %s, email = %s, phone_number = %s, address = %s, plan_id = %s
                            WHERE customer_id = %s
                        """, (new_name, new_email, new_phone, new_address, new_plan_id, row['customer_id']))
                        conn.commit()
                        st.success("✅ Customer updated successfully.")
                        st.session_state[f"edit_mode_{row['customer_id']}"] = False
                        st.rerun()
                    except mysql.connector.Error as e:
                        st.error(f"❌ Update failed: {e.msg}")
