from flask import url_for, jsonify
import json


class ResponseObject:
    def __init__(
        self,
        cuname,
        cuid,
        taskId,
        status,
        response=None,
        url=None,
        internal_url=None,
        result=None,
    ):
        self.cuname = cuname
        self.cuid = cuid
        self.taskId = taskId
        self.status = status
        self.response = response
        self.url = url
        self.internal_url = internal_url
        self.result = result

    def serialize(self):
        return jsonify({
            "cuname": self.cuname,
            "cuid": self.cuid,
            "id": self.taskId,
            "status": self.status,
            "response": self.response,
            "url": self.url,
            "internal_url": self.internal_url,
            "result": self.result,
        })


def getResponseObject(
    cuname, cuid, taskId, status = None, response=None, url=None, internal_url=None, result=None
):
    return ResponseObject(
        cuname=cuname,
        cuid=cuid,
        taskId=id,
        status=status,
        response=response,
        url=url,
        internal_url=internal_url,
        result=result,
    ).serialize()

#TODO Check with Eros about status for this response object
def getResponseObjectWithUrl(cuname, cuid, taskId):
    return getResponseObject(
        cuname=cuname,
        cuid=cuid,
        taskId=taskId,
        url=url_for("check_task", id=taskId, _external=True),
        internal_url=url_for("check_task", id=taskId, _external=False),
    )


def cantScheduleCeleryErrorResponse(VERTEBRANAME, VERTEBRAID):
    return getResponseObject(
        cuname=VERTEBRANAME,
        cuid=VERTEBRAID,
        taskId=0,
        status="error",
        response=f"can't  schedule celery task for {VERTEBRANAME}",
    )


def unAuthorizedResponse(VERTEBRANAME, VERTEBRAID):
    return getResponseObject(
        cuname =VERTEBRANAME,
        cuid = VERTEBRAID,
        taskId = 0,
        status = "not autorized",
        response = f"user is not autorized for {VERTEBRANAME}",
    )


def getResponseFromTaskResult(VERTEBRANAME, VERTEBRAID, task, id):
    if task.state == "SUCCESS":
        response = getResponseObject(
            status=task.state,
            result=task.result,
            taskId=id,
            cuname=VERTEBRANAME,
            cuid=VERTEBRAID,
        )
    elif task.state == "FAILURE":
        response = json.loads(
            task.backend.get(task.backend.get_key_for_task(task.id)).decode("utf-8")
        )
        del response["children"]
        del response["traceback"]
    else:
        response = getResponseObject(
            status =  task.state,
            result =  task.info,
            taskId =  id,
            cuname =  VERTEBRANAME,
            cuid =  VERTEBRAID,
        )
    return response
