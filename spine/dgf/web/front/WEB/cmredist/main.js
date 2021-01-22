var DGFDATALIST='<div class="input-group"> <span class="input-group-addon" id="{{ID}}">{{label}}</span><input type="text" list="{{data.XX}}" ng-model="data.S" ng-change="selected(data.S)"/><datalist id="{{data.XX}}" > <option ng-repeat="v in list" value="{{v[optionsvaluesfield]}}" > {{v[whichlabels]}}</option></datalist></div>';


var DGFWEBROOT= document.location.origin;



function fibonacci_spherev2(samples,R){

      points = []
      var polar =[];
      var azimuthal=[];

      var gr=(Math.sqrt(5.0) + 1.0) / 2.0;  // golden ratio = 1.6180339887498948482
      var ga=(2.0 - gr) * (2.0*Math.PI);  // golden angle = 2.39996322972865332

      var x,y,z,lat,lon;

      for (i=0; i<samples;i++) {
            lat = Math.asin(-1.0 + 2.0 * i / (samples+1));
            lon = ga * i;

            x = R*Math.cos(lon)*Math.cos(lat);
            y = R*Math.sin(lon)*Math.cos(lat);
            z = R*Math.sin(lat);

            points.push([x,y,z]);
            polar.push(lon);
            azimuthal.push(lat);

      }
      return {points:points,angle:{polar:polar,azimuthal:azimuthal}}

};

function toPolar(x,y,z){
      var sqrd = (x*x)+(y*y)+(z*z);
      var radius = Math.sqrt(sqrd);
      var theta = Math.acos(z/radius);
      var phi = Math.atan(y/x);
      var toReturn={
            radius:radius,
            azimuthal:phi,
            polar:theta
      }
      return toReturn
};

function polarTopoint(R,polar,azimuthal){


      return {x: R*Math.sin(polar)*Math.cos(azimuthal),
              y: R*Math.sin(polar)*Math.sin(azimuthal),
              z: R*Math.cos(polar)};      
};


function fibonacci_sphere(samples,R){
      var offset = 2 / samples;
      var OUT={};
      var random = Math.random() * samples;
      var increment = Math.PI * (3 - Math.sqrt(5));
      var  points = []
      var polar =[];
      var azimuthal=[];

      var pi = Math.PI;

      for (var i = 0; i < samples; i++) {
            var y = ((i * offset) - 1) + (offset / 2);
            var distance = Math.sqrt(1 - Math.pow(y, 2));
            var phi = ((i + random) % samples) * increment;
            var x = Math.cos(phi) * distance;
            var z = Math.sin(phi) * distance;
            x = x * R;
            y = y * R;
            z = z * R;

            points.push([x,y,z]);
            OUT= toPolar(x,y,z);

            polar.push(OUT.polar);
            azimuthal.push(OUT.azimuthal);

      }
      //      %we are writing the degree in rad
      return {points:points,angle:{polar:polar,azimuthal:azimuthal}}

};       



var THREEJSCANVAS='';

var CMTHREE = angular.module("CMTHREE", [])

.factory("CMsettings",[ function(){
      //    this is the factory store the information needed to make works this piece of code
      var u={url:DGFWEBROOT,
             author:'Dr. Eros Montin, PhD',
             email:'eros.montin@nyulangone.com',
             personalemail:'eros.montin@gmail.com'
            };

      u.queryPath=u.url + '/Q';
      u.queryServiceUrl=u.queryPath +'/serviceAPI.php';

      u.getQueryServerUrl=function(){return u.queryPath};
      u.getQueryServiceUrl=function(){return u.queryServiceUrl};
      return u;
}])


