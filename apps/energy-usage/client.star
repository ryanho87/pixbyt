load("pixlib/file.star", "file")

def client.get_response(base_url, token):
    input = {"base_url": base_url, "token": token}
    output = file.exec("sense.py", input)

    print("---sense.py--> %s" % (output))

    return output