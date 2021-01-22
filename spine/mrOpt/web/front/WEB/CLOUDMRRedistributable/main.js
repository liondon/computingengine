//allows to get your data delete send emails

var TTJQ = '<script>$(document).ready(function(){ $(\'[data-toggle="tooltip"]\').tooltip(); });</script>';

var CMDATALIST = '<div class="input-group"> <span class="input-group-addon" id="{{ID}}">{{label}}</span><input type="text" list="{{data.XX}}" ng-model="data.S" ng-change="selected(data.S)"  class="form-control"/><datalist id="{{data.XX}}" > <option ng-repeat="v in list" value="{{v[optionsvaluesfield]}}" > {{v[fieldsshow]}}</option></datalist></div>';




var CMSIMPLESELECT = '<div class="input-group" data-togle="tootltip" ng-attr-title="{{tooltip}}"> <span class="input-group-addon" id="{{data.ID}}" >{{label}}</span><select class="form-control" ng-model="model"><option ng-repeat="v in list" value={{v[optionsvaluesfield]}}>{{v[fieldsshow]}}</option></select></div><script>$(document).ready(function(){$(\'[data-toggle="tooltip"]\').tooltip();});</script>';




// var CMBUGREPORT = '<div class="container"> <form style="position: absolute;left: 50%;top: 50%;transform: translate(-50%, -50%);max-width: 30%"> <div class="cmParagraph"> <div class="cmFontTitle"> Thank you for reporting a bug</div> </div><div style="margin-bottom:1em"> <cm-datalist-json label="App" list="list" fieldsshow="name" optionsvaluesfield="name" model="model" > </cm-datalist-json> </div> <div style="margin-bottom:1em"> <cm-text-input model="title" label="Title" placeholder="Felix Bloch and Edward Purcell"></cm-text-input> </div> <div style="margin-bottom:1em"> <textarea class="form-control" rows="8" placeholder="Please enter your message here" ng-model="msg" ></textarea> </div> <div style="margin-bottom:1em; margin-top: 2em"> <button type="submit" class="cmButton" ng-click="sendfunction()" style="left: 0px">Submit</button> <button type="submit" class="cmButton" ng-click="resetbug()" style="right: 0px;float: right">Reset</button> </div> </form></div>';


var CMBUGSTYLE = '<style>.bugcontainer{border: 2px solid #dedede;border-radius: 5px;padding: 10px;margin: 10px 0;} .userbugreporter{border-color: #ccc; background-color: #ddd;  text-align: left;margin-right:21%} .bugcontainer::after {content: "";clear: both;display: table;} .cmbuganswer{border-color: #ccc; background-color: var(--NYUcolor01);  text-align: right;margin-left:21%} .time-right {float: right;color: #aaa;} .time-left { float: left; color: #999;} .bugcontainer img {float: left;max-width: 60px;width: 100%;margin-right: 20px;border-radius: 50%;} .bugcontainer img.rightimage{float: right;margin-left: 20px;margin-right:0;} .bugopen{color:var(--NYUcolor);} .bugwip{color:darkorange;} .bugclosed{color:red;} .bugsolved {color:green;} .panel {&.cmbuggylist {& > .panel-heading {background-image: none;background-color: transparent;color: black;border-bottom-width:"medium";border-bottom-style: groove;border-bottom-color: black; }} } .cmbugtitle::first-letter{text-transform: capitalize}</style>';



var BUGCOLOR = 'ng-class="{bugopen:h.status==\'open\',bugwip:h.status==\'wip\',bugsolved:h.status==\'resolved\',bugclosed:h.status==\'closed\'}"';

THEBUGLEGEND = '<div style="display:flex;flex-direction:row;flex-wrap:wrap;justify-content:center;align-items:stretch"> <div style="padding:2em"class= "cmMarginSpaceLR cmMarginSpaceTB "><i class="fas fa-bug bugopen" style="margin-right="1em"> </i>  Open</div> <div style="padding:2em" class= "cmMarginSpaceLR cmMarginSpaceTB "><i class="fas fa-bug bugwip" style="margin-right="1em"> </i> Work In Progress </div> <div style="padding:2em" class= "cmMarginSpaceLR cmMarginSpaceTB "><i class="fas fa-bug bugsolved" style="margin-right="1em"></i> Closed </div> <div style="padding:2em" class= "cmMarginSpaceLR cmMarginSpaceTB "><i class="fas fa-bug bugclosed" style="margin-right="1em"></i> On Hold</div></div>';


var THEBUGPANEL = '<uib-accordion > <div uib-accordion-group class="panel-default" is-open="app_.o" ng-show="app_.s"> <cm-uib-accordion-heading h="app_"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item" > <uib-accordion> <div uib-accordion-group class="cmbuggylist " ng-repeat="h in app_.THEAPPBUGLIST"> <uib-accordion-heading ><i class="fas fa-bug" ' + BUGCOLOR + '></i> <span class="cmbugtitle" style="text-transform: capitalize">{{h.title}}</span> -- {{h.name}} {{h.surname}} </uib-accordion-heading> <div class="bugcontainer userbugreporter"> <img ng-src="{{h.picture}}" alt="Avatar" class="right"> <p>{{h.message}}</p> <span class="time-left">{{h.dateIN}}</span> </div> <div class="bugcontainer cmbuganswer"> <img src="http://cloudmrhub.com/user.png" class="rightimage"> <p>{{h.answer}}</p> <span class="time-right">{{h.dateOUT}}</span></div> </div> </uib-accordion> </li></ul></div></uib-accordion>'

var CMBUGREPORT = CMBUGSTYLE + '<div class="cmRcontainer" style="padding-bottom:89px"> <div class="cmRcontainer" style="margin-left:auto;margin-right:auto;padding-bottom:89px;width:55%;max-width:377px;min-width:233px"> <div class="cmParagraph"> <div class="cmFontTitle"> Thank you for reporting a bug</div> </div> <div style="margin-bottom:1em" class="cmRflexitem"> <cm-datalist-json label="App" list="THEAPPLIST" fieldsshow="name" optionsvaluesfield="name" model="model"> </cm-datalist-json> </div> <div style="margin-bottom:1em" class="cmRflexitem"> <cm-text-input model="title" label="Title" placeholder="Felix Bloch and Edward Purcell"></cm-text-input> </div> <div style="margin-bottom:1em" class="cmRflexitem"> <textarea class="form-control" rows="8" placeholder="Please enter your message here" ng-model="msg"></textarea> </div> <div style="margin-bottom:1em; margin-top: 2em"> <button type="submit" class="cmButton" ng-click="sendfunction()" style="left: 0px">Submit</button> <button type="submit" class="cmButton" ng-click="resetbug()" style="right: 0px;float: right">Reset</button> </div> </div> ' + THEBUGLEGEND + '<div style="display:flex;flex-direction:row;flex-wrap:wrap;justify-content:center;align-items:stretch" > <div ng-repeat="app_ in APPSLIST" style="width:30%;max-width:610px;min-width:500px;margin:1em;" ng-if="app_.s">' + THEBUGPANEL + '</div> </div></div>';




