//in this file we put all the variables needed for the app
var QPATH= 'http://back/';

var CAMRIE = angular.module("CAMRIE", ["ui.router", "angular.filter","ui.bootstrap","CM","CAMRIEDIRECTIVE","CMFU","CMBDDRAWER"]);

var PAGE='<div class="container-fluid"> <div class="container-fluid"> <div class="navbar navbar-fixed-top" > <div ui-view="m-header"> </div> </div> </div> <div class="container-fluid"> <div ui-view="m-taskbar" style="padding-top:50px;"> </div> <div ui-view="m-body" style="padding-top: 0px;"> </div> </div></div>';

var HEADERBAR='<div class="navbar navbar-inverse cmnavbar" > <div class="container-fluid"> <div class="navbar-header"><a href="#" class="navbar-left"><img src="ico/icobar.jpg" class="navbar-brand"></a> <a class="navbar-brand" ng-hide="USER.logged">CAMRIE </a> </div> <div class="navbar-header"> <a class="navbar-brand" ng-show="USER.logged" ui-sref="camrie.home">CAMRIE </a> </div> <ul class="nav navbar-nav" > <li><a ui-sref="camrie.abt">About</a> </li> <li><a ui-sref="camrie.cnt">Contact Us</a></li> <li><a ui-sref="camrie.bug" ng-show="USER.logged">Bug Report</a></li> </ul> <ul class="nav navbar-nav navbar-right"> <li ng-show="USER.logged"><a ui-sref="camrie.home"><span class="glyphicon glyphicon-user"></span> {{USER.name}}</a></li> <li ng-show="USER.admin"><a ui-sref="camrie.godmode"><span class="glyphicon glyphicon-plus"></span> Users Admin</a></li> <li ng-show="USER.logged"><a href="javascript:;" ng-click="logout()"><span class="glyphicon glyphicon-log-out" data-toggle="tooltip" title="{{usertooltip}}"></span> Logout</a></li> </ul> </div> </div>'

var CNT='<cm-contactus useremail="email" username="USER_name" sendfunction="send" msg="msg" subject="subject" to="to"></cm-contactus>';

var BUG='<cm-bugs  list="DATA.APPS" title="DATA.title" msg="DATA.msg" sendfunction="sendBug" resetfunction="reset" model="DATA.X" ></cm-bugs>';

CAMRIE.config(function($httpProvider) {
    //Enable cross domain calls
    $httpProvider.defaults.useXDomain = true;

    //Remove the header used to identify ajax call  that would prevent CORS from working
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
});