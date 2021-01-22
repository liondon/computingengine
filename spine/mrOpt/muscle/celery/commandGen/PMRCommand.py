from muscleUtils import constants

class PMRCommand:
    def __init__(
 self,
        signalFile,
        noiseFile,
        optionsFileLocation,
        resultFile,
        logFile,
        QServer
    ):
        self.shFileName = "./run_PMRtask.sh"
        self.mcr = constants.MCR_PATH
        self.signalFile = signalFile
        self.noiseFile = noiseFile
        self.optionsFileLocation = optionsFileLocation
        self.resultFile = resultFile
        self.logFile = logFile
        self.QServer = QServer
    
    def serialize(self):
        return f"sh {self.shFileName} {self.mcr} {self.signalFile} {self.noiseFile} {self.optionsFileLocation} {self.resultFile} {self.logFile}  {self.QServer}"

def getPMRCommand(signalFile, noiseFile, optionsFileLocation, 
                resultFile, logFile, QServer):
    return PMRCommand(signalFile, noiseFile, optionsFileLocation, 
                resultFile, logFile, QServer).serialize()