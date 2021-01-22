import os

camrieEfference = os.getenv("CAMRIE", "http://localhost:5115/efference")
dgfEfference = os.getenv("DGF", "http://localhost:5114/efference")
mrOptEfference = os.getenv("MROPTIMUM", "http://localhost:5009/efference")


BLUEHOST_FALL2020_BASE_URL = "http://cloudmrhub.com/"
# BLUEHOST_FALL2020_BASE_URL = "http://localhost:1000/"
JOB_INSERT_PATH_TO_BLUEHOST = "apps/MROPTIMUM/mroQ/insertJob2.php"
JOB_INSERT_FULL_URL = BLUEHOST_FALL2020_BASE_URL + JOB_INSERT_PATH_TO_BLUEHOST
