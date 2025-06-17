from fpdf import FPDF
import os

def calculate_gst(base_amount, gst_rate=18):
    gst_amount = round(base_amount * gst_rate / 100, 2)
    total = round(base_amount + gst_amount, 2)
    return gst_amount, total

def generate_invoice_pdf(customer_name, bill_month, base_amount, gst_amount, total_amount, bill_id):
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=14)

    pdf.cell(200, 10, txt="Telecom Billing Invoice", ln=True, align='C')
    pdf.ln(10)
    pdf.set_font("Arial", size=12)

    pdf.cell(200, 10, f"Customer: {customer_name}", ln=True)
    pdf.cell(200, 10, f"Billing Month: {bill_month}", ln=True)
    pdf.cell(200, 10, f"Bill ID: {bill_id}", ln=True)
    pdf.cell(200, 10, f"Base Amount: INR {base_amount}", ln=True)
    pdf.cell(200, 10, f"GST (18%): INR {gst_amount}", ln=True)
    pdf.cell(200, 10, f"Total Payable: INR {total_amount}", ln=True)


        # Ensure the folder exists
    os.makedirs("customer_portal", exist_ok=True)

    filename = f"invoice_{bill_id}.pdf"
    path = os.path.join("customer_portal", filename)
    pdf.output(path)
    return path
