from pyngrok import ngrok
import os

# Kill previous tunnels (optional, but safe)
ngrok.kill()

# Start a new tunnel on port 8501 (Streamlit's default)
public_url = ngrok.connect(8501)
print(f"🚀 Public URL: {public_url}")

# Run your app.py using system command
os.system("streamlit run aap.py")
