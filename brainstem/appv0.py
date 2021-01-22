import os
from flask import Flask, flash, request, redirect, url_for, jsonify
from werkzeug.utils import secure_filename
from flask import send_from_directory

import requests,json

import uuid

import docker

import logging

#to delete 
import shutil


USER=os.getenv('USER', 'test')
PWD=os.getenv('PWD', 'test')
TMPDIR=os.getenv('TMPDIR', 'test')

PORT =os.getenv('PORT', '9999')
camrieEfference =os.getenv('CAMRIE', 'http://localhost:5115/efference')


# https://docker-py.readthedocs.io/en/stable/api.html
# https://docker-py.readthedocs.io/en/1.6.0/api/


UPLOAD_FOLDER = '/apptmp'
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER



def readJson(filename):
    with open(filename) as f:
        data = json.load(f)
    return data


def isUser(user,pwd):
    return True

def logIt(m):
    app.logger.info(m)
def getPipeID():
    return str(uuid.uuid4())

def getRandomFilename(examplefile):
    filename, file_extension = os.path.splitext(examplefile)
    return str(uuid.uuid4()) + file_extension


def getDockerLocalClient():
    return docker.from_env()

def getDockerOutsideClient():
    return  docker.DockerClient(base_url='tcp://127.0.0.1:1234')

def writeJsonFile(filename,data):
    with open(filename, 'w') as outfile:
        json.dump(data, outfile)

def efference(url, data):
    if isUser(USER,PWD):
        data["theuser"]=USER
        data["thepwd"]=PWD
        headers = {'Content-Type': 'application/json'}
        r = requests.post(camrieEfference, data=json.dumps(data), headers=headers)
        return r.json()



def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        # if user does not select file, browser also
        # submit an empty part without filename
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            return redirect(url_for('uploaded_file',
                                    filename=filename))
    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload new File</h1>
    <form method=post enctype=multipart/form-data>
      <input type=file name=file>
      <input type=submit value=Upload>
    </form>
    '''
@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'],
                               filename)

@app.route("/test")
def home():
    return ''' yep '''

@app.route("/testjson")
def jt():
   return jsonify(username='me',
                   email='you',
                   )
@app.route("/testjsonpost",methods=['POST'])
def jt2():
   req_data=request.json
   print (request)
   return jsonify(req_data
                   )

@app.route("/hellodocker")
def helloo():
    client = docker.from_env()
    client.containers.run('alpine', 'echo hello world', detach=True, remove=True)
    return "Hello World!"
                   
@app.route("/pipelines",methods=['POST'])
def pipelinesEater():
   req_data=request.json
   print(req_data)

   if(req_data["pipeline"][0]["application"]=='camrie'):
       pipelineID=getPipeID()
       data_set = {"pipelineid": 1,"options":req_data["pipeline"][0]["options"]}
       response=efference(camrieEfference, data_set)
       OUT=response
       log=OUT["log"]
       data = readJson(log)
       logIt(data)
       logIt(data["time"])
       shutil.rmtree(os.path.dirname(log), ignore_errors=True)



@app.route("/pipelinestest",methods=['POST'])
def pipelinesEaterTest():
   req_data=request.json
   print(req_data)

   if(req_data["pipeline"][0]["application"]=='camrie'):
       logIt('It is camrie task')
       pipelineID=getPipeID()
    #    logIt(' pipeline ID is ' + pipelineID )
       #to b changed by camrie muscles
       data_set = {"pipelineid": pipelineID,"options":req_data["pipeline"][0]["options"]}
       response=efference(camrieEfference, data_set)
       OUT=response
       log=OUT["log"]
       data = readJson(log)
       logIt(data)
       logIt(data["time"])
       shutil.rmtree(os.path.dirname(log), ignore_errors=True)


   return jsonify({"code":"end"})

@app.route("/pipelinestestwithredis",methods=['POST'])
def pipelinesEaterTestRedis():
   req_data=request.json
   print(req_data)

   if(req_data["pipeline"][0]["application"]=='camrie'):
       logIt('It is camrie task')
       pipelineID=getPipeID()
       data_set = {"pipelineid": pipelineID,"options":req_data["pipeline"][0]["options"]}
       response=efference(camrieEfference, data_set)
       OUT=response
       log=OUT["log"]
       data = readJson(log)
       logIt(data)
       logIt(data["time"])
       shutil.rmtree(os.path.dirname(log), ignore_errors=True)


   return jsonify({"code":"end"})

   

@app.route("/afference",methods=['POST'])
def afference():
    req_data=request.json
    #getting an update on a task update
    pipelineID=req_data["pipelineid"]
    #update redis
    logIt("didit")




if __name__ == "__main__":
    app.run(host='0.0.0.0', port=PORT, debug=True)



