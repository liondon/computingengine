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
            fileId = image["ID"]

            if fileNum != 0:
                filePathsParam += ", "
            filePath = os.path.join(currentTaskDirectory, f"file{fileNum}.dat")    

            result = fileUtils.downloadCmFile(filePath, fileId)
            fileUtils.checkDownloadResult(result)

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
        
        return {"output": outputFile, "log": logFile, "mat": matFile}
    except Exception as ex:
        exceptionHandler.handleException(ctask, ex)
