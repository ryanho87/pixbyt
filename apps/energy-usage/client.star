load("pixlib/file.star", "file")

def client.get_response():
    output = file.exec("sense.py")

    print("---sense.py--> %s" % (output))

    return output