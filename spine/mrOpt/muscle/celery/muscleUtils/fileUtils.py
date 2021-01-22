import json
import os
import sys
import uuid
import requests

TMPDIR = os.getenv("TMPDIR", "/app")

def writeJsonFile(filename, data):
    with open(filename, "w") as outfile:
        json.dump(data, outfile)

def getRandomFilename(examplefile):
    filename, file_extension = os.path.splitext(examplefile)
    return str(uuid.uuid4()) + file_extension

def getTaskDir():
    tmpdir = os.path.join(TMPDIR, str(uuid.uuid4()))
    os.mkdir(tmpdir)
    return tmpdir

def getRequiredFileNames(currentTaskDirectory):
    outputFile = os.path.join(currentTaskDirectory, "O.json")
    logFile = os.path.join(currentTaskDirectory, "L.json")
    matFile = os.path.join(currentTaskDirectory, "out.mat")

    return outputFile, logFile, matFile

def getJsonFromFile(jopt):
    with open(jopt) as f:
        fileJson = json.loads(f.read())
        # print(fileJson)
        return fileJson

def downloadFiles(filePath, fileUrl):
    with open(filePath, "wb" ) as fileToDownload:
        downloadFile = requests.get(fileUrl)
        fileToDownload.write(downloadFile.content)