// style="margin-left:auto;margin-right:auto;width:89%;max-width:610px;min-width:377px"
var MYWEBROOT = document.location.origin;

// var SELECTRESULTS ='<div style="text-align: center"> <div style="display: inline-block;margin:1em"> <span class="cmlabel" >Load Results File</span> <label for="x" class="custom-file-upload" > <i class="fas fa-folder-open fa-2x cmiconcolor" style="vertical-align:middle;border-style: ridge;padding-right:4px;padding-left:1px"></i> </label> <input type="file" id="x" style="display: none" onchange="angular.element(this).scope().onFileChange(this)" class="cmButton"/> </div> <div style="display: inline-block;margin:1em"> <span class="cmlabel"> OR </span> </div> <div style="display: inline-block;margin:1em"> <div style="display: flex;"> <span class="flex-inline" style="margin-right:0.5em;margin-left:0.5em;"><i class="fas fa-database fa-2x cmiconcolor" style="vertical-align:middle"></i> </span> <select id="selectResults" ng-options="x as x.Alias + \' (\' + x.dateIN + \')\' for x in results | filter:{status:\'ok\'} | orderBy: \'-dateIN\'" class="form-control flex-inline" ng-model="xxxxxx" ng-change="selectResultsf(xxxxxx)" style="display: inline;vertical-align:middle" ></select> </div> </div> </div>'

var SELECTRESULTS = ' <div style="text-align: center"> <div style="display: flex;flex-direction: row;flex-wrap: wrap;align-items:center" class="fakeprepend"> <div class="cmLflexitem cmLflexitem cmMarginSpaceLR cmMarginSpaceTB "> <span class="cmUploadLabel ">Results</span> </div> <div class="cmLflexitem cmLflexitem cmMarginSpaceLR cmMarginSpaceTB "> <div class="cmPrependGroup"> <label for="x" class="custom-file-upload" style="margin-top:5px;margin-bottom:5px;cursor: pointer"> <i class="far fa-file fa-2x cmiconcolor" style="vertical-align:middle"></i> </label> <input type="file" id="x" style="display: none" onchange="angular.element(this).scope().onFileChange(this)" /> </div> </div> <div class="cmLflexitem cmLflexitem cmMarginSpaceLR cmMarginSpaceTB "> <div class="input-group" data-togle="tootltip" title="select from Cloud MR"> <span class="input-group-addon" id="selectResults">or select from</span> <select id="selectResults" ng-options="x as x.Alias + \' (\' + x.dateIN + \')\' for x in results | filter:{status:\'ok\'} | orderBy: \'-dateIN\'" class="form-control flex-inline" ng-model="xxxxxx" ng-change="selectResultsf(xxxxxx)" style="display: inline;vertical-align:middle"></select> </div> </div> </div> <!-- container --> </div>'

//http://henriquat.re/modularizing-angularjs/modularizing-angular-applications/modularizing-angular-applications.html
var CM = angular.module("CM", [])

.factory("cmsettings", [function() {
    //    this is the factory store the information needed to make works this piece of code
    var u = {
        url: MYWEBROOT,
        author: 'Dr. Eros Montin, PhD',
        email: 'eros.montin@nyulangone.com',
        personalemail: 'eros.montin@gmail.com'
    };
    u.redistibutable = u.url + '/CLOUDMRRedistributable';
    //    where i place the clobal css
    u.css = u.redistibutable + '/cmCss.css';
    //    where i place the html template
    u.tmpl = u.redistibutable + '/tmpl';
    u.queryPath = u.url + '/Q';
    u.getMailAPI = u.url + '/Q/sendmail.php';
    u.queryServiceUrl = u.queryPath + '/serviceAPI.php';
    u.getcloudmrMainUrl = function() { return u.url };

    u.getCss = function() { return u.css };
    u.getCMurl = function() { return u.url };
    u.getQueryServerUrl = function() { return u.queryPath };
    u.getQueryServiceUrl = function() { return u.queryServiceUrl };
    return u;
}])

