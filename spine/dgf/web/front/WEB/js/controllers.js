
DGF.controller("bug", ["$scope","TASK","cmtool",function($scope,TASK,cmtool){
    $scope.USER=TASK.getUserLog();

    $scope.reset=function(){
        $scope.DATA={APPS:[{AID: 4,ID: 17,UID: $scope.USER.UID, json: document.location.origin + "/DGF/cfg/dgf.json",name: "DGF",status: "ok"}],X:{ID:undefined},title:undefined,msg:undefined};


    };

    $scope.reset();

    $scope.$watch("DATA.X",function(x){console.log(x);},true);

    $scope.sendBug=function(){
        cmtool.sendBug($scope.USER.UID,$scope.DATA.X.AID,$scope.DATA.title,$scope.DATA.msg).then(function(response){
            alert('Thank you '+$scope.USER.name + ' for your feedback, we will get back to you soon');
            $scope.reset();

        });
    };





}]);




DGF.controller("cnt", ["$scope","cmtool","TASK",function($scope,cmtool,TASK){
    $scope.USER=TASK.getUserLog();
    console.log($scope.USER);



    $scope.USER_name=$scope.USER.name + ' ' + $scope.USER.surname;


    $scope.init=function(){
        $scope.to="Cloud MR Team \nCenter for Advanced Imaging Innovation and Research\nNYU Langone Health\n660 1st Avenue - 4th Floor\nNew York, NY 10016 (USA)";
        $scope.WHO="support@cloudmrhub.com";
        $scope.subject=undefined;
        $scope.msg=undefined;
        $scope.email=$scope.USER.email;
    }

    
        $scope.init();
    
    
    $scope.send=function(){
        cmtool.LOAD(true);



        console.log();
                cmtool.generalRFAPI({em:$scope.WHO,sub:$scope.subject,message:$scope.msg,reply:$scope.email},'http://' + document.location.origin +'/Q/sendmail.php').then(function(response){
                    console.log("qui");
            cmtool.LOAD(false);
            alert("thank you for your feedback we will response ASAP ");
            $scope.init();

        });
    };

}]);

DGF.controller("taskbar",["$scope","TASK",function($scope,TASK) {
    //    $interal( function(){ $scope.WF=myWF.getState(); console.log($scope.WF); }, 200);

    $scope.goHome=function(){
        TASK.goto('app.home',{});
    };


}]);

DGF.controller("headerbar",["$scope","TASK","cmtool","$window","$interval",function($scope,TASK,cmtool,$window,$interval) {
    //    $interval( function(){ $scope.WF=myWF.getState(); console.log($scope.WF); }, 200);
    $scope.USER=TASK.getUserLog();
    $scope.goHome=function(){
        TASK.goto('app.home',{});
    };


    $scope.logout=function(){
        var url="http://cloudmrhub.com";


        $window.open(url, "_parent");
    };


    //with this i stop the search of the username
    $scope.$watch("USER.name",function(x){
        if (!(isUndefined(x))){
            $scope.usertooltip=$scope.USER.name + " " + $scope.USER.surname;
            $interval.cancel(interval);

        }
    },true);


    var interval=$interval(function(){$scope.USER=TASK.getUserLog();},1000);

}]);



DGF.controller("fakehome",["$scope","TASK","cmtool",function($scope,TASK,cmtool) {



    console.log("fake");
    $scope.TASKBAR={view:true,active:'home'};

    //that's what i've to fill
    TASK.setEntireUserLog({
        UID: 118,
        name: "Eros",
        surname: "Montin",
        email: "eros.montin@gmail.com",
        status:"active",
        admin: false,
        logged: true,
        allow:true,
        pwd:undefined
    });



    $scope.USER=TASK.getUserLog();

    $scope.uploadfunction=function(x){


        var DATA={alias:x.name,uid:$scope.USER.UID};
        //            getBaseName(x.name);

        cmtool.LOAD(true);
       // tool.uploadFile(x,DATA).then(function(ID){console.log("the id is " + ID); cmtool.LOAD(false)});




    }
}]);

