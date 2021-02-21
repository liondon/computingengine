## TODO
- Brainstem
	- [ ] flask image
		- [x] pipelines
		- [x] short term
		- [x] test sending a fake camrie task
			- afference
			- efference
			- sharing the space though images
	- Insert job to CloudMR DB new job list table: now it inserts job to JOBlist on MROpt DB 

- Muscles
	- [x] camrie CU
		- [x] fake code simple script that sleep and get the results
		- [x] test with real CAMRIECU
	- [ ] MR Optimum
		
- Senses
	- apis
	- routes

- Spinalnode
	- [x] Camrie
		- [x] redis + celery + flask + camrieCU + flower:)
		- [x] webgui
		- [x] back
	- [ ] DGF
		- [ ] redis + celery + flask + CU + flower:)
		- [ ] webgui
		- [ ] back
	- [ ] Data Eater
		- [ ] redis + celery + flask + CU + flower:)
		- [ ] webgui
		- [ ] back
	- [ ] Pseudo MR
		- [ ] redis + celery + flask + CU + flower:)
		- [ ] webgui
		- [ ] back
  - [ ] MR Optimum
    - [ ] redis + celery + flask + CU + flower:)
    - [ ] webgui
    - [ ] back
    - [ ] Mode2
      - [ ] Fixbug: upload data file to S3 bucket failed with large file that is divided into multiparts. 
      - Need to fix this before we can further test all the tasks. 
      - This might be caused by wrong config with S3 bucket.
      - Related file: `spine\mrOpt\web\front\WEB\CLOUDMRRedistributable\cmfu.js` 
      - [ ] Handle jopt file correctly: 
      - Issue - jopt is written into JSON file in docker volume by vertebra/sinalnode, there is not URL for the jopt file while the MATLAB executables requires URL as an argument. We should either add a web server that can provide url for the file, or change the MATLAB part to take a relative path instead of a url? 
      - Workaround for testing: Now it's using hardcoded jopt file url on cloudmrhub.com. Fix the related files after fixing the above issue: 
        - `spine\mrOpt\web\front\WEB\MROPTIMUMRedistribitable\main.js`: writing the hardcoded jopturl to `optionsFile` -> shouldn't write it
        - `spine\mrOpt\web\front\WEB\mrojs\factory.js`: there are hardcoded urls for jopt files
        - `brainstem\mrOptRouter\routeMrOptRequests.py`: getting the `optionsFileUrl` from `J` -> shouldn't do this, cause the jopt is written into JSON by vertebra/spinalnode. Also, the JSON data transmission could be further streamlined. There are redundant information and it's also hard to understand the relationship among different JSON data for different calls.
        - `spine\mrOpt\muscle\celery\simulations`: ACM, MR, PMR are using hardcoded jopt URL now, fix this after solving the above issue.
      - [ ] Find out what's causing `requests.exceptions.ConnectionError: ('Connection aborted.', ConnectionResetError(104, 'Connection reset by peer'))` with brainstem...
      - [ ] DI task: 
        - [X] working with small .jpg files
      - [ ] ACM & PMR task:
        - [X] working with small .jpg files (MATLAB program log error)
      - [ ] MR task:
        - [X] working with small .jpg files (MATLAB program log error)
    - [ ] Mode1
      - [ ] Test working with GUI deployed to Bluehost, the jopt file URL arguments are overwritten to default jopt files on Bluehost, not generated from the GUI. Deploy the GUI to Bluehost, delete the lines in `spine\mrOpt\muscle\celery\simulations` files and test it. 
      - [ ] Handle jopt file correctly: 
        - Issue - currently, the workflow is using jopt file URL for jopt file genearated by mode1 GUI on Bluehost, confirm is this is what we want?
      - [ ] DI task: 
        - [X] working with Dicom files downloaded from cloudmrhub.com
      - [ ] ACM & PMR task:
        - [ ] working with data files downloaded from cloudmrhub.com and default jopt file URL on Bluehost
							-> no response, stuck at executing the MATLAB executable. Maybe my VM is not powerful enough?
      - [ ] MR task:
        - [ ] working with data files downloaded from cloudmrhub.com and default jopt file URL on Bluehost
							-> error, not sure what's causing it

				```sh
				mroptmuscleworker_1     | [2021-02-21 07:50:57,601: WARNING/ForkPoolWorker-2] =============== Command ===============
				mroptmuscleworker_1     | [2021-02-21 07:50:57,602: WARNING/ForkPoolWorker-2] sh ./run_MRtask.sh /opt/mcr/v98 "[{'/apptmp/871c8583-6fdb-4a00-ba7f-2578e3fe9770/file0.dat'}]" http://cloudmrhub.com/apps/MROPTIMUM/APPDATA/212/MR/J/MROPT_5f452fca92548.json /apptmp/871c8583-6fdb-4a00-ba7f-2578e3fe9770/O.json  /apptmp/871c8583-6fdb-4a00-ba7f-2578e3fe9770/L.json http://cloudmrhub.com/Q/
				mroptmuscleworker_1     | [2021-02-21 07:51:09,743: WARNING/ForkPoolWorker-2] =============== LOG ===============
				mroptmuscleworker_1     | [2021-02-21 07:51:09,743: WARNING/ForkPoolWorker-2] {"time":"21-Feb-2021 07:51:06","text":"ERROR","type":"error"}
				```



- Session manager

- Security

[*Dr. Eros Montin, PhD*](http://me.biodimensional.com)

**46&2 just ahead of me!**
