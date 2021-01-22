import subprocess

def executeTask(ctask, command):
    ctask.update_state(state="PROGRESS", meta={"done": 5, "total": 60})
    ctask.update_state(state="PROGRESS", meta={"done": 10, "total": 60})
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    ctask.update_state(state="PROGRESS", meta={"done": 15, "total": 60})
    process.wait()
    ctask.update_state(state="PROGRESS", meta={"done": 60, "total": 60})
    # process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    # process.wait()
    return process.returncode
