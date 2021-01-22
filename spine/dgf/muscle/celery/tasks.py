import time
import datetime
import os, traceback
from celery import Celery, states
import subprocess


CELERY_BROKER_URL = os.getenv("REDISSERVER", "redis://redis_server:6379")
CELERY_RESULT_BACKEND = os.getenv("REDISSERVER", "redis://redis_server:6379")

celery = Celery('tasks', broker=CELERY_BROKER_URL, backend=CELERY_RESULT_BACKEND)


TMPDIR = os.getenv('TMPDIR', '/app')



@celery.task(name='dgf.cu', bind=True)
def dgf_simulation(self, jopt):
#    vertebra sends tmpdir a directory where i can write and the position of a json option file as defined in dgfCU version 20201026
    try:

        tmpdir=os.path.dirname(jopt)
        outputfile= os.path.join(tmpdir, "O.json")
        logfile= os.path.join(tmpdir, "L.json")
        matfile= os.path.join(tmpdir, "out.mat")

        self.update_state(state='PROGRESS', meta={'done': 5, 'total': 60})
        command= "sh ./run_dgf.sh /opt/mcr/v96/ " + jopt +" " + outputfile + " "+ logfile + " " + TMPDIR + "/ " + matfile
        self.update_state(state='PROGRESS', meta={'done': 10, 'total': 60})
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
        self.update_state(state='PROGRESS', meta={'done': 15, 'total': 60})
        process.wait()
        self.update_state(state='PROGRESS', meta={'done': 60, 'total': 60})
        

        
        return {"output": outputfile,"log":logfile,"mat":matfile}
    except Exception as ex:
        self.update_state(
            state=states.FAILURE,
            meta={
                'exc_type': type(ex).__name__,
                'exc_message': traceback.format_exc().split('\n')
            })
        raise ex
