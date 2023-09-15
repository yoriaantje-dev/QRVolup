# Importing library
import qrcode
from PIL import Image, ImageFont, ImageDraw

root_folder = "C:/Users/yoria/no_space_folder/newDev/QRVolup"

file = open(f"{root_folder}/qr_generator/inschrijving.txt", "r")
participant_list = []
font_calibri = ImageFont.truetype('calibri.ttf', 22)

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
    code.save(f"{root_folder}/qr_generator/codes/{name}.png")
    image=Image.open(f"{root_folder}/qr_generator/codes/{name}.png")
    width, height = image.size
    draw_image = ImageDraw.Draw(image)
    draw_image.text((round(width*0.2), round(height*0.88)), name, font=font_calibri)
    image.save(f"{root_folder}/qr_generator/codes/{name}.png")