DGF.controller("home",["$scope",'TASK','$stateParams','cmtool','$interval',function($scope,TASK,$stateParams,cmtool,$interval) {
    ///functions

    $scope.USER=TASK.getUserLog();


    $scope.getFileInfo=function(){
        if(isUndefined($scope.USER)){

        }else{
            cmtool.getMyData($scope.USER.UID).then(function(response){
                $scope.DATA=response;
            });
        }

    };


    $scope.totalreset=function(){
        $scope.total={p:0.0,v:0.0};

    };

    $scope.delData=function(fid){
        OUT=confirm("Do you want to delete the file?");
        if(OUT){
            $scope.totalreset();
            cmtool.deleteMyData($scope.USER.UID,fid).then( function(r){
                $scope.getFileInfo();
            });
        }
    };



    $scope.totalreset();

    $scope.getFileInfo();



    $scope.$watch('DATA',function(n){
        console.log(n);
        if (isUndefined(n)){

        }else{    
            if(n.length>0){
                cmtool.FIXUSERFILES(n,TASK.APPMAXDATA()).then(function(response){
                    console.log(response);
                    $scope.total=response;});
            }
        }
    },true);


    //    //that's what i've to fill
    //    $scope.NETUSER=$stateParams.u;
    //    $scope.$watch("NETUSER",function(x){
    //
    //        U=JSON.parse(x);
    //
    //        U.allow=true;
    //        TASK.setEntireUserLog(U).then(function(x){$scope.USER=TASK.getUserLog();});
    //        
    //          $scope.getFileInfo();
    //            $scope.startP();
    //
    //    },true);




    $scope.states=[{name:'Home',link:'app.home'},{name:'Set up',link:'app.settings'},{name:'Results',link:'app.results'}];
    $scope.selectedstate='Home';




    var promise2;


    // starts the interval
    $scope.startP = function() {
        // stops any running interval to avoid two intervals running at the same time
        $scope.stopP();
        //activate this later ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        promise2 = $interval( $scope.getFileInfo, 1000);

    };

    // stops the interval
    $scope.stopP = function() {

        $interval.cancel(promise2);
    };


    $scope.$on('$destroy', function() {
        $scope.stopP();
    });



    $scope.startP();



    //update data  
    $scope.FILE={
        v:{o:true,s:true,title:"Data",icon:"fas fa-database"}
    };

    $scope.TABLEDATAFUNCTIONS=[
        {click:$scope.delData,icon:"far fa-trash-alt",tooltip:'delete this file',type:'function'},
        {click:undefined,icon:"far fa-trash-alt",tooltip:'download this file',type:'download'}];

    $scope.$watch("DATA",function(x){

        $scope.TABLEDATA=[];
        if(!isUndefined(x)){
            if(x.length>0){
                x.forEach(function(o){
                    var v={ID:o.ID,'File Name':o.filename,'Date submitted':o.dateIN,Size:formatBytes(o.size),link:o.externalfilename,downloadfilename:o.filename};

                    switch(o.status){
                        case 'ok':
                            v.status='';
                            break;
                        case 'ko':
                            v.status='warning';
                            break;
                        default:
                            v.status='';
                    };


                    $scope.TABLEDATA.push(v);
                });
            }
        }
        $scope.TABLEDATAVISIBLE=[false,true,true,true,false,false,false];

    },true);





}]);


DGF.controller("start",["$scope","$timeout",'TASK','$stateParams','$interval','$rootScope','cmtool',function($scope,$timeout,TASK,$stateParams,$interval,$rootScope,cmtool){
    //thats the controller that is called from cloudmr to strat the app
    //    $interval( function(){ $scope.WF=myWF.getState(); console.log($scope.WF); }, 200);


    console.log($stateParams.u);
    
    ///functions
    $scope.getFileInfo=function(){
        if(isUndefined($scope.USER)){

        }else{
            cmtool.getMyData($scope.USER.UID).then(function(response){
                $scope.DATA=response;
            });
        }

    };



    $scope.totalreset=function(){
        $scope.total={p:0.0,v:0.0};

    };
    $scope.delData=function(fid){
        OUT=confirm("Do you want to delete the file?");
        if(OUT){
            $scope.totalreset();
            cmtool.deleteMyData($scope.USER.UID,fid).then( function(r){
                $scope.getFileInfo();
            });
        }
    };



    $scope.totalreset();

    $scope.$watch('DATA',function(n){

        if (isUndefined(n)){

        }else{    
            if(n.length>0){
                cmtool.FIXUSERFILES(n,TASK.APPMAXDATA()).then(function(response){

                    $scope.total=response;});
            }
        }
    },true);


    //that's what i've to fill
    $scope.NETUSER=$stateParams.u;
    $scope.$watch("NETUSER",function(x){

        U=JSON.parse(x);

        U.allow=true;
        TASK.setEntireUserLog(U).then(function(x){$scope.USER=TASK.getUserLog();});

        $scope.getFileInfo();
        $scope.startP();

    },true);




    $scope.states=[{name:'Home',link:'app.home'},{name:'Set up',link:'app.settings'},{name:'Results',link:'app.results'}];
    $scope.selectedstate='Home';




    var promise2;


    // starts the interval
    $scope.startP = function() {
        // stops any running interval to avoid two intervals running at the same time
        $scope.stopP();
        //activate this later ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        promise2 = $interval( $scope.getFileInfo, 1000);

    };

    // stops the interval
    $scope.stopP = function() {

        $interval.cancel(promise2);
    };


    $scope.$on('$destroy', function() {
        $scope.stopP();
    });


    //update data  
    $scope.FILE={
        v:{o:true,s:true,title:"Data",icon:"fas fa-database"}
    };

    $scope.TABLEDATAFUNCTIONS=[
        {click:$scope.delData,icon:"far fa-trash-alt",tooltip:'delete this file',type:'function'},
        {click:undefined,icon:"far fa-trash-alt",tooltip:'download this file',type:'download'}];

    $scope.$watch("DATA",function(x){

        $scope.TABLEDATA=[];
        if(!isUndefined(x)){
            if(x.length>0){
                x.forEach(function(o){
                    var v={ID:o.ID,'File Name':o.filename,'Date submitted':o.dateIN,Size:formatBytes(o.size),link:o.externalfilename,downloadfilename:o.filename};

                    switch(o.status){
                        case 'ok':
                            v.status='';
                            break;
                        case 'ko':
                            v.status='warning';
                            break;
                        default:
                            v.status='';
                    };


                    $scope.TABLEDATA.push(v);
                });
            }
        }
        $scope.TABLEDATAVISIBLE=[false,true,true,true,false,false,false];

    },true);





}]);

