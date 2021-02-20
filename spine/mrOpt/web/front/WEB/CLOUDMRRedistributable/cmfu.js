//this dircetive allows user to upload and download data from cloudmr.
// eros.montin@nyulangone.org
//during the (first?) coronavirus pandemic of 2020...
//
//
//
//TO use it add in your had part this code in src and in your module add CMFU, oh CMFU stands fro CloudMR File Upload

//DIRECTIVES:
//cmFilesArray is the directive that actually get the referecence of the file list (you don't have to use this because the other two directives cmUploadButton and cmuploadSelectFile use it)
//
//
//
//
//
//cmUploadButton      
// parameters:
//model:json variable with info of the choosen files if multiple is true it must be an arrya of json
//user:the userid of the person who wants to upload the files
//multiple:,true if the field it will be possible o select multiple file multiple upload
//tootlip: the tool text
//
// this should be used as final directive in the applciation
//cmUploadSelectFile
//parameters:
// list:file list retrieved from the server for example,
// label: label on the 
//user:the userid of the person who wants to upload the files
//multiple:,true if the field it will be possible o select multiple file multiple upload
//tootlip: the tool text










//to cancel

//var THEOVERLAY = '<style>#cmfuoverlay { position: fixed; display: none; width: 100%; height: 100%; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0,0,0,0.5); z-index: 2; cursor: pointer;}</style><div id="cmfuoverlay"></div>';


var TTJQ = '<script>$(document).ready(function(){ $(\'[data-toggle="tooltip"]\').tooltip(); });</script>';

var BUTTONUPLOADSTYLE = '<style> .custom-file-input::before {} .custom-file-input:hover::before { border-color: black; } .custom-file-input:active::before {} .custom-file-upload { margin-bottom: 0px; } .custom-file-upload:hover, .custom-file-upload:focus, .custom-file-upload:active, .custom-file-upload.active, .open .dropdown-toggle.custom-file-upload {} .custom-file-upload:active, .custom-file-upload.active, .open .dropdown-toggle.custom-file-upload { background-image: none; } .custom-file-upload.disabled, .custom-file-upload[disabled], fieldset[disabled] .custom-file-upload, .custom-file-upload.disabled:hover, .custom-file-upload[disabled]:hover, fieldset[disabled] .custom-file-upload:hover, .custom-file-upload.disabled:focus, .custom-file-upload[disabled]:focus, fieldset[disabled] .custom-file-upload:focus, .custom-file-upload.disabled:active, .custom-file-upload[disabled]:active, fieldset[disabled] .custom-file-upload:active, .custom-file-upload.disabled.active, .custom-file-upload[disabled].active, fieldset[disabled] .custom-file-upload.active {} .custom-file-upload .badge {} </style>';

