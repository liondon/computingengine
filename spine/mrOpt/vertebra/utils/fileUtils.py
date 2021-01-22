import json
import os
import sys
import uuid

TMPDIR = os.getenv("TMPDIR", "/app")

def writeJsonFile(filename, data):
    with open(filename, "w") as outfile:
        json.dump(data, outfile)


def getRandomFilename(examplefile):
    filename, file_extension = os.path.splitext(examplefile)
    return str(uuid.uuid4()) + file_extension


def getTaskDir():
    tmpdir = os.path.join(TMPDIR, str(uuid.uuid4()))
    os.mkdir(tmpdir)
    return tmpdir