DGF.controller("settings", ["$scope","TASK",
                            function($scope,TASK) {

                                 // settings
        var getUrl = window.location;
        var baseUrl = getUrl .protocol + "//" + getUrl.host.split(":")[0];
        $scope.uploadapi= baseUrl + ":" + BACKEND_PORT + "/fileupload";

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




                                $scope.USER=TASK.getUserLog();
                                 $scope.$watch('settings',function(n){console.log(n);},true);

                                   $scope.states=[{name:'Home',link:'app.home'},{name:'Set up',link:'app.settings'},{name:'Results',link:'app.results'}];
                                   $scope.selectedstate='Set up';
                                
                                

                                $scope.settings={
                                    gridsize:{
                                        //grid size of the matrix
                                        x:20,
                                        y:20,
                                        z:20
                                    },
                                    fieldstrength:1.5,
                                    Alias:"DGF Job",



                                };

                                $scope.settings.layers=[{
                                    radiusSTART:0,
                                    radiusEND:80,
                                    thickness:80,
                                    type:"custom",
                                    epsilon:60,
                                    sigma:0.45,
                                    opacity:100,
                                    color:"#ff0000",
                                    name:"first layer",
                                    ID:getUIID()
                                },{
                                    radiusSTART:80,
                                    radiusEND:100,
                                    thickness:20,
                                    type:"custom",
                                    epsilon:20,
                                    sigma:0.25,
                                    opacity:50,
                                    color:"#ffff00",
                                    name:"second layer",
                                    ID:getUIID()
                                },{
                                    radiusSTART:100,
                                    radiusEND:110,
                                    thickness:10,
                                    type:"custom",
                                    epsilon:60,
                                    sigma:0.45,
                                    opacity:20,
                                    color:"#00ff00",
                                    name:"third layer",
                                    ID:getUIID()
                                }

                                                      ];

                                $scope.settings.coils=[{
                                    number:20,
                                    radius:10,
                                    tube:1,
                                    currentRadius:120,
                                    radiusEND:122,
                                    thickness:2,
                                    epsilon:1,
                                    sigma:0,
                                    color:"#AAAAAA",
                                    name:"Coils layer",
                                    ID:getUIID(),
                                    position:{
                                        polar:[],
                                        azimuthal:[]
                                    }
                                }];

                                $scope.$watch("settings",function(x){console.log(x)},true);

                                $scope.VIEWS={OBJ:{
                                    o:true,
                                    s:true,
                                    title:"Object",
                                    //                                         icon:"fas fa-shapes"
                                    icon:"fas fa-child"
                                },SCANNER:{
                                    o:true,
                                    s:true,
                                    title:"Scanner",
                                    //                                         icon:"fas fa-shapes"
                                    icon:"fas fa-shapes"
                                },
                                              PUSH:{
                                                  o:true,
                                                  s:true,
                                                  title:"Geometry",
                                                  //                                         icon:"fas fa-shapes"
                                                  icon:"fas fa-database"
                                              }
                                             }




                                var getUrl = window.location;
                                var baseUrl = getUrl .protocol + "//" + getUrl.host.split(":")[0];
                                        
                                $scope.queuejob=function(){
                                    TASK.postIt(baseUrl + ":" + BACKEND_PORT + '/tasks',$scope.settings).then((d)=>{alert(d)});

                                };



                            }]);


