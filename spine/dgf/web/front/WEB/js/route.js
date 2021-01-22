DGF.config(
    ["$stateProvider", "$urlRouterProvider",
     function($stateProvider, $urlRouterProvider) {

         $urlRouterProvider.otherwise("/app/debug");
         $stateProvider

             .state("app", {
             cache: false,
             url:"/app",
             views:{
                 '':{
                     template: PAGE,
                 },
                 'm-header@app':{
                     template :HEADERBAR,
                     controller: "headerbar"
                 }


             },
             onEnter: function(){
                 console.log("Entering into DGF");
                 
             },
             onExit: function(){
                 console.log("Leaving the DGF");
                 
             }
         }
                   )






             .state("app.settings", {
             url: "/settings",
             views:{
                 'm-body@app':{
                     templateUrl: "tmpl/settings.html",
                     controller: "settings"

                 }

             }

         })


 
                           .state("app.results", {
             url: "/results/:ID/:u", 
             views:{
                 'm-body@app':{
                     templateUrl: "tmpl/results.html",
                     controller: "results"

                 }

             }

         })
     
     




     } //urlprovider
    ]);

