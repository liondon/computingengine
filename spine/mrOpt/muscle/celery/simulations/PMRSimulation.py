import os
from muscleUtils import constants, fileUtils, userAuth, execute, exceptionHandler
from commandGen import commandGenerator

def  pmr_simulation(ctask, jopt):
    try:
        currentTaskDir = os.path.dirname(jopt)
        outputFile, logFile, matFile = fileUtils.getRequiredFileNames(currentTaskDir)
        
        options = fileUtils.getJsonFromFile(jopt)["options"]
        print('=============== Task Options ===============', options)

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

        # TODO: using jopt file on bluehost for mode1, the default for mode2. See README for details.
        optionsFileUrl = options["optionsFileUrl"] if "optionsFileUrl" in options else None 
        
        # TODO: use default jopt on bluehost for testing
        optionsFileUrl = "http://cloudmrhub.com/apps/MROPTIMUM/APPDATA/147/PMR/J/PMROPT_5d1d0e23de333.json"

        command = commandGenerator.getMrOptCommandFromTaskName(
            constants.PMR_TASK_NAME, 
            signalFilePath, noiseFilePath, 
            optionsFileUrl,
            outputFile, logFile, 
            constants.qServer
        )
        print("=============== Command ===============", command)
        execute.executeTask(ctask, command)

        with open(logFile, 'r') as log:
            print("=============== LOG ===============", log.read())
        with open(outputFile, 'r') as output:
            print("=============== OUTPUT ===============", output.read())

        return {"output": outputFile, "log": logFile, "mat": matFile}
    except Exception as ex:
        exceptionHandler.handleException(ctask, ex)
