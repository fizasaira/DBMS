import os
import pandas as pd
from fpdf import FPDF
from datetime import datetime

def generate_usage_pdf(data: pd.DataFrame):
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=12)
    pdf.set_title("Usage Report")

    pdf.cell(200, 10, txt="Telecom Usage Report", ln=True, align="C")
    pdf.ln(10)

    summary = data['customer_name'].value_counts().reset_index()
    summary.columns = ['Customer', 'Usage Count']

    for index, row in summary.iterrows():
        pdf.cell(0, 10, f"{row['Customer']}: {row['Usage Count']} usage records", ln=True)

    pdf.ln(10)
    pdf.cell(0, 10, f"Report Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", ln=True)

    # Save PDF
    path = os.path.join("generated_reports", "usage_report.pdf")
    os.makedirs("generated_reports", exist_ok=True)
    pdf.output(path)
    return path
