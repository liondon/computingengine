//var HEAEDERBAR=' <div class="navbar navbar-inverse cmnavbar" > <div class="container-fluid"> <div class="navbar-header"> <a class="navbar-brand" ng-hide="USER.logged">MR Optimum </a> </div> <div class="navbar-header"> <a class="navbar-brand" ng-show="USER.logged" ui-sref="mroptimum.home">MR Optimum </a> </div> <ul class="nav navbar-nav" > <li><a ui-sref="mroptimum.abt">About</a> </li> <li><a ui-sref="mroptimum.cnt">Contact Us</a></li> <li><a ui-sref="mroptimum.bug" ng-show="USER.logged">Bug Report</a></li> </ul> <ul class="nav navbar-nav navbar-right"> <li ng-show="USER.logged"><a ui-sref="mroptimum.home"><span class="glyphicon glyphicon-user"></span> {{USER.name}}</a></li> <li ng-show="USER.admin"><a ui-sref="mroptimum.godmode"><span class="glyphicon glyphicon-plus"></span> Users Admin</a></li> <li ng-show="USER.logged"><a href="javascript:;" ng-click="logout()"><span class="glyphicon glyphicon-log-out" data-toggle="tooltip" title="{{usertooltip}}"></span> Logout</a></li> </ul> </div> </div>';

var MROABT = '<div class="container"> <div class="row"> <div class="col-md-1"></div> <div class="cmParagraph"> <div class="cmFontTitle">MR Optimum</div> <div class="cmText"> <span class="cloudmrTag">MR optimum</span> is a web-based application for the evaluation of MR image quality in terms of signal-to-noise ratio (SNR). It provides a standardized access to the most common methods for SNR calculation. </div> </div> <div class="cmParagraph"> <div class="cmFontTitle">Developers</div> <div class="cmText"> <a href="https://med.nyu.edu/faculty/riccardo-lattanzi" target="_blank">Riccardo Lattanzi, PhD</a>; <a href="http://cai2r.net/people/eros-montin" target="_blank">Eros Montin, PhD</a>; <a href="http://cai2r.net/people/roy-wiggins" target="_blank">Roy Wiggins</a>; </div> </div> <div class="cmParagraph"> <div class="cmFontTitle">Documentation</div> <div class="cmText"> Our C++ sources with annotated Doxygen documentation are available <a href="http://cloudmrhub.com/apps/MROPTIMUM/doxy/" target="_blank">here</a>. User manuals and video tutorials will be available in the future. </div> </div> <div class="cmParagraph"> <div class="cmFontTitle">Acknowledgements</div> <div class="cmText"> MR optimum is based on HTML 5, JavaScript, CSS, PhP/MySQL and uses the following open source libraries. <ul style="list-style-type:none;-webkit-padding-start: 0;padding-left: 0;"> <li> <a href="https://angularjs.org" target="_blank">Angular JS</a> JavaScript MVW Framework</li> <li><a href="http://fabricjs.com" target="_blank">Fabric.js</a> JavaScript Canvas Library </li> <li><a href="https://plotly.com/javascript/" target="_blank">Plotly </a> Plotly JavaScript Graphing Library </li> <li><a href="https://itk.org" target="_blank">ITK </a> Insight Toolkit</li> <li><a href="http://ismrmrd.github.io" target="_blank">ISMRMRD </a> ISMRM Raw Data Format</li> <li><a href="https://mrirecon.github.io/bart/" target="_blank">BART </a> The Berkeley Advanced Reconstruction Toolbox</li> </ul> </div> </div> <div class="cmParagraph"> <div class="cmFontTitle">Funding Support</div> <div class="cmText"> MR optimum is available through the <cloudmr-tag-External></cloudmr-tag-External> software application framework. Research reported in this website is supported by the <a href="https://www.nibib.nih.gov/" target="_blank">National Institute Of Biomedical Imaging And Bioengineering </a>of the National Institutes of Health under Award Number <span style="text-weight:bold">R01EB024536</span>. The content is solely the responsibility of the authors and does not necessarily represent the official views of the National Institutes of Health. </div> <div class="cmParagraph"> <div style="height:64px;margin-top: 0.2em;"> <img src="http://cloudmrhub.com/img/NIH.png" style="height: 100%;width:auto;display: block;" /> </div> </div> </div> </div> <div class="col-md-1"></div></div>'


