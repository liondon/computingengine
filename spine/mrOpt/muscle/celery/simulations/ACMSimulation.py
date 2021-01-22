import os
from muscleUtils import constants 
from muscleUtils import fileUtils
from muscleUtils import execute
from muscleUtils import exceptionHandler
from commandGen import commandGenerator

def acm_simulation(ctask, jopt):
    try:
        currentTaskDirectory = os.path.dirname(jopt)
        outputFile, logFile, matFile = fileUtils.getRequiredFileNames(currentTaskDirectory)
        
        requestParam = fileUtils.getJsonFromFile(jopt)["options"]
        
        signalFilePath = os.path.join(currentTaskDirectory, "signalFile.dat")
        noiseFilePath = os.path.join(currentTaskDirectory, "noiseFile.dat")

        fileUtils.downloadFiles(signalFilePath, requestParam["signalFileUrl"])
        fileUtils.downloadFiles(noiseFilePath, requestParam["noiseFileUrl"])

        command = commandGenerator.getMrOptCommandFromTaskName(constants.ACM_TASK_NAME, signalFilePath, noiseFilePath, 
                                            requestParam["optionsFileUrl"], outputFile, logFile, requestParam["qServer"])
        print(command)
        execute.executeTask(ctask, command)
        
        return {"output": outputFile, "log": logFile, "mat": matFile}
    except Exception as ex:
        exceptionHandler.handleException(ctask, ex)