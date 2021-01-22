import ftplib
import ntpath
import os
import requests
import sys
import json
import subprocess as sp
import uuid
import psutil
from requests_toolbelt import MultipartEncoder, MultipartEncoderMonitor
#install though apt python-requests-toolbelt
import xmltodict
#install though apt python-xmltodict


import conf
import time
#import wget

from os import path
srvr=conf.getServer()


#address of th server
SERVER=srvr['server']
#where to make calculation
w=srvr['workingPATH']

#base dir for data
#r=srvr['relativePATH']


#matalabfolder with webserver stuff
matlabWEBSERVER=srvr['matlab']

#('User-agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A')



#url = 'http://'+ SERVER

qurl= srvr['qurl']


#s="http://"+ SERVER + "/"

ftpS=srvr['ftpSERVER']
ftpU=srvr['ftpU']
ftpP=srvr['ftpP']


#InfoType="validate"
#InfoType="Extension"
#InfoType="convertin"
#InfoType="getSinglejob" JobTYpe
#InfoType="setresultjob" JobTYpe
#InfoType="setlog"
#"InfoType"="failedjob"
#"InfoType"="pendingjob"


serviceAPI = qurl + "/serviceAPI.php"




MROPTDATAAPI = qurl+"/getMROPTDataByID.php"





CONVERTOUT = qurl + "/convertEnd.php"
VALIDATEcommon = qurl + "/convertervaliadation.php"



FAILED= qurl + "/failedJob.php"


def rfAPIfull(url,data):
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain','User-Agent': 'My User Agent 1.0'}
    gg = requests.post(url, data=json.dumps(data), headers=headers)
    return gg


def rfAPI(url,data):
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain','User-Agent': 'My User Agent 1.0','Connection': 'keep-alive',}
    gg = requests.post(url, data=json.dumps(data), headers=headers)
    # print gg.text
    try:
        out=gg.json()
    except:
        out=json.loads(gg.text[gg.text.find('{'):])
    return out
    
def getJOB():
    C=rfAPI(serviceAPI,{"InfoType":"getsinglejob"})
    return C 

    
def sendJOBResult(r,jid,uid):
    C= rfAPI2(serviceAPI,{"output":json.dumps(r),"id":jid,"uid":uid,"InfoType":"setresultjob"})
    return C


def readMyjson(fi):
    with open(fi) as f:
        data = json.load(f)
        return data
        
        
        

def __unicode__(self):
   return self.some_field or u'None'
   
def getFreeMemory():
    p=psutil.virtual_memory()
    return p.available

def getCPU():
    return psutil.cpu_percent()

def scheduler(x):
    #x is the required ram
    #a=ramPercentage();
    a=getFreeMemory()    
    if (float(getCPU())<90):
        if a>x:
            return True
        else:
            return False
            
def getTMP():
    return w

def getmatlabWEBSERVER():
    return matlabWEBSERVER
    
def sendLOG(r,jid,uid):
    C=rfAPI2(serviceAPI,{"output":r,"id":jid,"uid":uid,"InfoType":"setlog"})
    
def failedJOB(jid):
    C=rfAPI2(serviceAPI,{"id":jid,"InfoType":"failedjob"})

def pendingJOB(jid):
    C=rfAPI2(serviceAPI,{"id":jid,"InfoType":"pendingjob"})   
    
        
def fixFTPPATH(p):
    p=p.replace('/home3/cloudmrh/', '/')
    return p
    
def rfAPI2(url,data):
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain','User-Agent': 'My User Agent 1.0'}
    YY = requests.post(url, data=json.dumps(data), headers=headers,timeout=500000)
    print(YY)
    return YY.text

def rfAPIDebug(url,data):
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
    r = requests.post(url, data=json.dumps(data), headers=headers)
    return r

def sleep(x):
    time.sleep(x)

FAILED= qurl + "/failedJob.php"
def logErrorEntry(errorMessage):
    if (type(errorMessage) == str):
         print("nothing to do")
    else:
        errorMessage=str(errorMessage)
    
    LOG={
        "text": errorMessage,
        "type": "error",
        "time": getNow()
        }
    return LOG
def downloadCmFile(fileid):
    if (type(fileid) == str):
        print("nothing to do")
    else:
        fileid=str(fileid)
    #from the file id get the file in the working tmp and get back the filename
    j = '{"serviceType":"getdatadownloadlink","id":"'+ fileid +'"}'
    x=json.loads(j)
    #x is take a json file
    TT=rfAPIfull(cmserviceAPI,x)
    fileresponse=TT.json()
    if fileresponse is not None: #file can be pending, error or a link
        if fileresponse =="pending":
            return "pending"
        if fileresponse =="nofile":
            return "nofile"
        if fileresponse =="error":
            return "error"
        O=downloadFilefromUrl(fileresponse)
        return O 
    else:
         return "weird"
    


def downloadFilefromUrl(url):   
    FILENAME=getUniqueFilenameOnWorkingTemp(url)
    if(requestFile(url,FILENAME)):
        return FILENAME
    else:
        return "error"    

def getUniqueFilenameOnWorkingTemp(thefile):
        pre, ext = os.path.splitext(thefile)
        return w + str(uuid.uuid4()) + ext


def requestFile(url,filename):
    # headers = {'host':'www.cloudmrhub.com','Accept': 'application/json, text/javascript, */*; q=0.01',
    #     'Accept-Language': 'en-US,en;q=0.5',
    #     'Accept-Encoding': 'gzip, deflate, br',
    #     'Referer': 'www.cloudmrhub.com', 
    #     'Content-Type':'application/json',
    #     'X-Requested-With': 'XMLHttpRequest',
    #     'Connection': 'keep-alive',
    #     'Origin': 'https://www.host.com','User-Agent': USERAGENT}
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain','User-Agent': 'My User Agent 1.0'}

    myfile = requests.get(url,headers= headers,allow_redirects=False)
    open(filename, 'wb').write(myfile.content)
    return path.exists(filename)