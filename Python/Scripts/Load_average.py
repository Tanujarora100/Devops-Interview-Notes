import os 
import smtplib
from email.message import EmailMessage
def check_load_average():
    load_average= os.getloadavg()
    THRESHOLD=0.6
    if load_average[0] > THRESHOLD:
        print(f"Load average is {load_average[0]}, which exceeds the threshold of {THRESHOLD}.")
        send_alert_email()
    else:
        print(f"Load average is {load_average[0]}, which is within the threshold of {THRESHOLD}.")
def send_alert_email():
    # Implement email sending logic here
    print("Sending alert email...")
    sender_email = "DL-CLOUDANDDEVOPS@Navisite.com"
    receiver_email = "tanujarora2703@gmail.com"
    password = "your_email_password"
    message = EmailMessage()
    message.set_content("Load average has exceeded the threshold.")
    message["Subject"] = "Load Average Alert"
    message["From"] = sender_email
    message["To"] = receiver_email
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login(sender_email, password)
        server.send_message(message)