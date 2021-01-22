import os
from flask import Flask, flash, request, redirect, url_for, jsonify
from werkzeug.utils import secure_filename
from flask import send_from_directory



import uuid

import subprocess

import sys

import json



from worker import celery
import celery.states as states


import shutil

TMPDIR = os.getenv('TMPDIR', '/app')


PORT =os.getenv('PORT', '9999')

AFFERENCE = os.getenv('AFFERENCE', '--')


VERTEBRANAME=os.getenv('NAME',"Dyadic Green Function (DGF)")
VERTEBRAID=os.getenv('ID','3')

def logIt(m):
    app.logger.info(m)

def writeJsonFile(filename,data):
    with open(filename, 'w') as outfile:
        json.dump(data, outfile)

def getRandomFilename(examplefile):
    filename, file_extension = os.path.splitext(examplefile)
    return str(uuid.uuid4()) + file_extension




def getTaskDir():
    tmpdir = os.path.join(TMPDIR,  str(uuid.uuid4()))
    os.mkdir(tmpdir)
    return tmpdir

def executeTask(com):
    process = subprocess.Popen(com, shell=True, stdout=subprocess.PIPE)
    process.wait()
    print (process.returncode)
    return process.returncode


def isUser(user,pwd):
    return True



app = Flask(__name__)


@app.route("/efference",methods=['POST'])
def efference():
    if request.is_json:       
        req_data=request.json
        user=req_data["theuser"]
        pwd=req_data["thepwd"]
        if isUser(user,pwd):
            #create the tmpdir name    
            options=req_data["options"]
            tmpdir=getTaskDir()
            joptions= os.path.join(tmpdir, "options.json")

            if (isinstance(options, dict)): #if options is not a file
                writeJsonFile(joptions,options)
            else:
                try: 
                    shutil.copyfile(options, joptions) 
  
                # If source and destination are same 
                except shutil.SameFileError: 
                    print("Source and destination represents the same file.") 
                
                # If destination is a directory. 
                except IsADirectoryError: 
                    print("Destination is a directory.") 
                
                # If there is any permission issue 
                except PermissionError: 
                    print("Permission denied.") 
                
                # For other errors 
                except: 
                    print("Error occurred while copying file.") 
            task = celery.send_task('dgf.cu', args=[joptions], kwargs={})
            # result.wait()
            return jsonify(dict(cuname=VERTEBRANAME,cuid=VERTEBRAID,id=task.id, url=url_for('check_task', id=task.id, _external=True), internalurl=url_for('check_task', id=task.id, _external=False)))

        else :
            return jsonify({"cuname":VERTEBRANAME,"cuid":VERTEBRAID,"id": 0, "status":"error","response":"can't  schedule celery task for " + VERTEBRANAME})
    else :
        return jsonify({"cuname":VERTEBRANAME,"cuid":VERTEBRAID,"pipeplineid": 0, "status":"not autorized","response":"user is not autorized for " + VERTEBRANAME})

#    https://beenje.github.io/blog/posts/running-background-tasks-with-flask-and-rq/


@app.route('/check/<string:id>')
def check_task(id):
    task = celery.AsyncResult(id)
    if task.state == 'SUCCESS':
        response = {
            'status': task.state,
            'result': task.result,
            'task_id': id,
            'cuname':VERTEBRANAME,
            'cuid':VERTEBRAID
        }
    elif task.state == 'FAILURE':
        response = json.loads(task.backend.get(task.backend.get_key_for_task(task.id)).decode('utf-8'))
        del response['children']
        del response['traceback']
    else:
        response = {
            'status': task.state,
            'result': task.info,
            'task_id': id,
            'cuname':VERTEBRANAME,
            'cuid':VERTEBRAID
        }
    return jsonify(response)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=PORT, debug=True)



