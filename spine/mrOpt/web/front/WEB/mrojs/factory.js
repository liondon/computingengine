MROPTIMUM.factory("cmTASK", ["$state", "$http", "$q", "$compile", "cmtool", "$interval", function ($state, $http, $q, $compile, cmtool, $interval) {


    var u = {
        promisedataretienving: undefined,
        USERDATA: [],
        updateDATA: 10000, //ms
        promisejobretienving: undefined,
        USERJOBS: [],
        updateJOBS: 10000, //ms
        MAXDATA: 10000000000,
        promisestart: undefined,
        logUID: {
            UID: 0,
            name: "Eros",
            surname: undefined,
            email: undefined,
            status: undefined,
            admin: false,
            logged: false,
            allow: true,
            pwd: "Eros",
            subdetails: undefined
        }
    };

    var getUrl = window.location;
    var baseUrl = getUrl.protocol + "//" + getUrl.host.split(":")[0];
    u.taskUploadAPI = baseUrl + ":" + BACKEND_PORT + '/tasks';

    u.pmrOptionsFile = "http://cloudmrhub.com/apps/MROPTIMUM/APPDATA/147/PMR/J/PMROPT_5d1d0e23de333.json";
    u.mrOptionsFile = "http://cloudmrhub.com/apps/MROPTIMUM/APPDATA/212/MR/J/MROPT_5f452fca92548.json"
    u.acmOptionsFile = "http://cloudmrhub.com/apps/MROPTIMUM/APPDATA/147/ACM/J/ACMOPT_5d1d0afd204bd.json"
    u.qServer = "http://cloudmrhub.com/Q/";

    u.getUserLog = function () {
        return u.logUID;
    };

    u.myRFAPI = function (DATA, web) {
        //make a query in the mrptimum querypath for simple RFAPI just use RFAPI
        var deferred = $q.defer();

        DATA.email = u.logUID.email;
        DATA.pwd = u.logUID.pwd;
        DATA.uid = u.logUID.UID;

        cmtool.generalRFAPI(DATA, QPATH + web).then(function (response) {
            deferred.resolve(response);
        });
        return deferred.promise;

    };

    u.fetchuserdata = function () {
        //get the data from cloudmr and place them where is needed u.USERDATA
        var USERID = u.getUserLog().UID;
        //console.log("D- fetch the data");
        var deferred = $q.defer();

        if (!isUndefined(USERID)) {
            cmtool.getMyData(USERID).then(function (response) {
                // console.log("D- got the data");
                if (response.length != u.USERDATA.length) {
                    u.USERDATA = response;
                    deferred.resolve(response);
                    //  console.log("D- different length");
                } else {
                    response.forEach(function (o, index) {

                        if (o.ID != u.USERDATA[index].ID || o.status != u.USERDATA[index].status) {
                            u.USERDATA[index] = o;
                            // console.log("DI-" + o.ID + "changed");

                        }
                        if (index === response.length - 1) {
                            deferred.resolve(response); //only if it's directly
                            //console.log("D- deferred compared");
                        }
                    });
                }
            });
        }
        return deferred.promise;
    };


    // interval for getting the data from the server
    u.startDataRetrieving = function () {
        // stops any running interval to avoid two intervals running at the same time
        u.stopDataRetrieving().then(function () {
            u.promiseDataretienving = $interval(function () {
                var USERID = u.getUserLog().UID;
                if (!(isUndefined(USERID))) {
                    u.fetchuserdata();
                }
            }, u.updateDATA);
        });

    };

    // stops the interval
    u.stopDataRetrieving = function () {
        var deferred = $q.defer();
        try {
            $interval.cancel(u.promisedataretienving);
            deferred.resolve(true);
        } catch (e) {
            console.log(e);
            deferred.resolve(true);
        }
        return deferred.promise;
    };

    u.deletedata = function (x) {
        var USERID = u.getUserLog().UID;
        var deferred = $q.defer();
        cmtool.deleteMyData(USERID, x).then(function (r) {
            u.fetchuserdata().then(function (o) {
                deferred.resolve(r);
            });
        });

        return deferred.promise;
    }


    ///jobs

    u.fetchusrjobs = function () {

        var deferred = $q.defer();
        u.myRFAPI({ InfoType: "userjobs" }, 'serviceAPI.php').then(function (response) {
            //change only if the status is different

            if (response.length != u.USERJOBS.length) {
                u.USERJOBS = response;
                deferred.resolve(response); //only if it's directly
            } else {
                response.forEach(function (o, index) {

                    if (o.ID != u.USERJOBS[index].ID || o.status != u.USERJOBS[index].status) {
                        u.USERJOBS[index] = o;

                    }
                    if (index === response.length - 1) {
                        deferred.resolve(response); //only if it's directly
                    }
                });
            }
            // 
        }

        );
        return deferred.promise
    };


    // starts the jobs intereval
    u.startJobsRetrieving = function () {
        var USERID = u.getUserLog().UID;
        u.fetchusrjobs();
        // stops any running interval to avoid two intervals running at the same time
        u.stopJobsRetrieving();

        u.promisejobretienving = $interval(function () {

            var USERID = u.getUserLog().UID;
            if (!(isUndefined(USERID))) {
                u.fetchusrjobs();
            }
        }, u.updateJOBS);

    };

    // stops the interval
    u.stopJobsRetrieving = function () {
        $interval.cancel(u.promisejobretienving);
    };

    u.startJobsRetrieving();

    u.getDIListOfData = function () {
        var deferred = $q.defer();
        var LIST = [];
        u.USERDATA.forEach(function (o, indexof) {
            switch (getFilextension(o.filename).toLowerCase()) {

                case 'jpg':
                case 'png':
                case 'jpeg':
                case 'ima':
                case 'dcm':
                    LIST.push(o);
                    break;
            }
            if (indexof == u.USERDATA.length - 1) {
                deferred.resolve(LIST);
            }
        })
        return deferred.promise;
    };


    u.getACMListOfData = function () {
        var deferred = $q.defer();
        var LIST = [];
        u.USERDATA.forEach(function (o, indexof) {
            switch (getFilextension(o.filename).toLowerCase()) {

                case 'ismrmrd':
                case 'dat':
                    LIST.push(o);
                    break;

            }
            if (indexof == u.USERDATA.length - 1) {
                deferred.resolve(LIST);
            }
        })
        return deferred.promise;
    };

    u.getListOfData = function () {
        var deferred = $q.defer();
        deferred.resolve(u.USERDATA);
        return deferred.promise;
    };



    u.getListOfJobs = function (status) {
        var deferred = $q.defer();
        var LIST = [];

        if (isUndefined(status)) {
            deferred.resolve(u.USERJOBS);
        } else {
            if (u.USERJOBS.length > 0) {
                u.USERJOBS.forEach(function (o, indexof) {
                    if (o.status === status) {
                        LIST.push(o);
                    }

                    if (indexof == u.USERJOBS.length - 1) {
                        deferred.resolve(LIST);


                    }
                });
            } else {
                deferred.resolve([]);
            }

        }



        return deferred.promise;
    };






    u.isAdmin = function () {
        return u.logUID.admin;
    };
    u.islogged = function () {
        return u.logUID.logged;
    };

    u.ora = function () {
        return new Date().toISOString().slice(0, 19).replace('T', ' ');
    };

    u.oggi = function () {
        var d = new Date();
        //        var c=d.getFullYear().toString();
        var c = d.getFullYear().toString() + "_" + d.getMonth().toString() + "_" + d.getDate().toString();
        return c;
    };




    u.setEntireUserLog = function (x) {
        var deferred = $q.defer();

        if (!(isUndefined(x))) {
            u.logUID = x;
            if (!(isUndefined(x.UID))) {
                console.log(u.getUserLog());
                cmtool.getMyData(x.UID).then(function (response) {
                    u.USERDATA = response;
                    console.log("start data retriving from cloudmr")
                    u.startDataRetrieving();
                });
            }

        }
        deferred.resolve(true);
        return deferred.promise;
    };


    u.goto = function (s, opt) {

        if (isUndefined(opt)) {
            opt = {};
        }
        $state.go(s, opt, {
            reload: true
        });
    };


    u.FIXUSERJOBS = function (X) {
        try {
            X.forEach(function (o, i) {
                var datei = new Date(o.dateIN);
                var dateo = new Date(o.dateOUT);
                var diffTime = Math.abs(dateo.getTime() - datei.getTime());
                o.SS = diffTime / (1000);
            });
        } catch (e) {

        }
    }

    u.postIt = (web,DATA) =>{
        var deferred = $q.defer();
        DATA["theuser"] = u.logUID.name
        DATA["thepwd"] = u.logUID.pwd
        // DATA["uid"] = u.logUID.UID
        $http({
            method: 'POST',
            url: web,
            data:DATA,
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .success(function(data, status, headers, config) {
            deferred.resolve(data);

        })
        .error(function(data, status, headers, config) {
            alert(status);
        });
        return deferred.promise;

    }

    u.getIt = (web)=>{
        var deferred = $q.defer();

        $http({
            method: 'GET',
            url: web
          }).then(function successCallback(response) {
              // this callback will be called asynchronously
              // when the response is available
              deferred.resolve(response);
            }, function errorCallback(response) {
              // called asynchronously if an error occurs
              // or server returns response with an error status.
              console.log('error');
            });

            return deferred.promise;

    }

    return u;

}]);