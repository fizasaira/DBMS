import streamlit as st
import mysql.connector
from utils.pdf_generator import generate_pdf_bill
import os

# --- Database Connection ---
@st.cache_resource
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="welcome",  # Replace with your MySQL password if any
        database="telecom_provider_db"
    )

conn = get_connection()
cursor = conn.cursor(dictionary=True)

st.title("📄 Billing Management")

# --- Load billing data ---
cursor.execute("""
SELECT b.bill_id, b.customer_id, c.name, b.billing_month, b.total_amount
FROM Billing b
JOIN Customer c ON b.customer_id = c.customer_id
ORDER BY b.billing_month DESC
""")
bills = cursor.fetchall()

if not bills:
    st.info("No billing records available.")
else:
    for bill in bills:
        with st.expander(f"Bill ID: {bill['bill_id']} | Customer: {bill['name']} | Month: {bill['billing_month']}"):
            st.write(f"**Customer ID:** {bill['customer_id']}")
            st.write(f"**Customer Name:** {bill['name']}")
            st.write(f"**Billing Month:** {bill['billing_month']}")
            st.write(f"**Total Amount:** ${bill['total_amount']}")

            if st.button("🧾 Generate PDF", key=f"pdf_{bill['bill_id']}"):
                path = generate_pdf_bill(bill['bill_id'])
                if path:
                    with open(path, "rb") as f:
                        st.download_button(
                            label="📥 Download PDF",
                            data=f,
                            file_name=os.path.basename(path),
                            mime="application/pdf"
                        )
                else:
                    st.error("Failed to generate PDF.")
