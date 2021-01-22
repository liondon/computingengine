import os
import requests
import json

from brainUtils import myH
USER = os.getenv("USER", "test")
PWD = os.getenv("PWD", "test")

def efferencev0(url, data):
    if myH.isUser(USER, PWD):
        data["theuser"] = USER
        data["thepwd"] = PWD
        headers = {"Content-Type": "application/json"}
        r = requests.post(url, data=json.dumps(data), headers=headers)
        return r.json()


def efference(url, data):
    if myH.isUser(data["theuser"], data["thepwd"]):
        headers = {"Content-Type": "application/json"}
        r = requests.post(url, data=json.dumps(data), headers=headers)
        return r.json()