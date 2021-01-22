import os
from flask import Flask, flash, request, redirect, url_for, jsonify
from werkzeug.utils import secure_filename
from flask import send_from_directory

import requests, json

import logging

# to delete
import shutil

import redis

from brainUtils import constants, verterbra, myH, bluehostAPI
from mrOptRouter import routeMrOptRequests

USER = os.getenv("USER", "test")
PWD = os.getenv("PWD", "test")
TMPDIR = os.getenv("TMPDIR", "test")

PORT = os.getenv("PORT", "9999")
constants.camrieEfference = os.getenv("CAMRIE", "http://localhost:5115/efference")
constants.dgfEfference = os.getenv("DGF", "http://localhost:5114/efference")
constants.mrOptEfference = os.getenv("MROPTIMUM", "http://localhost:5009/efference")

OUTPUTVERSION = "v0.0v"
# https://docker-py.readthedocs.io/en/stable/api.html
# https://docker-py.readthedocs.io/en/1.6.0/api/

app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = TMPDIR

# redis the memory
SHRTM = os.getenv("SHORTTERMMEMORY", "localhost")
shortmemory = redis.StrictRedis(host=SHRTM, port=6379, db=0)
pipelinememory = "pipelines"
appPipelines = []


def getPipelineOuput(id):

    # get the sections pipelines
    pipelines = json.loads(shortmemory.get(pipelinememory))
    # find the one i am interestd in
    # myH.logIt(app,pipelines)
    temp = 0
    for attrs in pipelines:
        if attrs["pipeline"] == id:
            temp = attrs
            break

    if temp == 0:
        return {"status": "error"}  # dict
    else:
        return checkPipes(temp)


def checkPipes(pipeline):
    out = []
    myH.logIt(app, pipeline)
    for pipe in pipeline["pipes"]:
        headers = {"Content-Type": "application/json"}
        myH.logIt(app, pipe)
        r = requests.get(pipe["url"], headers=headers)
        result = r.json()
        pipeout = {
            "status": result["status"],
            "cu": {"id": result["cuid"], "name": result["cuname"]},
        }
        if result["status"] == "SUCCESS":
            pipeout["out"] = result["result"]
            pipeout["complete"] = 1
        elif result["status"] == "PROGRESS":
            pipeout["complete"] = result["result"]["done"] / result["result"]["total"]
        else:
            pipeout["status"] = "ERROR"
        out.append(pipeout)
    return out


def logShortMemoryContent():
    myH.logIt(app, "Contents of the list before modification:")
    pipelines = json.loads(shortmemory.get(pipelinememory))
    for i in range(0, len(pipelines)):
        myH.logIt(app, pipelines[i])


def rememberPipeline(pipeline):
    # pipeline is a dict
    # myH.logIt(app,type(pipeline))
    pipeline["pipelinestatus"] = "pending"
    # myH.logIt(app,appPipelines)
    appPipelines.append(pipeline)
    shortmemory.set(pipelinememory, json.dumps(appPipelines))
    # logShortMemoryContent()


@app.route("/pipelines", methods=["POST"])
def pipelinesEater():
    req_data = request.json
    pipelineID = myH.getPipeID()
    toreturn = {
        "version": OUTPUTVERSION,
        "pipeline": pipelineID,
        "pipes": [],
        "pipelinestatus": "QUEUED",
        "percentagecompleted": 0,
    }
    myH.logIt(app, req_data)
    myH.logIt(app, "checking the pipelines")
    requestApplication = req_data["pipeline"][0]["application"]

    data_set = {}
    data_set["theuser"] = req_data["theuser"]
    data_set["thepwd"] = req_data["thepwd"]

    # jobId = bluehostAPI.insertJobToDb(req_data, requestApplication)

    myH.logIt(app, "here")
    requestOptions = req_data["pipeline"][0]["options"]
    request_data = {
        "requestFrom": "brain",
        "uid": requestOptions["UID"],
        "JobType": requestApplication,
        "J": requestOptions["J"],
        "Alias": requestOptions["Alias"],
    }

    requestApplication = requestApplication.lower()
    if requestApplication == "acm" or requestApplication == "pmr":
        request_data["ACM"] = requestOptions["ACM"]

    elif requestApplication == "mr":
        request_data["images"] = requestOptions["images"]

    headers = {
        "Content-Type": "application/json"
        # "Host": "cloudmrhub.com",
    }

    r = requests.request(
        "POST",
        constants.JOB_INSERT_FULL_URL,
        data=json.dumps(request_data),
        headers=headers,
    )

    data_set["jobId"] = bluehostAPI.insertJobToDb(req_data, requestApplication)

    if requestApplication == "camrie":
        myH.logIt(app, "CAMRIE Request")

        data_set["options"] = req_data["pipeline"][0]["options"]
        response = verterbra.efference(constants.camrieEfference, data_set)
        OUT = response
        OUT["cu"] = {"id": OUT["cuid"], "name": OUT["cuname"]}
        toreturn["pipes"].append(OUT)

    elif requestApplication == "dgf":
        myH.logIt(app, "DGF Request")
        data_set["options"] = req_data["pipeline"][0]["options"]
        response = verterbra.efference(constants.dgfEfference, data_set)
        OUT = response
        OUT["cu"] = {"id": OUT["cuid"], "name": OUT["cuname"]}
        toreturn["pipes"].append(OUT)

    elif requestApplication == "pmr" or requestApplication == "acm":
        routeMrOptRequests.handleACMOrPMRRequest(
            requestApplication, req_data, data_set, toreturn
        )
    elif requestApplication == "di":
        routeMrOptRequests.handleDIRequest(
            requestApplication, req_data, data_set, toreturn
        )
    elif requestApplication == "mr":
        routeMrOptRequests.handleMRRequest(
            requestApplication, req_data, data_set, toreturn
        )
    rememberPipeline(toreturn)
    return jsonify(toreturn)


@app.route("/pipelines/<string:id>", methods=["GET"])
def pipelinescheck(id):
    # myH.logIt(app,id)
    tmpout = getPipelineOuput(id)
    out = {"version": "v0.0v", "pipeline": id, "pipes": []}
    tc = 0.0
    rc = 0.0
    for t in tmpout:
        tc = tc + 1
        rc = rc + t["complete"]
        subout = {"cu": t["cu"], "percentagecompleted": t["complete"] * 100}

        if t["status"] == "SUCCESS":
            subout["output"] = t["out"]
            subout["status"] = "completed"
        elif t["status"] == "PROGRESS":
            subout["status"] = "calculating"

        out["pipes"].append(subout)

    out["pipelinestatus"] = "calculating"
    if tc == rc:
        out["pipelinestatus"] = "completed"
        # TODO set the pipline in the memory to done and synk maybe?

    out["percentagecompleted"] = rc / tc * 100

    # myH.logIt(app,tmpout)
    return jsonify(out)


# @app.route("/afference",methods=['POST'])
# def afference():
#     req_data=request.json
#     #getting an update on a task update
#     pipelineID=req_data["pipelineid"]
#     #update redis
#     myH.logIt(app,"didit")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT, debug=True)
