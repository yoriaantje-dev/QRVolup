# Importing library
import qrcode
from PIL import Image, ImageFont, ImageDraw

file = open("C:/Users/yoria/no_space_folder/newDev/QRVolup/qr_generator/inschrijving.txt", "r")
participant_list = []
for line in file:
  participant_data = line.strip().split(";")
  praticipant = {
      "name": participant_data[0],
      "mail": participant_data[1],
  }
  participant_list.append(praticipant)

for participant in participant_list:
    name = participant["name"]
    code = qrcode.make(name)
    code.save(f"C:/Users/yoria/no_space_folder/newDev/QRVolup/qr_generator/codes/{name}.png")

mf = ImageFont.truetype('calibri.ttf', 25)

for participant in participant_list:
    name = participant["name"]
    i=Image.open(f"C:/Users/yoria/no_space_folder/newDev/QRVolup/qr_generator/codes/{name}.png")
    width, height = i.size
    im = ImageDraw.Draw(i)
    im.text((round(width*0.2), round(height*0.88)), name, font=mf)
    i.save(f"C:/Users/yoria/no_space_folder/newDev/QRVolup/qr_generator/codes/{name}.png")



 
# Data to be encoded
# data = 'Maarten Visser'

# Encoding data using make() function
# yorian = qrcode.make("Yorian Peters")
# maarten = qrcode.make("Maarten Visser")
# sam = qrcode.make("Sam Lamerichs")

# Saving as an image file
# yorian.save('yorian.png')
# maarten.save('C:/Users/yoria/no_space_folder/newDev/QRVolup/qr_generator/codes/maarten.png')
# sam.save('sam.png')

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
