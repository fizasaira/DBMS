# pages/3_Query_Optimizer.py

import streamlit as st
import mysql.connector
import pandas as pd
import time

# --- MySQL Connection ---
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="welcome",
        database="telecom_provider_db"
    )

st.title("🧠 SQL Query Optimizer & Executor")

st.info("Write your custom SQL queries below and execute them to view results and performance insights.")

query = st.text_area("📝 Enter your SQL Query", height=200, placeholder="SELECT * FROM customer;")

if st.button("⚡ Run Query"):
    if not query.strip():
        st.warning("Please enter a valid SQL query.")
    else:
        try:
            conn = get_connection()
            cursor = conn.cursor()

            start_time = time.time()
            cursor.execute(query)

            # Try to fetch results if it's a SELECT
            if query.strip().lower().startswith("select"):
                data = cursor.fetchall()
                colnames = [i[0] for i in cursor.description]
                df = pd.DataFrame(data, columns=colnames)
                st.success(f"✅ Query executed in {round(time.time() - start_time, 4)} seconds")
                st.dataframe(df, use_container_width=True)
            else:
                conn.commit()
                st.success(f"✅ Query executed successfully in {round(time.time() - start_time, 4)} seconds")
                st.info(f"Affected rows: {cursor.rowcount}")

        except mysql.connector.Error as e:
            st.error(f"❌ MySQL Error: {e}")
        finally:
            cursor.close()
            conn.close()

st.caption("⚠️ Only run trusted queries. Write `EXPLAIN your_query` to view optimization insights.")
