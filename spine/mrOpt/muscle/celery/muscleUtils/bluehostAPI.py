from muscleUtils import constants, fileUtils
import requests
import json

# TODO: Change result upload to S3 bucket and treat results as normal files.
# S3 bucket or any persistent storage works. Update /Q/serviceAPI.php to write the url into database.
def uploadResultToBluehost(resultJson, jopt):
    uploadUrl = (
        constants.BLUEHOST_FALL2020_BASE_URL + constants.FILE_UPLOAD_PATH_TO_BLUEHOST
    )
    outputJson = fileUtils.getJsonFromFile(resultJson[constants.OUTPUT_KEY])
    requestParams = fileUtils.getJsonFromFile(jopt)
    dataForUpload = {
        "InfoType": "setresultjob",
        "JobType": requestParams["jobType"].lower(),
        "output": outputJson,
        "uid": requestParams["uid"],
        "id": requestParams["jobId"],
    }

    headers = {
        "Content-type": "application/json",
        "Accept": "text/plain",
        "User-Agent": "My User Agent 1.0",
    }

    r = requests.post(
        uploadUrl,
        data=json.dumps(dataForUpload),
        headers=headers,
    )

    print("=============== uploadResultToBluehost ===============", r.text)
