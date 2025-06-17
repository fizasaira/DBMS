📞 Telecom Management System (MySQL + Streamlit)
This project is a backend-driven telecom management system built using MySQL for data storage and Streamlit for the customer self-service portal. It supports managing customer data, subscription plans, usage records, billing with GST, and support ticket tracking.

🔧 This project focuses on robust relational database design, automation using stored procedures, triggers, functions, and backend analysis via SQL window functions.

✅ Features
🗃️ Backend Database (MySQL)
ER diagram modeled and implemented in 3NF

Tables: Customer, Subscription_Plan, Usage_Data, Billing, Customer_Support

JSON fields for storing daily usage summaries (calls, SMS, data)

Enforced domain constraints and foreign keys

Isolation levels and concurrency control with simulated deadlock handling

CAP Theorem analysis and justification

⚙️ Database Automation
Stored Procedures for usage and billing checks

Functions for calculating tax and total bill

Triggers to auto-log and validate actions

Error handling using SIGNAL

Window functions for advanced analysis

🌐 Customer Self-Service Portal (Streamlit)
Secure login using email and phone

View personal details and plan limits

Analyze latest usage from JSON summary

Download monthly bills with GST (PDF)

Raise support tickets and view history

📂 Project Structure
graphql
Copy
Edit
telecom_dashboard/
├── main.py                      # Entry point for customer portal
├── db.py                        # MySQL connection logic
├── billing_utils.py             # GST + PDF generation for billing
├── customer_portal/             # (Folder for customer dashboard)
│   └── [all related code here]
├── utils/
│   └── pdf_generator.py         # Modular PDF export (if used)
├── sql/
│   └── schema.sql               # Full SQL DDL for database
│   └── procedures.sql           # Stored procedures and triggers
🧪 How to Run
🔧 1. Clone the Repo
bash
Copy
Edit
git clone https://github.com/your-username/telecom-dashboard.git
cd telecom-dashboard
🐬 2. Set Up MySQL
Import sql/schema.sql into MySQL

Create sample data using provided inserts

Make sure your MySQL server is running locally

🧠 3. Configure DB in db.py
python
Copy
Edit
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="your_username",
        password="your_password",
        database="telecom_provider_db"
    )
🚀 4. Run the App
bash
Copy
Edit
streamlit run main.py
📚 Technologies Used
MySQL 8.0+

Python 3.10+

Streamlit

PyMySQL / SQLAlchemy

FPDF (for invoice generation)

✍️ Author
Fiza Kousar
Master’s in Data Analytics
Berlin School of Business and Innovation

