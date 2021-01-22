from muscleUtils import constants

class MRCommand:
    def __init__(
        self,
        imagesList,
        optionsFileLocation,
        resultFile,
        logFile,
        QServer
    ):
        self.shFileName = "./run_MRtask.sh"
        self.mcr = constants.MCR_PATH
        self.imagesList = imagesList
        self.optionsFileLocation = optionsFileLocation
        self.resultFile = resultFile
        self.logFile = logFile
        self.QServer = QServer
    
    def serialize(self):
        return f"sh {self.shFileName} {self.mcr} {self.imagesList} {self.optionsFileLocation} {self.resultFile}  {self.logFile} {self.QServer}"

def getMRCommand(imagesList, optionsFileLocation, 
                resultFile, logFile, QServer):
    return MRCommand(imagesList, optionsFileLocation, 
                resultFile, logFile, QServer).serialize()