//upload files DI+2,PMR 2+2+1,ACM 2+2+1
// '<div class="cmRflexitem"> <cm-checkbox model="f.coils.SourceCoilSensitivityMapSmooth" label="Smooth Coil Sensitivities Source"></cm-checkbox> </div>'
var TMPPLCoilSens = '<div class="cmRcontainerLeft">   <div class="cmRflexitem"> <div class="cmLcontainerWrap"> <div class="cmLflexitem" style="margin-right: 1em;"> <cm-radiobox-input model="data.LC" label="Load Coil Sensitivities" value="L" enable=false></cm-radiobox-input> </div> <div class="cmLflexitem" style="margin-right=1em;"> <cm-radiobox model="data.LC" label="Calculate Coil Sensitivities" value="C"></cm-radiobox> </div> </div> </div> <div class="cmRflexitme" ng-show="data.LC==\'C\'" style="margin-bottom:0.5em;"> <select class="form-control " style="align-self: center; width:377px;" ng-model="data.o.Method"> <option ng-repeat="ss in sensitivitymethods" value="{{ss.value}}">{{ss.label}}</option></select> </div> <div class="cmRflexitem" ng-show="data.LC==\'L\'"><cm-upload-select-file label="{{data.CS.label}}" user="user" model="data.CS.model" multiple=false tooltip="select the image" list="data.CS.list" statereset="data.CS.statereset"></cm-upload-select-file> </div> <div class="cmRflexitem" ng-show="(f.coils.Method==\'BodyCoil\') && data.LC==\'C\'"> <cm-upload-select-file label="{{data.BC.label}}" user="user" model="data.BC.model" multiple=false tooltip="select the the first image" list="data.BC.list" statereset="data.BC.statereset"></cm-upload-select-file></div><div class="cmRflexitem"> <cm-checkbox model="f.coils.SaveCoilSensivitities" label="Save Coil Sensitivities"></cm-checkbox> </div></div>';




var FASTUFF = '<div class="cmRflexitem"> <mroptimum-fa-selection f="data.x.p.FA"></mroptimum-fa-selection></div>';

var TMPACMTABLEMETHODS = '<li class="list-group-item" ng-show="data.XL.length>0"> <div class="row"> <table class="table table-striped table-hover cmTable"> <tr scope="row"> <th scope="col">Job Alias</th> <th scope="col">Job Options</th> <th scope="col">Delete</th> </tr> <tr scope="row" ng-repeat="x in data.XL"> <td> <input type="text" ng-model="x.alias"> </td> <td> <div ng-repeat="(key, value) in x.params"> <cm-settings-dictionary option=\'{{key}}\' value=\'{{value}}\'></cm-settings-dictionary> </div> </td> <td><a ng-click="changeACMMethods(x.N)"><i class="far fa-trash-alt" ></i></a> </td> </tr> </table> </div> <div class="row"> <div class="pull-right"> <button type="submit" class="cmButton " ng-click="collapse()">Done</button> </div> </div></li><li class="list-group-item" ng-show="data.XL.length==0"> <div class="row"> <table class="table table-striped table-hover cmTable"> <tr scope="row"> <th scope="col">Job Alias</th> <th scope="col">Job Options</th> <th scope="col">Delete</th> </tr> <tr scope="row"> <td>--</td> <td>--</td> <td><i class="far fa-trash-alt"></i></td> </tr> </table> </div> <div class="row"> <div class="pull-right"> <button type="submit" class="cmButton " ng-click="collapse()" disabled>Done</button> </div> </div></li>';

var HEADINGAndFA = '<uib-accordion > <div uib-accordion-group class="panel-default" is-open="v.o" ng-show="v.s"> <cm-uib-accordion-heading h="v"></cm-uib-accordion-heading> <ul class="list-group">  <li class="list-group-item"> <div class="cmRcontainerleft" >' + FASTUFF + '</li>';

var TMPLRSS = HEADINGAndFA + ' <div class="row"> <button type="submit" class="cmButton " ng-click="changeACMMethods(true)" style="margin-left: 20px;margin-right: 20px; margin-top: 20px; margin-bottom: 20px">Request Job</button> </div>' + TMPACMTABLEMETHODS + '</ul> </div></uib-accordion>';

//myACMB1.html

var HEADINGFAAndCS = HEADINGAndFA + '<li class="list-group-item"> <mroptimum-coilsensitivities-selection f="data.x.p.CS" accelerated="false"></mroptimum-coilsensitivities-selection> </li>';

var SENSEHEADINGFAAndCS = HEADINGAndFA + '<li class="list-group-item"> <mroptimum-coilsensitivities-selection f="data.x.p.CS" accelerated="true"></mroptimum-coilsensitivities-selection> </li>';

var TMPLB1 = HEADINGFAAndCS + ' <div class="row"> <button type="submit" class="cmButton " ng-click="changeACMMethods(true)" style="margin-left: 20px;margin-right: 20px; margin-top: 20px; margin-bottom: 20px">Request Job</button> </div>' + TMPACMTABLEMETHODS + '</ul> </div></uib-accordion>';

var HEADINGFACSandDECIMATE = SENSEHEADINGFAAndCS + '<li class="list-group-item"> <div class="cmRcontainerLeft" style="width: 377px;"> <div class="cmRflexitem"> <cm-checkbox model="data.x.p.Decimate" label="Decimate Data"></cm-checkbox> </div> <div class="cmRflexitem" ng-show="data.x.p.Decimate"> <cm-number-input model="data.x.p.AccelerationF" label="Acceleration Factor 1" > </cm-number-input> </div> <div class="cmRflexitem" ng-show="data.x.p.Decimate"> <cm-number-input model="data.x.p.AccelerationP" label="Acceleration Factor 2" > </cm-number-input> </div> <div class="cmRflexitem" ng-show="data.x.p.Decimate"> <cm-number-input model="data.x.p.Autocalibration" label="Autocalibration Lines" ng-if="data.x.p.Autocalibration>0"> </cm-number-input> </div> </div></li>';

var TMPLmSENSE = HEADINGFACSandDECIMATE + '<div class="row"> <button type="submit" class="cmButton " ng-click="changeACMMethods(true)" style="margin-left: 20px;margin-right: 20px; margin-top: 20px; margin-bottom: 20px">Request Job</button> </div>' + TMPACMTABLEMETHODS + '</ul> </div></uib-accordion>'


//myACM.html
var TMPLACM = '<uib-accordion > <div uib-accordion-group class="panel-default" is-open="v.o" ng-show="v.s"> <cm-uib-accordion-heading h="v"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item"> <div class="cmRcontainerLeft"> <div class="cmRflexitem"> <div class="cmLcontainerLeft"> <div> <span class="cmUploadLabel">Selected Image Reconstruction Method</span> </div> <div style="margin-right:2em;" class="cmLflexitem"> <cm-checkbox model="data.subview.RSS.selected" label="Root Sum of Squares"></cm-checkbox> </div> <div style="margin-right:2em;" class="cmLflexitem"> <cm-checkbox model="data.subview.B1.selected" label="B1-Weighted"></cm-checkbox> </div> <div style="margin-right:2em;" class="cmLflexitem"> <cm-checkbox model="data.subview.SENSE.selected" label="SENSE"></cm-checkbox> </div>  </div> </div></li><li class="list-group-item" ng-show="data.subview.RSS.v.s || data.subview.B1.v.s || data.subview.SENSE.v.s"> <cm-rss-recon v="data.subview.RSS.v" w="data.subview.RSS.w" list="data.LIST" f="data.f"></cm-rss-recon> <cm-bone-recon v="data.subview.B1.v" w="data.subview.B1.w" list="data.LIST" f="data.f"></cm-bone-recon> <cm-sense-recon v="data.subview.SENSE.v" w="data.subview.SENSE.w" list="data.LIST" f="data.f"></cm-sense-recon> <my-acm-load-data v="data.subview.LD.v" w="data.subview.LD.w" list="data.LIST" f="data.f"></my-acm-load-data> </li> </ul> </div></uib-accordion>';

// //myACMLD.html
// var oldTMPLACMLD = '<uib-accordion > <div uib-accordion-group class="panel-default" is-open="v.o" ng-show="v.s"> <cm-uib-accordion-heading h="v"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item" ng-hide="{{data.NR===undefined}}"> Number of Replicas<input type="number" ng-model="data.NR"> </li> <li class="list-group-item"> <div class="row top-buffer"> <form class="form-inline"> <cm-radiobox model="data.NOISE" label="Load Noise File" value="LN"></cm-radiobox> <!--<cm-radiobox model="data.NOISE" label="Read from Siemens Single RAID File" value="SN"></cm-radiobox>--><cm-radiobox model="data.NOISE" label="Read Noise Reference from Siemens Multiple RAID File" value="MN"></cm-radiobox> </form> </div> <div class="row top-buffer" ng-show="data.NOISE==\'LN\'"> <mroptimum-upload-select f="data.f.fn"></mroptimum-upload-select> </div> </li> <li class="list-group-item"> <div class="row top-buffer" > <mroptimum-upload-select f="data.f.fs"></mroptimum-upload-select> </div> </li> <li class="list-group-item" ng-show="(list.length>0)"> <table class="table table-striped"> <tr scope="row"> <th scope="col">Type</th> <th scope="col">Alias</th> <th scope="col">Job Options</th> <th scope="col">Delete</th> </tr> <tr scope="row" ng-repeat="x in list"><td>{{x.name}}</td><td>{{x.alias}}</td> <td><div ng-repeat="(key, value) in x.params">  <cm-settings-dictionary option=\'{{key}}\' value=\'{{value}}\'></cm-settings-dictionary></div></td> <td><a ng-click="removeTask(x.N)"><i class="far fa-trash-alt" ></i></a> </td></tr> </table> </li> <li class="list-group-item"> <div class="row tp-buffer"> <div class="col-md-12"> <button ng-click="insertjob()" class="btn btn-success" ng-disabled="data.disabledState">{{JJ}} <span class="badge badge-light">{{list.length}}</span></button> </div> </div> </li> </ul> </div></uib-accordion> ';

var TMPLACMLD = '<uib-accordion> <div uib-accordion-group class="panel-default" is-open="v.o" ng-show="v.s"> <cm-uib-accordion-heading h="v"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item" ng-hide="{{data.NR===undefined}}"> Number of Pseudo Replicas <input type="number" ng-model="data.NR"> </li> <li class="list-group-item"> <div class="row top-buffer"> <form class="form-inline"> <cm-radiobox model="data.NOISE" label="Load Noise File" value="LN"></cm-radiobox>  <cm-radiobox model="data.NOISE" label="Read Noise Reference from Siemens Multiple RAID File" value="MN"></cm-radiobox> </form> </div> <div class="row top-buffer" ng-show="data.NOISE==\'LN\'"> <cm-upload-select-file label="{{data.f.fn.label}}" user="user" model="data.f.fn.model" multiple=false tooltip="select the the noise Data" list="data.list" statereset="data.f.fn.stateret"></cm-upload-select-file> </div> </li> <li class="list-group-item"> <div class="row top-buffer"> <cm-upload-select-file label="{{data.f.fs.label}}" user="user" model="data.f.fs.model" multiple=false tooltip="select the the noise Data" list="data.list" statereset="data.f.fs.stateret"></cm-upload-select-file> </div> </li> <li class="list-group-item" ng-show="(list.length>0)"> <table class="table table-striped"> <tr scope="row"> <th scope="col">Type</th> <th scope="col">Alias</th> <th scope="col">Job Options</th> <th scope="col">Delete</th> </tr> <tr scope="row" ng-repeat="x in list"> <td>{{x.name}}</td> <td>{{x.alias}}</td> <td> <div ng-repeat="(key, value) in x.params"> <cm-settings-dictionary option=\'{{key}}\' value=\'{{value}}\'></cm-settings-dictionary> </div> </td> <td><a ng-click="removeTask(x.N)"><i class="far fa-trash-alt" ></i></a> </td> </tr> </table> </li> <li class="list-group-item"> <div class="row tp-buffer"> <div class="col-md-12"> <button ng-click="insertjob()" class="btn btn-success" ng-disabled="data.disabledState">{{JJ}} <span class="badge badge-light">{{list.length}}</span></button> </div> </div> </li> </ul> </div></uib-accordion>';