var CMUPLOADBUTTON = BUTTONUPLOADSTYLE + '<div class="cmPrependGroup"> <div data-toggle="tooltip" ng-attr-title="{{tooltip}}"> <div class="cmLcontainer" ng-if="((buttonstatus==\'selecting\') || (buttonstatus==\'readytoupload\'))"> <div class="mLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-if="(!(multiple) || isUndefined(multiple))"> <label href="javascript:void(0)" for="{{data.XX}}" class="custom-file-upload" style="cursor: pointer"> <i class="far fa-file fa-2x cmiconcolor" style="vertical-align:middle"></i> </label> <input type="file" id="{{data.XX}}" cm-files-array="data.files" style="display: none" button-state="data.state" /> </div> <div class="mLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-if="multiple"> <label href="javascript:void(0)" for="{{data.XXm}}" class="custom-file-upload" style="cursor: pointer"> <i class="far fa-copy fa-2x cmiconcolor" style="vertical-align:middle"></i> </label> <input type="file" id="{{data.XXm}}" cm-files-array="data.files" multiple style="display: none" /> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-show="data.DATALIST.length>0"> <a href="javascript:void(0)" ng-click="clickable=!clickable" ng-show="clickable"><i class="fas fa-edit"></i> </a> <a href="javascript:void(0)" ng-click="clickable=!clickable" ng-hide="clickable"><i class="far fa-edit"></i> </a> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-show="clickable"> <div style="display: flex;flex-direction:column;justify-content: center;flex-wrap: wrap;"> <div ng-repeat="F in data.DATALIST" style="z-index:100"> <input class="labelBox" type="text" ng-model="F.alias" ng-if="F.status==\'pending\'"> <span class="labelBox" ng-if="F.status==\'uploaded\'">{{F.alias}}</span> </div> </div> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <button ng-click="uploadFile()" ng-click="uploadFile()" ng-show="buttonstatus==\'readytoupload\'"> <i class="fas fa-cloud-upload-alt"></i> <span class="badge badge-light" ng-if="data.DATALIST.length>1">{{data.DATALIST.length}}</span></button> </div> </div> <div class="cmLcontainer" ng-if="buttonstatus==\'uploading\'"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <i class="far fa-file fa-2x fa-spin fa-fw cmiconcolor" ng-if="(!(multiple) || isUndefined(multiple))"></i></div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <i class="far fa-copy fa-2x fa-spin fa-fw cmiconcolor" ng-if="multiple"></i></div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <span class="cmLabelData"> uploading file</span></div> </div> <div class="cmLcontainer" ng-if="buttonstatus==\'done\'"> <div class="mLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-if="(!(multiple) || isUndefined(multiple))"> <label class="custom-file-upload"> <i class="far fa-file fa-2x cmiconcolor" style="vertical-align:middle"></i> </label> </div> <div class="mLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-if="multiple"> <label class="custom-file-upload"> <i class="far fa-copy fa-2x cmiconcolor" style="vertical-align:middle"></i> </label> </div> </div> </div></div>' + TTJQ;
//var CMUPLOADBUTTON='<style>.custom-file-input::before {}.custom-file-input:hover::before { border-color: black;}.custom-file-input:active::before {}.custom-file-upload { margin-bottom: 0px;} .custom-file-upload:hover, .custom-file-upload:focus, .custom-file-upload:active, .custom-file-upload.active, .open .dropdown-toggle.custom-file-upload { } .custom-file-upload:active, .custom-file-upload.active, .open .dropdown-toggle.custom-file-upload { background-image: none; } .custom-file-upload.disabled, .custom-file-upload[disabled], fieldset[disabled] .custom-file-upload, .custom-file-upload.disabled:hover, .custom-file-upload[disabled]:hover, fieldset[disabled] .custom-file-upload:hover, .custom-file-upload.disabled:focus, .custom-file-upload[disabled]:focus, fieldset[disabled] .custom-file-upload:focus, .custom-file-upload.disabled:active, .custom-file-upload[disabled]:active, fieldset[disabled] .custom-file-upload:active, .custom-file-upload.disabled.active, .custom-file-upload[disabled].active, fieldset[disabled] .custom-file-upload.active { } .custom-file-upload .badge { }</style> <label href="javascript:void(0)" for="{{data.XX}}" class="custom-file-upload"> <i class="far fa-file fa-2x cmiconcolor" style="vertical-align:middle"></i> </label><input type="file" id="{{data.XX}}" cm-files-array="data.files" style="display: none" />';

