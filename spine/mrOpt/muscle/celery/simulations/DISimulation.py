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
        
        options = fileUtils.getJsonFromFile(jopt)["options"]
        print('options', options)
        
        imageFile1Path = os.path.join(currentTaskDirectory, "imageFile1.dat")
        imageFile2Path = os.path.join(currentTaskDirectory, "imageFile2.dat")

        print(options["imageFile1"])
        if isinstance(options["imageFile1"], int) or options["imageFile1"].isnumeric():
            # Using fileId
            result = fileUtils.downloadCmFile(imageFile1Path, options["imageFile1"])
            fileUtils.checkDownloadResult(result)
        else: 
            # Using fileURL
            fileUtils.downloadFiles(imageFile1Path, options["imageFile1"])

        if isinstance(options["imageFile2"], int) or options["imageFile2"].isnumeric():
            # Using fileId
            result = fileUtils.downloadCmFile(imageFile2Path, options["imageFile2"])
            fileUtils.checkDownloadResult(result)
        else: 
            # Using fileURL
            fileUtils.downloadFiles(imageFile2Path, options["imageFile2"])

        command = commandGenerator.getMrOptCommandFromTaskName(
            constants.DI_TASK_NAME, 
            imageFile1Path, imageFile2Path, 
            "", 
            outputFile, logFile, 
            "")
        print(command)
        if command is not None:
            execute.executeTask(ctask, command)

            with open(logFile, 'r') as log:
                print(log.read())
            with open(outputFile, 'r') as output:
                print(output.read())

            return {"output": outputFile, "log": logFile, "mat": matFile}
        else: 
            return None
    except Exception as ex:
        exceptionHandler.handleException(ctask, ex)