var UPLOADBUTTON = '<style>.custom-file-input::before {}.custom-file-input:hover::before { border-color: black;}.custom-file-input:active::before {}.custom-file-upload { margin-bottom: 0px;} .custom-file-upload:hover, .custom-file-upload:focus, .custom-file-upload:active, .custom-file-upload.active, .open .dropdown-toggle.custom-file-upload { } .custom-file-upload:active, .custom-file-upload.active, .open .dropdown-toggle.custom-file-upload { background-image: none; } .custom-file-upload.disabled, .custom-file-upload[disabled], fieldset[disabled] .custom-file-upload, .custom-file-upload.disabled:hover, .custom-file-upload[disabled]:hover, fieldset[disabled] .custom-file-upload:hover, .custom-file-upload.disabled:focus, .custom-file-upload[disabled]:focus, fieldset[disabled] .custom-file-upload:focus, .custom-file-upload.disabled:active, .custom-file-upload[disabled]:active, fieldset[disabled] .custom-file-upload:active, .custom-file-upload.disabled.active, .custom-file-upload[disabled].active, fieldset[disabled] .custom-file-upload.active { } .custom-file-upload .badge { }</style><div style="display: inline-block"> <label href="javascript.void(0)" for="{{data.XX}}" class="custom-file-upload" > <i class="fas fa-folder-open fa-2x cmiconcolor" style="vertical-align:middle"></i> </label> <div class="input-group" ng-show="f.state==\'upload\'"> <input class="labelBox" type="text" ng-model="f.alias" > </div> <div class="input-group"> <button class="cmButton " ng-click="uploadFile()" ng-show="f.state==\'upload\'"> Upload</button> </div> <input id="{{data.XX}}" type="file" cm-file-model = "f.myFile" style="display: none"/ ></div>'
//var TMPLUPLOADORSELECT='<form class="form-inline" style="margin: 0px;"> <span class="cmlabel">{{f.label}}</span> <upload-mroptimum-file f="f" > </upload-mroptimum-file> <span style="margin-right: 0.5em;">OR</span> <select-mroptimum-file f="f" style="margin-right: 1em;"> </select-mroptimum-file>  <div class="input-group" ng-hide="(f.state==\'upload\')||(f.state==\'select\')"> <span class="cmlabel" >{{f.alias}}</span> </div>  </form>';

var TMPLUPLOADORSELECT = '<div class="cmLcontainerwrap" style="align-items:center" > <div class="cmLflexitem" style="margin-right: 0.5em;"> <span class="cmlabel" >{{f.label}}</span> </div> <div class="cmLflexitem" style="margin-right: 0.5em;"> <upload-mroptimum-file f="f"> </upload-mroptimum-file> </div> <div class="cmLflexitem" style="margin-right: 0.5em;"> <span>OR</span> </div> <div class="cmLflexitem" style="margin-right: 0.5em;"> <select-mroptimum-file f="f" style="margin-right: 1em;"> </select-mroptimum-file> </div> <div class="cmLflexitem" style="margin-right: 0.5em;"> <div class="input-group" ng-hide="(f.state==\'upload\')||(f.state==\'select\')"> <span class="cmlabel">{{f.alias}}</span> </div> </div></div>';


var RECONMETHODSSELECTIONS = '<li class="list-group-item"> <div class="cmRcontainerLeft"> <div class="cmRflexitem"> <div class="cmLcontainerLeft"> <div> <span class="cmUploadLabel">Selected Image Reconstruction Method</span> </div> <div style="margin-right:2em;" class="cmLflexitem"> <cm-checkbox model="data.subview.RSS.selected" label="Root Sum of Squares"></cm-checkbox> </div> <div style="margin-right:2em;" class="cmLflexitem"> <cm-checkbox model="data.subview.B1.selected" label="B1-Weighted"></cm-checkbox> </div> <div style="margin-right:2em;" class="cmLflexitem"> <cm-checkbox model="data.subview.SENSE.selected" label="mSENSE"></cm-checkbox> </div> <div style="margin-right:2em;" class="cmLflexitem"> <cm-checkbox model="data.subview.ESPIRIT.selected" label="ESPIRiT"></cm-checkbox> </div> </div> </div> </div></li><li class="list-group-item" ng-show="data.subview.RSS.v.s || data.subview.B1.v.s || data.subview.SENSE.v.s|| data.subview.ESPIRIT.v.s"> <div class="row"> <cm-rss-recon v="data.subview.RSS.v" w="data.subview.RSS.w" list="data.LIST" f="data.f"></cm-rss-recon> <cm-bone-recon v="data.subview.B1.v" w="data.subview.B1.w" list="data.LIST" f="data.f"></cm-bone-recon> <cm-msense-recon v="data.subview.SENSE.v" w="data.subview.SENSE.w" list="data.LIST" f="data.f"></cm-msense-recon> <cm-espirit-recon v="data.subview.ESPIRIT.v" w="data.subview.ESPIRIT.w" list="data.LIST" f="data.f"></cm-espirit-recon> <my-pmr-load-data v="data.subview.LD.v" w="data.subview.LD.w" list="data.LIST" f="data.f"></my-pmr-load-data> </div></li>';

var TMPLPMR = '<uib-accordion> <div uib-accordion-group class="panel-default" is-open="v.o" ng-show="v.s"> <cm-uib-accordion-heading h="v"></cm-uib-accordion-heading> <ul class="list-group"> ' + RECONMETHODSSELECTIONS + ' </ul> </div></uib-accordion>';



var RECONSTRUCTIONCONFIGURATOR = '<li class="list-group-item"><div class="cmRcontainerLeft"><div class="cmRflexitem"><div class="cmLcontainerLeft"><div><span class="cmUploadLabel">Selected Image Reconstruction Method</span></div><div style="margin-right:2em;" ng-repeat="r in reconstructions"  class="cmLflexitem"><cm-checkbox model="r.selected" label="{{r.label}}"></cm-checkbox></div></div></div></div></li><li class="list-group-item" ng-show="selectkernels"><div ng-repeat="PP in reconstructions"> <reconstructionwrapper  directivename="PP.directive" w="PP.w"  v="PP.v" list="model" f="data.f"></reconstructionwrapper></div></li>';


var MRhint = '<div class="row"> <div class="col-md-12"> <div class="cmParagraph"> <div class="cmHintText">The SNR is calculated on a pixel-by-pixel basis as the ratio of the average (signal) and standard deviation (noise) of pixel values through a stack of equivalent image replicas. The replicas can be generated with different image reconstruction techniques. A noise reference scan could be used to estimate the noise correlation between the elements of a phased array. </div> </div> </div></div>';

var PMRhint = '<div class="row"> <div class="col-md-12"> <div class="cmParagraph">    <div class="cmHintText"> The SNR is calculated on a pixel-by-pixel basis as the ratio of the average (signal) and standard deviation (noise) of pixel values through a stack of image pseudo replicas, which are generated via a Monte Carlo technique from k-space data from a single MR acquisition. The pseudo replicas can be generated with different image reconstruction techniques. A noise reference scan could be used to estimate the noise correlation between the elements of a phased array.</div> </div> </div></div>';




var ACMhint = '<div class="row"> <div class="col-md-12"> <div class="cmParagraph"> <div class="cmHintText"> This method is applicable to root-sum-of-squares magnitude combining, B1-weighted combining, and SENSE parallel imaging.$$\\begin{eqnarray}SNR_{RSS}= \\sqrt{2 (\\mathbf{p}^H \\Psi^{-1} \\mathbf{p}) }     \\nonumber \\\\ SNR_{B1}= \\sqrt{2} \\frac{\\mathbf{b}^H \\Psi_{scaled}^{-1} \\mathbf{p}} {\\mathbf{b}^H \\Psi_{scaled}^{-1} \\mathbf{b}}  \\nonumber \\\\ SNR_{SENSE}= \\sqrt{2} \\frac{|\\mathbf{u}^T\\mathbf{p}|} {\\sqrt{\\mathbf{u} \\Psi_{scaled}^{-1} \\mathbf{u}^T }}    \\nonumber\\end{eqnarray}$$ Where the superscript <sup>T</sup> and <sup>H</sup> indicate the transpose and the conjugate of the transpose, respectively; <b>b</b> is the vector of complex coil sensitivity, <b>p</b> is the vector of complex image values for each coil, and <b>u</b> is the vector of complex coil unmixing coefficients for the SENSE reconstruction.</div> </div> </div></div>';


// '<ul > <li> Root-sum-of-squares (RSS) $$ { SNR= \\sqrt{2 (\\mathbf{p}^H \\Psi^{-1} \\mathbf{p}) } } $$ </li> <li> B1-weighted $$ { SNR= \\sqrt{2} \\frac{\\mathbf{b}^H \\Psi_{scaled}^{-1} \\mathbf{p}} {\\mathbf{b}^H \\Psi_{scaled}^{-1} \\mathbf{b} } } $$</li> <li>SENSE $$ { SNR= \\sqrt{2} \\frac{|\\mathbf{u}^T\\mathbf{p}|} {\\sqrt{\\mathbf{u} \\Psi_{scaled}^{-1} \\mathbf{u}^T }} } $$ </li> </ul> Where the superscript <sup>T</sup> and <sup>H</sup>indicate the transpose and the conjugate of the transpose, respectively; <b>b</b>is the vector of complex coil sensitivity, <b>p</b> is the vector of complex image values for each coil, and <b>u</b>is the vector of complex coil unmixing coefficients for the SENSE reconstruction.</div> </div> </div></div>'





var DIhint = '<div class="row"> <div class="col-md-12"> <div class="cmParagraph"><div class="cmHintText">The SNR is calculated for a region of interest (ROI) as:$$ { SNR = \\frac{mean(ROI)_{S_{sum}} }{\\sqrt{2} \\cdot stdev(ROI)_{S_{dif}} } } $$ Where \${ S_{sum} =S_1+S_2  }$ ${ { S_{dif} =S_1-S_2 } }\$ are the sum and subtraction of two identical MR images.</div> </div> </div></div>'



//var DDMRWEBROOT = 'http://cloudmrhub.com/apps/MROPTIMUM';
var DDMRWEBROOT = document.location.origin;


var ROIWHATSAVEANDLOAD = ["id", "typeOF", "visible", "groupped"];

//https://www.textfixer.com/html/compress-html-compression.php
//https://css-tricks.com/snippets/css/a-guide-to-flexbox/

//http://henriquat.re/modularizing-angularjs/modularizing-angular-applications/modularizing-angular-applications.html
var MROPTIMUMDIRECTIVE = angular.module("MROPTIMUMDIRECTIVE", [])


