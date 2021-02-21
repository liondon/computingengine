import os
from muscleUtils import constants 
from muscleUtils import fileUtils
from muscleUtils import execute
from muscleUtils import exceptionHandler
from commandGen import commandGenerator

def di_simulation(ctask, jopt):
    try:
        currentTaskDir = os.path.dirname(jopt)
        outputFile, logFile, matFile = fileUtils.getRequiredFileNames(currentTaskDir)
        
        options = fileUtils.getJsonFromFile(jopt)["options"]
        print('=============== Task Options ===============', options)

        if isinstance(options["imageFile1"], int) or options["imageFile1"].isnumeric():
            downloadLink = fileUtils.getDataDownloadLink(options["imageFile1"]) 
        else: 
            downloadLink = options["imageFile1"]            
        imageFile1Path = fileUtils.downloadFilefromUrl(currentTaskDir, "imageFile1", downloadLink)

        if isinstance(options["imageFile2"], int) or options["imageFile2"].isnumeric():
            downloadLink = fileUtils.getDataDownloadLink(options["imageFile2"])
        else:
            downloadLink = options["imageFile2"]
        imageFile2Path = fileUtils.downloadFilefromUrl(currentTaskDir, "imageFile2", downloadLink)

        command = commandGenerator.getMrOptCommandFromTaskName(
            constants.DI_TASK_NAME, 
            imageFile1Path, imageFile2Path, 
            "", 
            outputFile, logFile, 
            ""
        )
        print("=============== Command ===============", command)

        if command is not None:
            execute.executeTask(ctask, command)

            with open(logFile, 'r') as log:
                print("=============== LOG ===============", log.read())
            # with open(outputFile, 'r') as output:
            #     print("=============== OUTPUT ===============", output.read())

            return {"output": outputFile, "log": logFile, "mat": matFile}
        else: 
            return None
    except Exception as ex:
        exceptionHandler.handleException(ctask, ex)
