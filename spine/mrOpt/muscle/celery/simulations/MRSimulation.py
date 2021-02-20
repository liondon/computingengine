import os
from muscleUtils import constants 
from muscleUtils import fileUtils
from muscleUtils import execute
from muscleUtils import exceptionHandler
from commandGen import commandGenerator

def mr_simulation(ctask, jopt):
    try:
        currentTaskDirectory = os.path.dirname(jopt)
        outputFile, logFile, matFile = fileUtils.getRequiredFileNames(currentTaskDirectory)
        
        options = fileUtils.getJsonFromFile(jopt)["options"]

        images = options["files"]
        filePathsParam = "\"[{"
        fileNum = 0
        for image in images:
            if "ID" in image:
                fileId = image["ID"]

            if fileNum != 0:
                filePathsParam += ", "
            filePath = os.path.join(currentTaskDirectory, f"file{fileNum}.dat")    

            if fileId:
                result = fileUtils.downloadCmFile(filePath, fileId)
                fileUtils.checkDownloadResult(result)
            else:
                fileUtils.downloadFiles(filePath, fileUrl)

            filePathsParam += f"'{filePath}'"
            fileNum = fileNum + 1
        filePathsParam += "}]\""

        command = commandGenerator.getMrOptCommandFromTaskName(
            constants.MR_TASK_NAME, 
            filePathsParam, 
            None,
            options["optionsFileUrl"], 
            outputFile, logFile, 
            options["qServer"])
        print(command)
        execute.executeTask(ctask, command)

        with open(logFile, 'r') as log:
            print(log.read())
        with open(outputFile, 'r') as output:
            print(output.read())

        return {"output": outputFile, "log": logFile, "mat": matFile}
    except Exception as ex:
        exceptionHandler.handleException(ctask, ex)
