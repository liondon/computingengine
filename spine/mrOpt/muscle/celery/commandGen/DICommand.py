from muscleUtils import constants

class DICommand:
    def __init__(
        self,
        imageFile1,
        imageFile2,
        resultFile,
        logFile
    ):
        self.shFileName = "./run_DImat.sh"
        self.mcr = constants.MCR_PATH
        self.imageFile1 = imageFile1
        self.imageFile2 = imageFile2
        self.resultFile = resultFile
        self.logFile = logFile
    
    def serialize(self):
        return f"sh {self.shFileName} {self.mcr} {self.imageFile1} {self.imageFile2} {self.resultFile}  {self.logFile}"

def getDICommand(imageFile1, imageFile2, resultFile, logFile):
    return DICommand(imageFile1, imageFile2, resultFile, logFile).serialize()