//var CMUPLOADSELECTBUTTON='<div class="cmLcontainer"> <div class="cmLflexitem cmLflexitem cmMarginSpaceLR cmMarginSpaceTB" > <span class="cmlabel">{{label}}</span> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <cm-upload-button multiple="multiple" user="user" model="model" tooltip={{tooltip}}></cm-upload-button> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-if="list.length>0"> </div></div>'
var CMUPLOADSELECTBUTTON = '<div class="fakeprepend"> <div style="display: flex;flex-direction: row;flex-wrap: wrap;align-items:center"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB "> <div class="cmLcontainer " style="align-items:center"> <div class="cmLflexitem cmLflexitem cmMarginSpaceLR cmMarginSpaceTB "> <span class="cmUploadLabel ">{{label}}</span> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB "> <cm-upload-button multiple="multiple " user="user " model="model " tooltip={{tooltip}} state="state "></cm-upload-button> </div> </div> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB " ng-if="list.length>0"> <cm-datalist-json list="THELIST" label="or select from" fieldsshow="filename" optionsvaluesfield="ID" model="data.THEMODEL" tooltip={{tooltip}}></cm-datalist-json> </div> <div class="cmLflexitem cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <div class="cmPrependGroup"> <div style="display: flex;flex-direction: row;flex-wrap: wrap;align-items:center"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB "> <button ng-click="resetthebutton()" title="reset the file list"><i class="fas fa-undo"></i></button> </div> <div class="cmLflexitem cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <cm-us-filenameshow jsonarray="model" multiple="multiple"></cm-us-filenameshow> </div> </div> </div> </div> </div></div>';




// var THEDATALIST = '<div class="cmLflexitem cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <div class="input-group"> <span class="input-group-addon"> Select from DB </span> <input type="text" list="{{datalistid}}" ng-model="data.S" ng-change="selected(data.S)" class="form-control" /> <datalist id="{{datalistid}}"> <option ng-repeat="v in THELIST" value="v.ID"> {{v.filename}}</option> </datalist> </div></div>';
// var THECHOSENFILE = '<div class="cmLflexitem cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <button ng-click="clickable=!clickable">w</button></div><div class="cmLflexitem cmLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-show="clickable"> <cm-us-filenameshow jsonarray="model" multiple="multiple"></cm-us-filenameshow></div>'
// var THEUPLOAD = '<div class="cmLcontainer" ng-if="((buttonstatus==\'selecting\') || (buttonstatus==\'readytoupload\'))"> <div class="mLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-if="(!(multiple) || isUndefined(multiple))"> <label href="javascript:void(0)" for="{{data.XX}}" class="custom-file-upload"> <i class="far fa-file fa-2x cmiconcolor" style="vertical-align:middle"></i> </label> <input type="file" id="{{data.XX}}" cm-files-array="data.files" style="display: none" button-state="data.state" /> </div> <div class="mLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-if="multiple"> <label href="javascript:void(0)" for="{{data.XXm}}" class="custom-file-upload"> <i h class="far fa-copy fa-2x cmiconcolor" style="vertical-align:middle"></i> </label> <input type="file" id="{{data.XXm}}" cm-files-array="data.files" multiple style="display: none" /> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-show="data.DATALIST.length>0"> <a href="javascript:void(0)" ng-click="clickable=!clickable" ng-show="clickable"><i class="fas fa-edit"></i> </a> <a href="javascript:void(0)" ng-click="clickable=!clickable" ng-hide="clickable"><i class="far fa-edit"></i> </a> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-show="clickable"> <div style="display: flex;flex-direction:column;justify-content: center;flex-wrap: wrap;"> <div ng-repeat="F in data.DATALIST" style="z-index:100"> <input class="labelBox" type="text" ng-model="F.alias" ng-if="F.status==\'pending\'"> <span class="labelBox" ng-if="F.status==\'uploaded\'">{{F.alias}}</span> </div> </div> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-hide="clickable"> ... </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <button ng-click="uploadFile()" class="cmButton" ng-click="uploadFile()" ng-show="buttonstatus==\'readytoupload\'"> Upload <span class="badge badge-light" ng-if="data.DATALIST.length>1">{{data.DATALIST.length}}</span></button> </div> </div> <div class="cmLcontainer" ng-if="buttonstatus==\'uploading\'"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <i class="far fa-file fa-2x fa-spin fa-fw cmiconcolor" ng-if="(!(multiple) || isUndefined(multiple))"></i></div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <i class="far fa-copy fa-2x fa-spin fa-fw cmiconcolor" ng-if="multiple"></i></div> </div> <div class="cmLcontainer" ng-if="buttonstatus==\'done\'"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <a href="javascript:void(0)" ng-click="clickable=!clickable" ng-init="clickable=false" ng-show="clickable"><i class="fas fa-eye"></i> </a> <a href="javascript:void(0)" ng-click="clickable=!clickable" ng-init="clickable=false" ng-hide="clickable"><i class="far fa-eye"></i> </a> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-show="clickable"> <div style="display: flex;flex-direction:column;justify-content: center;flex-wrap: wrap;"> <div ng-repeat="F in data.DATALIST" style="z-index:100"> <input class="labelBox" type="text" ng-model="F.alias" ng-if="F.status==\'pending\'"> <span class="labelBox" ng-if="F.status==\'uploaded\'">{{F.alias}}</span> </div> </div> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB" ng-hide="clickable"> ... </div> </div>'
// var CMFILEINPUT = '<div data-toggle="tooltip" ng-attr-title="{{tooltip}}"></div>' + THEUPLOAD + THEDATALIST + THECHOSENFILE + '</div>'