.service('threejsTOOL', [function () {



      this.threejsselectOBJbyname=function(scene,ID){
            var selectedObject = scene.getObjectByName(ID);
           
            return selectedObject;
      }

      this.threejschangeopacity=function(scene,ID,opacity){


            var selectedObject = this.threejsselectOBJbyname(scene,ID);
            selectedObject.material[0].wireframe=false;
            selectedObject.material[0].visible= true;
            selectedObject.material[0].transparent = true;
            selectedObject.material[0].opacity = opacity;
            selectedObject.material[0].needsUpdate = true;



      }

      this.threejsTransparent=function(scene,ID){

            var selectedObject = this.threejsselectOBJbyname(scene,ID);
            selectedObject.material[0].visible= false;
            selectedObject.material[0].needsUpdate = true;


      }
      
      this.threejsChangecolor=function(scene,ID,color){
            console.log(color);
            var thecolor=color.replace("#", "0x");
            var selectedObject = this.threejsselectOBJbyname(scene,ID);
            selectedObject.material[0].visible= true;
            
            selectedObject.material[0].color.setHex(thecolor);
            selectedObject.material[0].needsUpdate = true;


      }



      this.removeOBJ=function(scene,ID){
            var selectedObject = this.threejsselectOBJbyname(scene,ID);
            scene.remove( selectedObject );
      }




      this.transparencewireframe=function(scene,ID){
       
            var selectedObject = this.threejsselectOBJbyname(scene,ID);
            selectedObject.material[0].wireframe= !selectedObject.material[0].wireframe;
      }









}])






.directive('dgfRangeInput', [function() {
      return {
            restrict: 'E',
            scope: {
                  model:'=',
                  label:'@',
                  enable:'=',
                  min:'@',
                  max:'@'
            },
            //                        templateUrl: 'mrotmpl/directivetmpl/mroptimumTaskbar.html',
            template: '<div class="input-group"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <input ng-model="model" type="range" min="{{min.toFixed(2)}}" max="{{max.toFixed(2)}}" class="slider form-control" ng-disabled="myDisable"></div>',
            link: function(scope, element, attrs) {
                  //                  default is enable so desable the disblaer

                  scope.myDisable=false;

                  scope.$watch('enable',function(n){
                        if (typeof n === "boolean"){
                              scope.myDisable=!n;
                        }
                  },true);
            }
      }
}])


.directive('dgfCheckInput', [function() {
      return {
            restrict: 'E',
            scope: {
                  model:'=',
                  label:'@',
                  enable:'=',
                  list:'=' //arrays of possible selection
            },
            //                        templateUrl: 'mrotmpl/directivetmpl/mroptimumTaskbar.html',
            template: '<div class="input-group"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <label ng-repeat="obj in list"> <input name="selectedObj[]" type="checkbox" class="form-control" ng-disabled="myDisable" value={{obj.name}} ng-model="obj.selected">{{obj.name}}</label></div>',
            link: function(scope, element, attrs) {
                  //                  default is enable so desable the disblaer

                  scope.myDisable=false;

                  scope.$watch('enable',function(n){
                        if (typeof n === "boolean"){
                              scope.myDisable=!n;
                        }
                  },true);



                  scope.selectedObj = function() {
                        console.log(filterFilter(scope.list, { selected: true }));
                        return filterFilter(scope.list, { selected: true });
                  };

                  // Watch fruits for changes
                  scope.$watch('list|filter:{selected:true}', function (nv) {
                        scope.model = nv.map(function (obj) {
                              return obj.name;
                        });
                  }, true);                  



            }
      }
}])



//.directive('dgfRadioInput', [function() {
//      return {
//            restrict: 'E',
//            scope: {
//                  model:'=',
//                  label:'@',
//                  enable:'=',
//                  list:'=' //arrays of possible selection
//            },
//            //                        templateUrl: 'mrotmpl/directivetmpl/mroptimumTaskbar.html',
//            template: '<div class="input-group"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <label ng-repeat="obj in list"> <input             name={{ID}} value="selectedObj[]" type="radiobox" class="form-control" ng-disabled="myDisable" value={{obj.name}} ng-model="obj.selected">{{obj.name}}</label></div>',
//            link: function(scope, element, attrs) {
//                  //                  default is enable so desable the disblaer
//
//                  scope.myDisable=false;
//
//                  scope.$watch('enable',function(n){
//                        if (typeof n === "boolean"){
//                              scope.myDisable=!n;
//                        }
//                  },true);
//                  
//                  
//                  
//                  scope.selectedObj = function() {
//                        console.log(filterFilter(scope.list, { selected: true }));
//    return filterFilter(scope.list, { selected: true });
//  };
//
//  // Watch fruits for changes
//  scope.$watch('list|filter:{selected:true}', function (nv) {
//    scope.model = nv.map(function (obj) {
//      return obj.name;
//    });
//  }, true);                  


