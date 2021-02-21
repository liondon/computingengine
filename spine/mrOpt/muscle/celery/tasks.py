import os
from celery import Celery, states
import json

CELERY_BROKER_URL = os.getenv("REDISSERVER", "redis://redis_server:6379")
CELERY_RESULT_BACKEND = os.getenv("REDISSERVER", "redis://redis_server:6379")

celery = Celery("tasks", broker=CELERY_BROKER_URL, backend=CELERY_RESULT_BACKEND)

from simulations import PMRSimulation, ACMSimulation, DISimulation, MRSimulation
from muscleUtils import constants, fileUtils, bluehostAPI
TMPDIR = os.getenv("TMPDIR", "/apptmp")


@celery.task(name=constants.PMR_TASK_NAME, bind=True)
def pmr_simulation(self, jopt):
    resultJson = PMRSimulation.pmr_simulation(self, jopt)
    print("=============== RESULT ===============", resultJson)
    return bluehostAPI.uploadResultToBluehost(resultJson, jopt)

@celery.task(name=constants.ACM_TASK_NAME, bind=True)
def acm_simulation(self, jopt):
    resultJson = ACMSimulation.acm_simulation(self, jopt)
    print("=============== RESULT ===============", resultJson)
    return bluehostAPI.uploadResultToBluehost(resultJson, jopt)

@celery.task(name=constants.DI_TASK_NAME, bind=True)
def di_simulation(self, jopt):
    resultJson = DISimulation.di_simulation(self, jopt) 
    print("=============== RESULT ===============", resultJson)
    return bluehostAPI.uploadResultToBluehost(resultJson, jopt)

@celery.task(name=constants.MR_TASK_NAME, bind=True)
def mr_simulation(self, jopt):
    resultJson = MRSimulation.mr_simulation(self, jopt)
    print("=============== RESULT ===============", resultJson)
    return bluehostAPI.uploadResultToBluehost(resultJson, jopt)
    

