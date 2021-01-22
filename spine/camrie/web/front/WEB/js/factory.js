CAMRIE.factory("TASK",["$state","$http", "$q","cmtool",function($state,$http,$q,cmtool) {
    var u={};

    u.logUID={
        UID: undefined,
        name: undefined,
        surname: undefined,
        email: undefined,
        status:undefined,
        admin: false,
        logged: false,
        allow:false,
        pwd:undefined
    }




    u.isAdmin = function(){
        return u.logUID.admin;
    };
    u.islogged = function(){
        return u.logUID.logged;
    };

    u.ora = function(){
        return new Date().toISOString().slice(0, 19).replace('T', ' ');
    };

    u.oggi = function(){
        var d= new Date();
        //        var c=d.getFullYear().toString();
        var c=d.getFullYear().toString() +"_"+d.getMonth().toString()+"_"+ d.getDate().toString();
        return c;
    };

    u.setUserLog = function (us,n,s,e,o,a,pw,pic) {
        u.logUID.name=n;
        u.logUID.UID=us;
        u.logUID.surname=s;
        u.logUID.email=e;
        u.logUID.status=o;
        u.logUID.pwd=pw;
        u.logUID.picture=pic;

        if (a==1)
        {
            u.logUID.admin=true;
        }
        u.logUID.logged=true;

        if (o=="ok")
        {
            u.logUID.allow=true;

        }else{
            u.logUID.allow=false;
        }

    };


  
    u.setEntireUserLog = function (x) {
        var deferred = $q.defer();

        u.logUID=x;
        deferred.resolve(true);
        return deferred.promise;

    };



    u.getUserLog = function () {

        return u.logUID;
    };

    u.invalidate = function(){
        u.logUID.UID= undefined;
        u.logUID.name= undefined;
        u.logUID.surname= undefined;
        u.logUID.email= undefined;
        u.logUID.status=undefined;
        u.logUID.logged=false;
        u.logUID.admin=false;
        u.logUID.pwd=undefined;
        u.logUID.picture=undefined;

        //        $state.go("main.login", {}, {reload: true});

        u.goto("main.login");



    };

    u.goto = function(s,opt){

        if (isUndefined(opt)){
            opt={};    
        }
        $state.go(s, opt, {reload: true});
    };
    
    
      u.APPMAXDATA=function(){
            return 10*1024*1024*1024;
      };
      
      
      

    u.postIt = (web,DATA) =>{
        var deferred = $q.defer();
        $http({
            method: 'POST',
            url: web,
            data:DATA,
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .success(function(data, status, headers, config) {
            // console.log("status" + status); //-----------status200
            // console.log(angular.isObject(JSON)); // --------true            
            // console.log(data); //-------------[object JSON]
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



    

    u.appRFAPI = function(DATA,web){
        var deferred = $q.defer();
            
        cmtool.generalRFAPI(DATA,QPATH + web).then(function(response){
           
            deferred.resolve(response);


        });

      

        return deferred.promise;

    };

    
    

    return u;

}]);