{ /* <div class="row" style="margin:1em"> <button ng-click="AGGIUNGILI()" class="btn cmButton" title="load the default data"> <i class="fas fa-plus"></i> Default Data</button> </div> */ }

var MROHOME = '<div class="container"> <cm-taskbar states="states" model="{{selectedstate}}"></cm-taskbar> <uib-accordion> <div uib-accordion-group class="panel-default" is-open="FILE.v.o" ng-show="FILE.v.s" data-toggle="tooltip" data-placement="top"> <cm-uib-accordion-heading h="FILE.v"></cm-uib-accordion-heading> <ul> <li class="list-group-item">  <div class="row"> <div class="progress" style="margin:1em"> <div id="g" ng-class="{\'progress-bar progress-bar-striped progress-bar-warning active\': total.p>50 , \'progress-bar progress-bar-success progress-bar-striped active\': total.p<=50,\'progress-bar progress-bar-striped progress-bar-danger active\': total.p>80}" role="progressbar" aria-valuenow="{{total.p}}" aria-valuemin="0" aria-valuemax="100" style="width:{{total.p}}%"> {{total.p.toFixed(0)}} % </div> </div> </div> </li> <li class="list-group-item"> <cm-action-table caption="My Data" style="padding-top: 1em" list="TABLEDATA" functions="TABLEDATAFUNCTIONS" visible="TABLEDATAVISIBLE"></cm-action-table> </li> <li class="list-group-item"> <cm-action-table caption="My ROIs" style="padding-top: 1em" list="TABLEROIS" functions="TABLEROISFUNCTIONS" visible="TABLEROISVISIBLE"></cm-action-table> </li> <li class="list-group-item"> <cm-action-table caption="My Results" style="padding-top: 1em" list="TABLERESULTS" functions="TABLERESULTSFUNCTIONS" visible="TABLERESULTSVISIBLE"></cm-action-table> </li> </ul> </div> </uib-accordion> <uib-accordion ng-show=false> <div uib-accordion-group class="panel-default" is-open="RESULTS.v.o" ng-show="RESULTS.v.s" data-toggle="tooltip" data-placement="top"> <cm-uib-accordion-heading h="RESULTS.v"></cm-uib-accordion-heading> <ul > <li class="list-group-item" > <cm-action-table caption="Latest Activities" style="padding-top: 1em" list="TABLEJOBS" functions="TABLEJOBSFUNCTIONS" visible="TABLEJOBSVISIBLE"></cm-action-table> </li> </ul> </div> </uib-accordion></div>';

var MROSETTINGS = '<div class="container" ng-hide=USER.allow> I am sorry you still need to activate your account.You should received an email with a link.If you have further questions please contact us</div><div class="container" ng-show=USER.allow> <cm-taskbar states="states" model="{{selectedstate}}"></cm-taskbar> <choose-snr-methods snrmethods="SNRmethods" v="SNRmethods.VIEWS.main"></choose-snr-methods>  <my-di w="DI" v="SNRmethods.VIEWS.di" f="SNRmethods.functions"></my-di> <my-acm w="ACM" v="SNRmethods.VIEWS.acm" f="SNRmethods.functions"></my-acm> <my-mr w="MR" v="SNRmethods.VIEWS.mr" f="SNRmethods.functions"></my-mr> <my-pmr w="PMR" v="SNRmethods.VIEWS.pmr" f="SNRmethods.functions"></my-pmr> </div>';

var PAGE = '<div class="container-fluid"> <div class="container-fluid"> <div class="navbar navbar-fixed-top" > <div ui-view="m-header"> </div> </div> </div> <div class="container-fluid"> <div ui-view="m-taskbar" style="padding-top:50px;"> </div> <div ui-view="m-body" style="padding-top: 0px;"> </div> </div></div>';

