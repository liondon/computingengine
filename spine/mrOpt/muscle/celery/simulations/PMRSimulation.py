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
        
        if isinstance(options["signalFile"], int) or options["signalFile"].isnumeric():
            # Using fileId
            result = fileUtils.downloadCmFile(signalFilePath, options["signalFile"])
            fileUtils.checkDownloadResult(result)
        else: 
            # Using fileURL
            fileUtils.downloadFiles(signalFilePath, options["signalFile"])

        if isinstance(options["noiseFile"], int) or options["noiseFile"].isnumeric():
            # Using fileId
            result = fileUtils.downloadCmFile(noiseFilePath, options["noiseFile"])
            fileUtils.checkDownloadResult(result)
        else: 
            # Using fileURL
            fileUtils.downloadFiles(noiseFilePath, options["noiseFile"])

        command = commandGenerator.getMrOptCommandFromTaskName(
            constants.PMR_TASK_NAME, 
            signalFilePath, noiseFilePath, 
            options["optionsFileUrl"], 
            outputFile, logFile, 
            options["qServer"]
        )
        print(command)
        execute.executeTask(ctask, command)

        with open(logFile, 'r') as log:
            print(log.read())
        with open(outputFile, 'r') as output:
            print(output.read())

        return {constants.OUTPUT_KEY: outputFile, "log": logFile, "mat": matFile}
    except Exception as ex:
        exceptionHandler.handleException(ctask, ex)
