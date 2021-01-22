const express = require('express');
const app = express();

const PORT=4000;

const fileUpload = require('express-fileupload');



var fs = require('fs');



// default options
app.use(fileUpload());

var uuid = require('uuid');


var cors = require('cors')
app.use(cors());
app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST,  OPTIONS, PUT, PATCH, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.header("Access-Control-Allow-Headers", "Origin, Content-Type, Authorization, Content-Length, X-Requested-With, Host, Accept-Encoding, Referer, Accept, Content-Disposition, Content-Range, Content-Disposition, Content-Description")
   console.log(res);
  next();
});




app.get('/',(req,res) =>{

     res.send('inside');
 });


var UPLOADIR ='/DATA/';

app.post('/upload', function(req, res) {
    if (!req.files || Object.keys(req.files).length === 0) {
      return res.status(400).send('No files were uploaded.');
    }
  
    // The name of the input field (i.e. "sampleFile") is used to retrieve the uploaded file
    let sampleFile = req.files.myfile;
   

    // Use the mv() method to place the file somewhere on your server
    FILE=UPLOADIR + uuid.v4()+ '.' + sampleFile.name.split('.').pop();

    var TEST=[];

    sampleFile.mv(FILE, function(err) {
      if (err)
        return res.status(500).send(err);

        fs.readdir(UPLOADIR, function(err, items) {
            
            items.forEach((f,n)=>{
                TEST.push(f);
            })
            
        });
        res.json({file:FILE,test:TEST});
       // res.send(FILE);
    });
  });




  app.get('/',(req,res) =>{

    res.send('inside');
});


// this test the comunication between express and flask
app.get('/testjson', (req, res) => {
 request(BRAIN + '/testjson', function (error, response, body) {
   let ans='';
   if (!error && response.statusCode == 200) {        
     
     ans=JSON.parse(body);
     console.log(ans);        
     return res.send('GET HTTP method on task resource ' + ans.username);

   }else{
     return res.send('GET HTTP  nono');
   }});

});



// this test the comunication between express and flask with post
app.get('/testjsonpost', (req, res) => {
 var options = {
   uri: BRAIN + '/testjsonpost',
   method: 'POST',
   json: {
     "username": "http://www.google.com/"
   }
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
  
     return res.send('GET HTTP method on task resource ' + ans.username);

   }else{
     return res.send('GET HTTP  nono');
   }});

});




// this test send a carie request to brain, and send a pipeline which it is an array of elaborations in this case just ask for camrie
app.get('/testpipelinepost', (req, res) => {
 var options = {
   uri: BRAIN + '/pipelines',
   method: 'POST',
   json: {pipeline:[{
     order: 0,
     application: "camrie",
     inputs:[],
     options:{"version":"v0","output":{"noise":false,"sar":false,"signal":true},"imagereconstruction":"0","geometry":{"id":169,"filename":"Geometry_head2x2x2.txt","link":"http://cloudmrhub.com/test/head_2x2x2.txt","state":"uploaded"},"tissue":{"id":170,"filename":"Tissue_300MHz.prop","link":"http://cloudmrhub.com/test/Tissue_300MHz.prop","state":"uploaded"},"fields":{"B0":3,"tdb":[],"gradx":[],"grady":[],"gradz":[],"b1plus":[],"b1minus":[],"etransmitted":[],"ereceived":[]},"coils":{"receivingCoilsNumber":8,"transmittingCoilsNumber":8},"sequence":{"sequencename":"1","rfshape":"1","rfpd":2.6,"nrfp":128,"rffa":90,"TE":10,"TR":500,"dTR":0,"TI":10,"pedirection":"1","sliceorientation":"1","slicethickness":2,"matrixsize0":128,"matrixsize1":128,"fov0":300,"fov1":300,"resol0":2.34375,"resol1":2.34375,"rbw":50,"ss":true,"pe":true,"fe":true,"setX":0,"setY":0,"setZ":0},"Alias":"test 1"},
     outputs:[]
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
  
     return res.send('my pipeline id is' + ans.pipelineid);

   }else{
     return res.send('GET HTTP  nono');
   }});

});

//   var multer = require('multer');

//   app.post('/uploadmulter',function(req,res){
  
  
//        var your_filename = "";
//           var storage = multer.diskStorage({ 
//                             destination: function (req, file, cb) {
//                  cb(null, __dirname + UPLOADIR)
//               },
//               filename: function (req, file, cb) {
//                  var datetimestamp = Date.now(),
//                  file_name = file.originalname.split(".");
  
//                  your_filename = file_name[0]+'_'+datetimestamp+'.'+file_name[1];
//                  cb(null,  your_filename);
//               }
//           });
//               var upload = multer({ //multer settings
//                   storage: storage
//               }).single('file');
  
//               upload(req,res,function(err){
//                   if(err){
//                        res.json({error_code:1,err_desc:err});
//                        return;
//                   }
//                  res.json({error_code:0,err_desc:null,filename:your_filename});
//               })
  
//   })

// https://stackoverflow.com/questions/34550473/angularjs-failed-to-upload-file-express

app.listen(PORT,()=>console.log('Server started on port '+ PORT));