.factory("cmtool", ["$q", "$http", "$compile", "cmsettings", "$sce", "$interval", function($q, $http, $compile, settings, $sce, $interval) {
        //    this is the factory store the information needed to make works this piece of code
        var u = { clientinfo: window.navigator };


        u.oldloader = {
            element: undefined,
            promise: undefined
        }

        u.LOAD = function(x, HOWMUCH) {
            //      devcare a div in the main page   <div id="MYLOADER"></div>
            //      it will compile the directive cmload  
            if (isUndefined(HOWMUCH)) {
                HOWMUCH = 50000;
            }

            var dir = angular.element(document.createElement("cmload"));
            var el = $compile(dir);
            //        var el = $compile(dir)($scope);
            var box = "#MYLOADER";

            if (x) {
                //            if its true it creates
                angular.element(box).append(dir);
                u.oldloader.element = dir;
                u.oldloader.promise = $interval(function() { u.LOAD(false) }, HOWMUCH);
            } else {
                //            otherwise it cancels the element
                try {
                    var elmnt = angular.element(document.querySelector('#MYLOADER'));
                    elmnt.empty();
                    $interval.cancel(u.oldloader.promise);
                } catch (e) {

                    $interval.cancel(u.oldloader.promise);

                }

            }

        };

        u.loader = {
            promise: undefined,
            element: undefined
        };

        u.loading = function(x, HOWMUCH) {
            //no more than 30 seconds minutes
            if (isUndefined(HOWMUCH)) {
                HOWMUCH = 30000;
            }

            if (x) {
                u.loader.element = angular.element(document.createElement("cmload"));
                angular.element(document.body).append($compile(u.loader.element)(this));
                u.loader.promise = $interval(function() { u.loading(false) }, HOWMUCH);

            } else {
                u.loader.element.empty();
                $interval.cancel(u.loader.promise);

            }

        }



        //var el = $compile(loader);
        // $scope.$apply();



        u.getEmailAPI = function() {
            return settings.getMailAPI;
        }


        u.getClientBroswerInfo = function() {
            return u.clientinfo.appName;
        }

        u.getClientOsInfo = function() {
            return u.clientinfo.platform;
        }
        u.getClientInfo = function() {
            return u.clientinfo;
        }
        u.getClientInfoMin = function() {
            return u.clientinfo.appName + " on" + u.clientinfo.platform;
        }



        u.getTime = function() {
            return new Date().toISOString().slice(0, 19).replace('T', ' ');
        };

        u.getToday = function() {
            var d = new Date();
            //        var c=d.getFullYear().toString();
            var c = d.getFullYear().toString() + "_" + d.getMonth().toString() + "_" + d.getDate().toString();
            return c;
        };


        u.getJson = function(u) {

            var deferred = $q.defer();

            $http.get(u).success(function(data) {
                deferred.resolve(data);
                //  console.log(data);

            });

            return deferred.promise;
        };

        u.getJsonP = function(u) {

            var deferred = $q.defer();

            $http.jsonp(u).then(function(R) {
                // console.log(R);
                deferred.resolve(R);
                // console.log(R);

            });

            return deferred.promise;
        };

        u.sendBug = function(uid, appid, title, message) {

            var DATA = { UID: uid, APPID: appid, TITLE: title, MESSAGE: message };
            var deferred = $q.defer();


            // u.sendemail('support@cloudmrhub.com', "new bug title:" + title, message + "from user" + uid, 'support@cloudmrhub.com').then(function(oo) {
            u.RFAPI(DATA, 'bug').then(function(response) {

                deferred.resolve(response);


                //   });
            });



            return deferred.promise;


        };



        u.getBuglist = function(appid) {

            if (isUndefined(appid)) {
                appid = -1;
            }
            var deferred = $q.defer();
            DATA = { appid: appid };

            u.RFAPI(DATA, 'buglist').then(function(response) {

                deferred.resolve(response);
            });



            return deferred.promise;


        };

        u.RFAPI = function(DATA, serviceType) {
            //query the serviceAPI!!!
            var Q = settings.getQueryServiceUrl();

            DATA.serviceType = serviceType;

            var deferred = $q.defer();

            $http({
                method: 'POST',
                data: JSON.stringify(DATA),
                url: Q,
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            }).success(function(response) {

                deferred.resolve(response);
            });
            return deferred.promise;

        };


        u.generalRFAPI = function(DATA, Q) {
            //general implementation of a RFAPi requrest

            var deferred = $q.defer();

            $http({
                method: 'POST',
                data: DATA,
                url: Q,
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            }).success(function(response) {

                deferred.resolve(response);
            });
            return deferred.promise;

        };


        u.sendemail = function(email, subject, message, replyemail, from) {

            var deferred = $q.defer();

            if (isUndefined(from)) {

                u.generalRFAPI({ em: email, sub: subject, message: message, reply: replyemail }, u.getEmailAPI()).then(function(o) {
                    console.log(o);
                    deferred.resolve(o);
                });
            } else {

                u.generalRFAPI({ em: email, sub: subject, message: message, reply: replyemail, from: from }, u.getEmailAPI()).then(function(o) {
                    console.log(o);
                    deferred.resolve(o);
                });
            }
            return deferred.promise;
        }


        u.getMyData = function(uid, MAX) {
            var deferred = $q.defer();
            var OUT;

            u.queryData(uid).then(function(thedata) {
                //parse data
                deferred.resolve(thedata);

            });

            return deferred.promise;
        };


        u.queryData = function(uid) {

            var DATA = { UID: uid };
            var deferred = $q.defer();

            u.RFAPI(DATA, 'datainfo').then(function(response) {
                deferred.resolve(response);
            });



            return deferred.promise;
        };



        u.deleteMyData = function(uid, id) {

            var DATA = { UID: uid, id: id };
            var deferred = $q.defer();

            u.RFAPI(DATA, 'datadelete').then(function(response) {
                deferred.resolve(response);
            });



            return deferred.promise;
        };

        u.FIXUSERFILES = function(X, MAXDATA) {
            var total = { v: 0.0, p: 0.0 };
            var deferred = $q.defer();

            X.forEach(function(o, i) {
                //real value
                total.v = total.v + parseInt(o.size);
                //percentage
                total.p = (total.v / MAXDATA) * 100;
                if (i == X.length - 1) {
                    deferred.resolve(total);
                }

            });

            return deferred.promise;
        }





        return u;
    }]) //end cmtool

.service('cmFileUpload', ["$q", "$compile", function($q, $compile) {
    this.status = {
        progress: 0,
        phase: undefined
    };
    this.setProgress = function(x) { this.status.progress = x };
    this.getProgress = function() { return this.status.progress };
    var THESERVICE = this;
    this.uploadFileToUrl = function(file, uploadUrl, DATA) {
        //file is the file to be sent, uploadUrl, where is the page?, DATA, the post data we are sending along with the file, info json file with i/o interaxtin with this class




        var thefiledefferredpromise = $q.defer();

        var uploader = new Resumable({
            target: uploadUrl,
            chunkSize: 1 * 1024 * 1024,
            simultaneousUploads: 10,
            testChunks: false,
            throttleProgressCallbacks: 30,
            query: DATA
        });

        //flag to discriminate if you want to 
        switch (getFilextension(file.name)) {
            case "dat":
                submitTWIX(file, uploader);
                break;
            default:
                uploader.addFile(file);

        }




        uploader.on('fileAdded', function(file, event) {
            uploader.upload();


        });




        uploader.on('fileProgress', function(file) {
            THESERVICE.setProgress(Math.floor(file.progress() * 100));

        });

        uploader.on('complete', function(file) {


        });

        uploader.on('fileSuccess', function(file) {
            thefiledefferredpromise.resolve(true);
            // console.log('success');



        });


        uploader.on('fileError', function(file, message) {
            // console.log('error');
            // console.log(message);
            thefiledefferredpromise.resolve(false);


        });


        return thefiledefferredpromise.promise;
    }


}])


//delete after 2021
.service('cmFileUploadold', ["$q", "cmtool", function($q, cmtool) {

    this.uploadFileToUrl = function(file, uploadUrl, DATA) {

        var deferred = $q.defer();

        var uploader = new Resumable({
            target: uploadUrl,
            chunkSize: 20 * 1024 * 1024,
            simultaneousUploads: 2,
            testChunks: false,
            throttleProgressCallbacks: 1,
            query: DATA
        });


        switch (getFilextension(file.name)) {
            case "dat":
                submitTWIX(file, uploader);
                break;
            default:
                uploader.addFile(file);

        }



        uploader.on('fileAdded', function(file, event) {
            uploader.upload();
            cmtool.loading(true);
        });




        uploader.on('fileProgress', function(file) {
            // console.log(Math.floor(file.progress() * 100) + '%');
        });

        uploader.on('complete', function(file) {

            cmtool.loading(false);
        });

        uploader.on('fileSuccess', function(file) {
            deferred.resolve(true);
            cmtool.loading(false);
        });


        uploader.on('fileError', function(file, message) {
            deferred.resolve(true);
            cmtool.loading(false);
        });


        return deferred.promise;
    }


}])

.directive('cmload', function() {
    return {
        restrict: 'E',
        template: '  <div id="loaderBGDlayer"><div id="loader" style="z-index:9;"  ><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="lading"></div></div></div>'
    }
})