//this can be a general service if i load a json file, let's implement like this
.service('mrodictionaryservice', [function () {
    this.DICT = {
        FlipAngleMap: "Flip Angle Map Normalization",
        NBW: "Noise Bandwidth Normalization",
        UseCovarianceMatrix: "Use Covariance Matrix",
        NoiseFileType: "Noise Origin",
        NR: "Number of Pseudo Replicas",
        RSS: "Root Sum of Squares",
        RSSBART: "Root Sum of Squares",
        Type: "Reconstruction Type",

        "false": "no",
        //"0":"no",
        "true": "yes",
        noiseFile: "Single Raid File",
        SaveCoils: "Save Coils Sensitivity Map",
        SensitivityCalculationMethod: "Sensitivity Calculation Method",
        SourceCoilSensitivityMap: "Source Coil Sensitivity Map",
        SourceCoilSensitivityMapSmooth: "Smooth Coil Sensitivity Map",
        B1: "B1 weighted",
        B1BART: "B1 weighted",
        simplesense: "Internal Reference",
        espirit: "ESPIRiT",
        espiritaccelerated: "ESPIRiT with Autocalibration Lines",
        espiritv1: "ESPIRiT with Smart Thresholding",
        bartsense: "BART Calibration for mSENSE",
        adaptive: "Adaptive",
        AccelerationF: "Acceleration Factor 1",
        AccelerationP: "Acceleration Factor 2",
        bodycoil: "Body Coil",
        GFactorMask: "Mask G factor",
        Autocalibration: "Autocalibration Lines"
    };





    this.ParseTerm = function (x) {
        var O = this.DICT[x];
        if (isUndefined(O)) {
            return x;

        } else {
            return O;
        }

    };




}])

.service('cmreconstructions', [function () {
    this.RECON = [{
        selected: false,
        label: 'Root Sum of Squares',
        neednoise: false,
        directive: 'cm-rss-recon',
        v: {
            o: true,
            s: true,
        },
        w: ""

    },
    {
        selected: false,
        label: 'B1-Weighted',
        neednoise: true,
        directive: 'cm-bone-recon',
        v: {
            o: true,
            s: true,
        },
        w: ""

    },
    {
        selected: false,
        label: 'mSENSE',
        neednoise: true,
        directive: 'cm-msense-recon',
        v: {
            o: true,
            s: true,
        },
        w: ""

    }, {
        selected: false,
        label: 'ESPIRiT',
        neednoise: false,
        directive: 'cm-espirit-recon',
        v: {
            o: true,
            s: true,
        },
        w: ""
    }

    ];




    this.getReconstructions = function (x) {
        //all,withnoise, nonoise
        switch (x) {
            case 'nonoise':
                return findAndGet(this.RECON, 'neednoise', false);
                break;
            default:
                return this.RECON;
                break;
        }



    };




}])




.directive("reconstructionwrapper", function ($compile, $interval) {
    return {
        restrict: 'E',
        scope: {
            directivename: "=",
            w: "=",
            v: "=",
            f: "=",
            list: "="

        },
        link: function (scope, elem, attrs) {

            scope.$watch("directivename", function () {

                var html = '<' + scope.directivename + ' w="w" f="f" v="v" list="list" ></' + scope.directivename + '>';
                elem.html(html);
                $compile(elem.contents())(scope);
            }, true);
        }
    }
})


.directive('cmReconstructionConfigurator', ["$timeout", function ($timeout) {
    return {
        restrict: 'E',
        scope: {
            model: "=", //the output list                                
            reconstructions: "="
        },
        template: RECONSTRUCTIONCONFIGURATOR,
        link: function (scope, element, attrs) {


            scope.data = {
                f: {
                    getHowManyJobsNotYetSentToCloud: function (x) {
                        return scope.model.length;
                    },
                    getJOB: function (x) {


                        if (x == 'all') {
                            return scope.model;
                        } else {
                            var X = [];
                            angular.forEach(scope.model, function (value, key) {
                                if (value.name.toLocaleLowerCase() == x) {
                                    X.push(value);
                                }
                            });
                            return X;
                        }
                    },
                    removeJOB: function (n, x) {
                        findAndRemove(scope.model, "N", n);
                        var t = scope.data.f.getJOB(x);
                        return t;

                    }

                }
            };















            scope.$watch('reconstructions', function (x) {


                var t = 0;
                if (isUndefined(x)) {

                } else {
                    x.forEach(function (o, i) {
                        if (isUndefined(o.selected) || o.selected === false) {
                            o.w = "stop";
                        } else {
                            o.w = "reset";
                            t = t + 1;
                        }
                        if (i == x.length - 1) {

                            if (t > 0) {
                                scope.selectkernels = true;
                            } else {
                                scope.selectkernels = false;

                            }
                        }
                    });
                }
            }, true);









        } //link
    } //return

}])



.directive('cmSettingsDictionary', ["mrodictionaryservice", function (dictionary) {
    return {
        restrict: 'E',
        scope: {
            option: '@',
            value: '@'
        },
        //        templateUrl: 'mrotmpl/directivetmpl/MROptimumUploadOrSelect.html',
        template: '<span class="cmlabel">{{sOpt}}: {{sValue}}</span>',
        link: function (scope, element, attrs) {

            scope.Value = '';

            scope.$watch('option', function (x) {

                if (!isUndefined(x)) {
                    scope.sOpt = dictionary.ParseTerm(x);
                }
            });

            scope.$watch('value', function (x) {

                if (!isUndefined(x)) {
                    scope.sValue = dictionary.ParseTerm(x);
                }
            });


        }
    }

}])
.factory("mrosettings", [function () {
    //    this is the factory store the information needed to make works this piece of code
    var u = {
        url: DDMRWEBROOT + '/apps/MROPTIMUM/',
        author: 'Dr. Eros Montin, PhD',
        email: 'eros.montin@nyulangone.com',
        personalemail: 'eros.montin@gmail.com'
    };
    u.redistibutable = u.url + '/MROPTIMUMRedistribitable';
    //    where i place the clobal css
    u.css = u.redistibutable + '/mroCss.css';
    //    where i place the html template
    u.tmpl = u.redistibutable + '/tmpl';
    u.queryPath = u.url + '/mroQ';
    u.queryServiceUrl = u.queryPath + '/serviceAPI.php';
    u.getcloudmrMainUrl = function () {
        return u.url
    };

    u.getRedistributable = function () {
        return u.redistibutable
    }
    u.getCss = function () {
        return u.css
    };
    u.getCMurl = function () {
        return u.url
    };
    u.getQueryServerUrl = function () {
        return u.queryPath
    };
    u.getQueryServiceUrl = function () {
        return u.queryServiceUrl
    };
    return u;
}])



.directive('mroptimumPmrHint', [function () {
    return {
        restrict: 'E',
        scope: {

        },

        template: PMRhint,
        link: function (scope, element, attrs) {
            scope.$watch(function () {
                MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
                return true;
            });

        }
    };
}])


.directive('mroptimumMrHint', [function () {
    return {
        restrict: 'E',
        scope: {

        },

        template: MRhint,
        link: function (scope, element, attrs) {
            scope.$watch(function () {
                MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
                return true;
            });

        }
    };
}])



.directive('mroptimumDiHint', [function () {
    return {
        restrict: 'E',
        scope: {

        },

        template: DIhint,
        link: function (scope, element, attrs) {
            scope.$watch(function () {
                MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
                return true;
            });

        }
    };
}])


.directive('mroptimumAcmHint', [function () {
    return {
        restrict: 'E',
        scope: {
            type: '='
        },

        template: ACMhint,
        link: function (scope, element, attrs) {

            scope.JSONDATA = {
                settings: {
                    Type: undefined
                }
            };

            //            scope.$watch('type',function(n,o){console.log(n);},true);





            scope.$watch(function () {
                MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
                return true;
            });

        }
    };
}])


.directive('cmFileModel', ['$parse', function ($parse) {
    return {
        restrict: 'A',

        link: function (scope, element, attrs) {


            var model = $parse(attrs.cmFileModel);
            var modelSetter = model.assign;

            element.bind('change', function () {
                scope.$apply(function () {
                    modelSetter(scope, element[0].files[0]);


                });
            });

        }
    };
}])

//SNR UTILS
.directive('mroptimumFaSelection', ["$timeout", "cmTASK", "$interval", function ($timeout, cmTASK, $interval) {
    return {
        restrict: 'E',
        //json of id,state,name id can be an ID or "no"
        scope: {
            f: "="
        },
        //        templateUrl: 'tmpl/mroptimumFaSelection.html',
        template: '<div class="cmRcontainer"> <div class="cmRflexitem"> <div class="cmLcontainerwrap"> <div class="cmLflexitem"> <cm-checkbox model="data.falabel" label="No Flip Angle Correction"></cm-checkbox> </div> </div> </div> <div class="cmRflexitem"> <div class="cmLcontainerwrap"> <div class="cmLflexitem"> <cm-upload-select-file label="{{data.fa.label}}" user="user" model="data.fa.model" multiple=false tooltip="select the FA map" list="data.list"  ng-show="!(data.falabel)" statereset="data.fa.statereset"></cm-upload-select-file> </div> </div> </div></div>',
        link: function (scope, element, attrs) {





            scope.data = {
                fa: {},
                falabel: true,
                output: "no",
                list: []
            };

            scope.defaultvalues = function () {
                scope.data = {
                    fa: { model: [], label: "FA map", statereset: "reset" },
                    falabel: true,
                    output: "no",
                };
            }

            scope.defaultvalues();

            cmTASK.getDIListOfData().then(function (o) {
                scope.data.list = o;
            });


            $interval(function () {
                cmTASK.getDIListOfData().then(function (o) {
                    scope.data.list = o;
                });

            }, 2000);

            scope.user = cmTASK.getUserLog();

            scope.reset = function () {
                scope.defaultvalues();
            };




            scope.$watch('data.falabel', function (n) {
                //if the user flag he does not want to divide by the fa map
                if (n) {
                    try {
                        scope.f.id = "no";

                    } catch (err) {

                    };
                }

            }, false);



            scope.$watch('data.fa.model.id', function (n) {


                if (n != undefined) {
                    scope.f.id = scope.data.fa.model.id;

                };

            }, false);




            scope.$watch('f.state', function (n) {

                if (n == "selecting") {
                    scope.reset();
                };

            }, false);




        }
    }
}])

//https://stackoverflow.com/questions/22967475/angularjs-html-in-js-escaping-single-quote

