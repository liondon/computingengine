import os
from muscleUtils import constants, fileUtils, execute, exceptionHandler
from commandGen import commandGenerator

def mr_simulation(ctask, jopt):
    try:
        currentTaskDirectory = os.path.dirname(jopt)
        outputFile, logFile, matFile = fileUtils.getRequiredFileNames(currentTaskDirectory)
        
        options = fileUtils.getJsonFromFile(jopt)["options"]
        files = options["files"]

        filePathsParam = "\"[{"
        fileNum = 0
        for file in files:
            if fileNum != 0:
                filePathsParam += ", "

            if isinstance(file, int) or file.isnumeric():
                downloadLink = fileUtils.getDataDownloadLink(file)
            else:
                downloadLink = file
            filePath = fileUtils.downloadFilefromUrl(currentTaskDir, "file{fileNum}", downloadLink)

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