.directive('cmContactus', function() {
    return {
        restrict: 'E',
        scope: {
            to: "=",
            useremail: "=",
            username: "=",
            sendfunction: "=",
            subject: "=",
            msg: "=",
            who: "="

        },
        template: '<div class="container"> <form style="position: absolute;left: 50%;top: 50%;transform: translate(-50%, -50%);max-width: 30%"> <div class="input-group" style="margin-bottom:1em"> <span class="input-group-addon" for="XXMM"> To</span> <textarea id="XXMM" class="form-control" ng-model="to" rows="{{LINES}}" disabled> </textarea> </div> <div style="margin-bottom:1em"> <cm-text-input model="username" label="From" placeholder="Felix Bloch and Edward Purcell"></cm-text-input> </div> <div style="margin-bottom:1em"> <cm-text-input model="useremail" label="Email" placeholder="user@email.com"></cm-text-input> </div> <div style="margin-bottom:1em"> <cm-text-input model="subject" label="Subject" placeholder="Cloud MR is great"></cm-text-input> </div> <div style="margin-bottom:1em"> <textarea class="form-control" rows="8" placeholder="Please enter your message here" ng-model="msg" ></textarea> </div> <div style="margin-bottom:1em; margin-top: 2em"> <button type="submit" class="cmButton" ng-click="sendfunction()">Send Mail</button> </div> </form></div>',
        link: function(scope, element, attrs) {

            scope.$watch('to', function(x) {
                var txtArea = x.split('\n');
                scope.LINES = txtArea.length + 1;
                // console.log(txtArea);
            }, true);



        }
    }
})


.directive('cmBugs', ["cmtool", function(cmtool) {
    return {
        restrict: 'E',
        scope: {
            list: "=", //applist //applist
            title: "=",
            msg: "=",
            model: "=",
            sendfunction: "=",
            resetfunction: "=",

        },
        template: CMBUGREPORT,
        link: function(scope, element, attrs) {

            scope.THEBUGLIST = undefined;
            scope.THEAPPLIST = [];
            scope.APPSLIST = [];

            scope.$watch('model.AID', function(x) {
                console.log(x);
                if (isUndefined(x)) {
                    //scope.model = undefined;
                    // scope.THEBUGLIST = [];
                } else {
                    //    cmtool.getBuglist(x).then(function(x) {
                    //      scope.THEBUGLIST = x;
                    // });

                }
            }, true);





            scope.resetbug = function() {
                scope.resetfunction();
                scope.msg = "Browser: " + cmtool.getClientBroswerInfo() + " \nOS: " + cmtool.getClientOsInfo() + ", " + '\n\nBug Description:\nExpected behavior: \nActual behavior: \nFile/Task ID:';

            }

            scope.msg = "Browser: " + cmtool.getClientBroswerInfo() + " \nOS: " + cmtool.getClientOsInfo() + ", " + '\n\nBug Description:\nExpected behavior: \nActual behavior: \nFile/Task ID:';



            scope.getbugslist = function(thelist) {
                scope.APPSLIST = [];
                thelist.forEach(function(app, index) {
                    console.log(app);
                    scope.APPSLIST.push({ name: app.name, THEAPPBUGLIST: [], o: false, s: true, icon: "fas fa-bug", title: app.name })
                    cmtool.getBuglist(app.AID).then(function(x) {

                        x.forEach(function(b) { scope.APPSLIST[index].THEAPPBUGLIST.push(b); });
                        if (x.length > 0) {
                            scope.APPSLIST[index].s = true;
                        } else {
                            scope.APPSLIST[index].s = false;
                        }
                    });
                })


            }



            scope.submitthebug = function() {
                ScreenOrientation.sendfunction();
                scope.resetbug();
            }

            scope.$watch('list', function(x) {
                var TL = jsonCopy(x);


                if (isUndefined(x)) {

                } else {
                    TL.push({
                        ID: 0,
                        name: "Cloud MR",
                        json: "",
                        status: "ok",
                        UID: 118,
                        AID: 0
                    });
                    scope.THEAPPLIST = TL;
                    scope.getbugslist(scope.THEAPPLIST);

                }




            }, true);



        }
    }
}])


















.directive('cmCheckbox', [function() {
    return {
        restrict: 'E',
        scope: {
            model: "=",
            label: "@",
            tooltip: '@'
        },
        template: '<div class="input-group" data-toggle="tooltip" ng-attr-title="{{tooltip}}"> <div class="cmcheckbox"> <label class="input-group "> <input ng-model="model" type="checkbox" > <span class="cmcr"> <i class="cmcr-icon glyphicon glyphicon-ok"></i> </span>{{label}} </label> </div></div>' + TTJQ,
        link: function(scope, element, attrs) {}
    }
}])

.directive('cmRadiobox', [function() {
    return {
        restrict: 'E',
        scope: {
            model: "=",
            label: "@",
            value: "@",
            tooltip: "@"
        },

        template: '<div class="input-group" data-toggle="tooltip" ng-attr-title="{{tooltip}}"> <div class="cmradio" > <label class="input-group" > <input ng-model="model" type="radio" value="{{value}}" > <span class="cmcr"> <i class="cmcr-icon glyphicon glyphicon-ok"></i> </span>{{label}} </label> </div></div>' + TTJQ,
        link: function(scope, element, attrs) {



        }
    }
}])



.directive('cmUibAccordionHeading', ["cmsettings", function(settings) {
    //    h is a json with title, icon, o and s
    return {
        restrict: 'E',
        scope: {

            h: "="
        },
        //        templateUrl: $sce.trustAsResourceUrl(settings.tmpl + '/cmUibAccordionHeading.html'),
        template: '<uib-accordion-heading> <i class="{{h.icon}}"></i> {{h.title}} <i class="pull-right glyphicon" ng-class="{\'glyphicon-chevron-down\': !h.o, \'glyphicon-chevron-up\': h.o}"></i></uib-accordion-heading>',
        link: function(scope, element, attrs) {
            // scope.CSS=settings.getCss();
        }
    }
}])




.directive('cmColorInput', [function() {
    return {
        restrict: 'E',
        scope: {
            model: '=',
            label: '@',
            enable: '=',
            tooltip: '@'
        },

        template: '<div class="input-group" data-toggle="tooltip" ng-attr-title="{{tooltip}}"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <input ng-model="model" type="color" class="form-control" ng-disabled="myDisable"></div>' + TTJQ,
        link: function(scope, element, attrs) {
            //                  default is enable so desable the disblaer

            scope.myDisable = false;

            scope.$watch('enable', function(n) {
                if (typeof n === "boolean") {
                    scope.myDisable = !n;
                }
            }, true);
        }
    }
}])


