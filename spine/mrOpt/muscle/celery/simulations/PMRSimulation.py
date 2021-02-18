import os
from muscleUtils import constants 
from muscleUtils import fileUtils
from muscleUtils import userAuth
from muscleUtils import execute
from muscleUtils import exceptionHandler
from commandGen import commandGenerator

def  pmr_simulation(ctask, jopt):
    try:
        currentTaskDirectory = os.path.dirname(jopt)
        outputFile, logFile, matFile = fileUtils.getRequiredFileNames(currentTaskDirectory)
        
        options = fileUtils.getJsonFromFile(jopt)["options"]
        
        signalFilePath = os.path.join(currentTaskDirectory, "signalFile.dat")
        noiseFilePath = os.path.join(currentTaskDirectory, "noiseFile.dat")

        result = fileUtils.downloadCmFile(signalFilePath, options["signalFile"])
        fileUtils.checkDownloadResult(result)

        result = fileUtils.downloadCmFile(noiseFilePath, options["noiseFile"])
        fileUtils.checkDownloadResult(result)

        command = commandGenerator.getMrOptCommandFromTaskName(
            constants.PMR_TASK_NAME, 
            signalFilePath, noiseFilePath, 
            options["optionsFileUrl"], 
            outputFile, logFile, 
            options["qServer"]
        )
        print(command)
        execute.executeTask(ctask, command)
        
        return {constants.OUTPUT_KEY: outputFile, "log": logFile, "mat": matFile}
    except Exception as ex:
        exceptionHandler.handleException(ctask, ex)
