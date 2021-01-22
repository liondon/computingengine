MROPTIMUM.controller("bug", ["$scope", "cmTASK", "cmtool",


    function ($scope, cmTASK, cmtool) {
        $scope.USER = cmTASK.getUserLog();

        $scope.reset = function () {
            $scope.DATA = { APPS: [{ AID: 4, ID: 17, UID: $scope.USER.UID, json: "http://cloudmrhub.com/apps/MROPTIMUM/cfg/mroptimum.json", name: "MR optimum", status: "ok" }], X: { ID: undefined }, title: undefined, msg: undefined };


        };

        $scope.reset();

        // $scope.$watch("DATA.X", function(x) { console.log(x); }, true);

        $scope.sendBug = function () {
            cmtool.sendBug($scope.USER.UID, $scope.DATA.X.AID, $scope.DATA.title, $scope.DATA.msg).then(function (response) {
                alert('Thank you ' + $scope.USER.name + ' for your feedback, we will get back to you soon');
                $scope.reset();

            });
        };





    }
]);




MROPTIMUM.controller("taskbar", ["$scope", "cmTASK", function ($scope, cmTASK) {
    //    $interval( function(){ $scope.WF=myWF.getState(); console.log($scope.WF); }, 200);

    $scope.goHome = function () {
        cmTASK.goto('mroptimum.home', {});
    };


}]);



