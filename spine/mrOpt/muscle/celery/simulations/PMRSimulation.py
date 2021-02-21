import os
from muscleUtils import constants, fileUtils, userAuth, execute, exceptionHandler
from commandGen import commandGenerator

def  pmr_simulation(ctask, jopt):
    try:
        currentTaskDirectory = os.path.dirname(jopt)
        outputFile, logFile, matFile = fileUtils.getRequiredFileNames(currentTaskDirectory)
        
        options = fileUtils.getJsonFromFile(jopt)["options"]
        if isinstance(options["signalFile"], int) or options["signalFile"].isnumeric():
            downloadLink = fileUtils.getDataDownloadLink(options["signalFile"])
        else:
            downloadLink = options["signalFile"]
        signalFilePath = fileUtils.downloadFilefromUrl(currentTaskDir, "signalFile", downloadLink)

        if isinstance(options["noiseFile"], int) or options["noiseFile"].isnumeric():
            downloadLink = fileUtils.getDataDownloadLink(options["noiseFile"])
        else:
            downloadLink = options["noiseFile"]
        noiseFilePath =  fileUtils.downloadFilefromUrl(currentTaskDir, "noiseFile", downloadLink)

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
