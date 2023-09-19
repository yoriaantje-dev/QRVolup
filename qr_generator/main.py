# Importing library
import qrcode
from PIL import Image, ImageFont, ImageDraw

root_folder = "C:/Users/yoria/no_space_folder/newDev/QRVolup"

file = open(f"{root_folder}/qr_generator/inschrijving.txt", "r")
participant_list = []
email_list = []
font_calibri = ImageFont.truetype('calibri.ttf', 22)

for line in file:
  participant_data = line.strip().split(";")
  praticipant = {
      "name": participant_data[0],
      "mail": participant_data[1],
  }
  participant_list.append(praticipant)
  participant_list = sorted(participant_list, key=lambda x: x['name'])
file.close()

file = open(f"{root_folder}/qr_generator/mail.txt", "w")
for participant in participant_list:
    name = participant["name"]
    email = participant["mail"]

    code = qrcode.make(name)
    code.save(f"{root_folder}/qr_generator/codes/{name}.png")
    image=Image.open(f"{root_folder}/qr_generator/codes/{name}.png")
    width, height = image.size
    
    draw_image = ImageDraw.Draw(image)
    draw_image.text((round(width*0.2), round(height*0.88)), name, font=font_calibri)

    image.save(f"{root_folder}/qr_generator/codes/{name}.png")
    file.write(f"{name.strip()} {email}\n")

file.close()