.directive('cmSliderInput', [function() {
    return {
        restrict: 'E',
        scope: {
            model: '=',
            label: '@',
            enable: '=',
            min: '@',
            max: '@',
            tooltip: '@'

        },

        template: '<div class="input-group" > <span class="input-group-addon" id="{{ID}}">{{label}} </span> <input ng-model="model" type="range" min="{{min}}" max="{{max}}" class="form-control class="custom-range" ng-disabled="myDisable"></div>' + TTJQ,
        link: function(scope, element, attrs) {
            //                  default is enable so desable the disblaer

            scope.myDisable = false;

            scope.$watch('enable', function(n) {
                if (typeof n === "boolean") {
                    scope.myDisable = !n;
                }
            }, true);
        }
    }
}])

.directive('cmRadioboxInput', [function() {
    return {
        restrict: 'E',
        scope: {
            model: "=",
            label: "@",
            value: "@",
            enable: '=',
            tooltip: "@"
        },

        template: '<div class="input-group" data-toggle="tooltip" ng-attr-title="{{tooltip}}"> <div class="cmradio" > <label class="input-group" > <input ng-model="model" type="radio" value="{{value}}" ng-disabled="myDisable" > <span class="cmcr"> <i class="cmcr-icon glyphicon glyphicon-ok"></i> </span>{{label}} </label> </div></div>' + TTJQ,
        link: function(scope, element, attrs) {

            scope.myDisable = false;

            scope.$watch('enable', function(n) {
                if (typeof n === "boolean") {
                    scope.myDisable = !n;
                }
            }, true);

        }
    }
}])


.directive('cmCheckboxInput', [function() {
    return {
        restrict: 'E',
        scope: {
            model: '=',
            label: '@',
            enable: '=',
            tooltip: '@'

        },

        template: '<div class="input-group" data-toggle="tooltip" ng-attr-title="{{tooltip}}"> <span class="input-group-addon" id="{{ID}}">{{label}} </span> <input type="checkbox" ng-model="model" class="form-control" ng-disabled="myDisable"></div>' + TTJQ,
        link: function(scope, element, attrs) {
            //                  default is enable so desable the disblaer

            scope.myDisable = false;

            scope.$watch('enable', function(n) {
                if (typeof n === "boolean") {
                    scope.myDisable = !n;
                }
            }, true);
        }
    }
}])


//just a rename:)
.directive('cmRangeInput', [function() {
    return {
        restrict: 'E',
        scope: {
            model: '=',
            label: '@',
            enable: '=',
            min: '@',
            max: '@',
            tooltip: '@'

        },

        template: '<cm-slider-input model="model" min="min" max="max" enable="enable" label="label" tooltip="{{tooltip}}"></div>',
        link: function(scope, element, attrs) {
            //                  default is enable so desable the disblaer

            scope.myDisable = false;

            scope.$watch('enable', function(n) {
                if (typeof n === "boolean") {
                    scope.myDisable = !n;
                }
            }, true);
        }
    }
}])


.directive('cmTextareaInput', [function() {
    return {
        restrict: 'E',
        scope: {
            model: '=',
            label: '@',
            enable: '='
        },

        template: '<div class="input-group"> <span class="input-group-addon" for="{{ID}}"> {{label}}</span> <textarea id="{{ID}} class="form-control" ng-model="model" rows="{{LINES}}"  ng-disabled="myDisable"> </textarea></div>',
        link: function(scope, element, attrs) {
            //                  default is enable so desable the disblaer

            scope.myDisable = false;

            scope.$watch('enable', function(n) {
                if (typeof n === "boolean") {
                    scope.myDisable = !n;
                }
            }, true);


            scope.$watch('model', function(x) {
                try {
                    var txtArea = x.split('\n');
                    scope.LINES = txtArea.length + 1;
                } catch (e) { scope.LINES = 3; }

            }, true);
        }
    }
}])






.directive('cmRangeInput', [function() {
    return {
        restrict: 'E',
        scope: {
            model: '=',
            label: '@',
            enable: '=',
            min: '@',
            max: '@',
            tooltip: '@'
        },

        template: '<div class="input-group" data-toggle="tooltip" ng-attr-title="{{tooltip}}"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <input ng-model="model" type="range" min="{{min.toFixed(2)}}" max="{{max.toFixed(2)}}" class="slider form-control" ng-disabled="myDisable"></div><script>$(document).ready(function(){ $(\'[data-toggle="tooltip"]\').tooltip(); });</script>',
        link: function(scope, element, attrs) {
            //                  default is enable so desable the disblaer

            scope.myDisable = false;

            scope.$watch('enable', function(n) {
                if (typeof n === "boolean") {
                    scope.myDisable = !n;
                }
            }, true);
        }
    }
}])


.directive('cmProgressbar', [function() {
    return {
        restrict: 'E',
        scope: {
            model: '=',
            label: '@',
            visible: '=',
            min: '@',
            max: '@',
            tooltip: '@',
            class: '@'
        },

        template: '<style>.progress-label-20200410 {float: left;margin-right: 1em;}</style><div class="container"><p class="progress-label-20200410">{{label}} - {{model}} %</p><div class="progress"> <div class="progress-bar" ng-class="class" role="progressbar" aria-valuenow="{{model}}" aria-valuemin="{{min}}" aria-valuemax="{{max}}"  ng-style="{\'width\' : model + \'%\' }">  </div></div></div>' + TTJQ,
        link: function(scope, element, attrs) {
            //                  default is enable so desable the disblaer


            scope.myVisibility = true;



            scope.$watch('visible', function(n) {
                if (typeof n === "boolean") {
                    scope.myVisibility = !n;
                }
            }, false);
        }
    }
}])


.directive('cmNumberInput', [function() {
    return {
        restrict: 'E',
        scope: {
            model: '=', // the real number 
            label: '@', // the labelof the field
            step: '@', //step for the number
            enable: '=', //enable or disabled
            tooltip: "@"
        },

        template: '<div class="input-group" data-toggle="tooltip" ng-attr-title="{{tooltip}}"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <input ng-model="model" type="number" class="form-control" step="{{step}}" ng-disabled="myDisable"></div>',
        link: function(scope, element, attrs) {
            //                  default is enable so desable the disblaer
            scope.myDisable = false;

            scope.$watch('enable', function(n) {
                if (typeof n === "boolean") {
                    scope.myDisable = !n;
                }
            }, true);


        }
    }
}])







