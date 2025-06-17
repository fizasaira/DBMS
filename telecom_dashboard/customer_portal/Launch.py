# launch_customer.py
from pyngrok import ngrok
import subprocess
import time

# Start ngrok tunnel for port 8501
public_url = ngrok.connect(8501)
print("🌐 Public URL:", public_url)

# Wait a bit for ngrok to get ready
time.sleep(2)

# Launch the customer portal
subprocess.Popen(["streamlit", "run", "main.py"])

# Keep this script alive to maintain tunnel
while True:
    pass
