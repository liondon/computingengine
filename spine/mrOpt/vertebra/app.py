import json
import os
import shutil
import sys
import uuid

import celery.states as states
from flask import Flask, flash, jsonify, redirect, request, send_from_directory
from werkzeug.utils import secure_filename

app = Flask(__name__)

from utils import constants
from utils import fileUtils
from utils import response
from utils import userAuth

from worker import celery

TMPDIR = os.getenv("TMPDIR", "/app")

PORT = os.getenv("PORT", "9999")

AFFERENCE = os.getenv("AFFERENCE", "--")

VERTEBRANAME = os.getenv("NAME", "MROPT")  # TODO Add PMR full form here.
VERTEBRAID = os.getenv("ID", "11")


def logIt(m):
    app.logger.info(m)


@app.route("/efference", methods=["POST"])
def efference():
    if request.is_json:
        req_data = request.json
        taskName = req_data["jobType"].upper()
        
        if (taskName not in constants.taskNames):
            print(f"Invalid task name {taskName}")
            return response.invalidRequest()

        user = req_data["theuser"]
        pwd = req_data["thepwd"]
        if userAuth.isUser(user, pwd):
            # create the tmpdir name
            options = req_data["options"]
            taskDirectory = fileUtils.getTaskDir()
            joptions = os.path.join(taskDirectory, "options.json")
            if (options, dict):  # if options is not a file
                fileUtils.writeJsonFile(joptions, req_data)
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
            task = celery.send_task(taskName, args=[joptions], kwargs={})
            # result.wait()
            responseVal = response.getResponseObjectWithUrl(VERTEBRANAME, VERTEBRAID, task.id)
            logIt(f"task : {task.id} completed,  response : {responseVal}")
            return responseVal

        else:
            responseVal = response.cantScheduleCeleryErrorResponse(VERTEBRANAME, VERTEBRAID)
            return responseVal

    else:
        responseVal = response.unAuthorizedResponse(VERTEBRANAME, VERTEBRAID)
        return responseVal


#    https://beenje.github.io/blog/posts/running-background-tasks-with-flask-and-rq/


@app.route("/check/<string:id>")
def check_task(id):
    task = celery.AsyncResult(id)
    responseVal = response.getResponseFromTaskResult(VERTEBRANAME, VERTEBRAID, task, id)
    return responseVal


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT, debug=True)