.directive('mroptimumCoilsensitivitiesSelection', ["cmTASK", "$timeout", "$interval", function (cmTASK, $timeout, $interval) {
    return {
        restrict: 'E',
        //json of coils,state coils contains method and fileid and if you want to save them f:{coils:{method:undefined,file:undefined,SaveCoils},state}
        scope: {
            f: "=",
            accelerated: "@"
        },
        //        templateUrl: 'tmpl/mroptimumCoilsensitivitiesSelection.html',
        template: TMPPLCoilSens,
        link: function (scope, element, attrs) {




            scope.user = cmTASK.getUserLog();

            scope.data = {
                BC: {
                    list: []
                },
                CS: { //coil sens
                    list: []

                },
                o: {}
            }
            scope.sensitivitymethods = [];



            scope.defaultvalues = function () {
                scope.data.BC.model = [];
                scope.data.BC.label = "Body Coil Data";
                scope.data.BC.list = [];
                scope.data.BC.statereset = "reset";

                scope.data.BC.model = [];
                scope.data.BC.label = "Coil Sens. Image";
                scope.data.BC.list = [];
                scope.data.BC.statereset = "reset";

                scope.data.LC = "C";


                scope.data.o.SourceCoilSensitivityMap = 'self';
                scope.data.o.SaveCoilSensivitities = false;
                scope.data.o.SourceCoilSensitivityMapSmooth = false;
                scope.data.o.Method = 'simplesense';


                if (!isUndefined(scope.f)) {
                    if (!isUndefined(scope.f.coils)) {

                        scope.f.coils.SourceCoilSensitivityMap = scope.data.o.SourceCoilSensitivityMap
                        scope.f.coils.Method = scope.data.o.Method;
                    }
                }

                if (scope.accelerated === 'true') {

                    scope.sensitivitymethods = [{
                        value: 'espiritaccelerated',
                        label: "ESPIRiT with Autocalibration Lines"
                    }, {
                        value: 'espiritv1',
                        label: 'ESPIRiT with Smart Thresholding'
                    }, {
                        value: 'bartsense',
                        label: 'BART Calibration for mSENSE'
                    }, {
                        value: 'simplesense',
                        label: 'Internal Reference'
                    }, {
                        value: 'BodyCoil',
                        label: 'Body Coil Reference'
                    }];


                } else {

                    scope.sensitivitymethods = [{
                        value: 'espirit',
                        label: "ESPIRiT"
                    }, {
                        value: 'simplesense',
                        label: 'Internal Reference'
                    }, {
                        value: 'BodyCoil',
                        label: 'Body Coil Reference'
                    }];

                }




            }

            scope.defaultvalues();

            $interval(function () {
                cmTASK.getDIListOfData().then(function (o) {
                    scope.data.CS.list = o;
                });

            }, 2000);


            $interval(function () {
                cmTASK.getACMListOfData().then(function (o) {
                    scope.data.BC.list = o;
                });

            }, 2000);


            cmTASK.getDIListOfData().then(function (o) {
                scope.data.CS.list = o;
            });

            cmTASK.getACMListOfData().then(function (o) {
                scope.data.BC.list = o;
            });



            //load or calc






            scope.reset = function () {



                scope.defaultvalues();
            };




            scope.$watch('f.state', function (n) {

                if (n == "selecting") {
                    scope.reset();


                }

            }, false);



            scope.$watch('data.BC.model.id', function (n) {

                if (!(isUndefined(n))) {
                    scope.f.coils.SourceCoilSensitivityMap = n;
                    scope.f.coils.Method = 'BodyCoil';
                    scope.f.state = "selected";
                }

            }, false);


            scope.$watch('data.CS.model.id', function (n) {

                if (!(isUndefined(n))) {
                    scope.f.coils.SourceCoilSensitivityMap = n;
                    scope.f.coils.Method = 'LoadCoil';
                    scope.f.state = "selected";
                }

            }, false);

            //scope.$watch('f', function(o) { console.log(o) }, true);


            scope.$watch('data.o.Method', function (n) {

                if (!(isUndefined(n)) && ((n == 'simplesense') || (n == 'espirit') || (n == 'espiritaccelerated') || (n == 'espiritv1') || (n == 'bartsense') || (n == 'adaptive'))) {
                    try {
                        if (!isUndefined(scope.f)) {
                            if (!isUndefined(scope.f.coils)) {
                                scope.f.coils.SourceCoilSensitivityMap = 'self';
                                scope.f.coils.Method = n;
                                scope.f.state = "selected";
                            }
                        }
                    } catch (e) { };
                } else {
                    scope.f.coils.Method = n;
                }

            }, true);


        }
    }
}])



//SNR

.directive('myMr', ["cmTASK", "$timeout", "cmreconstructions", "cmtool", "$q", "$interval", function (cmTASK, $timeout, cmreconstructions, cmtool, $q, $interval) {
    return {
        restrict: 'E',
        scope: {
            w: "=", //toreset or stop
            v: "=", //vuewer hson
            f: "=" ///functions shared

        },


        // template: '<uib-accordion> <div uib-accordion-group class="panel-default" is-open="v.o" ng-show="v.s"> <cm-uib-accordion-heading h="v"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item"> <cm-upload-select-file statereset="data.f.F.statereset" label="{{data.f.F.label}}" user="user" model="data.f.F.model" multiple=true tooltip="select the Signal" list="data.list"> </cm-upload-select-file> <form class="form"> <div class="input-group" ng-repeat="ll in data.stack"> {{ll.name}}<a ng-click="remove(ll.uid)"><i class="far fa-trash-alt"></i></a></div> </form> </li> <li class="list-group-item"> <div class="row top-buffer"> <form class="form-inline"> <cm-radiobox model="data.noisetype" label="No Noise File" value="NN"></cm-radiobox> <cm-radiobox model="data.noisetype" label="Load Noise File" value="LN"></cm-radiobox> <cm-radiobox model="data.noisetype" label="Read Noise Reference from Siemens Multiple RAID File" value="MN"></cm-radiobox> </form> </div> <div class="row top-buffer" ng-show="data.noisetype==\'LN\'"> <div class="col-md-12"> <cm-upload-select-file statereset="data.f.N.statereset" label=" {{data.f.N.label}} " user="user " model="data.f.N.model " multiple=false tooltip="select the noise " list="data.list "> </cm-upload-select-file> </div> </div> <div class="row top-buffer" ng-show="data.noisetype==\'MN\'"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <cm-number-input model="data.noiseimagenumber" label="#noise image" step="1" tootlip="select image in the signal data contains the noise data"></cm-number-input> </div> </div> </li> <li class="list-group-item "> <cm-reconstruction-configurator reconstructions="reconstructions " model="data.optionslist "></cm-reconstruction-configurator> </li> <li class="list-group-item "> <div class="row "> <div class="col-md-12 "> <div class="pull-left cmLcontainerWrap "> <div class="cmLflexitem " style="margin-right=1em "> <button class="btn btn-success" ng-click="insertJOB()" ng-show=" buttonuploadenable ">Queue Job ({{data.optionslist.length}})</button> <button class="btn btn-success " ng-hide="buttonuploadenable " disabled>Queue Job </button> </div> <div class="cmLflexitem " style="margin-right=1em "> <button ng-click="reset() " class="cmButton cmLitem ">Reset</button> </div> </div> </div> </div> </li> </ul> </div></uib-accordion>',
        template: '<uib-accordion> <div uib-accordion-group class="panel-default" is-open="v.o" ng-show="v.s"> <cm-uib-accordion-heading h="v"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item "> <cm-reconstruction-configurator reconstructions="reconstructions " model="data.optionslist "></cm-reconstruction-configurator> </li> <uib-accordion> <div uib-accordion-group class="panel-default" is-open="loadpanel.o" ng-show="loadpanel.s"> <cm-uib-accordion-heading h="loadpanel"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item"> <div class="row top-buffer"> <form class="form-inline"> <cm-radiobox model="data.noisetype" label="No Noise File" value="NN"></cm-radiobox> <cm-radiobox model="data.noisetype" label="Load Noise File" value="LN"></cm-radiobox> <cm-radiobox model="data.noisetype" label="Read Noise Reference from Siemens Multiple RAID File" value="MN"></cm-radiobox> </form> </div> <div class="row top-buffer" ng-show="data.noisetype==\'LN\'"> <div class="col-md-12"> <cm-upload-select-file statereset="data.f.N.statereset" label=" {{data.f.N.label}} " user="user " model="data.f.N.model " multiple=false tooltip="select the noise " list="data.list "> </cm-upload-select-file> </div> </div> <div class="row top-buffer" ng-show="data.noisetype==\'MN\'"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <cm-number-input model="data.noiseimagenumber" label="#noise image" step="1" tootlip="select image in the signal data contains the noise data"></cm-number-input> </div> </div> </li> <li class="list-group-item"> <div class="row top-buffer"> <div class="col-md-12"> <cm-upload-select-file label="{{data.f.F.label}}" user="user" model="data.f.F.model" multiple=true tooltip="select the the noise Data" list="data.list" statereset="data.f.F.statereset"></cm-upload-select-file> </div> </div> </li> <li class="list-group-item "> <div class="row "> <div class="col-md-12 "> <div class="pull-left cmLcontainerWrap "> <div class="cmLflexitem " style="margin-right=1em "> <button class="btn btn-success" ng-click="insertJOB()" ng-show="buttonuploadenable">Queue Job ({{data.optionslist.length}})</button> <button class="btn btn-success " ng-hide="buttonuploadenable" disabled>Queue Job </button> </div> <div class="cmLflexitem " style="margin-right=1em "> <button ng-click="reset() " class="cmButton cmLitem ">Reset</button> </div> </div> </div> </div> </li> <li class="list-group-item" ng-show="(data.optionslist.length>0)"> <table class="table table-striped"> <tr scope="row"> <th scope="col">Type</th> <th scope="col">Alias</th> <th scope="col">Job Options</th> <th scope="col">Delete</th> </tr> <tr scope="row" ng-repeat="x in data.optionslist "> <td>{{x.name}}</td> <td>{{x.alias}}</td> <td> <div ng-repeat="(key, value) in x.params"> <cm-settings-dictionary option=\'{{key}}\' value=\'{{value}}\'></cm-settings-dictionary> </div> </td> <td><a ng-click="removeTask(x.N)" style="cursor: pointer"><i class="far fa-trash-alt" ></i></a> </td> </tr> </table> </li> </ul> </div> </uib-accordion> </ul> </div></uib-accordion>',
        link: function (scope, element, attrs) {



            scope.removeTask = function (x) {




                findAndRemove(scope.data.optionslist, "N", x);


            };


            scope.resetSignal = function (typeofcall) {
                // console.log("MR-rsts")
                switch (typeofcall) {
                    case "init":

                        scope.data.f = {
                            //no need to statereser bec it has just started
                            // N: { model: [], label: "Noise Data", statereset: "reset" }
                            F: { model: [], label: "Data", statereset: undefined }

                        };
                        break;
                    case "hard":

                        scope.data.f.F.statereset = "reset";
                        break;
                    default:
                        scope.data.f.F.statereset = "reset";
                        break;

                }
            };


            scope.defaultvalues = function (typeofcall) {
                // console.log("MR-dflt")
                scope.data.list = [];
                scope.data.stack = []; //stack of data and or multiple replicas
                scope.data.optionslist = [];
                scope.data.alias = "MR" + cmTASK.ora();
                scope.data.noisetype = 'NN';
                scope.data.noiseimagenumber = 1;
                scope.buttonuploadenable = false;
                switch (typeofcall) {
                    case "init":
                        // console.log("MR-dfltinit")

                        scope.data.f = {
                            //no need to resetstate bec it has just started
                            // N: { model: [], label: "Noise Data", statereset: "reset" }
                            N: { model: [], label: "Noise Reference", statereset: undefined }

                        };
                        break;
                    case "hard":

                        scope.data.f.N.statereset = "reset";
                        // console.log("MR-dglthard");

                        break;

                }
                scope.loadpanel = {
                    title: "Load Data and Start Calculation",
                    icon: "fas fa-database",
                    o: true,
                    s: true

                }

                scope.resetSignal(typeofcall);
                // console.log("MR-resetsignalo");
                scope.data.list = [];
                scope.data.stack = []; //stack of data and or multiple replicas
                scope.data.optionslist = [];
                scope.data.alias = "MR" + cmTASK.ora();
                scope.data.noisetype = 'LN';
                scope.data.noiseimagenumber = 1;
            }


            scope.$watch('data', function () {
                scope.buttonuploadenable = ((scope.data.stack.length > 0) && (scope.data.optionslist.length > 0));
                scope.loadpanel.s = scope.data.optionslist.length > 0;
            }, true);
            //init!

            scope.data = {
                list: [],
                optionslist: [],
                f: {
                    F: { model: [], label: "Data", statereset: undefined },
                    N: { model: [], label: "Noise Reference", statereset: undefined }
                },
                stack: []
            };


            $interval(function () {
                cmTASK.getACMListOfData().then(function (o) {

                    scope.data.list = o;
                });

            }, 4000);

            //the init

            scope.reconstructions = cmreconstructions.getReconstructions('nonoise');

            scope.user = cmTASK.getUserLog();

            scope.defaultvalues();


            //everytime i load a file i put it in the list
            var watchsignal = scope.$watch("data.f.F.model", function (n) {

                if (!(isUndefined(n))) {
                    scope.data.stack = [];
                    if (n.length > 0) {

                        //  console.log("adding" + n);
                        n.forEach(function (thefile, index) {

                            var im = {
                                ID: thefile.id,
                                uid: getUIID(),
                                name: thefile.filename,
                            };

                            scope.data.stack.push(im);
                        });
                    }
                };

            }, true);


            //change the reconstructos according to the presence of noise file
            var watchnoise = scope.$watch("data.noisetype", function (n, o) {
                if (isUndefined(n)) {

                } else {

                    switch (n) {
                        case 'MN':
                        case 'LN':
                            scope.reconstructions = cmreconstructions.getReconstructions('all');
                            break;
                        default:
                            scope.reconstructions = cmreconstructions.getReconstructions('nonoise');
                            break;
                    }

                }

            }, true);





            scope.reset = function () {

                scope.v.o = true;
                scope.v.s = true;
                scope.v.title = "Multiple Replica";
                scope.v.icon = "glyphicon glyphicon-tasks";


            };




            scope.getMR = function () {
                return scope.data.stack;
            };






            scope.insertJOB_ = function (j, a) {
                console.log(scope.data.stack)
                var deferred = $q.defer();
                //noise id,optionsjson and the alias
                j.images = JSON.stringify(scope.data.stack);
                j.client = JSON.stringify(cmtool.getClientInfo());
                j.clientmin = cmtool.getClientInfoMin();
                j.alias = a;

                // TODO: this is hardcoded for test, the workflow is not correct now.
                // the whole "j" is the jopt, and is written into a JSON file at vertebra/spinalnode
                // See README for more detail.
                // j.optionsFile = cmTASK.mrOptionsFile;
                // j.qServer = cmTASK.qServer;

                data = {
                    'JobType': "MR",
                    'images': JSON.stringify(scope.data.stack),
                    'J': j,
                    'Alias': a,
                    'UID': cmTASK.logUID.UID
                }

                cmTASK.postIt(cmTASK.taskUploadAPI, data).then((response) => {
                    deferred.resolve(response);
                });
                // promises.push(data)
                // cmTASK.myRFAPI({
                //     'JobType': "MR",
                //     'images': JSON.stringify(scope.data.stack),
                //     'J': j,
                //     'Alias': a
                // }, 'insertJob.php').then(function (response) {


                // });

                return deferred.promise;
            };



            //real function called by the web
            scope.insertJOB = function () {


                if (scope.data.optionslist.length > 0) {
                    //copy the list of options
                    var L = jsonCopy(scope.data.optionslist);

                    //fetch the tasks
                    var promises = [];


                    for (c = 0; c < L.length; c++) {
                        d = L[c].params;
                        d.NBW = 1;
                        d.type = L[c].name;
                        d.alias = L[c].alias;


                        switch (scope.data.noisetype) {
                            case "LN":
                                if (isUndefined(scope.data.f.N.model.id)) {
                                    alert("you need to select a noise file");
                                    return
                                } else {
                                    d.NoiseFileType = "noiseFile";
                                    //       console.log(scope.data.f.N)
                                    d.NoiseID = scope.data.f.N.model.id;
                                }
                                break;
                            case "SN":
                                d.NoiseFileType = "selfSingle";
                                d.NoiseID = scope.data.stack[scope.data.noiseimagenumber - 1].id;
                                break;

                            case "MN":
                                d.NoiseFileType = "selfMulti";
                                d.NoiseID = scope.data.stack[scope.data.noiseimagenumber - 1].id;
                                break;
                            case "NN":
                                d.NoiseFileType = "noNoise";
                                //d.NoiseID = scope.data.F.id;
                                break;
                        }


                        var promise = scope.insertJOB_(d, d.alias);

                    }



                    $q.all(promises).then(function () {
                        if (promises.length > 1) {
                            alert("Jobs Queued");
                        } else {
                            alert("Job Queued");
                        }

                        //scope.reset();
                        scope.defaultvalues("hard");
                    });
                } else {
                    alert("select a reconstruction method")
                }
            };



            var W = scope.$watch("w", function (n) {
                switch (n) {
                    case "reset":
                        scope.reset();

                        break;
                    case "stop":
                        scope.f.hideview(scope.v);
                }
            }, true);




            scope.$on('$destroy', function () {
                // try {
                //     W();
                // } catch (e) {

                // }

                // try {
                //     watchnoise();
                // } catch (e) {

                // }
                // try {
                //     watchsignal();
                // } catch (e) {

                // }
            });

        }
    }
}])

