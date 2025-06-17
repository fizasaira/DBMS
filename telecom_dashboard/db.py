import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="welcome",
        database="telecom_provider_db"
    )
