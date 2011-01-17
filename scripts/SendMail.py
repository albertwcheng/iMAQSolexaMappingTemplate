#!/usr/bin/python


# Emailing from Python

import smtplib
from email.MIMEText import MIMEText
from sys import argv,stderr,stdout

# Set up a MIMEText object (it's a dictionary)
def sendMail(MailServer,Subject,FromTag,ToTag,ReplyToTag,RealFrom,RealTo,Message):
	msg = MIMEText(Message)
	
	# You can use add_header or set headers directly ...
	msg['Subject'] = Subject
	# Following headers are useful to show the email correctly
	# in your recipient's email box, and to avoid being marked
	# as spam. They are NOT essential to the snemail call later
	msg['From'] = FromTag
	msg['Reply-to'] = ReplyToTag
	msg['To'] = ToTag
		
	# Establish an SMTP object and connect to your mail server
	s = smtplib.SMTP()
	s.connect(MailServer)
	# Send the email - real from, real to, extra headers and content ...
	s.sendmail(RealFrom,RealTo, msg.as_string())
	s.close()
	
if __name__=="__main__":
	if len(argv)<9:
		print >> stderr, argv[0],"MailServer Subject FromTag ToTag ReplyToTag RealFrom RealTo Message"
	else:
		sendMail(argv[1],argv[2],argv[3],argv[4],argv[5],argv[6],argv[7],argv[8])


#Email from BASH
"""
# send an email using /bin/mail
/bin/mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE

#$EMAILMESSAGE is filename

"""