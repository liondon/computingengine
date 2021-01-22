var TTJQ = '<script>$(document).ready(function(){ $(\'[data-toggle="tooltip"]\').tooltip(); });</script>';


var CAMRIEROOT = document.location.origin + '/apps/CAMRIE/';

//https://css-tricks.com/snippets/css/a-guide-to-flexbox/

//http://henriquat.re/modularizing-angularjs/modularizing-angular-applications/modularizing-angular-applications.html
var CAMRIEDIRECTIVE = angular.module("CAMRIEDIRECTIVE", [])

    .factory("camrieresettings", [function () {
        //    this is the factory store the information needed to make works this piece of code
        var u = {
            url: CAMRIEROOT,
            author: 'Dr. Eros Montin, PhD',
            email: 'eros.montin@nyulangone.com',
            personalemail: 'eros.montin@gmail.com'
        };
        u.redistibutable = u.url + '/CAMRIERedistributable';
        //    where i place the clobal css
        u.css = u.redistibutable + '/cmCss.css';
        //    where i place the html template
        u.tmpl = u.redistibutable + '/tmpl';
        u.queryPath = u.url + '/Q';
        u.queryServiceUrl = u.queryPath + '/serviceAPI.php';
        u.getcloudmrMainUrl = function () { return u.url };

        u.getCss = function () { return u.css };
        u.getCMurl = function () { return u.url };
        u.getQueryServerUrl = function () { return u.queryPath };
        u.getQueryServiceUrl = function () { return u.queryServiceUrl };
        return u;
    }])

    //template for sequence choose
    .directive('camrieSequence', ['$timeout', function ($timeout) {
        return {
            restrict: 'E',
            scope: {
                model: '=',
                setfunction: '='
            },
            template: '<div class="cmLcontainerLeft"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cmInputElement" ng-repeat="s in SEQUENCEOPTIONS"> <cm-number-input model=s.model label={{s.label}} step={{s.step}} enable=s.enable ng-if="s.type==\'N\'" tooltip={{s.tooltip}}></cm-number-input> <cm-checkbox model=s.model label={{s.label}} enable=s.enable ng-if="s.type==\'CB\'"></cm-checkbox> <cm-datalist-labels model=s.model label={{s.label}} enable=s.enable ng-if="s.type==\'DL\'" list=s.list fieldsshow={{s.fieldsshow}} optionsvaluesfield={{s.optionsvaluesfield}} tooltip={{s.tooltip}}> </cm-datalist-labels> <cm-datalist-values model=s.model label={{s.label}} enable=s.enable ng-if="s.type==\'DV\'" list=s.list fieldsshow={{s.fieldsshow}} optionsvaluesfield={{s.optionsvaluesfield}} tooltip={{s.tooltip}}> </cm-datalist-values> <cm-datalist-json model=s.model label={{s.label}} enable=s.enable ng-if="s.type==\'DJ\'" list=s.list fieldsshow={{s.fieldsshow}} optionsvaluesfield={{s.optionsvaluesfield}} tooltip={{s.tooltip}}> </cm-datalist-json> <cm-select-input model=s.model label={{s.label}} enable=s.enable ng-if="s.type==\'S\'" list=s.list fieldsshow={{s.fieldsshow}} optionsvaluesfield={{s.optionsvaluesfield}} tooltip={{s.tooltip}}> </cm-select-input> </div></div><button type="submit" class="cmButton" ng-click="saveit()" data-toggle="tooltip" title="submit the options of your virtual sequence">Submit</button>' + TTJQ,
            link: function (scope, element, attrs) {

                scope.saveit = function () {
                    scope.setfunction();
                    //              pass all the fields of the options and save it in settings
                    scope.SEQUENCEOPTIONS.forEach(function (o) {
                        scope.model[o.variable] = o.model;


                    })
                }

                var sequenceoptions = [{
                    type: "GRE",
                    value: "1"
                }, {
                    type: "SE",
                    value: "2"
                }, {
                    type: "GRE EPI",
                    value: "3"
                }, {
                    type: "GRE Ti",
                    value: "4"
                }

                ];

                var rfpulseshapes = [{
                    shape: "Sync",
                    value: "1"

                }, {
                    shape: "Rect",
                    value: "2"

                }, {
                    shape: "Gauss",
                    value: "3"
                },

                ];



                //
                var PEAx = [{
                    direction: "P-A",
                    value: 1

                }, {
                    direction: "L-R",
                    value: 2
                }

                ];

                var PECor = [{
                    direction: "F-H",
                    value: 3

                }, {
                    direction: "L-R",
                    value: 2
                }

                ];

                var PESag = [{
                    direction: "P-A",
                    value: 1

                }, {
                    direction: "F-H",
                    value: 3
                }

                ];



                scope.loadit = function () {
                    //              pass all the fields of the options and save it in settings
                    var TMP;
                    scope.SEQUENCEOPTIONS.forEach(function (o) {

                        TMP = undefined;

                        if (isUndefined(o.model)) {


                            if (scope.model.hasOwnProperty(o.variable)) {

                                if (isUndefined(scope.model[o.variable])) {
                                    try {
                                        o.model = o.init;
                                    } catch (e) {

                                    }
                                } else {
                                    o.model = scope.model[o.variable];
                                }
                            } else {
                                try {
                                    o.model = o.init;
                                } catch (e) {

                                }
                            }
                        }
                    })
                }

                scope.SEQUENCEOPTIONS = [

                    {
                        variable: "sequencename",
                        label: "Sequence Type",
                        type: "S", //select
                        init: "1",
                        model: undefined,
                        enable: true,
                        list: sequenceoptions,
                        fieldsshow: 'type',
                        optionsvaluesfield: 'value',
                        tooltip: 'select the sequence type among the ' + sequenceoptions.length + ' proposed'

                    },
                    {
                        variable: "rfshape",
                        label: "RF Shape",
                        type: "S",
                        init: "1",
                        model: undefined,
                        enable: true,
                        list: rfpulseshapes,
                        fieldsshow: 'shape',
                        optionsvaluesfield: 'value',
                        tooltip: 'select the Radio frequency pulse type among the ' + rfpulseshapes.length + ' proposed'

                    }, {
                        variable: "rfpd",
                        label: "RF Pulse Duration (ms)",
                        type: "N",
                        model: undefined,
                        step: 0.1,
                        init: 2.6,
                        enable: true,
                        tooltip: 'select the radio frequency pulse duration'
                    },
                    {
                        variable: "nrfp",
                        label: "# Pts in RF Pulse",
                        type: "N",
                        model: undefined,
                        step: 1,
                        init: 128,
                        enable: true,
                        tooltip: 'select the number of points in the rf pulse'
                    },
                    {
                        variable: "rffa",
                        label: "RF FA (deg)",
                        type: "N",
                        model: undefined,
                        step: 10,
                        init: 90,
                        enable: true,
                        tooltip: 'select the radio frequency flip angle'
                    },
                    {
                        variable: "TE",
                        label: "TE (ms)",
                        type: "N",
                        model: undefined,
                        step: 10,
                        init: 10,
                        enable: true,
                        tooltip: 'select the Echo time'
                    },
                    {
                        variable: "TR",
                        label: "TR (ms)",
                        type: "N",
                        model: undefined,
                        step: 10,
                        init: 500,
                        enable: true,
                        tooltip: 'select the repetition time'
                    }, {
                        variable: "dTR",
                        label: "Dummy TR (ms)",
                        type: "N",
                        model: undefined,
                        step: 10,
                        init: 0,
                        enable: false,
                        tooltip: 'select the dummy repetition time'
                    }, {
                        variable: "TI",
                        label: "TI (ms)",
                        type: "N",
                        model: undefined,
                        step: 0.1,
                        init: 10,
                        enable: true,
                        tooltip: 'select the Inversion time'
                    }, {
                        variable: "pedirection", //9
                        label: "PE direction",
                        type: "S",
                        model: undefined,
                        init: '1',
                        enable: true,
                        list: PEAx,
                        fieldsshow: 'direction',
                        optionsvaluesfield: 'value',
                        tooltip: 'select the phase encoding direction'
                    }, {
                        variable: "sliceorientation", //10
                        label: "slice orientation",
                        type: "S",
                        model: undefined,
                        init: "1",
                        enable: true,
                        list: [{
                            orientation: "Axial",
                            value: 1
                        }, {
                            orientation: "Coronal",
                            value: 2
                        }, {
                            orientation: "Sagittal",
                            value: 3
                        }

                        ],
                        fieldsshow: 'orientation',
                        optionsvaluesfield: 'value',
                        tooltip: 'select the slice order'
                    }, {
                        variable: "slicethickness",
                        label: "Slice thickness (mm)",
                        type: "N",
                        model: undefined,
                        step: 1,
                        init: 2,
                        enable: true,
                        tooltip: 'select the slice thickness'
                    }, {
                        variable: "matrixsize0",
                        label: "Matrix Size 1",
                        type: "N",
                        model: undefined,
                        step: 2,
                        init: 128,
                        enable: true,
                        tooltip: 'select the Matrix size in the first direction'
                    }, {
                        variable: "matrixsize1",
                        label: "Matrix Size 2",
                        type: "N",
                        model: undefined,
                        step: 2,
                        init: 128,
                        enable: true,
                        tooltip: 'select the Matrix size in the second direction'
                    }, {
                        variable: "fov0",
                        label: "FoV 1 (mm)",
                        type: "N",
                        model: undefined,
                        step: 2,
                        init: 300,
                        enable: true,
                        tooltip: 'select the Field of View for the first direction'
                    }, {
                        variable: "fov1",
                        label: "FoV 2 (mm)",
                        type: "N",
                        model: undefined,
                        step: 2,
                        init: 300,
                        enable: true,
                        tooltip: 'select the Field of View for the second direction'
                    }, {
                        variable: "resol0",
                        label: "Resolution 1 (mm)",
                        type: "N",
                        model: undefined,
                        step: 0.01,
                        init: 2.34375,
                        enable: true,
                        tooltip: 'select the Resolution for the first direction'
                    }, {
                        variable: "resol1",
                        label: "Resolution 2 (mm)",
                        type: "N",
                        model: undefined,
                        step: 0.01,
                        init: 2.34375,
                        enable: true,
                        tooltip: 'select the Resolution for the second direction'
                    }, {
                        variable: "rbw",
                        label: "Reciving BW (kHz)",
                        type: "N",
                        model: undefined,
                        step: 2,
                        init: 50,
                        enable: true,
                        tooltip: 'select the Reciving bandwidth'
                    }, {
                        variable: "ss",
                        label: "SS",
                        type: "CB",
                        model: undefined,
                        init: true,
                        enable: true,
                        tooltip: 'SS___'
                    }, {
                        variable: "pe",
                        label: "PE",
                        type: "CB",
                        model: undefined,
                        init: true,
                        enable: true,
                        tooltip: 'PE___'
                    }, {
                        variable: "fe",
                        label: "FE",
                        type: "CB",
                        model: undefined,
                        init: true,
                        enable: true,
                        tooltip: 'FE___'
                    }, {
                        variable: "setX",
                        label: "Offset X",
                        type: "N",
                        model: undefined,
                        init: 0,
                        enable: true,
                        tooltip: 'set X'
                    }, {
                        variable: "setY",
                        label: "Offset Y",
                        type: "N",
                        model: undefined,
                        init: 0,
                        enable: true,
                        tooltip: 'set Y'
                    }, {
                        variable: "setZ",
                        label: "Offset Z",
                        type: "N",
                        model: undefined,
                        init: 0,
                        enable: true,
                        tooltip: 'set Z'
                    }




                ];


                scope.$watch('SEQUENCEOPTIONS', function (n, o) {

                    if (n[10].model != o[10].model) {
                        switch (n[10].model) {
                            //axial
                            case ('1'):
                                scope.SEQUENCEOPTIONS[9].list = PEAx;
                                scope.SEQUENCEOPTIONS[9].model = '1';

                                break;
                            case ('2'):
                                scope.SEQUENCEOPTIONS[9].list = PECor;
                                scope.SEQUENCEOPTIONS[9].model = '2';

                                break;
                            case ('3'):
                                scope.SEQUENCEOPTIONS[9].list = PESag;
                                scope.SEQUENCEOPTIONS[9].model = '3';

                                break;
                        }
                    }
                }, true);

                $timeout(scope.loadit, 10);
            }
        }
    }])


    //template for sequence choose
    .directive('camrieCoils', ['$timeout', function ($timeout) {
        return {
            restrict: 'E',
            scope: {
                model: '=',
                setfunction: "="
            },
            template: '<div class="cmLcontainerLeft"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cmInputElement" ng-repeat="s in SEQUENCEOPTIONS"> <cm-number-input model=s.model label={{s.label}} step={{s.step}} enable=s.enable ng-if="s.type==\'N\'" tooltip={{s.tooltip}}></cm-number-input> <cm-checkbox model=s.model label={{s.label}} enable=s.enable ng-if="s.type==\'CB\'"></cm-checkbox> <cm-datalist-labels model=s.model label={{s.label}} enable=s.enable ng-if="s.type==\'DL\'" list=s.list fieldsshow={{s.fieldsshow}} optionsvaluesfield={{s.optionsvaluesfield}} tooltip={{s.tooltip}}> </cm-datalist-labels> <cm-datalist-values model=s.model label={{s.label}} enable=s.enable ng-if="s.type==\'DV\'" list=s.list fieldsshow={{s.fieldsshow}} optionsvaluesfield={{s.optionsvaluesfield}} tooltip={{s.tooltip}}> </cm-datalist-values> <cm-datalist-json model=s.model label={{s.label}} enable=s.enable ng-if="s.type==\'DJ\'" list=s.list fieldsshow={{s.fieldsshow}} optionsvaluesfield={{s.optionsvaluesfield}} tooltip={{s.tooltip}}> </cm-datalist-json> <cm-select-input model=s.model label={{s.label}} enable=s.enable ng-if="s.type==\'S\'" list=s.list fieldsshow={{s.fieldsshow}} optionsvaluesfield={{s.optionsvaluesfield}} tooltip={{s.tooltip}}> </cm-select-input> </div></div><button type="submit" class="cmButton" ng-click="saveit()" data-toggle="tooltip" title="submit the coils options to go further">Submit</button>' + TTJQ,
            link: function (scope, element, attrs) {

                scope.saveit = function () {
                    //              pass all the fields of the options and save it in settings
                    scope.SEQUENCEOPTIONS.forEach(function (o) {
                        scope.model[o.variable] = o.model;
                        scope.setfunction();
                    })
                }
                scope.loadit = function () {
                    //              pass all the fields of the options and save it in settings
                    var TMP;
                    scope.SEQUENCEOPTIONS.forEach(function (o) {

                        TMP = undefined;

                        if (isUndefined(o.model)) {


                            if (scope.model.hasOwnProperty(o.variable)) {

                                if (isUndefined(scope.model[o.variable])) {
                                    try {
                                        o.model = o.init;
                                    } catch (e) {

                                    }
                                } else {
                                    o.model = scope.model[o.variable];
                                }
                            } else {
                                try {
                                    o.model = o.init;
                                } catch (e) {

                                }
                            }
                        }
                    })
                }

                scope.SEQUENCEOPTIONS = [{
                    variable: "receivingCoilsNumber",
                    label: "# Receiving (Rx)",
                    type: "N",
                    model: undefined,
                    step: 1,
                    init: 1,
                    enable: true,
                    tootltip: 'select the number of receiving coils channels'
                },
                {
                    variable: "transmittingCoilsNumber",
                    label: "# Transmitting (Tx)",
                    type: "N",
                    model: undefined,
                    step: 1,
                    init: 1,
                    enable: true,
                    tooltip: 'select the number of transmitting coils '
                }




                ];

                $timeout(scope.loadit, 10);
            }
        }
    }])









    //direcive that takes the actually takes the file
    .directive("localFilesArray", ["$parse", function ($parse) {
        return {
            restrict: 'A',
            link: function (scope, element, attrs) {
                var model = $parse(attrs.localFilesArray);
                var modelSetter = model.assign;
                element.bind('change', function () {
                    console.log('quii')
                    scope.$apply(function () {
                        modelSetter(scope, element[0].files);
                    });
                });
            }
        };
    }])


    .directive('localUploadButton', ['$timeout','$q', function ($timeout,$q) {
        return {
            restrict: 'E',
            scope: {
                model: '=', //out json with info of the choosen files if multiple it must be an array of json must be instialized with a []
                user: '=', //the userid of the person who wants to upload the files
                multiple: '=', //if the field exist it will be consider to be used as multiple upload
                tootlip: '@', //tooltip for 
                state: '=', //interact with the button state, just put "reset" on this variable and the uplaoder is going to reset itself and the this variable is put to ready after
                endpoint: '@', //http://localhost:4000/upload
                label:'@'
            },
            template: '<div><style>.inputfile {width: 0.1px;height: 0.1px;opacity: 0;overflow: hidden;position: absolute;z-index: -1;} .inputfile + label {font-size: 1.25em;font-weight: 700;color: white;background-color: black;display: inline-block;} .inputfile:focus + label,.inputfile + label:hover {background-color: red;} .inputfile + label {cursor: pointer;}</style><input type = "file" local-files-array = "data.thefilearray" id="{{data.id}}" class="inputfile" multiple /> <label for="{{data.id}}">{{label}}</label><div>',

            link: function (scope, element, attrs) {


                const t= getUIID();
                scope.data = { thefilearray: [], id:t };
                
                // const fileInput = document.querySelector(scope.data.id);
                //fileInput = document.getElementById(scope.data.id);

                function uploadfile(file) {
                    var deferred = $q.defer();

                    const formData = new FormData();

                    formData.append('myfile', file);
                        
                    const options = {
                        method: 'POST',
                        body: formData
                        };

                   

                    fetch(scope.endpoint, options)
                    
                        .then(res=>{res.json().then(data => {
                            console.log(data);
                            scope.model.push({link:data.link})
                            deferred.resolve(true);
                        })
                    })
                    
                    return deferred.promise;
                }

                $timeout(10, () => {
                    
                    // scope.data = { thefilearray: [], id:t };

                    // angular.forEach(
                    //     angular.element("input[id='thefile']"),
                    //     function(inputElem) {
                    //       angular.element(inputElem).val(null);
                    //     });

                });

                scope.$watch('data.thefilearray', (n) => {
                    fileInput = document.getElementById(scope.data.id);
                    if(!(isUndefined(n))){
                    for (a=0;a<n.length;a++){
                        
                    uploadfile(fileInput.files[a]);
                    }
                }
                }, false);
            }
        }
    }])