MROPTIMUM.controller("headerbar", ["$scope", "cmTASK", "cmtool", "$window", "$interval", function ($scope, cmTASK, cmtool, $window, $interval) {
    //    $interval( function(){ $scope.WF=myWF.getState(); console.log($scope.WF); }, 200);
    $scope.USER = cmTASK.getUserLog();
    $scope.goHome = function () {
        cmTASK.goto('mroptimum.home', {});
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


    var interval = $interval(function () { $scope.USER = cmTASK.getUserLog(); }, 1000);

}]);

MROPTIMUM.controller("fakehome", ["$scope", 'cmTASK', '$stateParams', function ($scope, cmTASK, $stateParams) {
    //    $interval( function(){ $scope.WF=myWF.getState(); console.log($scope.WF); }, 200);
    $scope.WF = myWF.getState();

    //that's what i've to fill
    cmTASK.setEntireUserLog({
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

    $scope.u = $stateParams.u;





}]);

MROPTIMUM.controller("home", ["$scope", 'cmTASK', '$stateParams', '$timeout', '$interval', 'cmtool', function ($scope, cmTASK, $stateParams, $timeout, $interval, cmtool) {
    //    $interval( function(){ $scope.WF=myWF.getState(); console.log($scope.WF); }, 200);

    $scope.USER = cmTASK.getUserLog();

    $scope.AGGIUNGILI = function () {
        console.log(document.location.origin + "/Q/serviceAPIbe.php");

        cmtool.generalRFAPI({
            "InfoType": "defaultdataset",
            "uid": $scope.USER.UID,
            "serverdirectorypath": "SHAREDDATA/MROPTIMUMTEST/"
        }, document.location.origin + "/Q/serviceAPIbe.php").then(function (response) {
            alert("MR Optimum Default Images updated");
        });



    };



    $scope.states = [{ name: 'Home', link: 'mroptimum.home' }, { name: 'Set up', link: 'mroptimum.settings' }, { name: 'Results', link: 'mroptimum.results' }];
    $scope.selectedstate = 'Home';



    $scope.total = { v: 0.0, p: 0.0 };
    var promise2;


    // starts the interval
    $scope.startP = function () {
        // stops any running interval to avoid two intervals running at the same time
        $scope.getInfo();
        $scope.stopP();
        promise2 = $interval(function () { $scope.getInfo(); }, 5000);

    };

    // stops the interval
    $scope.stopP = function () {

        $interval.cancel(promise2);
    };


    $scope.$on('$destroy', function () {
        $scope.stopP();
        wD();
        wJ();
        wR();
    });










    $scope.FILE = {
        v: { o: true, s: true, title: "Data", icon: "fas fa-database" }
    };
    $scope.RESULTS = { v: { o: true, s: true, title: "Latest Activities", icon: "fas fa-database" } };






    $scope.getInfo = function () {
        var totalJ = { v: 0.0, p: 0.0 };
        var totalD = { v: 0.0, p: 0.0 };

        //  console.log("S- get the roi");
        cmTASK.getListOfJobs('ok').then(function (x) {
            //    console.log("S- " + x.length + "get the roi");

            $scope.JOBS = x;
            cmTASK.FIXUSERJOBS(x);
            if ((x.length > 0) && (x != null) && (!(isUndefined(x)))) {
                cmtool.FIXUSERFILES($scope.JOBS, cmTASK.MAXDATA).then(function (o) {
                    //    console.log("S- fixed the rois files");
                    totalJ = o;

                    cmTASK.getListOfData().then(function (x2) {
                        //      console.log("S- got list of data" + x2.length);
                        $scope.DATA = x2;
                        cmtool.FIXUSERFILES(x2, cmTASK.MAXDATA).then(function (o2) {
                            totalD = o2;
                            //       console.log("S- fixed the job files");
                            if ((totalD.v + totalJ.v) != $scope.total.v) {
                                $scope.total.v = totalD.v + totalJ.v;
                                $scope.total.p = totalD.p + totalJ.p;
                            }


                        })

                    });
                });
            } else {
                cmTASK.getListOfData().then(function (x2) {
                    //    console.log("S- got list of data" + x2.length);
                    $scope.DATA = x2;
                    cmtool.FIXUSERFILES(x2, cmTASK.MAXDATA).then(function (o2) {
                        totalD = o2;
                        //           console.log("S- fixed the job files");
                        if ((totalD.v + totalJ.v) != $scope.total.v) {
                            $scope.total.v = totalD.v + totalJ.v;
                            $scope.total.p = totalD.p + totalJ.p;
                        }


                    })

                });

            }
        });






        cmTASK.myRFAPI({ InfoType: "userrois" }, 'serviceAPI.php').then(function (response) {
            $scope.allROIS = response;
        });

    }


    $scope.TABLEROISVISIBLE = [true, true, true, false, false];

    var wR = $scope.$watch("allROIS", function (x) {
        if (isUndefined(x)) {

        } else {
            $scope.TABLEROIS = [];
            x.forEach(function (o) {
                var v = { ID: o.ID, "ROI Alias": o.Alias, "JOB Alias": o.jobalias, 'Date submitted': o.dateModified, link: o.filename, downloadfilename: basename(o.filename) };

                //                switch(o.status){
                //                    case 'ok':
                //                        v.status='success';
                //                        break;
                //                    case 'ko':
                //                        v.status='warning';
                //                        break;
                //                    default:
                //                        v.status='';
                //                };
                v.status = '';

                $scope.TABLEROIS.push(v);

            });
        }
    }, true);


    $scope.TABLEJOBSVISIBLE = [false, true, true, true, false];
    $scope.TABLERESULTSVISIBLE = [true, true, true, true, false, false];

    var wJ = $scope.$watch("JOBS", function (x) {



        $scope.TABLEJOBS = [];
        $scope.TABLERESULTS = [];
        // cmTASK.FIXUSERFILES(x, $scope.total);
        if (isUndefined(x)) {

        } else {
            x.forEach(function (o) {
                try {
                    var v = { ID: o.ID, Alias: o.Alias, 'Date submitted': o.dateIN, "Calculation Time": o.SS };

                    var results = { ID: o.ID, Alias: o.Alias, 'Date submitted': o.dateIN, Size: formatBytes(o.size), link: o.results, downloadfilename: basename(o.results) };

                    switch (o.status) {
                        case 'ok':
                            v.status = '';

                            $scope.TABLERESULTS.push(results);

                            break;
                        case 'ko':
                            v.status = 'warning';
                            break;
                        default:
                            v.status = 'active';
                    };

                    if (o.status === 'ok') {
                        v.status = 'ok';
                        $scope.TABLEJOBS.push(v);
                    }



                } catch (e) {

                }
            });
            cmTASK.FIXUSERJOBS($scope.TABLERESULTS);
        }
    }, true);




    var wD = $scope.$watch("DATA", function (x) {

        $scope.TABLEDATA = [];
        if (!isUndefined(x)) {

            if (x.length > 0) {
                x.forEach(function (o) {
                    var v = { ID: o.ID, 'File Name': o.filename, 'Date submitted': o.dateIN, Size: formatBytes(o.size), link: o.externalfilename, downloadfilename: o.filename };

                    switch (o.status) {
                        case 'ok':
                            v.status = '';
                            break;
                        case 'ko':
                            v.status = 'warning';
                            break;
                        default:
                            v.status = '';
                    };


                    $scope.TABLEDATA.push(v);
                });
            }
        }
        $scope.TABLEDATAVISIBLE = [true, true, true, true, false, false, false];

    }, true);

    $scope.goR = function (x) {

        $scope.stopP();
        cmTASK.goto('mroptimum.results', { ID: x, u: 0 });
        //        $state.go('mropt.results', {ID: x,u:0});

    };

    $scope.TABLEJOBSFUNCTIONS = [{ click: $scope.goR, icon: "fas fa-eye", tooltip: 'Watch this result', type: 'function' }];





    $scope.delData = function (x) {
        OUT = confirm("Do you want to delete the file?");
        cmtool.loading(true);
        if (OUT) {
            cmTASK.deletedata(x).then(function (o) {
                $scope.getInfo();
                cmtool.loading(false);
            });
        }
    };



    $scope.delRoi = function (x) {

        OUT = confirm("Do you want to delete ROI with ID " + x + "?");
        cmtool.loading(true);
        if (OUT) {

            cmTASK.myRFAPI({ "roiid": x, InfoType: "deleteroi" }, 'serviceAPI.php').then(function (r) {

                $scope.getInfo();
                cmtool.loading(false);
            });
        }
    };


    $scope.delResult = function (x) {


        var OUT = false;
        OUT = confirm("Do you want to delete JOB ID " + x + "?");
        cmtool.loading(true);
        if (OUT) {

            cmTASK.myRFAPI({ canc: x, DelType: "job" }, 'delete.php').then(function (r) {
                cmTASK.fetchusrjobs().then(function (o, i) {
                    $scope.getInfo();
                    cmtool.loading(false);
                })

            });

        }
    };


    $scope.TABLEDATAFUNCTIONS = [{ click: $scope.delData, icon: "far fa-trash-alt", tooltip: 'delete this file', type: 'function' }, { click: undefined, icon: "far fa-trash-alt", tooltip: 'download this file', type: 'download' }];


    $scope.TABLEROISFUNCTIONS = [{ click: $scope.delRoi, icon: "far fa-trash-alt", tooltip: 'delete this file', type: 'function' }, { click: undefined, icon: "far fa-trash-alt", tooltip: 'download this file', type: 'download' }];

    $scope.TABLERESULTSFUNCTIONS = [{ click: $scope.delResult, icon: "far fa-trash-alt", tooltip: 'delete this file', type: 'function' }, { click: undefined, icon: "far fa-trash-alt", tooltip: 'download this file', type: 'download' }];


    $timeout($scope.startP, 5); //difference bethween home ad start




}]);


MROPTIMUM.controller("start", ["$scope", "$timeout", 'cmTASK', '$stateParams', '$interval', '$rootScope', 'cmtool', function ($scope, $timeout, cmTASK, $stateParams, $interval, $rootScope, cmtool) {
    //thats the controller that is called from cloudmr to strat the app



    try {
        cmtool.loading(false);
    } catch (e) {

    }

    //that's what i've to fill
    $scope.NETUSER = $stateParams.u;
    var wU = $scope.$watch("NETUSER", function (x) {

        U = JSON.parse(x);

        U.allow = true;

        cmTASK.setEntireUserLog(U).then(function (x) {
            $scope.USER = cmTASK.getUserLog();

            $scope.startP();
            wU();
        });

    }, true);


    $scope.AGGIUNGILI = function () {
        console.log(document.location.origin + "/Q/serviceAPIbe.php");

        cmtool.generalRFAPI({
            "InfoType": "defaultdataset",
            "uid": $scope.USER.UID,
            "serverdirectorypath": "SHAREDDATA/MROPTIMUMTEST/"
        }, document.location.origin + "/Q/serviceAPIbe.php").then(function (response) {
            alert("MR Optimum Default Images updated");
        });



    };



    $scope.states = [{ name: 'Home', link: 'mroptimum.home' }, { name: 'Set up', link: 'mroptimum.settings' }, { name: 'Results', link: 'mroptimum.results' }];
    $scope.selectedstate = 'Home';



    $scope.total = { v: 0.0, p: 0.0 };
    var promise2;


    // starts the interval
    $scope.startP = function () {
        // stops any running interval to avoid two intervals running at the same time
        $scope.getInfo();
        $scope.stopP();
        promise2 = $interval(function () { $scope.getInfo(); }, 5000);

    };

    // stops the interval
    $scope.stopP = function () {

        $interval.cancel(promise2);
    };


    $scope.$on('$destroy', function () {
        $scope.stopP();
        wD();
        wJ();
        wR();
    });










    $scope.FILE = {
        v: { o: true, s: true, title: "Data", icon: "fas fa-database" }
    };
    $scope.RESULTS = { v: { o: true, s: true, title: "Latest Activities", icon: "fas fa-database" } };







    $scope.getInfo = function () {
        var totalJ = { v: 0.0, p: 0.0 };
        var totalD = { v: 0.0, p: 0.0 };

        //  console.log("S- get the roi");
        cmTASK.getListOfJobs('ok').then(function (x) {
            // console.log("S- " + x.length + "get the roi");
            // console.log("x is" + x);
            // console.log("x is" + typeof(x));
            $scope.JOBS = x;
            cmTASK.FIXUSERJOBS(x);
            if ((x.length > 0) && (x != null) && (!(isUndefined(x)))) {
                cmtool.FIXUSERFILES($scope.JOBS, cmTASK.MAXDATA).then(function (o) {
                    // console.log("S- fixed the rois files");
                    totalJ = o;

                    cmTASK.getListOfData().then(function (x2) {
                        // console.log("S- got list of data" + x2.length);
                        $scope.DATA = x2;
                        cmtool.FIXUSERFILES(x2, cmTASK.MAXDATA).then(function (o2) {
                            totalD = o2;
                            // console.log("S- fixed the job files");
                            if ((totalD.v + totalJ.v) != $scope.total.v) {
                                $scope.total.v = totalD.v + totalJ.v;
                                $scope.total.p = totalD.p + totalJ.p;
                            }


                        })

                    });
                });
            } else {
                cmTASK.getListOfData().then(function (x2) {
                    //   console.log("S- got list of data" + x2.length);
                    $scope.DATA = x2;
                    cmtool.FIXUSERFILES(x2, cmTASK.MAXDATA).then(function (o2) {
                        totalD = o2;
                        //    console.log("S- fixed the job files");
                        if ((totalD.v + totalJ.v) != $scope.total.v) {
                            $scope.total.v = totalD.v + totalJ.v;
                            $scope.total.p = totalD.p + totalJ.p;
                        }


                    })

                });

            }
        });






        cmTASK.myRFAPI({ InfoType: "userrois" }, 'serviceAPI.php').then(function (response) {
            $scope.allROIS = response;
        });

    }


    $scope.TABLEROISVISIBLE = [true, true, true, false, false];

    var wR = $scope.$watch("allROIS", function (x) {
        if (isUndefined(x)) {

        } else {
            $scope.TABLEROIS = [];
            x.forEach(function (o) {
                var v = { ID: o.ID, "ROI Alias": o.Alias, "JOB Alias": o.jobalias, 'Date submitted': o.dateModified, link: o.filename, downloadfilename: basename(o.filename) };

                //                switch(o.status){
                //                    case 'ok':
                //                        v.status='success';
                //                        break;
                //                    case 'ko':
                //                        v.status='warning';
                //                        break;
                //                    default:
                //                        v.status='';
                //                };
                v.status = '';

                $scope.TABLEROIS.push(v);

            });
        }
    }, true);


    $scope.TABLEJOBSVISIBLE = [false, true, true, true, false];
    $scope.TABLERESULTSVISIBLE = [true, true, true, true, false, false];

    var wJ = $scope.$watch("JOBS", function (x) {



        $scope.TABLEJOBS = [];
        $scope.TABLERESULTS = [];
        // cmTASK.FIXUSERFILES(x, $scope.total);
        if (isUndefined(x)) {

        } else {
            x.forEach(function (o) {
                try {
                    var v = { ID: o.ID, Alias: o.Alias, 'Date submitted': o.dateIN, "Calculation Time": o.SS };

                    var results = { ID: o.ID, Alias: o.Alias, 'Date submitted': o.dateIN, Size: formatBytes(o.size), link: o.results, downloadfilename: basename(o.results) };

                    switch (o.status) {
                        case 'ok':
                            v.status = '';

                            $scope.TABLERESULTS.push(results);

                            break;
                        case 'ko':
                            v.status = 'warning';
                            break;
                        default:
                            v.status = 'active';
                    };

                    if (o.status === 'ok') {
                        v.status = 'ok';
                        $scope.TABLEJOBS.push(v);
                    }



                } catch (e) {

                }
            });
            cmTASK.FIXUSERJOBS($scope.TABLERESULTS);
        }
    }, true);




    var wD = $scope.$watch("DATA", function (x) {

        $scope.TABLEDATA = [];
        if (!isUndefined(x)) {

            if (x.length > 0) {
                x.forEach(function (o) {
                    var v = { ID: o.ID, 'File Name': o.filename, 'Date submitted': o.dateIN, Size: formatBytes(o.size), link: o.externalfilename, downloadfilename: o.filename };

                    switch (o.status) {
                        case 'ok':
                            v.status = '';
                            break;
                        case 'ko':
                            v.status = 'warning';
                            break;
                        default:
                            v.status = '';
                    };


                    $scope.TABLEDATA.push(v);
                });
            }
        }
        $scope.TABLEDATAVISIBLE = [true, true, true, true, false, false, false];

    }, true);

    $scope.goR = function (x) {

        $scope.stopP();
        cmTASK.goto('mroptimum.results', { ID: x, u: 0 });
        //        $state.go('mropt.results', {ID: x,u:0});

    };

    $scope.TABLEJOBSFUNCTIONS = [{ click: $scope.goR, icon: "fas fa-eye", tooltip: 'Watch this result', type: 'function' }];





    $scope.delData = function (x) {
        OUT = confirm("Do you want to delete the file?");
        cmtool.loading(true);
        if (OUT) {
            cmTASK.deletedata(x).then(function (o) {
                $scope.getInfo();
                cmtool.loading(false);
            });
        }
    };



    $scope.delRoi = function (x) {

        OUT = confirm("Do you want to delete ROI with ID " + x + "?");
        cmtool.loading(true);
        if (OUT) {

            cmTASK.myRFAPI({ "roiid": x, InfoType: "deleteroi" }, 'serviceAPI.php').then(function (r) {

                $scope.getInfo();
                cmtool.loading(false);
            });
        }
    };


    $scope.delResult = function (x) {


        var OUT = false;
        OUT = confirm("Do you want to delete JOB ID " + x + "?");
        cmtool.loading(true);
        if (OUT) {

            cmTASK.myRFAPI({ canc: x, DelType: "job" }, 'delete.php').then(function (r) {
                cmTASK.fetchusrjobs().then(function (o, i) {
                    $scope.getInfo();
                    cmtool.loading(false);
                })

            });

        }
    };


    $scope.TABLEDATAFUNCTIONS = [{ click: $scope.delData, icon: "far fa-trash-alt", tooltip: 'delete this file', type: 'function' }, { click: undefined, icon: "far fa-trash-alt", tooltip: 'download this file', type: 'download' }];


    $scope.TABLEROISFUNCTIONS = [{ click: $scope.delRoi, icon: "far fa-trash-alt", tooltip: 'delete this file', type: 'function' }, { click: undefined, icon: "far fa-trash-alt", tooltip: 'download this file', type: 'download' }];

    $scope.TABLERESULTSFUNCTIONS = [{ click: $scope.delResult, icon: "far fa-trash-alt", tooltip: 'delete this file', type: 'function' }, { click: undefined, icon: "far fa-trash-alt", tooltip: 'download this file', type: 'download' }];
}]);

MROPTIMUM.controller("settings", ["$scope", "cmTASK",
    function ($scope, cmTASK) {
        var view = "settings";
        // console.log(view + "start")
        $scope.USER = cmTASK.getUserLog();

        $scope.states = [{ name: 'Home', link: 'mroptimum.home' }, { name: 'Set up', link: 'mroptimum.settings' }, { name: 'Results', link: 'mroptimum.results' }];
        $scope.selectedstate = 'Set up';

        //var watcherchoosenmethod = undefined;

        $scope.leaving = function () {

            // console.log(view + "leaving")
            try {
                watcherchoosenmethod();
            } catch (e) {
                // console.log(e);
            }

        };

        $scope.$on('$destroy', $scope.leaving);






        $scope.SNRmethods = {
            available: [{
                name: "Difference Image",
                value: "DI",
                state: "enabled"
            },
            {
                name: "Multiple Replica",
                value: "MR",
                state: "enabled"

            },
            {
                name: "Array Combining",
                value: "ACM",
                state: "enabled",

            },
            {
                name: "Pseudo Multiple Replica",
                value: "PMR",
                state: "disabled"
            },

            ],
            choosen: undefined,
            subchoosen: undefined,
            VIEWS: {
                main: {
                    o: true,
                    s: true
                },
                di: {
                    o: false,
                    s: false
                },
                acm: {
                    o: false,
                    s: false
                },
                mr: {
                    o: false,
                    s: false
                },
                pmr: {
                    o: false,
                    s: false
                }
            },
            functions: {

            }
        };


        $scope.SNRmethods.functions.hideview = function (x) {
            x.o = false;
            x.s = false;
        };


        $scope.DI = undefined;
        $scope.ACM = undefined;
        $scope.MR = undefined;
        $scope.PMR = undefined;



        var watcherchoosenmethod = $scope.$watch("SNRmethods.choosen", function (n, o) {
            if (isUndefined(n)) {

            } else {
                switch (n) {
                    case "ACM":
                        $scope.DI = "stop";
                        $scope.MR = "stop";
                        $scope.ACM = "reset";
                        $scope.PMR = "stop";
                        break;
                    case "DI":
                        $scope.DI = "reset";
                        $scope.ACM = "stop";
                        $scope.MR = "stop";
                        $scope.PMR = "stop";
                        break;
                    case "MR":
                        $scope.DI = "stop";
                        $scope.ACM = "stop";
                        $scope.MR = "reset";
                        $scope.PMR = "stop";
                        break;
                    case "PMR":
                        $scope.DI = "stop";
                        $scope.ACM = "stop";
                        $scope.MR = "stop";
                        $scope.PMR = "reset";
                        break;

                }
            }

        });



    }
]);







MROPTIMUM.controller("results", ["$scope", "cmTASK", "$stateParams", "$timeout", "$state", "$interval", "$q", "cmtool", "$window", "$compile", "drawingservice", "mrodictionaryservice", function ($scope, cmTASK, $stateParams, $timeout, $state, $interval, $q, cmtool, $window, $compile, drawingservice, dictionary) {

    $scope.USER = cmTASK.getUserLog();

    $scope.states = [{ name: 'Home', link: 'mroptimum.home' }, { name: 'Set up', link: 'mroptimum.settings' }, { name: 'Results', link: 'mroptimum.results' }];
    $scope.selectedstate = 'Results';

    var isitDI = false;

    var di = { images: [] };




    var dfltTitle = "Results"
    $scope.viewtitle = dfltTitle;

    $scope.uploadROI = function (x, a) {
        var l = QPATH + '/serviceAPI.php'
        cmtool.loading(true, 2);
        var deferred = $q.defer();
        cmtool.generalRFAPI({
            "roi": x,
            "jid": $scope.JID,
            "alias": a,
            "uid": $scope.USER.UID,
            "InfoType": "insertrois"
        }, l).then(function (response) {
            cmtool.loading(false, 2);
            alert(a + " correctly saved");
            deferred.resolve(true);
        });

        return deferred.promise;

    }


    $scope.getServerRois = function () {
        var deferred = $q.defer();
        var l = QPATH;
        cmtool.generalRFAPI({
            "jid": $scope.JID,
            InfoType: "roi"
        }, l + '/getJobROIS.php').then(function (r) {

            deferred.resolve(r.response);

        });

        return deferred.promise;
    };





    $scope.getMyResults = function () {

        var deferred = $q.defer();

        cmTASK.getListOfJobs().then(function (r) {
            deferred.resolve(r);
        });

        return deferred.promise;
    };





    $scope.deleteUserJob = function (x) {
        var deferred = $q.defer();

        //    console.log(l);
        cmtool.loading(true);
        cmTASK.myRFAPI({ canc: x, DelType: "job" }, 'delete.php').then(function (r) {
            cmTASK.fetchusrjobs().then(function (o) {
                cmTASK.getListOfJobs().then(function (x) {
                    cmtool.loading(false);
                    deferred.resolve(r);
                });
            })


        });

        return deferred.promise;
    };



    $scope.sendjobfeedback = function (message, id) {
        var deferred = $q.defer();
        cmtool.loding(true);
        cmTASK.myRFAPI({ "message": message, "canc": id }, 'sendFeedback.php').then(function (r) {
            cmtool.loading(false);
            deferred.resolve(r);
        });
        return deferred.promise;
    };







    $scope.report = function (innerscope, rois, transformation) {

        var popupWindow = $window.open('mroReport.html', '_blank');
        popupWindow.JSONDATA = $scope.jsondata;
        popupWindow.DATA = innerscope.data;
        popupWindow.USER = $scope.USER;
        popupWindow.ROIS = rois;
        popupWindow.CANVASTRANSFORM = transformation;


    };


    //if i'm coming from the automatic selection
    $timeout(function () {

        if ($stateParams.ID == "0" || !($stateParams.ID)) {
            //            console.log("nothing to plot");
            $scope.start();

        } else {
            cmtool.loading(true);
            $scope.getMyResults().then(function (r) {

                //find the results to get the json poistion
                var A = findAndGet(r, "ID", parseInt($stateParams.ID));
                //    console.log(A);
                //take the json

                cmtool.getJson(A[0].results).then(function (thejsondile) {
                    $scope.JID = $stateParams.ID;
                    try {
                        $scope.jsondata = JSON.parse(thejsondile);
                        cmtool.loading(false);

                    } catch (e) {
                        $scope.jsondata = thejsondile;
                        cmtool.loading(false);
                    }

                    try {
                        $scope.viewtitle = A[0].alias;
                    } catch (e) {
                        $scope.viewtitle = dfltTitle;
                    }

                });

            });
        };

    }, 10);





    $scope.conf = {
        reportfunction: function (inscope, roistojson, transformation) { $scope.report(inscope, roistojson, transformation) },
        canvassize: {
            h: 233,
            w: 233
        },
        title: $scope.viewtitle,
        applicationname: "Mr Optimum",
        snapshotname: "Mr Optimum",
        resultdownloadrootname: function () { return cmTASK.ora() },
        actionbuttons: [],
        userroiupload: function (x, id) {
            var deferred = $q.defer();
            $scope.uploadROI(x, id).then(function (o) { deferred.resolve(o); });
            return deferred.promise;
        },
        userroiget: function () {
            var deferred = $q.defer();
            $scope.getServerRois().then(function (o) { deferred.resolve(o); });
            return deferred.promise;
        },
        usermovingfunction: function (evt, data, ids) {

            if (isitDI) {

                var arr0 = [];
                var arr1 = [];
                getCanvasOriginAndScale(data.Canvas, data.arrayData.w, data.arrayData.h).then(function (originandscale) {

                    var SL = parseInt(data.imageinteractions.selectedSlice);

                    drawingservice.parseImageDetails(di, 0, SL, data.imageinteractions.selectedValue).then(function (IM1) {

                        getROIData(IM1, evt.target, data.Canvas, originandscale.origin, originandscale.scale, data.Canvas.viewportTransform).then(function (array0) {
                            arr0 = array0;
                            drawingservice.parseImageDetails(di, 1, SL, data.imageinteractions.selectedValue).then(function (IM2) {
                                getROIData(IM2, evt.target, data.Canvas, originandscale.origin, originandscale.scale, data.Canvas.viewportTransform).then(function (array1) {
                                    calculateDISNR(arr0, array1).then(function (xx) {
                                        var SNR = xx.v;
                                        var oo = document.getElementById(ids.optionaltext);
                                        oo.innerHTML = "<table class='table table-striped'><tbody> <tr> <td scope='col'>SNR </td> <td>" + SNR.toFixed(2) + "</td> </tr> </table>";

                                        // <table class='table table-striped'> <thead class='thead-dark'> <th scope='col'>Features</th> <th scope='col'>Values</th> </thead> <tbody> <tr> <td scope='col'>SNR </td> <td>" + SNR.toFixed(2) + "</td> </tr> </table>"

                                    });
                                });
                            });
                        });
                    });
                });





            } else {
                var oo = document.getElementById(ids.optionaltext);
                // console.log(oo);
                oo.innerHTML = "";
            }
        },
        deletejob: $scope.deleteUserJob,
        sendjobfeedback: function (message, id) {
            var deferred = $q.defer();
            $scope.sendjobfeedback(message, id).then(function (o) { deferred.resolve(o); });
            return deferred.promise;
        },
        user: $scope.USER,
        joblistgetter: $scope.getMyResults
    };



    $scope.getAliasfromID = function (id) {

        var thetitle = undefined;
        var deferred = $q.defer();
        //if he can't find the alias he is ging to give the deafult name
        var yourTimer = $timeout(function () {
            if (isUndefined(thetitle)) {
                deferred.resolve(dfltTitle);
                $timeout.cancel(yourTimer);
            }
        }, 2000);
        console.log(id);
        if (isUndefined(id)) {
            deferred.resolve(dfltTitle);
        } else {
            $scope.getMyResults("ok").then(function (r) {
                //find the results to get the json poistion
                r.forEach(function (o, index) {

                    if (o.ID == parseInt(id)) {
                        $timeout.cancel(yourTimer);
                        title = o.Alias;
                        deferred.resolve(o.Alias);

                    }
                    if (index === r.length) {
                        deferred.resolve(dfltTitle);
                        $timeout.cancel(yourTimer);
                    }
                })


            });
        }

        return deferred.promise;

    };


    $scope.start = function () {
        $scope.jsondata = undefined;
        $scope.JID = undefined;
    };

    //test if its DI
    var vJ = $scope.$watch('jsondata', function (o) {

        if (getmrojsonType(o) == 'DI') {
            isitDI = true;
            findAndGetWithPromise(o.images, 'imageName', "Image 1").then(function (im1) {

                di.images.push(im1[0]);
            });

            findAndGetWithPromise(o.images, 'imageName', "Image 2").then(function (im2) {

                di.images.push(im2[0]);
            });

        } else { isitDI = false; };

        if (!(isUndefined(o))) {
            $scope.getAliasfromID($scope.jsondata.info.jobnumber).then(function (thepossibletitle) {
                console.log(thepossibletitle)
                $scope.viewtitle = dictionary.ParseTerm(getmrojsonType(o)) + ":  " + thepossibletitle;
            });
        }


    }, true);

    $scope.$watch('viewtitle', function (x) {
        if (!(isUndefined(x))) {

            $scope.conf.title = x
        }
    }, true);


    $scope.killer = function () {
        vJ();
    }
    $scope.$on('$destroy', $scope.killer);


}]);









MROPTIMUM.controller("cnt", ["$scope", "cmtool", "cmTASK", function ($scope, cmtool, cmTASK) {
    $scope.USER = cmTASK.getUserLog();




    $scope.USER_name = $scope.USER.name + ' ' + $scope.USER.surname;


    $scope.init = function () {
        $scope.to = "Cloud MR Team \nCenter for Advanced Imaging Innovation and Research\nNYU Langone Health\n660 1st Avenue - 4th Floor\nNew York, NY 10016 (USA)";
        $scope.WHO = "support@cloudmrhub.com";
        $scope.subject = undefined;
        $scope.msg = undefined;
        $scope.email = $scope.USER.email;
    }

    $scope.send = function () {
        cmtool.loading(true);


        cmtool.sendemail($scope.WHO, $scope.subject, $scope.msg, $scope.email).then(function (o) {
            // console.log(o);
            cmtool.loading(false);
            alert("thank you for your feedback we will response ASAP ");
            $scope.init();
        });

    };


    $scope.init();



}]);