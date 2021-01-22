# Brain 
*brain* is the python interface to the [CloudMR](www.cloudmrhub.com) apps. It works with pipelines an array of computatiion to solve a task.
for example simulate an MRI with Camrie, and evaulate SRN with MR Optimum.




## Implementation
flask

inside here i'll put the local images of camrie
### Docker
docker image is python:alpine 
run on port 5010

### Routes
- "/pipelines" receive a post a pipeline, which is an array of computations. Needed informations are:
    
    | Key | Value |
    | - | - |
    | application | application name ('camrie','mroptimum',...) |
    | options | calculation options for the app |
    | - | - |

    you get back the pipeline ID in {pipeline: 'xxxx}

- "pipelinestest" send a camrie task to camrie


## Notes


## TODO levels High and Low, Urgent and Important
- [x] define the pipelines API HU:HI
- [] upload file HU:HI 
    - CORS problem

- [] start calculation on camrieCU HU:HI  
    - [x] start the docker not neded because we have muscles now
    - [] store the info somewere (redis?) "pipelinestestwithredis"
    - [x] send the task request to a muscle (camrie "pipelinestest")
    - [] send the result back when requested
    - [] 


## Diary

### 29/09/2020
Routes pipelinestestwithredis test the storing of the information on redis

### 23/09/2020
- "/pipelinestest" 
    - [] Route need a json file from a post request
    - [] sends a task to camrie
    - [] next step will be store on redis the task in the queue


### 17/09/2020
- "/testjsonpost" 
    - Route need a json file from a post request
    - We tried [docker-py](https://docker-py.readthedocs.io/en/stable/) to start the docker




### 15/09/2010
- "/" roots is a GET or POST, i am trying to pass the data and download them locally to then start the calculation





    


## Links
[*Dr. Eros Montin, PhD*](http://me.biodimensional.com)

**46&2 just ahead of me!**