.directive('myDi', ["cmTASK", "$timeout", "$interval", function (cmTASK, $timeout, $interval) {
    return {
        restrict: 'E',
        scope: {
            w: "=",
            v: "=",
            f: "="
        },
        template: '<uib-accordion> <div uib-accordion-group class="panel-default" is-open="v.o" ng-show="v.s"> <cm-uib-accordion-heading h="v"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item"> <div style="margin-bottom:1em"> <cm-upload-select-file label="{{data.f0.label}}" user="user" model="data.f0.model" multiple=false tooltip="select the the first image" list="data.list" statereset="data.f0.statereset"></cm-upload-select-file> </div> <div style="margin-bottom:1em"> <cm-upload-select-file label="{{data.f1.label}}" user="user" model="data.f1.model" multiple=false tooltip="select the the second image" list="data.list" statereset="data.f1.statereset"></cm-upload-select-file> </div> </li> <li class="list-group-item"> <div class="float-center"> <form class="form-inline"> <div class="input-group"> <label for="DIAL">Job Alias</label> </div> <div class="input-group"> <input type="text" class="form-control" id="DIAL" placeholder="enter alias" ng-model="data.alias"> </div> <div class="input-group"> <button class="btn btn-success" ng-click="addDI()">Queue Job</button> </div> <div class="input-group"> <button ng-click="reset()" class="cmButton ">Reset</button> </div> </form> </div> </li> </ul> </div></uib-accordion>',
        link: function (scope, element, attrs) {



            scope.defaultvalues = function () {
                scope.data = {
                    list: [],
                    alias: "DI_" + cmTASK.ora(),
                    f0: { model: [], label: "Image 1", statereset: "reset" },
                    f1: { model: [], label: "Image 2", statereset: "reset" }
                };
            }
            scope.init = function () {


                cmTASK.getDIListOfData().then(function (o) {
                    scope.data.list = o;
                });

                scope.user = cmTASK.getUserLog();

                scope.defaultvalues();

            };

            scope.reset = function () {


                scope.v.o = true;
                scope.v.s = true;
                scope.v.title = "Difference Image";
                scope.v.icon = "glyphicon glyphicon-tasks";

                scope.defaultvalues();

            };

            // scope.$watch("data", function(o) { console.log(o); }, true);

            $timeout(scope.init(), 0);

            scope.addDI = function () {
                // console.log({ image0: scope.data.f0.model.id, image1: scope.data.f1.model.id, alias: scope.data.alias });
                if (isUndefined(scope.data.f0.model.id)) {
                    alert("you need to choose the first image");

                } else {
                    if (isUndefined(scope.data.f1.model.id)) {
                        alert("you need to choose the second image");
                    } else {
                        data = {
                            'JobType': 'DI',
                            'UID': cmTASK.logUID.UID,
                            'J': { image0: scope.data.f0.model.id,
                                    image1: scope.data.f1.model.id,
                                    alias: scope.data.alias },
                            'Alias': scope.data.alias
                        }
                        cmTASK.postIt(cmTASK.taskUploadAPI, data).then((response) => {
                            alert("Job Queued");
                            scope.reset();
                        });
                    }
                }

            };

            $interval(function () {
                cmTASK.getDIListOfData().then(function (o) {
                    scope.data.list = o;
                });

            }, 2000);


            //scope.$on('$destroy', function() { console.log("bye") });

            scope.$watch("w", function (n) {


                switch (n) {
                    case "reset":
                        scope.reset();
                        break;
                    case "stop":
                        scope.f.hideview(scope.v);

                }
            }, true);




        }
    }
}])



.directive('myAcm', ["cmTASK", "$timeout", "$interval", function (cmTASK, $timeout, $interval) {
    return {
        restrict: 'E',
        scope: {
            w: "=",
            v: "=",
            f: "="

        },
        //        templateUrl: 'tmpl/myACM.html',
        template: TMPLACM,
        link: function (scope, element, attrs) {
            var view = "myACM-";
            // console.log(view + "start");

            scope.data = {};
            scope.data.f = {};

            //for later
            scope.data.loadjob = {
                id: undefined,
                filename: undefined,
                type: "JOB",
                label: "Load Job",
                state: "selecting"
            };

            //  scope.$watch('data.LIST', function(n) { console.log(n) }, true);

            scope.init = function () {
                // console.log(view + "init");
                scope.data.state = "new";
                scope.data.LIST = [];
                // console.log("ACM INIT");




                scope.data.f.getHowManyJobsNotYetSentToCloud = function (x) {

                    return scope.data.LIST.length;
                }



                scope.data.f.getJOB = function (x) {


                    if (x == 'all') {
                        return scope.data.LIST;
                    } else {
                        var X = [];
                        angular.forEach(scope.data.LIST, function (value, key) {
                            if (value.name.toLocaleLowerCase() == x) {
                                X.push(value);
                            }
                        });
                        return X;
                    }
                }

                scope.data.f.removeJOB = function (n, x) {
                    findAndRemove(scope.data.LIST, "N", n);
                    var t = scope.data.f.getJOB(x);
                    return t;

                };

            };

            $timeout(function () {
                // console.log("ACM CREATED");
                scope.init();
            }, 0);


            scope.reset = function () {
                //  console.log(view + "reset");
                scope.data.LIST = [];

                scope.v.o = true;
                scope.v.s = true;
                scope.v.title = "Array Combining";
                scope.v.icon = "glyphicon glyphicon-tasks";

                scope.data.subview = {
                    RSS: {
                        selected: false,
                        v: {
                            o: false,
                            s: false
                        },
                        w: ""
                    },
                    B1: {
                        selected: false,
                        v: {
                            o: false,
                            s: false
                        },
                        w: ""
                    },
                    SENSE: {
                        selected: false,
                        v: {
                            o: false,
                            f: false
                        },
                        w: ""
                    },
                    LD: {
                        selected: false,
                        v: {
                            o: false,
                            s: false
                        },
                        w: ""
                    },
                };




            };




            //that's to know if anyone is updatind the list in the factory
            // scope.data.backCom=true;

            var vR = scope.$watch("data.subview.RSS.selected", function (n) {

                switch (n) {
                    case true:
                        scope.data.subview.RSS.w = "reset";
                        break;
                    case false:
                        scope.data.subview.RSS.w = "stop";

                }

            }, true);




            var vS = scope.$watch("data.subview.SENSE.selected", function (n) {

                switch (n) {
                    case true:
                        scope.data.subview.SENSE.w = "reset";
                        break;
                    case false:
                        scope.data.subview.SENSE.w = "stop";

                }

            }, true);




            var vB = scope.$watch("data.subview.B1.selected", function (n) {

                switch (n) {
                    case true:
                        scope.data.subview.B1.w = "reset";
                        break;
                    case false:
                        scope.data.subview.B1.w = "stop";

                }

            }, true);




            var RESET = scope.$watch("w", function (n) {
                switch (n) {
                    case "reset":
                        scope.reset();
                        break;
                    case "stop":
                        scope.f.hideview(scope.v);


                }
            }, true);

            scope.cleanup = function () {
                // console.log(view + "leaving");
                //RESET();
                //vR();
                //vS();
                //vB()
            };
            scope.$on("$destroy", scope.cleanup());

        }
    }
}])