.directive('cmSelectInput', [function() {
        return {
            restrict: 'E',
            scope: {
                list: '=', //array of json
                label: '@', //the label of th field
                fieldsshow: '@', //which field do you want to show in the list
                optionsvaluesfield: '@', //which field you want to get
                model: '=', //value of the choise
                tooltip: "@",


            },

            template: CMSIMPLESELECT,
            link: function(scope, element, attrs) {


                var c = getUIID();
                scope.data = { ID: c, S: undefined };


            }
        }
    }



]).directive('cmDatalistLabels', [function() {
    return {
        restrict: 'E',
        scope: {
            list: '=', //array of json
            label: '@', //the label of th field
            fieldsshow: '@', //which field do you want to show in the list
            optionsvaluesfield: '@', //which field you want to get
            model: '=', //value of the choise
            tooltip: "@"
        },

        template: CMDATALIST,
        link: function(scope, element, attrs) {



            var c = getUIID();
            scope.data = { XX: c, S: undefined };

            scope.selected = function(x) {

                if (!(isUndefined(x))) {
                    var A = findAndGet(scope.list, scope.optionsvaluesfield, x);
                    // console.log(A);
                    if (A.length > 0) {
                        scope.model = A[0][scope.fieldsshow];
                    }
                }
            };

        }
    }
}])



.directive('cmDatalistValues', [function() {
    return {
        restrict: 'E',
        scope: {
            list: '=',
            label: '@',
            fieldsshow: '@',
            optionsvaluesfield: '@',
            model: '=',
            tooltip: "@"

        },

        template: CMDATALIST,
        link: function(scope, element, attrs) {



            var c = getUIID();
            scope.data = { XX: c, S: undefined };

            scope.selected = function(x) {

                if (!(isUndefined(x))) {
                    var A = findAndGet(scope.list, scope.optionsvaluesfield, x);

                    if (A.length > 0) {
                        scope.model = A[0][scope.optionsvaluesfield];
                    }
                }
            };

        }
    }
}])


.directive('cmDatalistJson', [function() {
    return {
        restrict: 'E',
        scope: {
            list: '=',
            label: '@',
            fieldsshow: '@',
            optionsvaluesfield: '@',
            model: '=',
            tooltip: "@"

        },

        template: CMDATALIST,
        link: function(scope, element, attrs) {



            scope.$watch('model', function(x) {

                if (isUndefined(x)) {
                    scope.init();
                }
            }, true);

            var c = getUIID();
            scope.init = function() {
                scope.data.S = undefined;
            };

            scope.data = { XX: c, S: undefined };

            scope.selected = function(x) {
                // console.log(x);
                if (!(isUndefined(x))) {

                    var A = findAndGet(scope.list, scope.optionsvaluesfield, x);
                    // console.log(A);
                    if (A.length > 0) {
                        scope.model = A[0];

                    } else {
                        scope.model = {};
                    }


                }
            };

        }
    }
}])

.directive('cmTextInput', [function() {
    return {
        restrict: 'E',
        scope: {
            model: '=', //the  written text
            label: '@', //label of the field
            enable: '=', //boolean can be enabled or disabled
            placeholder: '@', //you can put a placeholder if you want
            tooltip: "@"
        },
        template: '<div class="input-group" data-toggle="tooltip" ng-attr-title="{{tooltip}}"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <input ng-model="model" type="text" class="form-control" ng-disabled="myDisable" placeholder="{{ph}}"></div><script>$(document).ready(function(){$(\'[data-toggle="tooltip"]\').tooltip(); });</script>',

        link: function(scope, element, attrs) {
            //                  default is enable so desable the disblaer

            scope.myDisable = false;

            scope.$watch('enable', function(n) {
                if (typeof n === "boolean") {
                    scope.myDisable = !n;
                }
            }, true);
        }
    }
}])

.directive('cmEmailInput', [function() {
    return {
        restrict: 'E',
        scope: {
            model: '=', //the  written email
            label: '@', //label of the field
            enable: '=', //boolean can be enabled or disabled
            placeholder: '@' //you can put a placeholder if you want
        },

        template: '<div class="input-group"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <input ng-model="model" type="email" class="form-control" ng-disabled="myDisable" placeholder="{{ph}}"></div>',

        link: function(scope, element, attrs) {
            //                  default is enable so desable the disblaer

            scope.myDisable = false;

            scope.$watch('enable', function(n) {
                if (typeof n === "boolean") {
                    scope.myDisable = !n;
                }
            }, true);
        }
    }
}])




.directive('cmPasswordInput', [function() {
    return {
        restrict: 'E',
        scope: {
            model: '=',
            label: '@',
            enable: '=',
            placeholder: '@'
        },

        template: '<div class="input-group"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <input ng-model="model" type="password" class="form-control" ng-disabled="myDisable" placeholder="{{ph}}"></div>',

        link: function(scope, element, attrs) {
            //                  default is enable so desable the disblaer

            scope.myDisable = false;

            scope.$watch('enable', function(n) {
                if (typeof n === "boolean") {
                    scope.myDisable = !n;
                }
            }, true);
        }
    }
}])






.directive('cloudmrTag', ["cmsettings", function(settings) {
    return {
        template: '<a href=' + settings.getCMurl() + '><span class="cloudmrTag">Cloud MR</span></a>'
    }
}])

.directive('cloudmrTagExternal', ["cmsettings", function(settings) {
    return {
        template: '<a href=' + settings.getCMurl() + ' target="_blank"><span class="cloudmrTag">Cloud MR</span></a>'
    }
}])

.directive('cmArticleBibliography', ["cmsettings", function(settings) {

    return {
        scope: {
            citeid: "=",
            autors: "=",
            title: "=",
            journal: "=",
            date: "=",
            pages: "=",
            other: "="
        },
        template: '<span ng-hide="citeid==null">[{{citeid}}]</span> <span ng-repeat="a in autors" class="cmarticleautors">{{a}}, </span><span class="cmarticletitle">{{title}};</span><span class="cmarticlejournal"> {{journal}},</span><span class="cmarticledate"> {{date}},</span> <span class="cmarticle"> {{pages}}.</span> <span> {{other}}</span>',
        link: function(scope, element, attrs) {

            //  scope.CSS=settings.getCss();
            var val = getUIID();
            scope.data = { X: val };
            console.log(scope.pages)




        }
    }
}])

.directive('cmBibliography', ["cmsettings", function(settings) {

    return {
        scope: {
            articles: "="
        },
        template: '<ul style="list-style-type:none;"><li ng-repeat="a in articles"><cm-article-bibliography pages="a.pages" citeid="a.citeid" autors="a.autors" title="a.title" date="a.date" journal="a.journal" ></cm-article-bibliography> </li></ul>',
        link: function(scope, element, attrs) {

            //              scope.CSS=settings.getCss();
            var val = getUIID();
            scope.data = { X: val };





        }
    }
}])




