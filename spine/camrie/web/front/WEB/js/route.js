

CAMRIE.config(
    ["$stateProvider", "$urlRouterProvider",
     function($stateProvider, $urlRouterProvider) {

         $stateProvider

             .state("camrie", {
             cache: false,
             url:"/camrie",
             views:{
                 '':{
                     template: PAGE,
                 },
                 'm-header@camrie':{
                     template :HEADERBAR,
                     controller: "headerbar"
                 }


             },
             onEnter: function(){
                 console.log("Entering into CAMRIE");
                 
             },
             onExit: function(){
                 console.log("Leaving the CAMRIE");
                 
             }
         }
                   )






             .state("camrie.settings", {
             url: "/settings",
             views:{
                 'm-body@camrie':{
                     templateUrl: "tmpl/settings.html",
                     controller: "settings"

                 }

             }

         })

         .state("camrie.results", {
            url: "/results",
            views:{
                'm-body@camrie':{
                    templateUrl: "tmpl/results.html",
                    controller: "results"

                }

            }

        })









     } //urlprovider
    ]);

