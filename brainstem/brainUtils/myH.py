import json
import uuid
import os

def readJson(filename):
    with open(filename) as f:
        data = json.load(f)
    return data


def isUser(user,pwd):
    return True

def logIt(app,m):
    app.logger.info(m)

def getPipeID():
    return str(uuid.uuid4())

def getRandomFilename(examplefile):
    filename, file_extension = os.path.splitext(examplefile)
    return str(uuid.uuid4()) + file_extension


def writeJsonFile(filename,data):
    with open(filename, 'w') as outfile:
        json.dump(data, outfile)