.directive('chooseSnrMethods', [function () {
    return {
        restrict: 'E',
        scope: {

            snrmethods: "=",
            v: "="
        },
        //        templateUrl: 'mrotmpl/directivetmpl/chooseSnrMethods.html',
        template: '<uib-accordion> <div uib-accordion-group class="panel-default" is-open="v.o" ng-show="v.s" data-toggle="tooltip" data-placement="top" title="Choose how to calculate the Signal to Noise Ratio among the possible methods" > <cm-uib-accordion-heading h="v"></cm-uib-accordion-heading> <ul class="list-group"> <li class="list-group-item"> <div class="row top-buffer"> <div class="col-md-12"> <form class="form-inline"><!-- <div class="input-group" ng-repeat="PA in snrmethods.available"> <div class="radio" ng-if="PA.state==\'enabled\'"> <label class="input-group " ><input ng-model="snrmethods.choosen" type="radio" value="{{PA.value}}" > <span class="cr"><i class="cr-icon glyphicon glyphicon-ok"></i></span>{{PA.name}} </label> </div> <div class="radio" ng-if="PA.state==\'disabled\'" ng-mouseover="disabledF(PA)"> <label class="input-group " ><input ng-model="snrmethods.choosen" type="radio" value="{{PA.value}}" disabled> <span class="cr" ng-mouseover="disabledF(PA)"><i class="cr-icon glyphicon glyphicon-remove-circle"></i></span>{{PA.name}} </label> </div> </div>--> <!-- <div class="input-group" ng-repeat="PA in snrmethods.available">--> <div class="input-group" ng-repeat="PA in snrmethods.available"> <cm-radiobox model="snrmethods.choosen" label="{{PA.name}}" value="{{PA.value}}"></cm-radiobox> </div> </form> </div> </div></li><li class="list-group-item"><mroptimum-pmr-hint ng-if="snrmethods.choosen==\'PMR\'"></mroptimum-pmr-hint> <mroptimum-acm-hint ng-if="snrmethods.choosen==\'ACM\'"></mroptimum-acm-hint> <mroptimum-di-hint ng-if="snrmethods.choosen==\'DI\'"></mroptimum-di-hint> <mroptimum-mr-hint ng-if="snrmethods.choosen==\'MR\'"></mroptimum-mr-hint></li></ul></div></uib-accordion>',
        link: function (scope, element, attrs) {




            scope.init = function () {

                scope.v.o = true;
                scope.v.s = true;
                scope.v.title = "SNR Analysis Methods";
                scope.v.icon = "fas fa-calculator";


            };

            scope.$watch("snrmethods.choosen", function (n) {

                if (isUndefined(n)) {

                    scope.init();
                } else {
                    // scope.v.o = false;

                }
            }, true)


            scope.disabledF = function (x) {

                alert("In this version of MR Optimum " + x.name + " feature is " + x.state);
            };



        }
    }
}])


.directive('myAcmLoadData', ["cmTASK", "$timeout", "$q", "cmtool", "$interval", function (cmTASK, $timeout, $q, cmtool, $interval) {
    return {
        restrict: 'E',
        scope: {
            w: "=",
            v: "=",
            f: "=",
            list: "=" //reconlist
        },
        template: TMPLACMLD,
        link: function (scope, element, attrs) {

            scope.data = {
                f: {},
                list: []
            };

            $interval(function () {
                cmTASK.getACMListOfData().then(function (o) {

                    scope.data.list = o;
                });

            }, 2000);

            // scope.$watch("data", function(o) { console.log(o); }, true);


            scope.defaultvalues = function () {

                scope.data.f = {
                    fn: { model: [], label: "Noise Data", statereset: "reset" },
                    fs: { model: [], label: "Signal Data", statereset: "reset" }
                }
                scope.data.list = [];
            }




            scope.init = function () {
                scope.data.NOISE = "LN";
                scope.data.unebw = true;
                scope.defaultvalues();
                scope.user = cmTASK.getUserLog();

                cmTASK.getACMListOfData().then(function (o) {

                    scope.data.list = o;
                });

            }




            scope.reset = function () {
                // console.log("resetting ACMLD")
                scope.v.title = "Load Data and Start Calculation";
                scope.v.icon = "fas fa-database";
                scope.v.o = true;
                scope.v.s = true;
                scope.defaultvalues();


            }


            scope.open = function () {
                scope.v.title = "Load Data and Start Calculation";
                scope.v.icon = "fas fa-database";
                scope.v.o = true;
                scope.v.s = true;

            }


            scope.stop = function () {
                scope.v.s = false;

            };


            scope.collapse = function () {
                scope.v.o = false;

            };


            scope.removeTask = function (x) {
                console.log(x);
                scope.list = scope.f.removeJOB(x, 'all');
            };


            scope.$watch("list", function (n, o) {
                if (!(isUndefined(scope.v))) {
                    if (n.length == 0) {
                        scope.v.s = false;
                    } else {

                        scope.open();
                        if (n.length > 1) {
                            scope.JJ = "Queue Jobs";
                        } else {
                            scope.JJ = "Queue Job";
                        }
                    }
                } else {

                }
            }, true);




            scope.$watch("w", function (n) {

                switch (n) {
                    case "reset":
                        scope.reset();
                        break;
                    case "stop":
                        scope.stop(scope.v);

                }
            }, true);




            scope.$watch("data.f", function (x) {

                //   console.log(x)
                //                if(isUndefined(scope.data.f.fs.id) || isUndefined(scope.data.f.fn.id)){
                if (isUndefined(scope.data.f.fs.model.id) || (scope.data.NOISE == "LN" && isUndefined(scope.data.f.fn.model.id))) {
                    scope.data.disabledState = true;

                } else {
                    scope.data.disabledState = false;
                }
            }, true);


            scope.$watch("data.NOISE", function () {

                //                if(isUndefined(scope.data.f.fs.id) || isUndefined(scope.data.f.fn.id)){
                if (isUndefined(scope.data.f.fs.model.id) || (scope.data.NOISE == "LN" && isUndefined(scope.data.f.fn.model.id))) {
                    scope.data.disabledState = true;

                } else {
                    scope.data.disabledState = false;
                }
            }, true);



            scope.insertjob = function () {

                cmtool.LOAD(true);

                var L = jsonCopy(scope.list);

                //fetch the tasks
                var promises = [];

                var myN = undefined;

                for (c = 0; c < L.length; c++) {
                    d = L[c].params;
                    if (scope.data.unebw) {
                        d.NBW = 1;
                    } else {
                        d.NBW = 0;
                    }

                    d.type = L[c].name;

                    d.signalData = scope.data.f.fs.model.id;


                    switch (scope.data.NOISE) {
                        case "LN":
                            d.NoiseFileType = "noiseFile";

                            d.noiseData = scope.data.f.fn.model.id;
                            break;
                        case "SN":
                            d.NoiseFileType = "selfSingle";

                            d.noiseData = scope.data.f.fs.model.id;
                            break;

                        case "MN":
                            d.NoiseFileType = "selfMulti";

                            d.noiseData = scope.data.f.fs.model.id;
                            break;
                    }
                    d.alias = L[c].alias
                    
                    // TODO: this is hardcoded for test, the workflow is not correct now.
                    // the whole "d" is the jopt, and is written into a JSON file at vertebra/spinalnode
                    // See README for more detail.
                    // d.optionsFile = cmTASK.acmOptionsFile;
                    // d.qServer = cmTASK.qServer;

                    data = {
                        'JobType': 'ACM',
                        'UID': cmTASK.logUID.UID,
                        'J': d,
                        'ACM': L[c].id,
                        'Alias': L[c].alias
                    }
                    cmTASK.postIt(cmTASK.taskUploadAPI, data).then((response) => {
                        scope.removeTask(L[c].N);
                        promises.push(response)
                        console.log("Job sent");
                    });
                    

                    
                    // var promise = cmTASK.myRFAPI({
                    //     'JobType': 'ACM',
                    //     'UID': cmTASK.logUID.UID,
                    //     'J': d,
                    //     'ACM': L[c].id,
                    //     'Alias': L[c].alias
                    // }, 'insertJob.php').then(scope.removeTask(L[c].N));
                    // //console.log(al + "_" + a.ACM[c].name);
                    // promises.push(promise);
                };




                $q.all(promises).then(function () {
                    if (promises.length > 1) {
                        alert("Jobs Queued");
                    } else {
                        alert("Job Queued");
                    }
                    cmtool.LOAD(false);
                    scope.reset();
                });
            };




            $timeout(scope.init(), 0);

        }
    }
}])




.directive('cmRssRecon', ["$timeout", function ($timeout) {
    return {
        restrict: 'ECA',
        scope: {
            w: "=",
            v: "=",
            f: "=",
            list: "="

        },

        template: TMPLRSS,
        link: function (scope, element, attrs) {


            scope.data = {
                x: {
                    p: {

                    }
                }
            };


            scope.init = function () {
                scope.data.XL = [];

            };




            scope.resetDATA = function () {
                scope.data.x = {
                    p: {
                        FA: {
                            state: "selecting",
                            id: "no",
                            filename: undefined
                        },
                        alias: " RSS #" + scope.f.getHowManyJobsNotYetSentToCloud()
                    }
                }


            };


            scope.reset = function () {
                scope.v.title = "Root Sum of Squares";
                scope.v.icon = "fas fa-signature";
                scope.v.o = true;
                scope.v.s = true;
                scope.resetDATA();
            }


            scope.stop = function () {
                scope.v.s = false;

            };


            scope.collapse = function () {
                scope.v.o = false;

            };




            scope.add = function (p, alias) {
                scope.list.push({
                    "N": getUIID(),
                    "name": "rss",
                    "id": 5,
                    "params": {
                        Type: "RSSBART",
                        //true or false
                        FlipAngleMap: p.FA.id
                    },
                    "alias": p.alias
                });


            };



            scope.changeACMMethods = function (XX, p) {
                //                if (Number.isInteger(XX)){
                if (typeof XX === 'string' || XX instanceof String) {
                    scope.v.XL = scope.f.removeJOB(XX, 'rss');

                } else {
                    //copy to dereferene
                    //console.log(scope.data.x.p);
                    scope.add(jsonCopy(scope.data.x.p));

                }

            };


            scope.$watch("list", function (n) {

                if (!(isUndefined(scope.f.getJOB))) {
                    scope.data.XL = scope.f.getJOB('rss');
                    scope.resetDATA();

                }
            }, true);

            scope.$watch("w", function (n) {

                switch (n) {
                    case "reset":
                        scope.reset();

                        break;
                    case "stop":
                        scope.stop(scope.v);


                }
            }, true);



            $timeout(function () {
                //   console.log("ACM RSS CREATED");
                scope.init();
            }, 0);
        }
    }
}])

