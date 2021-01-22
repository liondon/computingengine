CAMRIE.controller("bug", ["$scope", "TASK", "cmtool", function ($scope, TASK, cmtool) {
    $scope.USER = TASK.getUserLog();

    $scope.reset = function () {
        $scope.DATA = { APPS: [{ AID: 4, ID: 17, UID: $scope.USER.UID, json: document.location.origin + "/apps/CAMRIE/cfg/camrie.json", name: "CAMRIE", status: "ok" }], X: { ID: undefined }, title: undefined, msg: undefined };


    };

    $scope.reset();

    $scope.$watch("DATA.X", function (x) { console.log(x); }, true);

    $scope.sendBug = function () {
        cmtool.sendBug($scope.USER.UID, $scope.DATA.X.AID, $scope.DATA.title, $scope.DATA.msg).then(function (response) {
            alert('Thank you ' + $scope.USER.name + ' for your feedback, we will get back to you soon');
            $scope.reset();

        });
    };





}]);

CAMRIE.controller("cnt", ["$scope", "cmtool", "TASK", function ($scope, cmtool, TASK) {
    $scope.USER = TASK.getUserLog();




    $scope.USER_name = $scope.USER.name + ' ' + $scope.USER.surname;


    $scope.init = function () {
        $scope.to = "Cloud MR Team \nCenter for Advanced Imaging Innovation and Research\nNYU Langone Health\n660 1st Avenue - 4th Floor\nNew York, NY 10016 (USA)";
        $scope.WHO = "support@cloudmrhub.com";
        $scope.subject = undefined;
        $scope.msg = undefined;
        $scope.email = $scope.USER.email;
    }

    $scope.send = function () {
        cmtool.LOAD(true);



        console.log($scope.WHO, $scope.subject, $scope.msg, $scope.email);
        //        cmtool.generalRFAPI({em:$scope.WHO,sub:$scope.subject,message:$scope.msg,reply:$scope.email},'http://cloudmrhub.com/Q/sendmail.php').then(function(response){

        cmtool.myRFAPI({ em: $scope.WHO, sub: $scope.subject, message: $scope.msg, reply: $scope.email }, 'sendmail.php').then(function (response) {

            cmtool.LOAD(false);
            alert("thank you for your feedback we will response ASAP ");
            $scope.init();

        });
    };

}]);

CAMRIE.controller("taskbar", ["$scope", "TASK", function ($scope, TASK) {
    //    $interval( function(){ $scope.WF=myWF.getState(); console.log($scope.WF); }, 200);

    $scope.goHome = function () {
        TASK.goto('camrie.home', {});
    };


}]);

CAMRIE.controller("headerbar", ["$scope", "TASK", "cmtool", "$window", "$interval", function ($scope, TASK, cmtool, $window, $interval) {
    //    $interval( function(){ $scope.WF=myWF.getState(); console.log($scope.WF); }, 200);
    $scope.USER = TASK.getUserLog();
    $scope.goHome = function () {
        TASK.goto('camrie.home', {});
    };


    $scope.logout = function () {
        var url = "http://cloudmrhub.com";


        $window.open(url, "_parent");
    };


    //with this i stop the search of the username
    $scope.$watch("USER.name", function (x) {
        if (!(isUndefined(x))) {
            $scope.usertooltip = $scope.USER.name + " " + $scope.USER.surname;
            $interval.cancel(interval);

        }
    }, true);


    var interval = $interval(function () { $scope.USER = TASK.getUserLog(); }, 1000);

}]);