DGF.controller("results", ["$scope","TASK","$stateParams","$timeout","$state","$interval","$q","cmtool",function($scope,TASK,$stateParams,$timeout,$state,$interval,$q,cmtool) {

    

//    $timeout(function(){
//        if($stateParams.ID=="0"){
//            console.log("nothing to plot");
//
//        }else{
//            TASK.LOAD(true);
//            $scope.getMyResults().then(function(r){
//                console.log(r);
//                var A=findAndGet(r,"ID",parseInt($stateParams.ID));
//
//
//                TASK.getJson(A[0].results).then(function(d){
//                    $scope.results.choosen.data=d;
//                    $scope.results.choosen.data.THEID=parseInt($stateParams.ID);
//                    $scope.THENNEWVIEWER=jsonCopy(d);
//                    TASK.LOAD(false);
//                });
//
//            });
//        }
//    },10);








    
    
     $scope.states=[{name:'Home',link:'app.home'},{name:'Set up',link:'app.settings'},{name:'Results',link:'app.results'}];
    $scope.selectedstate='Results';
    $scope.USER=TASK.getUserLog();


  

    $scope.uploadROI = function(x, a, jid) {
        var l=QPATH+'/serviceAPI.php'
        //   console.log(l);
        var deferred = $q.defer();
        cmtool.generalRFAPI({
            "roi": x,
            "jid": jid,
            "alias": a,
            "InfoType": "insertrois"
        }, l).then(function(response) {
            alert("correctly uploaded" + " " + a);
            deferred.resolve(true);
        });


        return deferred.promise;

    }  

    $scope.getServerRois = function() {
        var deferred = $q.defer();
        var l=QPATH+'/serviceAPI.php'
        //    console.log(l);

        cmtool.generalRFAPI({
            "jid": $scope.JID,
            InfoType: "getjobrois"
        }, l ).then(function(r) {

            deferred.resolve(r);

        });
        return deferred.promise;
    };
    
    

    $scope.getUserJob = function () {
        var getUrl = window.location;
        var baseUrl = getUrl .protocol + "//" + getUrl.host.split(":")[0];
        var deferred = $q.defer();
        var l = baseUrl + ":" + BACKEND_PORT + '/tasks'


        TASK.getIt(l).then(function (r) {
            console.log(r)
            deferred.resolve(r.data);
        });
        return deferred.promise;
    };
    
    
    
    $scope.deleteUserJob = function(x) {
        var deferred = $q.defer();
        var l=QPATH+'serviceAPI.php'
        //    console.log(l);

        cmtool.generalRFAPI({
            "UID": $scope.USER.UID,
            jid:x,
            InfoType: "deleteuserjob"
        }, l ).then(function(r) {

            deferred.resolve(r);

        });
        return deferred.promise;
    };
    
    
    
    $scope.sendjobfeedback = function(message,id) {
        var deferred = $q.defer();
        var l=QPATH+'serviceAPI.php'
        //    console.log(l);
        
        cmtool.generalRFAPI({
            message:message,
            jid:id,
            InfoType: "setjobfeedback"
        }, l ).then(function(r) {

            deferred.resolve(r);

        });
        return deferred.promise;
    };










    $scope.conf={
        canvassize:{h:233,
                    w:233},
        applicationname:"Dyadic Green Functions solver",
        snapshotname:"DGF shot",
        resultdownloadrootname:function(){return TASK.ora()},
        actionbuttons:[{
            icon:"fas fa-teeth-open",
            function:function(){alert('yep');},
            tootltip:'yepyep'}],
        userroiupload:function(x,id){var deferred =$q.defer();$scope.uploadROI(x,id,$scope.JID).then(function(o){deferred.resolve(o);});return deferred.promise;},
        userroiget:function(){var deferred =$q.defer();$scope.getServerRois($scope.JID).then(function(o){deferred.resolve(o);});return deferred.promise;},
        usermovingfunction:function(x,y){console.log('outside_moving');console.log($scope.USER);console.log(x);console.log(y);},
        deletejob:$scope.deleteUserJob,
        sendjobfeedback:function(message,id){var deferred =$q.defer();$scope.sendjobfeedback(message,id).then(function(o){deferred.resolve(o);});return deferred.promise;},
        user:$scope.USER,
        joblistgetter:$scope.getUserJob
    };


   



    $scope.start=function(){
        $scope.jsondata=undefined;
          $scope.JID=undefined;
    };

    
    
    $scope.start();
    
    
    



}]);




