const express = require('express');
const request = require('request');
const cors = require('cors');
const bodyParser = require('body-parser')
const app = express();
const fileUpload = require('express-fileupload');
var fs = require('fs');
var uuid = require('uuid');
const axios = require('axios');

const PORT=process.env.PORT || 4000;
 


const BRAIN=process.env.BRAIN || 'http://localhost:5010';

const UPLOADDIR=process.env.UPLOADDIR || '/tmp'

const USERNAME = process.env.USERNAME || 'Eros'
const PWD = process.env.PWD || 'Eros'



var TASKS=[]
var FILES=[]

app.use(cors());
// support parsing of application/json type post data
app.use(bodyParser.json());

//support parsing of application/x-www-form-urlencoded post data
app.use(bodyParser.urlencoded({ extended: true }));
app.use((req, res, next) => {
  // do something
  console.log('test');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST,  OPTIONS, PUT, PATCH, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.header("Access-Control-Allow-Headers", "Origin, Content-Type, Authorization, Content-Length, X-Requested-With, Host, Accept-Encoding, Referer, Accept, Content-Disposition, Content-Range, Content-Disposition, Content-Description")
  
  next();
});





function fixTheTasksForCamrie() {
  return new Promise(function(resolve, reject) {
    

    let thetasks=[];
    let status="";
    let results="";
    TASKS.forEach((t)=>{
      
      switch(t.pipelinestatus){
        case "calculating":
          status="calc";
          results=null;
          break;
        case "completed":
          status="ok";
          results="http://localhost:" + PORT  + "/output/" + t.pipeline //let's transfrom the json into an api
          break;
      }

      thetasks.push({
        Alias:"test",
        ID:t.pipeline,
        UID:212,
        dateIN: "2020-04-30 09:24:23",
        dateOUT: "2020-04-30 09:24:23",
        size:00,
        optionJsonFN: "http://cloudmrhub.com/apps/MROPTIMUM/APPDATA/212/ACM/J/ACMOPT_5eaaeda7542c9.json",
        status:status,
        results:results})
    })

    resolve(thetasks);
    

    
  });
}



// default options
app.use(fileUpload());



app.get("/output/:id",function(req,res){
  
let id =req.params.id;
console.log(id);

let pip = TASKS.find(el => el.pipeline === id);

fs.readFile(pip.pipes[0].output.output, 'utf8', function (err, data) {
  if (err) {
    // handle error
    return;
  }
  

return res.json(JSON.parse(data))

});
});


app.post('/fileupload', function(req, res) {
  if (!req.files || Object.keys(req.files).length === 0) {
    return res.status(400).send('No files were uploaded.');
  }

  // The name of the input field (i.e. "sampleFile") is used to retrieve the uploaded file
  let sampleFile = req.files.myfile;
 

  // Use the mv() method to place the file somewhere on your server
  FILE=UPLOADDIR + "/" + uuid.v4()+ '.' + sampleFile.name.split('.').pop();

  var TEST=[];


  sampleFile.mv(FILE, function(err) {
    if (err)
      return res.status(500).send(err);
    
      FILES.push(FILE)
      console.log(FILES)
      fs.readdir(UPLOADDIR, function(err, items) {
          
          items.forEach((f,n)=>{
              TEST.push(f);
          })
          
      });
      res.json({link:FILE,test:TEST});
     // res.send(FILE);
  });
});




 
app.post('/tasks', (req, res) => {
  //add a task
  
  
  var J=req.body;

  var options = {
    uri: BRAIN + '/pipelines',
    method: 'POST',
    json: {    
      theuser:USERNAME,
    thepwd:PWD,
    pipeline:[{
      application: "camrie",
      options:J,

    }]}
  };

  request(options, function (error, response, body) {
    let ans='';
    if (!error && response.statusCode == 200) {        

      console.log(body);
      try{
      ans=JSON.parse(body);
      }catch(e){
      ans=body
      }
      
      TASKS.push(ans);
      
      return res.json(ans);

    }else{
      return res.send('GET HTTP  nono');
    }});



});


// just an example
app.get('/tasksfull/', (req, res) => {
  var link= BRAIN + '/pipelines/';

  let   NEWTASK=[]

  let promises=[]

  TASKS.forEach((t)=>{


    if (t.pipelinestatus=="completed")
    {
      NEWTASK.push(t);
    }else{
    promises.push(
      axios.get(link + t.pipeline).then(response => {
        NEWTASK.push(response.data);
      })
    );
    }

  // 
  
   
 
});
axios.all(promises).then(() => {
  TASKS=NEWTASK;  
  return res.json(TASKS );});
});

app.get('/tasks/', (req, res) => {

  // update the tasks array
  var link= BRAIN + '/pipelines/';
  let   NEWTASK=[]
  let promises=[]

  TASKS.forEach((t)=>{


    if (t.pipelinestatus=="completed")
    {
      NEWTASK.push(t);

      // i can delete this if i find asmart way to link the last function...
      promises.push(
        new Promise(resolve => setTimeout(resolve, 10))
      );


    }else{
    promises.push(
      axios.get(link + t.pipeline).then(response => {
        NEWTASK.push(response.data);
      })
    );
    }

  // 
  
   
 
});

// when all the update it is done we can parse as requested by the front end
//console.log(axios);
axios.all(promises).then(() => {
  TASKS=NEWTASK;  
  
}).then(()=>{
  
  fixTheTasksForCamrie().then((out)=>{
    return res.json(out);});
  });
  
});



app.put('/tasks/:taskId', (req, res) => {
  return res.send(
    `PUT HTTP method on task/${req.params.taskId} resource`,
  );
});
 
app.delete('/tasks/:taskId', (req, res) => {
  return res.send(
    `DELETE HTTP method on task/${req.params.taskId} resource`,
  );
});




app.listen(PORT,()=>console.log('Server started on port '+ PORT));