//                  
//            }
//      }
//}])






.directive('dgfColorInput', [function() {
      return {
            restrict: 'E',
            scope: {
                  model:'=',
                  label:'@',
                  enable:'='
            },
            //                        templateUrl: 'mrotmpl/directivetmpl/mroptimumTaskbar.html',
            template: '<div class="input-group"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <input ng-model="model" type="color" class="form-control" ng-disabled="myDisable"></div>',
            link: function(scope, element, attrs) {
                  //                  default is enable so desable the disblaer

                  scope.myDisable=false;

                  scope.$watch('enable',function(n){
                        if (typeof n === "boolean"){
                              scope.myDisable=!n;
                        }
                  },true);
            }
      }
}])


.directive('dgfTextInput', [function() {
      return {
            restrict: 'E',
            scope: {
                  model:'=',
                  label:'@',
                  enable:'='
            },
            //                        templateUrl: 'mrotmpl/directivetmpl/mroptimumTaskbar.html',
            template:'<div class="input-group"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <input ng-model="model" type="text" class="form-control" ng-disabled="myDisable"></div>',

            link: function(scope, element, attrs) {
                  //                  default is enable so desable the disblaer

                  scope.myDisable=false;

                  scope.$watch('enable',function(n){
                        if (typeof n === "boolean"){
                              scope.myDisable=!n;
                        }
                  },true);
            }
      }
}])



.directive('dgfNumberInput', [function() {
      return {
            restrict: 'E',
            scope: {
                  model:'=',
                  label:'@',
                  step:'@',
                  enable:'='
            },
            //                        templateUrl: 'mrotmpl/directivetmpl/mroptimumTaskbar.html',
            template: '<div class="input-group"> <span class="input-group-addon" id="{{ID}}">{{label}}</span> <input ng-model="model" type="number" class="form-control" step="{{step}}" ng-disabled="myDisable"></div>',
            link: function(scope, element, attrs) {
                  //                  default is enable so desable the disblaer
                  scope.myDisable=false;

                  scope.$watch('enable',function(n){
                        if (typeof n === "boolean"){
                              scope.myDisable=!n;
                        }
                  },true);


            }
      }
}])



.directive('dgfDatalistLabels', [function() {
      return {
            restrict: 'E',
            scope: {
                  list:'=',
                  label:'@',
                  fieldsshow:'@',
                  optionsvaluesfield:'@',
                  model:'='

            },
            //                        templateUrl: 'mrotmpl/directivetmpl/mroptimumTaskbar.html',
            template: DGFDATALIST,
            link: function(scope, element, attrs) {



                  var c=getUIID();
                  scope.data={XX:c,S:undefined};

                  scope.selected= function(x){

                        if(!(isUndefined(x)))
                        {
                              var A=findAndGet(scope.list,scope.optionsvaluesfield,x);
                              console.log(A);
                              if (A.length>0){
                                    scope.model=A[0][scope.fieldsshow];
                              }
                        }
                  };

            }
      }
}
                                ])



.directive('dgfDatalistValues', [function() {
      return {
            restrict: 'E',
            scope: {
                  list:'=',
                  label:'@',
                  fieldsshow:'@',
                  optionsvaluesfield:'@',
                  model:'='

            },
            //                        templateUrl: 'mrotmpl/directivetmpl/mroptimumTaskbar.html',
            template: DGFDATALIST,
            link: function(scope, element, attrs) {



                  var c=getUIID();
                  scope.data={XX:c,S:undefined};

                  scope.selected= function(x){

                        if(!(isUndefined(x)))
                        {
                              var A=findAndGet(scope.list,scope.optionsvaluesfield,x);
                              console.log(A);
                              if (A.length>0){
                                    scope.model=A[0][scope.optionsvaluesfield];
                              }
                        }
                  };

            }
      }
}
                                ])


