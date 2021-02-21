## TODO
- Brainstem
	- [ ] flask image
		- [x] pipelines
		- [x] short term
		- [x] test sending a fake camrie task
			- afference
			- efference
			- sharing the space though images

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
    - [ ] mode2
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
        - [ ] working with .dat/Dicom files (test this after uploading large file to S3 bug fixed)
      - [ ] ACM & PMR task:
        - [X] working with small .jpg files (MATLAB program log error)
        - [ ] working with .dat/Dicom files (test this after uploading large file to S3 bug fixed)
      - [ ] MR task:
        - [X] working with small .jpg files (MATLAB program log error)
        - [ ] working with .dat/Dicom files (test this after uploading large file to S3 bug fixed)


- Session manager

- Security

[*Dr. Eros Montin, PhD*](http://me.biodimensional.com)

**46&2 just ahead of me!**
