// this is dor the NYU VM
//var WPATH="http://epmlcdcdvm01.nyumc.org";


var WPATH ="";
var QPATH= WPATH + "mroQ/";



//var uploadFTPMROPTDATAAPI = QPATH + "uploaderMROPTDATA.php";

var MROPTIMUM = angular.module("MROPTIMUM", ["ui.router", "angular.filter","ui.bootstrap","CM","MROPTIMUMDIRECTIVE","CMBDDRAWER","CMFU"]);

MROPTIMUM.config(function($httpProvider) {
    //Enable cross domain calls
    $httpProvider.defaults.useXDomain = true;

    //Remove the header used to identify ajax call  that would prevent CORS from working
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
});