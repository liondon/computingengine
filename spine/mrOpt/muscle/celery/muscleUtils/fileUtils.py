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

def downloadFiles(filePath, fileUrl):
    with open(filePath, "wb" ) as fileToDownload:
        downloadFile = requests.get(fileUrl)
        fileToDownload.write(downloadFile.content)

# For Downloading files from cloudmrhub.com
# TODO: can we replace `requestFile` & `downloadFileFromUrl` with `downloadFiles`?
def requestFile(url, filePath):
    # headers = {'host':'www.cloudmrhub.com','Accept': 'application/json, text/javascript, */*; q=0.01',
    #     'Accept-Language': 'en-US,en;q=0.5',
    #     'Accept-Encoding': 'gzip, deflate, br',
    #     'Referer': 'www.cloudmrhub.com', 
    #     'Content-Type':'application/json',
    #     'X-Requested-With': 'XMLHttpRequest',
    #     'Connection': 'keep-alive',
    #     'Origin': 'https://www.host.com','User-Agent': USERAGENT}
    headers = {
        'Content-type': 'application/json', 
        'Accept': 'text/plain',
        'User-Agent': 'My User Agent 1.0'
    }
    myfile = requests.get(url, headers= headers, allow_redirects=False)
    open(filePath, 'wb').write(myfile.content)
    return path.exists(filePath)
def downloadFilefromUrl(filePath, url):   
    if(requestFile(url, filePath)):
        return "succeed"
    else:
        return "error"   

def rfAPIfull(url, data):
    headers = {
        "Content-type": "application/json", 
        "Accept": "text/plain",
        "User-Agent": "My User Agent 1.0"
    }
    gg = requests.post(url, data=json.dumps(data), headers=headers)
    return gg

def downloadCmFile(filePath, fileId):
    if (type(fileId) != str):
        fileId = str(fileId)

    # from the file id get the file in the working tmp and get back the filename
    TT = rfAPIfull(constants.cmServiceAPI, json.loads(
        '{"serviceType":"getdatadownloadlink","id":"'+ fileId +'"}'
    ))
    fileresponse = TT.json()

    if fileresponse is not None:  # file can be pending, error or a link
        if fileresponse == "pending":
            return "pending"
        if fileresponse == "nofile":
            return "nofile"
        if fileresponse == "error":
            return "error"
        downloadFilefromUrl(filePath, fileresponse)
        return "succeed"
    else:
        return "weird"

def checkDownloadResult(result):
    if(result == 'nofile'):
        # TODO: update result to brainstem
        # myH.failedJOB(data["ID"])
        # L = myH.logErrorEntry("image not found")
        # myH.sendLOG(L,data["ID"],data["UID"]) 
        exit()
    if((result == 'pending')):
        # TODO: update result to brainstem
        # myH.pendingJOB(data["ID"])
        exit()
