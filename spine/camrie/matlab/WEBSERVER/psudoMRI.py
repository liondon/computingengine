import myH
import subprocess as sp
import os
import uuid


#working directory
w=myH.getTMP()

matlabWEBSERVER=myH.getmatlabWEBSERVER()

#get the psudomrijob
data = myH.getJOB()

#avoid collision of threades
if not data:
    print ("nothing to do")
    myH.sleep(10)
else:
    if myH.scheduler(2000000):
        if not data:
            print ("nothing to do")
            myH.sleep(10)
        else:
            jsonop = myH.downloadFilefromUrl( data["optionJsonFN"])
            if(jsonop=='error'):
                myH.failedJOB(data["ID"])
                L=myH.logErrorEntry("first image not found")
                myH.sendLOG(L,data["ID"],data["UID"]) 
                exit()
                #get a filename for the results
            fn=myH.getUniqueFilenameOnWorkingTemp('a.json') #cloudmroutput
            #get a filename for the log file
            log=myH.getUniqueFilenameOnWorkingTemp('a.json') #logfile    
            command = """matlab -nodisplay -nodesktop  -r "cd('""" + matlabWEBSERVER +"""');cd ('GUI2014bEdit');fromjsontobat('"""+ jsonop + """','"""+ fn + """','"""+ log + """','"""+ w + """');exit" """
            print command
            sh=sp.Popen(command,shell=True)
            print (sh.communicate())
            output=myH.readMyjson(fn)
            myH.sendJOBResult(output,data["ID"],data["UID"])      
            os.remove(fn)
                        
    else:
        myH.pendingJOB(data["ID"])
        
