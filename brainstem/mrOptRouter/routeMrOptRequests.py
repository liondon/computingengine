from brainUtils import myH, verterbra, constants
import json
from flask import Flask

app = Flask(__name__)


def handleACMOrPMRRequest(requestApplication, req_data, data_set, toreturn):
    myH.logIt(app, f"{requestApplication} Request")
    requestData = req_data["pipeline"][0]
    requestOptions = requestData["options"]
    myH.logIt(app, requestOptions)
    options = {}
    options["signalFileUrl"] = requestOptions["J"]["signalData"]
    options["noiseFileUrl"] = requestOptions["J"]["noiseData"]
    options["optionsFileUrl"] = requestOptions["J"]["optionsFile"]
    options["qServer"] = requestOptions["J"]["qServer"]
    data_set["jobType"] = requestApplication.lower()
    # data_set["taskName"] =
    data_set["uid"] = requestData["uid"]
    data_set["options"] = options
    myH.logIt(app, data_set)
    response = verterbra.efference(constants.mrOptEfference, data_set)
    # myH.logIt(app, response)
    OUT = response
    OUT["cu"] = {"id": OUT["cuid"], "name": OUT["cuname"]}
    toreturn["pipes"].append(OUT)


def handleDIRequest(requestApplication, req_data, data_set, toreturn):
    myH.logIt(app, f"{requestApplication} Request")
    requestOptions = req_data["pipeline"][0]["options"]

    myH.logIt(app, requestOptions)
    options = {}
    options["imageFile1Url"] = requestOptions["J"]["image0"]
    options["imageFile2Url"] = requestOptions["J"]["image1"]

    data_set["jobType"] = requestApplication.lower()
    # data_set["taskName"] =
    data_set["uid"] = requestOptions["UID"]
    data_set["options"] = options
    myH.logIt(app, data_set)
    response = verterbra.efference(constants.mrOptEfference, data_set)
    OUT = response
    OUT["cu"] = {"id": OUT["cuid"], "name": OUT["cuname"]}
    toreturn["pipes"].append(OUT)


def handleMRRequest(requestApplication, req_data, data_set, toreturn):
    myH.logIt(app, f"{requestApplication} Request")
    requestData = req_data["pipeline"][0]
    requestOptions = requestData["options"]
    myH.logIt(app, requestOptions)
    options = {}

    fileUrls = [val["ID"] for val in json.loads(requestOptions["J"]["images"])]
    options["fileUrls"] = fileUrls
    options["optionsFileUrl"] = requestOptions["J"]["optionsFile"]
    options["qServer"] = requestOptions["J"]["qServer"]

    data_set["jobType"] = requestApplication.lower()
    # data_set["taskName"] =
    data_set["uid"] = requestData["uid"]
    data_set["options"] = options
    myH.logIt(app, data_set)
    response = verterbra.efference(constants.mrOptEfference, data_set)
    # myH.logIt(app, response)
    OUT = response
    OUT["cu"] = {"id": OUT["cuid"], "name": OUT["cuname"]}
    toreturn["pipes"].append(OUT)