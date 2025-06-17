import streamlit as st
from db import get_connection

conn = get_connection()
cursor = conn.cursor()

cursor.execute("SELECT name, email FROM Customer LIMIT 5;")
rows = cursor.fetchall()

st.title("📋 Customer Preview")

for row in rows:
    st.write(f"Name: {row[0]}, Email: {row[1]}")
