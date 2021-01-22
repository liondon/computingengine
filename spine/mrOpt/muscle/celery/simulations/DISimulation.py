import os
from muscleUtils import constants 
from muscleUtils import fileUtils
from muscleUtils import execute
from muscleUtils import exceptionHandler
from commandGen import commandGenerator

def di_simulation(ctask, jopt):
    try:
        currentTaskDirectory = os.path.dirname(jopt)
        outputFile, logFile, matFile = fileUtils.getRequiredFileNames(currentTaskDirectory)
        
        requestParam = fileUtils.getJsonFromFile(jopt)["options"]
        
        imageFile1Path = os.path.join(currentTaskDirectory, "imageFile1.dat")
        imageFile2Path = os.path.join(currentTaskDirectory, "imageFile2.dat")

        fileUtils.downloadFiles(imageFile1Path, requestParam["imageFile1Url"])
        fileUtils.downloadFiles(imageFile2Path, requestParam["imageFile2Url"])

        command = commandGenerator.getMrOptCommandFromTaskName(constants.DI_TASK_NAME, imageFile1Path, imageFile2Path, 
                                            "", outputFile, logFile, "")
        print(command)
        if command is not None:
            execute.executeTask(ctask, command)
            return {"output": outputFile, "log": logFile, "mat": matFile}
        else: 
            return None
    except Exception as ex:
        exceptionHandler.handleException(ctask, ex)