.directive('dgfDatalistJson', [function() {
      return {
            restrict: 'E',
            scope: {
                  list:'=',
                  label:'@',
                  fieldsshow:'@',
                  optionsvaluesfield:'@',
                  model:'='

            },
            //                        templateUrl: 'mrotmpl/directivetmpl/mroptimumTaskbar.html',
            template: DGFDATALIST,
            link: function(scope, element, attrs) {



                  var c=getUIID();
                  scope.data={XX:c,S:undefined};

                  scope.selected= function(x){

                        if(!(isUndefined(x)))
                        {
                              var A=findAndGet(scope.list,scope.optionsvaluesfield,x);

                              if (A.length>0){
                                    scope.model=A[0];

                              }else{
                                    scope.model={};
                              }
                        }
                  };

            }
      }
}
                              ])



.directive('sphereLayer', ["threejsTOOL",function(threejsTOOL) {
      return {
            restrict: 'E',
            scope: {
                  layers:'='


            },
            templateUrl: DGFWEBROOT + '/cmredist/sphereLayer.html',
            //template: ' <div> {{layers[0].name}} from <</div>',
            link: function(scope, element, attrs) {


                  //                  var viewerDFL=[hidd{name:'hidden',selected:false},{name:'solid',selected:true},{name:'wireframe',selected:true}];











            }

      }
}])


.directive('coilLayer', ['$http',function($http) {
      return {
            restrict: 'E',
            scope: {
                  layers:'=',
                  scene:'='

            },
            templateUrl: DGFWEBROOT + '/cmredist/coilLayer.html',
            //template: ' <div> {{layers[0].name}} from <</div>',
            link: function(scope, element, attrs) {

                  var TORUS={radius:10,
                             tube:1.5,
                             name:"LacunaCoils",
                             color:"#ffffff"
                            };


                  scope.selectedCoilSetup={};
                  scope.layers[0].info='here you will be prompted information about the simulation. After you selected the design you can edit this space and use it as memo for the results area';


                  $http.get('cmredist/coilsSetup.json')
                        .then(function(res){
                        console.log(res);
                        scope.coilsetup = res.data;
                        //                         scope.coilsetup.push fibonacci
                  });










                  scope.$watch("selectedCoilSetup",function(n,o){


                        if(!(isUndefined(n))){




                              try{
                                    for( var i = scope.scene.children.length - 1; i >= 0; i--) {if(scope.scene.children[i].name=="POINTS"){
                                          scope.scene.remove( scope.scene.children[i] );
                                    } };
                              }catch(e){

                              }
                              var O = new THREE.Vector3( );
                              var radius=scope.layers[0].currentRadius;
                              var coilradius=radius*n.coil_radius_multiplier;

                              scope.layers[0].radius=coilradius;
                              scope.layers[0].number= n.polar.length;
                              var coilnumber=scope.layers[0].number;
                              var tube=scope.layers[0].tube;

                              var ACTUALRADIUS=Math.sqrt(radius*radius-(coilradius)*(coilradius));
                              scope.layers[0].info="the simulation will be performed using " + scope.layers[0].number + " coils with a radius of " + scope.layers[0].radius.toFixed(2) + " mm. the actual radius of the current sphere is (coil offset)" + ACTUALRADIUS.toFixed(2);


                              n.polar.forEach(function(polar,i){
                                    var geometry =new THREE.TorusGeometry(coilradius, 1.5, 20, 20 )
                                    var meshMaterial = new THREE.MeshBasicMaterial( { color:TORUS.color} );
                                    var mesh = new THREE.Mesh(geometry, [meshMaterial]);

                                    var p=polarTopoint(ACTUALRADIUS,polar,n.azimuthal[i]);
                                    mesh.position.x = p.x;
                                    mesh.position.y = p.y;
                                    mesh.position.z = p.z;
                                    mesh.name="POINTS";                //the name of the mesh is the id:) confusing but smart
                                    scope.scene.add(mesh);
                                    mesh.lookAt(O);
                                    scope.layers[0].position.polar.push(polar);
                                    scope.layers[0].position.azimuthal.push(n.azimuthal[i]);
                              });


                        }else{
                              for( var i = scope.scene.children.length - 1; i >= 0; i--) {if(scope.scene.children[i].name=="POINTS"){
                                    scope.scene.remove( scope.scene.children[i] );
                              } };

                        }
                  },true);

            }

      }
}])

