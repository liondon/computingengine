import json
import os
import sys
import uuid
import requests
from muscleUtils import constants
from os import path

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

def downloadFilefromUrl(currentTaskDirectory, fileName, fileUrl):
    pre, ext = os.path.splitext(fileUrl)
    print("pre=", pre)
    ext = ext.split('?')[0]
    print("ext=", ext)
    filePath = os.path.join(currentTaskDirectory, fileName + ext)

    with open(filePath, "wb" ) as file:
        downloadFile = requests.get(fileUrl, allow_redirects=False)
        file.write(downloadFile.content)

    return filePath

def rfAPIfull(url, data):
    # headers = {
    #     "Content-type": "application/json", 
    #     "Accept": "text/plain",
    #     "User-Agent": "My User Agent 1.0"
    # }
    gg = requests.post(url, data=json.dumps(data)) #, headers=headers
    return gg

def getDataDownloadLink(fileId):
    if (type(fileId) != str):
        fileId = str(fileId)

    downloadLink = rfAPIfull(constants.cmServiceAPI, json.loads(
        '{"serviceType":"getdatadownloadlink","id":"'+ fileId +'"}'
    ))
    downloadLink = downloadLink.json()

    if downloadLink is not None:  # file can be pending, error or a link
        if downloadLink == "pending":
            # TODO: update result to brainstem
            # myH.pendingJOB(data["ID"])
            raise SystemExit('Error: cannot downloadCmFile: file pending')
        if downloadLink == "nofile":
            # TODO: update result to brainstem
            # myH.failedJOB(data["ID"])
            # L = myH.logErrorEntry("image not found")
            # myH.sendLOG(L,data["ID"],data["UID"]) 
            raise SystemExit('Error: cannot downloadCmFile: nofile')
        if downloadLink == "error":
            # TODO: update result to brainstem
            raise SystemExit('Error: cannot downloadCmFile: error')
        return downloadLink
    else:
        raise SystemExit('Error: cannot downloadCmFile: weird')