CAMRIE.controller("settings", ["$scope", "TASK", "$timeout",
    function ($scope, TASK, $timeout) {

        // settings
        $scope.uploadapi= BACKEND + "/fileupload";

        TASK.setEntireUserLog({
            UID: 0,
            name: "Eros",
            surname: "Montin",
            email: "eros.montin@gmail.com",
            status: "active",
            admin: false,
            logged: true,
            allow: true,
            pwd: undefined
        });



        //the file
        $scope.thefile = { mytest: [] };

        $scope.$watch('thefile.mytest', (n, o) => { console.log(n) }, false);

        $scope.settings = {
            version: "v0",
            output: { //to update
                noise: true,
                sar: true,
                signal: true
            },
            imagereconstruction: '0',
            geometry: [],
            tissue: [],
            fields: {
                B0: 3,
                tdb: [],
                gradx: [],
                grady: [],
                gradz: [],
                b1plus: [],
                b1minus: [],
                etransmitted: [],
                ereceived: []
            },
            coils: {
                receivingCoilsNumber: undefined,
                transmittingCoilsNumber: undefined,
            },
            sequence: {},
            limit:{min:1,max:2},
            Alias: "CAMRIE"

        };
        $scope.$watch('settings', function (n) { console.log(n); }, true);

        $scope.states = [{ name: 'Home', link: 'camrie.home' }, { name: 'Set up', link: 'camrie.settings' }, { name: 'Results', link: 'camrie.results' }];
        $scope.selectedstate = 'Set up';

        $scope.STATE = { output: true, geometry: false, coils: false, sequence: false, fields: false, calc: false }


        $scope.setCalulationOptions = function () {
            console.log("GEOM!!")
            $scope.STATE.geometry = true;
            $scope.VIEWS.OUTPUT.o = false;
            $scope.VIEWS.GEOM.s = true;

        };



        $scope.setGeometry = function () {
            var T = false; //just for testing remove when done
            if (T) {
                if (isUndefined($scope.settings.geometry)) {
                    alert('you should uplaod or select a Geometry file');
                } else {
                    if (isUndefined($scope.settings.tissue)) {
                        alert('you should uplaod or select a Tissue Property file');
                    } else {
                        $scope.STATE.geometry = true;
                        $scope.VIEWS.GEOM.o = false;

                    }
                }
            } else {
                $scope.STATE.geometry = true;
                $scope.VIEWS.GEOM.o = false;
            }
        };
        $scope.setCoils = function () {
            $scope.STATE.coils = true;
            $scope.VIEWS.COILS.o = false;
        };


        $scope.setSequence = function () {
            console.log("SEQ");

            $scope.STATE.sequence = true;
            $scope.VIEWS.SEQUENCE.o = false;
        };

        $scope.setFields = function () {
            if (isUndefined($scope.settings.fields.B0)) {
                alert('you have to set the B0');
            } else {
                $scope.STATE.fields = true;
                $scope.VIEWS.FIELDS.o = false;
            }
        };



        $scope.optionalstuff = {
            geometry: { statereset: undefined, list: [], model: undefined }
        }


        $scope.$watch('optionalstuff', function (b) { console.log(b); }, true);




        $scope.availablereconstructions = [
            { id: 0, name: 'RSS' }
        ];
        $scope.reset = function () {



            $scope.settings = {
                version: "v0",
                output: { //to update
                    noise: true,
                    sar: true,
                    signal: true
                },
                imagereconstruction: '0',
                geometry: [],
                tissue: [],
                fields: {
                    B0: 3,
                    tdb: [],
                    gradx: [],
                    grady: [],
                    gradz: [],
                    b1plus: [],
                    b1minus: [],
                    etransmitted: [],
                    ereceived: []
                },
                coils: {
                    receivingCoilsNumber: undefined,
                    transmittingCoilsNumber: undefined,
                },
                sequence: {},
            limit:{min:1,max:2},
                Alias: "CAMRIE"

            };

            $scope.optionalstuff.geometry.statereset = "reset"
        };

        $scope.VIEWS = {
            OUTPUT: {
                o: true,
                s: true,
                title: "Simulation Output",
                //                                         icon:"fas fa-shapes"
                icon: "fas fa-tasks"
            },
            GEOM: {
                o: true,
                s: false,
                title: "Geometry",
                //                                         icon:"fas fa-shapes"
                icon: "fas fa-child"
            },
            SEQUENCE: {
                o: true,
                s: true,
                title: "Sequence",
                icon: "fas fa-wave-square",
                ORIGIN: "create"
            },
            FIELDS: {
                o: true,
                s: false,
                title: "Fields",
                icon: "fas fa-long-arrow-alt-up"
            },
            COILS: {
                o: true,
                s: true,
                title: "Coils",
                icon: "fas fa-broadcast-tower"
            },
            RESUME: {
                o: true,
                s: false,
                title: "Start Calculation",
                icon: "fas fa-database"
            }

        }



        $scope.$watch('STATE.geometry', function (n, o) {
            $scope.VIEWS.COILS.s = n;
            $scope.VIEWS.COILS.o = n;

        }, false);

        $scope.$watch('STATE.coils', function (n, o) {
            $scope.VIEWS.SEQUENCE.s = n;
            $scope.VIEWS.SEQUENCE.o = n;
            $scope.VIEWS.FIELDS.s = n;
            $scope.VIEWS.FIELDS.o = n;

        }, false);

        $scope.$watch('STATE.sequence', function (n, o) {
            $scope.VIEWS.RESUME.s = n;
            $scope.VIEWS.RESUME.o = n;

        }, false);





        $scope.queuejob = function () {


    TASK.postIt(BACKEND + '/tasks',$scope.settings).then((d)=>{alert(d)});

                    // TASK.appRFAPI({ "InfoType": 'setpsudojob', settings: $scope.settings, Alias: $scope.settings.Alias }, 'serviceAPI.php').then(function(x) {
                    //     console.log(x);
                    //     alert("Jobs " + $scope.settings.Alias + " Submitted (ID: " + x + ")");
                    //     $scope.reset();

                    // })
                };


                // $timeout($scope.reset, 0);

            }
]);
//
//
//
//
//
//
//
CAMRIE.controller("results", ["$scope", "TASK", "$stateParams", "$timeout", "$state", "$interval", "$q", "cmtool", function ($scope, TASK, $stateParams, $timeout, $state, $interval, $q, cmtool) {

    $scope.states = [{ name: 'Home', link: 'camrie.home' }, { name: 'Set up', link: 'camrie.settings' }, { name: 'Results', link: 'camrie.results' }];
    $scope.selectedstate = 'Results';
    $scope.USER = TASK.getUserLog();




    $scope.uploadROI = function (x, a, jid) {
        var l = QPATH + '/serviceAPI.php'
        //   console.log(l);
        var deferred = $q.defer();
        cmtool.generalRFAPI({
            "roi": x,
            "jid": jid,
            "alias": a,
            "InfoType": "insertrois"
        }, l).then(function (response) {
            alert("correctly uploaded" + " " + a);
            deferred.resolve(true);
        });


        return deferred.promise;

    }

    $scope.getServerRois = function () {
        var deferred = $q.defer();
        var l = QPATH + '/serviceAPI.php'
        //    console.log(l);

        cmtool.generalRFAPI({
            "jid": $scope.JID,
            InfoType: "getjobrois"
        }, l).then(function (r) {

            deferred.resolve(r);

        });
        return deferred.promise;
    };



    $scope.getUserJob = function () {
        var deferred = $q.defer();
        var l = BACKEND + '/tasks'


        TASK.getIt(l).then(function (r) {
            console.log(r)
            deferred.resolve(r.data);
        });
        return deferred.promise;
    };



    $scope.deleteUserJob = function (x) {
        var deferred = $q.defer();
        var l = QPATH + 'serviceAPI.php'
        //    console.log(l);

        cmtool.generalRFAPI({
            "UID": $scope.USER.UID,
            jid: x,
            InfoType: "deleteuserjob"
        }, l).then(function (r) {

            deferred.resolve(r);

        });
        return deferred.promise;
    };



    $scope.sendjobfeedback = function (message, id) {
        var deferred = $q.defer();
        var l = QPATH + 'serviceAPI.php'
        //    console.log(l);

        cmtool.generalRFAPI({
            message: message,
            jid: id,
            InfoType: "setjobfeedback"
        }, l).then(function (r) {

            deferred.resolve(r);

        });
        return deferred.promise;
    };










    $scope.conf = {
        canvassize: {
            h: 233,
            w: 233
        },
        applicationname: "CAMRIE",
        snapshotname: "CAMRIE shot",
        resultdownloadrootname: function () { return TASK.ora() },
        actionbuttons: [{
            icon: "fas fa-teeth-open",
            function: function () { alert('yep'); },
            tootltip: 'yepyep'
        }],
        userroiupload: function (x, id) {
            var deferred = $q.defer();
            $scope.uploadROI(x, id, $scope.JID).then(function (o) { deferred.resolve(o); });
            return deferred.promise;
        },
        userroiget: function () {
            var deferred = $q.defer();
            $scope.getServerRois($scope.JID).then(function (o) { deferred.resolve(o); });
            return deferred.promise;
        },
        usermovingfunction: function (x, y) {
            console.log('outside_moving');
            console.log($scope.USER);
            console.log(x);
            console.log(y);
        },
        deletejob: $scope.deleteUserJob,
        sendjobfeedback: function (message, id) {
            var deferred = $q.defer();
            $scope.sendjobfeedback(message, id).then(function (o) { deferred.resolve(o); });
            return deferred.promise;
        },
        user: $scope.USER,
        joblistgetter: $scope.getUserJob
    };






    $scope.start = function () {
        $scope.jsondata = undefined;
        $scope.JID = undefined;
    };


    $scope.start();


}]);