//needed
//loadscript("http://cloudmrhub.com/CLOUDMRRedistributable/resumable.js");
//loadscript("http://cloudmrhub.com/CLOUDMRRedistributable/anonymize_header.js");
//loadscript("https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/js/all.min.js");

loadscript("https://sdk.amazonaws.com/js/aws-sdk-2.814.0.min.js")


angular.module("CMFU", [])

    .factory("settings", [function () {


        var u = {

            url: document.location.origin,
            author: 'Dr. Eros Montin, PhD',
            email: 'eros.montin@nyulangone.com',
            personalemail: 'eros.montin@gmail.com',
        };

        u.uploadapi = u.url + '/Q/dataUploader.php';
        u.service = u.url + '/Q/serviceAPI.php';

        u.getUploadAPI = function () {
            return u.uploadapi;

        };
        u.getServiceAPI = function () {
            return u.service;

        };
        return u;
    }])

    //direcive that takes the actually takes the file
    .directive("cmFilesArray", ["$parse", function ($parse) {
        return {
            restrict: 'A',
            link: function (scope, element, attrs) {
                var model = $parse(attrs.cmFilesArray);
                var modelSetter = model.assign;
                element.bind('change', function () {
                    scope.$apply(function () {
                        modelSetter(scope, element[0].files);
                    });
                });
            }
        };
    }])


    //direcive that displays filename
    .directive("cmUsFilenameshow", [function () {
        return {
            restrict: 'E',
            scope: {
                jsonarray: "=",
                multiple: "="
            },
            template: '<ul ng-show="((multiple) && (jsonarray.length>0))" style="list-style-type:none;padding-left:0px;"><li ng-repeat="it in jsonarray track by $index"><span>{{it.filename}}</span></li></ul><ul style="list-style-type:none;padding-left:0px; ng-hide="multiple"><li><span>{{jsonarray.filename}}</span></li></ul>',
            link: function (scope, element, attrs) {

                // scope.$watch("jsonarray", function(n) {
                //     //     console.log(n);
                //     scope.items = n
                // }, true);

            }
        };

    }])



    .directive('cmUploadButton', ['cmFileUpload', 'settings', 'cmtool', '$q', '$timeout', function (cmFileUpload, settings, cmtool, $q, $timeout) {
        return {
            restrict: 'E',
            scope: {
                model: '=', //out json with info of the choosen files if multiple it must be an arrya of json must be instialized with a []
                user: '=', //the userid of the person who wants to upload the files
                multiple: '=', //if the field exist it will be consider to be used as multiple upload
                tootlip: '@', //tooltip for 
                state: '=' //interact with the button state, just put "reset" on this variable and the uplaoder is going to reset itself and the this variable is put to ready after
            },
            template: CMUPLOADBUTTON,

            link: function (scope, element, attrs) {
                //maybe woulf be cool a timer after that the download finish with an error

                //prepare the uiid of the labels
                var c = getUIID();
                var cm = getUIID();
                var uploaderwatcher; //unwatcher for the upload
                var userselectedwatcher; //unwatcher for the file selection







                scope.reset = function () {
                    scope.buttonstatus = 'selecting';
                    scope.data = { files: [], XX: c, XXm: cm };
                    scope.filestouploadarray = [];
                    scope.clickable = false;
                    scope.state = "ready";
                    try {
                        userselectedwatcher(); //remove the possible watcher
                    } catch (e) {

                    }
                    //create a new one

                    userselectedwatcher = scope.$watch('data.files', function (n) {
                        scope.data.DATALIST = [];

                        Array.from(n).forEach(function (f, i) {
                            scope.filestouploadarray.push(0);

                            var v = {
                                file: f,
                                status: 'pending',
                                alias: jsonCopy(f.name)

                            };
                            scope.data.DATALIST.push(v);

                            if (i === n.length - 1) {

                                scope.buttonstatus = 'readytoupload';
                            }

                        });
                    }, false);


                }

                //actually upload it
                scope.uploadFile = function () {
                    var bucketName = "cloudmrhub";
                    var bucketRegion = 'us-east-2';
                    var identityPoolId = 'us-east-2:f20bb844-8be4-4162-bb23-b33fb57bd7dc';
                    // TODO: the identityPoolId here Enable access to unauthenticated identities
                    // should change it to only allow logged-in users. Check AWS Cognito.

                    AWS.config.update({
                        region: bucketRegion,
                        credentials: new AWS.CognitoIdentityCredentials({
                            IdentityPoolId: identityPoolId,
                        })
                    });

                    var s3 = new AWS.S3({
                        apiVersion: '2006-03-01',
                        params: { Bucket: bucketName }
                    });

                    userselectedwatcher(); //we fon't need to watch the user selection
                    scope.buttonstatus = 'uploading';
                    // document.getElementById("cmfuoverlay").style.display = "block";
                    //get the upload API path
                    var UPLOADLINK = settings.getUploadAPI();
                    //get the service interface link
                    var SERVICELINK = settings.getServiceAPI();
                    //create the info needed to send
                    var DATA = scope.user;


                    var uploadpromises = [];
                    var TOBERETRIEVED = [];
                    //put all the 


                    scope.data.DATALIST.forEach(function (f, the) {


                        if (the == 0) {
                            // only the first time activate the watcher, will be removed by wearedone
                            uploaderwatcher = scope.$watch('filestouploadarray', function (neww) {

                                if (neww.reduce(function (pv, cv) { return pv + cv; }, 0) == neww.length) {
                                    scope.wearedone();
                                    console.log(neww);
                                }


                            }, true);

                        }

                        var thefilename = jsonCopy(f.file.name);

                        var EXT = getFilextension(thefilename);
                        var DATA = {
                            alias: jsonCopy(f.alias),
                            UID: scope.user.UID
                        };



                        const anonymizeAndUploadFile = async () => {
                            file = f.file
                            if (getFilextension(file.name) == "dat") {
                                f.file = await anonymizeTWIX(file);
                            }
                            scope.filestouploadarray[the].status = 1;
                            // uploadpromises.push(uploadpromise);
                            var filePath = scope.user.UID + "/" + f.alias + "/" + f.file.name;
                            var fileUrl = 'https://' + bucketRegion + '.amazonaws.com/' +
                                bucketName + "/" + filePath;
                            console.log(fileUrl);

                            s3.upload({
                                Key: filePath,
                                Body: f.file,
                                ACL: 'public-read'
                            }, function (err, data) {
                                if (err) {
                                    console.log(err);
                                } else {
                                    scope.filestouploadarray[the].status = 1;
                                    f.status = 'uploaded';
                                    scope.filestouploadarray[the] = 1;

                                    response = {}

                                    //Get signed url for the uploaded object
                                    const getSignedUrl = async () => {
                                        const params = {
                                            Bucket: bucketName,
                                            Key: filePath,
                                            Expires: 60 * 60 * 24 * 7
                                        };
                                        try {
                                            response.url = await new Promise((resolve, reject) => {
                                                s3.getSignedUrl('getObject', params, (err, url) => {
                                                    err ? reject(err) : resolve(url);
                                                });
                                            });
                                            console.log(response.url)
                                        } catch (err) {
                                            if (err) {
                                                console.log(err)
                                            }
                                        }
                                        //TODO This current works because id from here is visible in the main.js queuejob section.
                                        var O = {
                                            id: response.url,
                                            filename: f.alias,
                                            link: response.url,
                                            state: 'uploaded'
                                        }
                                        //if it's multiple file th eoutput is an array

                                        if (scope.multiple) {
                                            scope.model.push(O);
                                            //console.log("File " + O.filename + " Correctly Uploaded");
                                        } else {
                                            scope.model = O;
                                            //console.log("File " + O.filename + " Correctly Uploaded");
                                        }
                                    }
                                    getSignedUrl();


                                    alert('Successfully Uploaded!');

                                }

                            }).on('httpUploadProgress', function (progress) {
                                var uploaded = parseInt((progress.loaded * 100) / progress.total);
                                if (uploaded % 25 == 0) {
                                    console.log(uploaded);
                                }

                                $("progress").attr('value', uploaded);
                            });
                        }

                        anonymizeAndUploadFile();



                    });



                }; //uploadfile

                scope.wearedone = function () {
                    scope.buttonstatus = 'done';
                    uploaderwatcher();
                };
                var W = scope.$watch('state', function (o) {

                    if (typeof o === 'string' || o instanceof String)

                        switch (o) {
                            case "reset":
                            case "selected":
                                scope.reset();
                                break;
                        }

                }, true);
                //ten seconds after the load it start the reset
                //            $timeout(function() { if (scope.state!="ready") }, 10);

                scope.$on('$destroy', function () {
                    W();
                    console.log("left the button");
                });

                scope.reset();
            }
        }

    }])

    //this is the actual working directive to use
    .directive('cmUploadSelectFile', [function () {
        return {
            restrict: 'E',
            scope: {
                model: '=',
                user: '=',
                list: '=',
                label: '@',
                multiple: '=',
                tooltip: '@',
                statereset: "=" //to reset the button just put reset on this button

            },
            template: CMUPLOADSELECTBUTTON,
            link: function (scope, element, attrs) {

                scope.data = { THEMODEL: undefined };



                scope.reset = function () {
                    scope.data = { THEMODEL: undefined }
                    scope.clickable = false;
                    scope.model = [];

                };

                //deepscan the array to find fidderences 
                scope.$watch("list", function (newlist) {
                    scope.THELIST = newlist;
                }, true);


                scope.$watch("data.THEMODEL", function (t) {

                    if (!(isUndefined(t))) {
                        var T = jsonCopy(t);
                        T.id = T.ID;
                        T.state = "selected";
                        if (!(isUndefined(scope.model)) && !(isUndefined(T.id))) {
                            if (scope.multiple) {
                                scope.model.push(T);
                            } else {
                                scope.model = T;
                            }
                        }
                    }
                }, true);


                scope.$watch('statereset', function (o) {
                    if (isUndefined(o)) {

                    } else {
                        switch (o) {
                            case "reset":
                                scope.resetthebutton();
                                break;
                        }
                        scope.statereset = "ready";
                    }
                }, false);

                scope.resetthebutton = function () {
                    scope.state = "reset";
                    scope.reset();
                };


                scope.reset();

            }
        }

    }])

    .directive('cmFileinput', [function () {
        return {
            restrict: 'E',
            scope: {
                model: '=',
                user: '=',
                list: '=',
                label: '@',
                multiple: '=',
                tooltip: '@',
            },
            template: CMFILEINPUT,
            link: function (scope, element, attrs) {

                function cleanup() {
                    console.log("clean");
                    watcherL();
                }
                //deepscan the array to find fidderences 
                var watcherL = scope.$watch("list", function (newlist) {
                    scope.THELIST = newlist;
                }, true);



                scope.$on('$destroy', function () {
                    console.log("destroy");
                    cleanup();

                });
            }
        }
    }])