.directive('cmMsenseRecon', ["$timeout", function ($timeout) {
    return {
        restrict: 'ECA',
        scope: {
            w: "=",
            v: "=",
            f: "=",
            list: "="
        },
        template: TMPLmSENSE,

        link: function (scope, element, attrs) {



            scope.data = {
                x: {
                    p: {}
                }
            };

            scope.init = function () {

                scope.data.XL = [];
            }



            scope.resetDATA = function () {
                scope.data.x = {
                    p: {
                        FA: {
                            state: "selecting",
                            id: "no",
                            filename: undefined
                        },
                        GFactorMask: {
                            state: "selecting",
                            id: "no",
                            filename: undefined
                        },
                        CS: {
                            coils: {
                                Method: 'simplesense',
                                SourceCoilSensitivityMap: 'self',
                                SaveCoilSensivitities: false,
                                SourceCoilSensitivityMapSmooth: false
                            },
                            state: "selecting"
                        },
                        Decimate: false,
                        AccelerationF: 1,
                        AccelerationP: 1,
                        Autocalibration: 24,
                        alias: "mSENSE #" + scope.f.getHowManyJobsNotYetSentToCloud()
                    }
                }
            };




            scope.reset = function () {
                scope.v.o = true;
                scope.v.s = true;
                scope.v.title = "mSENSE";
                scope.v.icon = "fas fa-signature";
                scope.resetDATA();
            }




            scope.$watch("data.x.p.AccelerationF", function (x) {
                if (x < 1) {
                    scope.data.x.p.AccelerationF = 1;
                }
            }, true);

            scope.$watch("data.x.p.AccelerationP", function (x) {
                if (x < 1) {
                    scope.data.x.p.AccelerationP = 1;
                }

            }, true);


            scope.$watch("data.x.p.Autocalibration", function (x) {
                if (x < 4) {
                    scope.data.x.p.Autocalibration = 4;
                }

            }, true);


            scope.stop = function () {
                scope.v.s = false;

            };


            scope.collapse = function () {
                scope.v.o = false;

            };




            scope.add = function (p) {
                //   console.log(p);
                var MYJSON = {
                    "N": getUIID(),
                    "name": "SENSE",
                    "id": 8,
                    "params": {
                        Type: "mSENSE",
                        FlipAngleMap: p.FA.id,
                        SensitivityCalculationMethod: p.CS.coils.Method,
                        SaveCoils: p.CS.coils.SaveCoilSensivitities,
                        SourceCoilSensitivityMap: p.CS.coils.SourceCoilSensitivityMap,
                        SourceCoilSensitivityMapSmooth: p.CS.coils.SourceCoilSensitivityMapSmooth,
                        AccelerationF: p.AccelerationF,
                        AccelerationP: p.AccelerationP,
                        Autocalibration: p.Autocalibration,
                        GFactorMask: p.GFactorMask.id
                    },
                    "alias": p.alias
                };


                scope.list.push(MYJSON);

            };




            scope.changeACMMethods = function (XX, p) {

                if (typeof XX === 'string' || XX instanceof String) {
                    scope.data.XL = scope.f.removeJOB(XX, 'sense');

                } else {
                    //copy to dereferene
                    scope.add(jsonCopy(scope.data.x.p));

                }

            };


            scope.$watch("list", function (n) {
                //   console.log(n);
                if (!(isUndefined(scope.f.getJOB))) {
                    scope.data.XL = scope.f.getJOB('sense');
                    scope.resetDATA();
                }

            }, true);

            scope.$watch("w", function (n) {

                switch (n) {
                    case "reset":
                        scope.reset();
                        break;
                    case "stop":
                        scope.stop(scope.v);

                }
            }, true);



            $timeout(function () {
                //    console.log("ACM B1 CREATED");
                scope.init();
            }, 0);

        }
    }
}])


.directive('cmSenseRecon', ["$timeout", function ($timeout) {
    return {
        restrict: 'ECA',
        scope: {
            w: "=",
            v: "=",
            f: "=",
            list: "="
        },
        template: TMPLmSENSE, //yes we are using the same template of sense

        link: function (scope, element, attrs) {
            console.log("SENSE!!");


            scope.data = {
                x: {
                    p: {}
                }
            };

            scope.init = function () {

                scope.data.XL = [];
            }



            scope.resetDATA = function () {
                scope.data.x = {
                    p: {
                        FA: {
                            state: "selecting",
                            id: "no",
                            filename: undefined
                        },
                        GFactorMask: {
                            state: "selecting",
                            id: "no",
                            filename: undefined
                        },
                        CS: {
                            coils: {
                                Method: 'simplesense',
                                SourceCoilSensitivityMap: 'self',
                                SaveCoilSensivitities: false,
                                SourceCoilSensitivityMapSmooth: false
                            },
                            state: "selecting"
                        },
                        Decimate: false,
                        AccelerationF: 1,
                        AccelerationP: 1,
                        Autocalibration: 0,
                        alias: "SENSE #" + scope.f.getHowManyJobsNotYetSentToCloud()
                    }
                }
            };




            scope.reset = function () {
                scope.v.o = true;
                scope.v.s = true;
                scope.v.title = "SENSE";
                scope.v.icon = "fas fa-signature";
                scope.resetDATA();
            }




            scope.$watch("data.x.p.AccelerationF", function (x) {
                if (x < 1) {
                    scope.data.x.p.AccelerationF = 1;
                }
            }, true);

            scope.$watch("data.x.p.AccelerationP", function (x) {
                if (x < 1) {
                    scope.data.x.p.AccelerationP = 1;
                }

            }, true);





            scope.stop = function () {
                scope.v.s = false;

            };


            scope.collapse = function () {
                scope.v.o = false;

            };



            var CSWATCHER = undefined;


            scope.$watch('data.x.p.CS.coils.Method', function (n) {
                console.log(n);
                if (!(isUndefined(n))) {
                    //if the method needs autocalibrations
                    switch (n.toLowerCase()) {
                        case 'simplesense':
                        case 'adaptive':
                        case 'bodycoil':
                            scope.data.x.p.Autocalibration = 0;
                            try {
                                CSWATCHER();
                            } catch (e) {

                            }
                            break;
                        case 'espiritaccelerated':
                        case 'espiritv1':
                        case 'bartsense':
                            scope.data.x.p.Autocalibration = 4;
                            CSWATCHER = scope.$watch("data.x.p.Autocalibration", function (x) {
                                if (x < 4) {
                                    scope.data.x.p.Autocalibration = 4;
                                }

                            }, true);
                            break;
                    }

                }
            }, true);

            scope.add = function (p) {
                //   console.log(p);
                var MYJSON = {
                    "N": getUIID(),
                    "name": "SENSE",
                    "id": 8,
                    "params": {
                        Type: "SENSE",
                        FlipAngleMap: p.FA.id,
                        SensitivityCalculationMethod: p.CS.coils.Method,
                        SaveCoils: p.CS.coils.SaveCoilSensivitities,
                        SourceCoilSensitivityMap: p.CS.coils.SourceCoilSensitivityMap,
                        SourceCoilSensitivityMapSmooth: p.CS.coils.SourceCoilSensitivityMapSmooth,
                        AccelerationF: p.AccelerationF,
                        AccelerationP: p.AccelerationP,
                        Autocalibration: p.Autocalibration,
                        GFactorMask: p.GFactorMask.id
                    },
                    "alias": p.alias
                };


                scope.list.push(MYJSON);

            };




            scope.changeACMMethods = function (XX, p) {

                if (typeof XX === 'string' || XX instanceof String) {
                    scope.data.XL = scope.f.removeJOB(XX, 'sense');

                } else {
                    //copy to dereferene
                    scope.add(jsonCopy(scope.data.x.p));

                }

            };


            scope.$watch("list", function (n) {
                //   console.log(n);
                if (!(isUndefined(scope.f.getJOB))) {
                    scope.data.XL = scope.f.getJOB('sense');
                    scope.resetDATA();
                }

            }, true);

            scope.$watch("w", function (n) {

                switch (n) {
                    case "reset":
                        scope.reset();
                        break;
                    case "stop":
                        scope.stop(scope.v);

                }
            }, true);



            $timeout(function () {
                //    console.log("ACM B1 CREATED");
                scope.init();
            }, 0);

        }
    }
}])

.directive('cmEspiritRecon', ["$timeout", function ($timeout) {
    return {
        restrict: 'ECA',
        scope: {
            w: "=",
            v: "=",
            f: "=",
            list: "="
        },
        template: TMPLmSENSE,

        link: function (scope, element, attrs) {


            scope.data = {
                x: {
                    p: {}
                }
            };

            scope.init = function () {

                scope.data.XL = [];
            }



            scope.resetDATA = function () {
                scope.data.x = {
                    p: {
                        FA: {
                            state: "selecting",
                            id: "no",
                            filename: undefined
                        },
                        GFactorMask: {
                            state: "selecting",
                            id: "no",
                            filename: undefined
                        },
                        CS: {
                            coils: {
                                Method: 'simplesense',
                                SourceCoilSensitivityMap: 'self',
                                SaveCoilSensivitities: false,
                                SourceCoilSensitivityMapSmooth: false
                            },
                            state: "selecting"
                        },
                        Decimate: false,
                        AccelerationF: 1,
                        AccelerationP: 1,
                        Autocalibration: 24,
                        alias: "ESPIRiT #" + scope.f.getHowManyJobsNotYetSentToCloud()
                    }
                }
            };




            scope.reset = function () {
                scope.v.o = true;
                scope.v.s = true;
                scope.v.title = "ESPIRiT";
                scope.v.icon = "fas fa-signature";
                scope.resetDATA();
            }




            scope.$watch("data.x.p.AccelerationF", function (x) {
                if (x < 1) {
                    scope.data.x.p.AccelerationF = 1;
                }
            }, true);

            scope.$watch("data.x.p.AccelerationP", function (x) {
                if (x < 1) {
                    scope.data.x.p.AccelerationP = 1;
                }

            }, true);


            scope.$watch("data.x.p.Autocalibration", function (x) {
                if (x < 4) {
                    scope.data.x.p.Autocalibration = 4;
                }

            }, true);


            scope.stop = function () {
                scope.v.s = false;

            };


            scope.collapse = function () {
                scope.v.o = false;

            };




            scope.add = function (p) {
                //   console.log(p);
                var MYJSON = {
                    "N": getUIID(),
                    "name": "ESPIRIT",
                    "id": 8,
                    "params": {
                        Type: "espirit",
                        FlipAngleMap: p.FA.id,
                        SensitivityCalculationMethod: p.CS.coils.Method,
                        SaveCoils: p.CS.coils.SaveCoilSensivitities,
                        SourceCoilSensitivityMap: p.CS.coils.SourceCoilSensitivityMap,
                        SourceCoilSensitivityMapSmooth: p.CS.coils.SourceCoilSensitivityMapSmooth,
                        AccelerationF: p.AccelerationF,
                        AccelerationP: p.AccelerationP,
                        Autocalibration: p.Autocalibration,
                        GFactorMask: p.GFactorMask.id
                    },
                    "alias": p.alias
                };


                scope.list.push(MYJSON);

            };




            scope.changeACMMethods = function (XX, p) {

                if (typeof XX === 'string' || XX instanceof String) {
                    scope.data.XL = scope.f.removeJOB(XX, 'espirit');

                } else {
                    //copy to dereferene
                    scope.add(jsonCopy(scope.data.x.p));

                }

            };


            scope.$watch("list", function (n) {
                //   console.log(n);
                if (!(isUndefined(scope.f.getJOB))) {
                    scope.data.XL = scope.f.getJOB('espirit');
                    scope.resetDATA();
                }

            }, true);

            scope.$watch("w", function (n) {

                switch (n) {
                    case "reset":
                        scope.reset();
                        break;
                    case "stop":
                        scope.stop(scope.v);

                }
            }, true);



            $timeout(function () {
                //    console.log("ACM B1 CREATED");
                scope.init();
            }, 0);

        }
    }
}])

