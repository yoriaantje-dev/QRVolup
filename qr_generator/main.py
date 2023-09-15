# Importing library
import qrcode

# Data to be encoded
data = 'Maarten Visser'

# Encoding data using make() function
yorian = qrcode.make("Yorian Peters")
maarten = qrcode.make("Maarten Visser")
sam = qrcode.make("Sam Lamerichs")

# Saving as an image file
yorian.save('yorian.png')
maarten.save('maarten.png')
sam.save('sam.png')

# user_dict = {
#     {
#         "firstname": "Yorian",
#         "lastname": "Peters",
#         "qr": "Yorian",
#     }
# }

def MakeParticipantList():
    flag = True
    while flag:
        pass

def SaveQRList(Participants, QRCodes): 
    print("Saving List of QR Codes...")
    count = 0
    for QR in QRCodes:
        print(f"Saving QR for {Participants[count]}: QR_{Participants[count]}")
        QR.save(f"QR_{Participants[count]}")
        count += 1
    print("Done!...")