.directive('cmActionTable', [function() {
    return {
        restrict: 'E',
        scope: {
            list: '=',
            functions: '=',
            visible: '=',
            height: '=',
            caption: '@'
        },
        template: '<style> .table-wrapper-scroll-y { display: block; max-height: {{maxheight}}; overflow-y: auto; -ms-overflow-style: -ms-autohiding-scrollbar; }</style> <div ng-show="list.length>0"><div style="margin-bottom:1%;"><span class="cmFontSubTitle" id={{myid}}></span></div><div class="table-wrapper-scroll-y"> <table class="table table-bordered table-striped mb-0" style="width: 100%" >  <thead> <tr ng-repeat="item in list | limitTo:1" > <th scope="col" style="word-wrap: break-word" ng-repeat="(key, val) in item" ng-show="visible[$index]"><span class="cmlabel">{{key}}</span> <th scope="col" ng-if="functions.length>0"><span class="cmlabel">Actions</span></th> </tr> </thead> <tbody> <tr ng-repeat="item in list" ng-class="item.status"> <td scope="row" style="word-wrap: break-word" ng-repeat="(key,val) in item" ng-show="visible[$index]"> <span class="labelData">{{val}}</span></td> <td scope="col" ng-if="functions.length>0"><a href="javascript:void(0)" ng-repeat="f in functions" ng-click="f.click(item.ID)" title="{{f.tooltip}}"><i class="{{f.icon}}" ng-show="f.type==\'function\'"></i> </a> <a ng-repeat="f in functions" ng-href="{{item.link}}" download="{{item.downloadfilename}}"> <i class="glyphicon glyphicon-save" ng-show="((f.type==\'download\')&&(item.link.length>2))"></i></a></td> </tr> </tbody> </table></div></div>',

        link: function(scope, element, attrs) {

            scope.maxheight = '300px';

            var ID = getUIID();

            scope.myid = ID;

            scope.$watch('height', function(x) { if (!(isUndefined(x))) { scope.maxheght = x; } }, true);

            scope.$watch('caption', function(x) {
                if (!(isUndefined(x))) {
                    // console.log(document.getElementById(ID));
                    document.getElementById(ID).innerHTML = x;
                }
            }, true);



        }
    };
}])



.directive('cmTaskbar', [function() {
    return {
        restrict: 'E',
        scope: {
            states: '=', //json with name link 
            model: '@' //to activate the state
        },
        template: '<div style="margin-top: 2em;margin-bottom: 1em"> <button ng-repeat="state in states" type="button" ui-sref="{{state.link}}" ui-sref-opts="{reload: true, notify: true}" style="vertical-align: middle;margin-right: 0.5em" ng-class="{\'btn btn-cmselected\':state.active,\'btn cmButton\':!state.active}" > {{state.name}}</button> </div>',

        link: function(scope, element, attrs) {



            scope.$watch('model', function(newstate, oldstate) {

                scope.states.forEach(function(o) {

                    if (o.name == scope.model) {
                        o.active = true;

                    } else {
                        o.active = false;

                    }
                });



            }, true);

        }
    };
}])





///cmDRwer2D must be add

.directive('cmResultsQueue', ["cmtool", "$interval", function(cmtool, $interval) {
    return {
        restrict: 'E',
        scope: {


            jsondata: "=",
            conf: "=",
            resultsid: "="
                // $scope.conf={
                //        applicationname:"CAMRIE",
                //        resultdownloadrootname:function(){return TASK.ora()},
                //        deletejob: defereedfunction,
                //        sendjobfeedback:defereedfunction,
                //        user:{name:,surname:,UID:},
                //        joblistgetter:defereedfunction
                //    };

        },
        template: '<uib-accordion> <div uib-accordion-group class="panel-default" is-open="v.o" ng-show="v.s"> <cm-uib-accordion-heading h="v"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item">' + SELECTRESULTS + '</li> <li class="list-group-item"> <div style="display: block; max-height: 300px; overflow-y: auto; -ms-overflow-style: -ms-autohiding-scrollbar;"> <table class="table"> <th>Task ID</th> <th>Alias</th> <th>Date Submitted</th> <th>Status</th> <th>Action</th> <tr ng-repeat="x in results | orderBy: \'-dateIN\'" ng-class="{\'secondary\': x.status==\'pending\', \'success\': x.status==\'ok\', \'danger\': x.status==\'ko\',\'warning\': x.status==\'calc\'}"> <td scope="col">{{x.ID }}</td> <td scope="col" ng-if="x.status!=\'ok\'">{{x.Alias }}</td> <td scope="col" ng-if="x.status==\'ok\'"><a href="JavaScript:Void(0);" ng-click="startJOB(x.results,x.ID)"> {{x.Alias }}</a></td> <td scope="col">{{x.dateIN}}</td> <td scope="col"><span style = "text-transform:capitalize;">{{x.tablestatus}}</span></td> <td scope="col" ng-if="x.status==\'ok\'"> <a href="JavaScript:Void(0);" ng-click="startJOB(x.results,x.ID)"> <i class="fas fa-eye"></i> </a> <a href="JavaScript:Void(0);" ng-click="delJOB(x.ID)"> <i class="far fa-trash-alt"></i></a> <a ng-href="{{x.results}}" download="{{jsonFilebasename(x.results)}}"> <i class="glyphicon glyphicon-save"></i></a> </td> <td scope="col" ng-if="x.status!=\'ok\'"> <a href="JavaScript:Void(0);" ng-click="delJOB(x.ID)"> <i class="far fa-trash-alt"></i></a> <a href="JavaScript:Void(0);" ng-if="x.status==\'ko\'" ng-click="sendfb(x.ID,x.Alias)"><i class="far fa-comments"></i></a></td> </tr> </table> </div> </li> </ul> </div></uib-accordion>',
        link: function(scope, element, attrs) {


            scope.v = { o: true, s: true, title: "Job Queue", icon: "fas fa-stream" };
            scope.USER = scope.conf.user;


            scope.loadingfromtheselect = false;

            scope.results = [];
            scope.TMPresults = [];

            scope.startJOB = function(x, id) {
                cmtool.loading(true);
                scope.resultsid = id;

                cmtool.getJson(x).then(function(d) {



                    scope.v.o = false;


                    try {
                        scope.jsondata = JSON.parse(d);
                        cmtool.loading(false);
                    } catch (e) {
                        scope.jsondata = d;
                        cmtool.loading(false);
                    }



                    cmtool.loading(false);
                });

            };

            scope.jsonFilebasename = function(x) {
                var O = scope.conf.resultdownloadrootname();
                return O + basename(x);
            }

            scope.delJOB = function(id) {
                var OUT = false;
                OUT = confirm("Do you want to delete JOB ID " + id + "?");

                if (OUT) {

                    scope.conf.deletejob(id).then(function(r) {
                        scope.resultsCheck();

                    });

                }
            };

            scope.sendfb = function(x, y) {

                var m = prompt("Hi " + scope.USER.name + "! you are reporting some problem on JOB " + y + '(ID ' + x + ')');

                if (isUndefined(m)) {} else {
                    scope.conf.sendjobfeedback(m, x).then(function(r) {

                        alert("Thank you " + scope.USER.name + " for having taken your time to provide us with your valuable feedback on " + scope.conf.applicationname + " job number " + x);

                    });
                }

            };





            scope.selectResultsf = function(FF) {

                if (scope.loadingfromtheselect) {

                } else {
                    try {
                        cmtool.loading(true);

                        cmtool.getJson(FF.results).then(function(d) {

                            scope.v.o = false;

                            try {
                                scope.jsondata = JSON.parse(d);
                                cmtool.loading(false);
                            } catch (e) {
                                scope.jsondata = d;
                                cmtool.loading(false);
                            }

                            // scope.data = JSON.parse(d);
                            scope.resultsid = FF.ID;
                            scope.loadingfromtheselect = false;
                        });
                    } catch (e) {

                        cmtool.loading(false);
                        scope.loadingfromtheselect = false;
                    }
                }
            };



            scope.onFileChange = function(fileEl) {
                var files = fileEl.files;
                var file = files[0];
                var reader = new FileReader();


                reader.onloadend = function(evt) {
                    if (evt.target.readyState === FileReader.DONE) {
                        scope.$apply(function() {
                            scope.resultsid = undefined;
                            scope.jsondata = JSON.parse(evt.target.result);
                        });
                    }
                };

                reader.readAsText(file);
            };





            scope.resultsCheck = function() {

                scope.conf.joblistgetter().then(function(resp) {

                    scope.TMPresults = resp;
                });
            };


            scope.$watch("TMPresults", function(n, o) {
                if (n.length != scope.results.length) {
                    scope.results = jsonCopy(n);
                } else {
                    n.forEach(function(r, index) {
                        if (objectEquals(r, scope.results[index])) {

                        } else {
                            scope.results[index] = jsonCopy(r);
                        }
                    });
                }

            }, true);

            scope.$watch('results', function(n) {
                n.forEach(function(r) {
                    switch (r.status) {
                        case 'ok':
                            r.tablestatus = 'Done';
                            break;
                        case 'pending':
                            r.tablestatus = 'Queued';
                            break;
                        case 'calc':
                            r.tablestatus = 'Running';
                            break;
                        case 'ko':
                            r.tablestatus = 'Error';
                            break;

                    }
                })

            }, true);




            var promise;


            // starts the interval
            scope.startretrieving = function() {
                // stops any running interval to avoid two intervals running at the same time
                scope.stopretrieving();
                scope.RETRIVE = true;
                // store the interval promise
                promise = $interval(scope.resultsCheck, 1000);

            };

            // stops the interval
            scope.stopretrieving = function() {
                scope.RETRIVE = false;
                $interval.cancel(promise);
            };


            scope.$on('$destroy', function() {
                scope.stopretrieving();
            });


            scope.$watch("v.o", function(n) {
                if (n) {
                    scope.startretrieving();
                } else {
                    scope.stopretrieving()
                }

            }, true);



            //check the results


        }
    }
}])




