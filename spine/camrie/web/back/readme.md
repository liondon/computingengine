# Camrie backend

## Implementation
express.js
### Docker
docker image is node:alpine 
run on port 4000

you need to set the NRAIN variable

### Routes
- "/testpipelinepost" route post a pipeline, which is an array of computations to *brain*
    
 

## TODO
- [ ] set variable from env
- [x] test connection between express and flask  
- [ ] task handling  
    - [x] send a default task  
    - [ ] customize tasks with an API



## Diary
### 17/09/2020
- [x] '/testjsonpost' route sends a post with reqest to *brain* and gte back the result, very cool
- [x] '/testcamrietask route sends a post reqest to *brain* with a standard request for a camrie task and get the id of the task back

### Next/2020
- [ ] '/tasks' routes POST, GET, PUT, DELETE to *brain*


## Links
[*Dr. Eros Montin, PhD*](http://me.biodimensional.com)

**46&2 just ahead of me!**