.directive('cmBoneRecon', ["$timeout", function ($timeout) {
    return {
        restrict: 'ECA',
        scope: {
            w: "=",
            v: "=",
            f: "=",
            list: "="
        },
        template: TMPLB1,
        //        templateUrl: 'tmpl/myACMB1.html',
        link: function (scope, element, attrs) {




            scope.data = {
                x: {
                    p: {}
                }
            };

            scope.init = function () {

                scope.data.XL = [];

            }




            scope.resetDATA = function () {
                scope.data.x = {
                    p: {
                        FA: {
                            state: "selecting",
                            id: "no",
                            filename: undefined
                        },
                        CS: {
                            coils: {
                                Method: 'simplesense',
                                SourceCoilSensitivityMap: 'self',
                                SaveCoilSensivitities: false,
                                SourceCoilSensitivityMapSmooth: false
                            },
                            state: "selecting"
                        },
                        alias: "B1 #" + scope.f.getHowManyJobsNotYetSentToCloud()
                    }
                };
            };

            scope.reset = function () {
                scope.v.o = true;
                scope.v.s = true;
                scope.v.title = "B1-Weighted";
                scope.v.icon = "fas fa-signature";

                scope.resetDATA();
            }




            scope.stop = function () {
                scope.v.s = false;

            };


            scope.collapse = function () {
                scope.v.o = false;

            };




            scope.add = function (p, alias) {
                // console.log(p);
                var MYJSON = {
                    "N": getUIID(),
                    "name": "B1",
                    "id": 7,
                    "params": {
                        Type: "B1BART",

                        FlipAngleMap: p.FA.id,
                        SensitivityCalculationMethod: p.CS.coils.Method,
                        SaveCoils: p.CS.coils.SaveCoilSensivitities,
                        SourceCoilSensitivityMap: p.CS.coils.SourceCoilSensitivityMap,
                        SourceCoilSensitivityMapSmooth: p.CS.coils.SourceCoilSensitivityMapSmooth
                    },
                    "alias": p.alias
                };

                scope.list.push(MYJSON);

            };




            scope.changeACMMethods = function (XX, p) {

                if (typeof XX === 'string' || XX instanceof String) {
                    scope.data.XL = scope.f.removeJOB(XX, 'b1');

                } else {
                    //copy to dereferene
                    //console.log(scope.data.x.p);
                    scope.add(jsonCopy(scope.data.x.p));

                }

            };


            scope.$watch("list", function (n) {

                if (!(isUndefined(scope.f.getJOB))) {
                    scope.data.XL = scope.f.getJOB('b1');
                    scope.resetDATA();
                }

            }, true);

            scope.$watch("w", function (n) {

                switch (n) {
                    case "reset":
                        scope.reset();

                        break;
                    case "stop":
                        scope.stop(scope.v);


                }
            }, true);




            $timeout(function () {
                //    console.log("ACM B1 CREATED");
                scope.init();
            }, 0);

        }
    }
}])




.directive('myPmr', ["$timeout", function ($timeout) {
    return {
        restrict: 'E',
        scope: {
            w: "=",
            v: "=",
            f: "="
        },
        //        templateUrl: 'tmpl/myPMR.html',
        template: TMPLPMR,
        link: function (scope, element, attrs) {
            scope.data = {};
            scope.data.f = {};
            scope.data.NR = {};
            scope.init = function () {
                scope.data.state = "new";
                scope.data.LIST = [];
                //  console.log("PMR INIT");
                scope.data.f.getHowManyJobsNotYetSentToCloud = function (x) {

                    return scope.data.LIST.length;
                }



                scope.data.f.getJOB = function (x) {


                    if (x == 'all') {
                        return scope.data.LIST;
                    } else {
                        var X = [];
                        angular.forEach(scope.data.LIST, function (value, key) {
                            if (value.name.toLocaleLowerCase() == x) {
                                X.push(value);
                            }
                        });
                        return X;
                    }
                }

                scope.data.f.removeJOB = function (n, x) {
                    findAndRemove(scope.data.LIST, "N", n);
                    var t = scope.data.f.getJOB(x);
                    return t;

                };

            };

            $timeout(function () {
                //  console.log("ACM CREATED");
                scope.init();
            }, 0);


            scope.reset = function () {
                scope.data.LIST = [];

                scope.v.o = true;
                scope.v.s = true;
                scope.v.title = "Pseudo Multiple Replica";
                scope.v.icon = "glyphicon glyphicon-tasks";

                scope.data.subview = {
                    RSS: {
                        selected: false,
                        v: {
                            o: false,
                            s: false
                        },
                        w: ""
                    },
                    B1: {
                        selected: false,
                        v: {
                            o: false,
                            s: false
                        },
                        w: ""
                    },
                    SENSE: {
                        selected: false,
                        v: {
                            o: false,
                            f: false
                        },
                        w: ""
                    },
                    ESPIRIT: {
                        selected: false,
                        v: {
                            o: false,
                            f: false
                        },
                        w: ""
                    },
                    LD: {
                        selected: false,
                        v: {
                            o: false,
                            s: false
                        },
                        w: ""
                    },
                };
            };

            scope.$watch("data.subview.RSS.selected", function (n) {
                //  console.log(n);
                switch (n) {
                    case true:
                        scope.data.subview.RSS.w = "reset";
                        break;
                    case false:
                        scope.data.subview.RSS.w = "stop";

                }

            }, true);

            scope.$watch("data.subview.B1.selected", function (n) {
                //    console.log(n);
                switch (n) {
                    case true:
                        scope.data.subview.B1.w = "reset";
                        break;
                    case false:
                        scope.data.subview.B1.w = "stop";

                }

            }, true);

            scope.$watch("data.subview.SENSE.selected", function (n) {

                switch (n) {
                    case true:
                        scope.data.subview.SENSE.w = "reset";
                        break;
                    case false:
                        scope.data.subview.SENSE.w = "stop";

                }

            }, true);


            scope.$watch("data.subview.ESPIRIT.selected", function (n) {

                switch (n) {
                    case true:
                        scope.data.subview.ESPIRIT.w = "reset";
                        break;
                    case false:
                        scope.data.subview.ESPIRIT.w = "stop";

                }

            }, true);




            scope.$watch("w", function (n) {
                switch (n) {
                    case "reset":
                        scope.reset();
                        break;
                    case "stop":
                        scope.f.hideview(scope.v);


                }
            }, true);




        }
    }
}])




.directive('myPmrLoadData', ["cmTASK", "$timeout", "$q", "cmtool", "$interval", function (cmTASK, $timeout, $q, cmtool, $interval) {
    return {
        restrict: 'E',
        scope: {
            w: "=",
            v: "=",
            f: "=",
            list: "="
        },
        //        templateUrl: 'tmpl/myACMLD.html',
        template: TMPLACMLD,
        link: function (scope, element, attrs) {

            scope.data = {
                f: {},
                list: []
            };


            $interval(function () {
                cmTASK.getACMListOfData().then(function (o) {

                    scope.data.list = o;
                });

            }, 2000);

            //scope.$watch("data", function(o) { console.log(o); }, true);


            scope.defaultvalues = function () {
                scope.data.f = {
                    fn: { model: [], label: "Noise Data", statereset: "reset" },
                    fs: { model: [], label: "Signal Data", statereset: "reset" }
                }
                scope.data.list = [];
                scope.data.NR = 30;
            }




            scope.init = function () {
                scope.data.NOISE = "LN";
                scope.data.unebw = true;
                scope.defaultvalues();
                scope.user = cmTASK.getUserLog();

                cmTASK.getACMListOfData().then(function (o) {

                    scope.data.list = o;
                });

            }





            scope.reset = function () {
                scope.v.title = "Load Data and Start Calculation";
                scope.v.icon = "fas fa-database";
                scope.v.o = true;
                scope.v.s = true;

                scope.defaultvalues();

            }


            scope.open = function () {
                scope.v.title = "Load Data and Start Calculation";
                scope.v.icon = "fas fa-database";
                scope.v.o = true;
                scope.v.s = true;

            }


            scope.stop = function () {
                scope.v.s = false;

            };


            scope.collapse = function () {
                scope.v.o = false;

            };


            scope.removeTask = function (x) {
                scope.list = scope.f.removeJOB(x, 'all');
            };


            scope.$watch("list", function (n, o) {
                if (!(isUndefined(scope.v))) {
                    if (n.length == 0) {
                        scope.v.s = false;
                    } else {

                        scope.open();
                        if (n.length > 1) {
                            scope.JJ = "Queue Jobs";
                        } else {
                            scope.JJ = "Queue Job";
                        }
                    }
                } else {

                }
            }, true);




            scope.$watch("w", function (n) {

                switch (n) {
                    case "reset":
                        scope.reset();
                        break;
                    case "stop":
                        scope.stop(scope.v);

                }
            }, true);

            scope.$watch("data.f", function (x) {

                //console.log(x)
                //                if(isUndefined(scope.data.f.fs.id) || isUndefined(scope.data.f.fn.id)){
                if (isUndefined(scope.data.f.fs.model.id) || (scope.data.NOISE == "LN" && isUndefined(scope.data.f.fn.model.id))) {
                    scope.data.disabledState = true;

                } else {
                    scope.data.disabledState = false;
                }
            }, true);


            scope.$watch("data.NOISE", function () {

                //                if(isUndefined(scope.data.f.fs.id) || isUndefined(scope.data.f.fn.id)){
                if (isUndefined(scope.data.f.fs.model.id) || (scope.data.NOISE == "LN" && isUndefined(scope.data.f.fn.model.id))) {
                    scope.data.disabledState = true;

                } else {
                    scope.data.disabledState = false;
                }
            }, true);




            scope.insertjob = function () {


                var L = jsonCopy(scope.list);

                //fetch the tasks
                var promises = [];

                var myN = undefined;

                for (c = 0; c < L.length; c++) {
                    d = L[c].params;
                    if (scope.data.unebw) {
                        d.NBW = 1;
                    } else {
                        d.NBW = 0;
                    }

                    d.type = L[c].name;



                    d.signalData = scope.data.f.fs.model.id;


                    switch (scope.data.NOISE) {
                        case "LN":
                            d.NoiseFileType = "noiseFile";

                            d.noiseData = scope.data.f.fn.model.id;
                            break;
                        case "SN":
                            d.NoiseFileType = "selfSingle";

                            d.noiseData = scope.data.f.fs.model.id;
                            break;

                        case "MN":
                            d.NoiseFileType = "selfMulti";

                            d.noiseData = scope.data.f.fs.model.id;
                            break;
                    }

                    d.NR = scope.data.NR;

                    // TODO: this is hardcoded for test, the workflow is not correct now.
                    // the whole "d" is the jopt, and is written into a JSON file at vertebra/spinalnode
                    // See README for more detail.
                    // d.optionsFile = cmTASK.pmrOptionsFile;
                    // d.qServer = cmTASK.qServer;

                    data = {
                        'JobType': 'PMR',
                        'UID': cmTASK.logUID.UID,
                        'J': d,
                        'ACM': L[c].id,
                        'Alias': L[c].alias
                    }
                    cmTASK.postIt(cmTASK.taskUploadAPI, data).then((d) => {
                        // TODO Add remove task from scope.
                        console.log("Job sent");
                    });
                    promises.push(data)
                };

                $q.all(promises).then(function () {
                    if (promises.length > 1) {
                        alert("Jobs Queued");
                    } else {
                        alert("Job Queued");
                    }
                    scope.reset();
                });
            };

            $timeout(scope.init(), 0);

        }
    }
}])