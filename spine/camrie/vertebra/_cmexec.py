import subprocess
import requests
import json
import os


def executeTaskRedis(command,afference):
    os.mkdir(afference)
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    process.wait()
    os.mkdir('/apptmp')

    headers = {'Content-Type': 'application/json'}
    data = {"didit": "didit"}
    r = requests.post(afference, data=json.dumps(data), headers=headers)
    os.mkdir("/apptmp/a")
    return process.returncode