.directive("cmInputForm", [function() {
    return {
        restrict: 'E',
        scope: {
            thearray: "=", //array of json with value,type,label and tooltip
            updatefunction: "=", //the function to be called to update
            conf: '='
        },
        template: '<uib-accordion> <div uib-accordion-group class="panel-default" is-open="conf.o" ng-show="conf.s"> <cm-uib-accordion-heading h="conf"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item"> <div style="display:flex;flex-direction:row;flex-wrap: wrap;"> <div ng-repeat="info in THEARRAY track by $index" class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cminputElement" style="width:300px";> <cm-text-input model="info.value " label="{{info.label}} " ng-if="info.type==\'text\'"></cm-text-input> <cm-text-input model="info.value " label="{{info.label}}" ng-if="info.type==\'date\'"></cm-text-input> </div> </div> <button class="cmButton" ng-click="UpdateInfo()">Save</button> </li> </ul> </div></uib-accordion>',
        link: function(scope, element, attrs) {

            scope.THEARRAY = [];
            scope.UpdateInfo = function() {
                console.log("update");
                scope.updatefunction(scope.THEARRAY);

            }

            scope.$watch('thearray', function(x) {
                console.log("the array");
                if (!(isUndefined(x))) {
                    scope.THEARRAY = x;
                }
            }, false);


        }
    }
}])

.directive('cmResultsDisplay', ["$injector", function($injector) {
    return {
        restrict: 'E',
        scope: {

            jsondata: "=", //the classical jsonfile i can create with my matlab api:)!!
            conf: "=",

            // $scope.conf={
            //        applicationname:"CAMRIE",
            //        resultdownloadrootname:function(){return TASK.ora()},
            //        deletejob: defereedfunction,
            //        sendjobfeedback:defereedfunction,
            //        user:{name:,surname:,UID:},
            //        joblistgetter:defereedfunction
            //    };
        },

        template: '<uib-accordion> <div uib-accordion-group class="panel-default" is-open="v.o" ng-show="v.s" > <cm-uib-accordion-heading h="v"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item"> <cm-display  jsondata="jsondata" conf="conf" canvassizeh="{{conf.canvassize.h}}" canvassizew="{{conf.canvassize.w}}"  ></cm-display></li> </ul> </div></uib-accordion>',
        link: function(scope, element, attrs) {



            scope.v = { title: "Plot", icon: "fas fa-chart-area", o: false, s: true };
            scope.USER = scope.conf.user;
            console.log(scope.conf);
            scope.$watch("jsondata", function() {
                scope.v.o = !isUndefined(scope.jsondata)
            }, true);


            //  scope.apiService = $injector.get(attributes.apiService);


        }

    };
}])


// .directive('cmJsonfieldsvalues', [function() {
//     return {
//         restrict: 'E',
//         scope: {

//             jsonarray: "=", //the classical jsonfile i can create with my matlab api:)!!
//             conf: "=",

//         },

//         template: '<table> <tr> <th ng-repeat="(key, val) in items[0]">{{key}}</th> </tr> <tr ng-repeat="item in items"> <td ng-repeat="(key, val) in item">{{val}}</td> </tr></table>',
//         link: function(scope, element, attrs) {
//             scope.$watch("jsonarray", function(n) {
//                 console.log(n);
//                 scope.items = n
//             }, true);


//         }

//     };
// }])



//this can be a general service if i load a json file, let's implement like this
.service('cmdictionaryservice', [function() {
    this.DICT = {};

    this.setDIctionary = function(x) {
        this.DICT = x;
    }


    this.getDIctionary = function() {
        return x;
    }



    this.ParseTerm = function(x) {
        var O = this.DICT[x];
        if (isUndefined(O)) {
            return x;

        } else {
            return O;
        }

    };




}])