var HEADERBAR = '<div class="navbar navbar-inverse cmnavbar" > <div class="container-fluid"> <div class="navbar-header"><a href="#" class="navbar-left"><img src="mroico/bar.png" class="navbar-brand"  style="filter:contrast(50%) brightness(150%);padding-top:5px;padding-bottom:10px"></a> <a class="navbar-brand" ng-hide="USER.logged">MR Optimum </a> </div> <div class="navbar-header"> <a class="navbar-brand" ng-show="USER.logged" ui-sref="mroptimum.home">MR Optimum </a> </div> <ul class="nav navbar-nav" > <li><a ui-sref="mroptimum.abt">About</a> </li> <li><a ui-sref="mroptimum.cnt">Contact Us</a></li> <li><a ui-sref="mroptimum.bug" ng-show="USER.logged">Bug Report</a></li> </ul> <ul class="nav navbar-nav navbar-right"> <li ng-show="USER.logged"><a ui-sref="mroptimum.home"><span class="glyphicon glyphicon-user"></span> {{USER.name}}</a></li> <li ng-show="USER.admin"><a ui-sref="mroptimum.godmode"><span class="glyphicon glyphicon-plus"></span> Users Admin</a></li> <li ng-show="USER.logged"><a href="javascript:;" ng-click="logout()"><span class="glyphicon glyphicon-log-out" data-toggle="tooltip" title="{{usertooltip}}"></span> Logout</a></li> </ul> </div> </div>'




var CNT = '<cm-contactus useremail="email" username="USER_name" sendfunction="send" msg="msg" subject="subject" to="to"></cm-contactus>';

var BUG = '<cm-bugs  list="DATA.APPS" title="DATA.title" msg="DATA.msg" sendfunction="sendBug" resetfunction="reset" model="DATA.X" ></cm-bugs>';


MROPTIMUM.config(
    ["$stateProvider", "$urlRouterProvider",
        function ($stateProvider, $urlRouterProvider) {

            $urlRouterProvider.otherwise("/mroptimum/home");
            $stateProvider



                .state("mroptimum", {
                    cache: false,
                    url: "/mroptimum",
                    views: {
                        '': {
                            template: PAGE,
                        },
                        'm-header@mroptimum': {
                            template: HEADERBAR,
                            controller: "headerbar"
                        }


                    }
                })

                .state("mroptimum.settings", {
                    url: "/settings",
                    views: {
                        'm-body@mroptimum': {
                            template: MROSETTINGS,
                            controller: "settings"

                        }

                    }

                })

                .state("mroptimum.results", {
                    url: "/results/:ID/:u",
                    views: {
                        'm-body@mroptimum': {

                            template: "<div class=\"container-fluid\"> <cm-taskbar states=\"states\" model=\"{{selectedstate}}\"></cm-taskbar> <cm-results-queue jsondata=\"jsondata\" conf=\"conf\" resultsid=\"JID\"></cm-results-queue> <cm-results-display jsondata=\"jsondata\" conf=\"conf\"></cm-results-display> </div>",
                            controller: "results"

                        }

                    }

                })


                .state("mroptimum.home", {
                    url: "/home",
                    views: {
                        'm-body@mroptimum': {
                            template: MROHOME,
                            controller: "home"

                        }

                    }

                })


                .state("mroptimum.start", {
                    url: "/start/:u",
                    views: {
                        'm-body@mroptimum': {
                            template: MROHOME,
                            controller: "start"

                        },


                    },
                    onEnter: function () {
                        // console.log("Entering into MROPTIMUM HOME");
                        // cmtool.loading(true);
                    },
                    onExit: function () {
                        //console.log("Leaving the MROPTIMUM HOME");

                    }

                })

                .state("mroptimum.debug", {
                    url: "/debug",
                    views: {
                        'm-body@mroptimum': {
                            template: MROHOME,
                            controller: "fakehome"

                        }

                    }

                })


                .state("mroptimum.bug", {
                    url: "/bug",
                    views: {
                        'm-body@mroptimum': {
                            template: BUG,
                            controller: "bug"

                        }

                    }

                })

                .state("mroptimum.fake", {
                    url: "/fake",
                    views: {
                        'm-body@mroptimum': {
                            template: MROHOME,
                            controller: "fakehome"

                        }

                    }

                })

                .state("mroptimum.abt", {
                    url: "/abt",
                    views: {
                        'm-body@mroptimum': {
                            template: MROABT

                        }

                    }

                })
                .state("mroptimum.cnt", {
                    url: "/cnt",
                    views: {
                        'm-body@mroptimum': {
                            template: CNT,
                            controller: "cnt"

                        }

                    }

                })









        } //urlprovider
    ]);