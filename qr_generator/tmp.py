import qrcode
name = "Yorian"
code = qrcode.make(name)
code.save(f"qr_generator/{name}.png")
