import requests
import json
from flask import Flask

app = Flask(__name__)

from brainUtils import constants, myH


def insertJobToDb(req_data, reqApplication):
    requestOptions = req_data["pipeline"][0]["options"]
    request_data = {
        "requestFrom": "brain",
        "uid": requestOptions["UID"],
        "JobType": reqApplication,
        "J": requestOptions["J"],
        "Alias": requestOptions["Alias"],
    }

    reqApplication = reqApplication.lower()
    if reqApplication == "acm" or reqApplication == "pmr":
        request_data["ACM"] = requestOptions["ACM"]

    elif reqApplication == "mr":
        request_data["images"] = requestOptions["images"]

    headers = {
        "Content-type": "application/json",
        "Accept": "text/plain",
        "User-Agent": "My User Agent 1.0",
    }

    try:
        r = requests.post(
            constants.JOB_INSERT_FULL_URL,
            data=json.dumps(request_data),
            headers=headers,
        )
        
        return r.json()["jid"]
    except:
        print(
            "Unable to get jobId from cloudmrhub.com. Setting to 0."
        )  # TODO Change this to log
        return 1216