.directive('threejsCanvas', ["CMsettings","$timeout","threejsTOOL",function(settings,$timeout,threejsTOOL){
      return {
            restrict: 'E',
            scope: {
                  layers:'=',
                  coils:'='
            },
            // template: THREEJSCANVAS,
            templateUrl: DGFWEBROOT + '/cmredist/threjsstuff.html',
            link: function(scope, element, attrs) {

                  scope.pre=function(){
                        console.log("start 3d canvas");
                        //                        var head = document.getElementsByTagName('head')[0];
                        //
                        //
                        //                        var SCRIPTS=[ {src:'https://threejs.org/build/three.js'},
                        //                                     {src:"https://cdn.rawgit.com/mrdoob/three.js/master/examples/js/controls/OrbitControls.js"},
                        //                                     {src:"https://cdn.rawgit.com/mrdoob/three.js/master/examples/js/exporters/GLTFExporter.js"}
                        //                                     //{src:"http://cloudmrhub.com/CLOUDMRRedistributable/main.js"},
                        //                                    ];
                        //
                        //                        SCRIPTS.forEach(function(s){
                        //                              var script0 = document.createElement('script');
                        //                              script0.type = 'text/javascript';
                        //                              script0.setAttribute( 'src', s.src );
                        //                              document.head.appendChild(script0);
                        //                              console.log(s);
                        //
                        //                        });

                  };




                  scope.init=function(){




                        //                        var scripts = document.getElementsByTagName('script');
                        //
                        //                        console.log(scripts);


                        var CANVAS=document.getElementById('DRAWER');
                        //            var canvasWidth=CANVAS.width;
                        var canvasWidth=750;
                        //            var canvasHeight=CANVAS.height;
                        var canvasHeight=750;


                        scope.scene = new THREE.Scene();
                        //var camera = new THREE.PerspectiveCamera(50, 500 / 400, 0.1, 1000);
                        scope. camera = new THREE.PerspectiveCamera( 75, canvasWidth / canvasHeight, 0.1, 1000 );

                        scope.renderer = new THREE.WebGLRenderer( { canvas: DRAWER } );
                        scope.renderer.setSize(canvasWidth,canvasHeight);

                        scope.renderer.setSize( canvasWidth,canvasHeight );

                        scope.camera.position.x = 200;
                        scope.camera.position.y = 200;
                        scope.camera.position.z = 200;

                        var controls = new THREE.OrbitControls(scope.camera, scope.renderer.domElement);


                        scope.animate();

                        scope.reset();
                  };



                  scope.animate=function() {


                        requestAnimationFrame( scope.animate );
                        scope.renderer.render( scope.scene, scope.camera );
                  }


                  scope.reset=function(){


                        scope.layers.forEach(function(o,i){
                              console.log(o);
                              o.viewlist='solid'
                              scope.addSphere(o.radiusEND,o.color,o.ID);

                              threejsTOOL.threejschangeopacity(scope.scene,o.ID,o.opacity/100);

                        });

                        scope.coils.forEach(function(o,i){
                              console.log(o);
                              scope.addCurrentRadius(o.currentRadius,o.color,o.ID);
                        });

                        scope.coil={number:10,type:"toroid",radius:10,tube:1};



                        // setting the unpossible editing stuff
                        scope.layers.forEach(function(o,i){

                              o.enabler={epsilon:true,color:true,radius:{start:false,end:true,thickness:true}};

                              if (i==0){
                                    o.enabler.radius.start=false;
                              }

                        });



                  };







                  scope.$watch('coils',function(n,old){

                        if (isUndefined(old))
                        {
                              n.forEach(function(o,i){
                                    scope.addCurrentRadius(o.currentRadius,o.color,o.ID);
                              });


                        }else{

                              n.forEach(function(o,i){

                                    if(o.currentRadius<o.radiusEND){
                                          //                                                                    if we changed the external radius 
                                          if (o.radiusEND != old[i].radiusEND){


                                                try{
                                                      //                                                                                we have to update the one inside
                                                      //n[i-1].radiusEND=o.radiusSTART;
                                                }catch(e){
                                                      //                                                                                if there's no other layer than i'm art the sphere level
                                                      //scope.layers[2].radiusEND=o.radiusSTART;
                                                }
                                          }


                                          //if we changed the outer radius 
                                          if ((o.currentRadius != old[i].currentRadius)|| (o.color != old[i].color)){
                                                //I've to re render but before i've to delete the old render 
                                                threejsTOOL.removeOBJ(scope.scene,o.ID);

                                                scope.addCurrentRadius(o.currentRadius,o.color,o.ID);



                                          }
                                    }else{
                                          var tmp=o.currentRadius;
                                          o.radiusEND=o.currentRadius+o.thickness;

                                          o.currentRadius=old[i].currentRadius;
                                          o.currentRadius=tmp;

                                    }


                              });

                        }
                  },true);





                  scope.$watch('layers',function(n,old){



                        n.forEach(function(o,i){

                               if (o.opacity!=old[i].opacity){
                                     
                                     threejsTOOL.threejschangeopacity(scope.scene,o.ID,o.opacity/100);

                                    };  
                              
                              if (o.color!=old[i].color){
                                     
                                     threejsTOOL.threejsChangecolor(scope.scene,o.ID,o.color);

                                    };
                        
                              
                              
                              
                              if (o.viewlist!=old[i].viewlist){

                                    switch(o.viewlist){
                                          case 'solid':
                                                threejsTOOL.threejschangeopacity(scope.scene,o.ID,o.opacity/100);
                                                break;
                                          case 'hidden':
                                                threejsTOOL.threejsTransparent(scope.scene,o.ID);
                                                break;
                                          case 'wireframe':
                                                threejsTOOL.transparencewireframe(scope.scene,o.ID);
                                                break;

                                    };
                              };

                                    if (o.thickness != old[i].thickness){
                                          if(o.thickness>=0){
                                                try{
                                                      o.radiusEND=o.radiusSTART+o.thickness;

                                                }catch(e){

                                                }
                                          }else{
                                                o.thickness=0;
                                          }
                                    }




                                    if (o.radiusSTART != old[i].radiusSTART){

                                          try{
                                                o.radiusEND=o.radiusSTART+o.thickness;
                                          }
                                          catch(e){

                                          }
                                          try{
                                                n[i-1].radiusEND=o.radiusSTART;
                                          }catch(e){

                                          }
                                    }



                                    if (o.radiusEND != old[i].radiusEND){
                                          
                                          threejsTOOL.removeOBJ(scope.scene,o.ID);

                                          o.thickness =o.radiusEND-o.radiusSTART;

                                          scope.addSphere(o.radiusEND,o.color,o.ID);
                                          threejsTOOL.threejschangeopacity(scope.scene,o.ID,o.opacity/100);
                                          
                                          try{
                                                n[i+1].radiusSTART=o.radiusEND;
                                          }catch(e){
                                                //                                                 it means that's the last layer i've to check if the current layer is ok                                         
                                                if (scope.coils[0].currentRadius<o.radiusEND){  scope.coils[0].currentRadius=o.radiusEND+0.3;
                                                                                             }
                                          }
                                    }



                              });

                        },true);













                        scope.addSphere=function(radius,color,id){

                              var geometry =new THREE.SphereGeometry(radius, 20, 20);
                              var meshMaterial = new THREE.MeshBasicMaterial( { color: color } );
                              var mesh = new THREE.Mesh(geometry, [meshMaterial]);
                              mesh.name=id;                //the name of the mesh is the id:) confusing but smart
                              scope.scene.add(mesh);

                        };     





                        scope.addCurrentRadius=function(radius,color,id){

                              var geometry =new THREE.SphereGeometry(radius, 20, 20);
                              var meshMaterial = new THREE.MeshBasicMaterial( { color: color,wireframe:true } );
                              var mesh = new THREE.Mesh(geometry, [meshMaterial]);
                              mesh.name=id;                //the name of the mesh is the id:) confusing but smart
                              scope.scene.add(mesh);

                        };
















                        $timeout(scope.pre,0);
                        $timeout(scope.init,50);

                  }
                               }

                               }])