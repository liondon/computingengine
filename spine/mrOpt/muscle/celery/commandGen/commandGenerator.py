from muscleUtils import constants
from commandGen import ACMCommand, PMRCommand, MRCommand, DICommand

def getMrOptCommandFromTaskName(taskName, signalFile, noiseFile, optionsFileLocation, 
                                resultFile, logFile, qServer = None):
    if taskName == constants.PMR_TASK_NAME:
        return PMRCommand.getPMRCommand(signalFile, noiseFile, optionsFileLocation, 
                resultFile, logFile, qServer)
    elif taskName == constants.ACM_TASK_NAME:
        return ACMCommand.getACMCommand(signalFile, noiseFile, optionsFileLocation, 
                resultFile, logFile, qServer)
    elif taskName == constants.DI_TASK_NAME:
        return DICommand.getDICommand(signalFile, noiseFile, resultFile, logFile)
    elif taskName == constants.MR_TASK_NAME:
        return MRCommand.getMRCommand(signalFile, optionsFileLocation, resultFile, 
            logFile, qServer)
    else:
        print(f"{taskName} doesn't exist")
        return None
