from fpdf import FPDF
import os
import mysql.connector

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="welcome",  # Replace with your MySQL password
        database="telecom_provider_db"
    )

def fetch_billing_data(bill_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
    SELECT b.bill_id, b.customer_id, c.name, c.email, c.address,
           b.billing_month, b.total_amount
    FROM Billing b
    JOIN Customer c ON b.customer_id = c.customer_id
    WHERE b.bill_id = %s
    """, (bill_id,))
    
    result = cursor.fetchone()
    conn.close()
    return result

def generate_pdf_bill(bill_id):
    data = fetch_billing_data(bill_id)
    if not data:
        return None

    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", "B", 16)
    pdf.cell(200, 10, "Telecom Provider - Billing Statement", ln=True, align="C")

    pdf.set_font("Arial", size=12)
    pdf.ln(10)
    pdf.cell(100, 10, f"Bill ID: {data['bill_id']}", ln=True)
    pdf.cell(100, 10, f"Customer ID: {data['customer_id']}", ln=True)
    pdf.cell(100, 10, f"Customer Name: {data['name']}", ln=True)
    pdf.cell(100, 10, f"Email: {data['email']}", ln=True)
    pdf.cell(100, 10, f"Address: {data['address']}", ln=True)
    pdf.ln(10)
    pdf.cell(100, 10, f"Billing Month: {data['billing_month']}", ln=True)
    pdf.cell(100, 10, f"Total Amount Due: ${data['total_amount']}", ln=True)

    # Save file
    output_path = f"generated_bills/bill_{bill_id}.pdf"
    os.makedirs("generated_bills", exist_ok=True)
    pdf.output(output_path)

    return output_path
