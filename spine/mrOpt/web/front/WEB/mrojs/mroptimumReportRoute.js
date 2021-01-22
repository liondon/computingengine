function makeTableStatReport(px0, tid) {

    var v = document.getElementById(tid);
    v.innerHTML = "<table class='table table-striped' id='myTable'><thead class='thead-dark'><th scope='col'>Features</th><th scope='col'>Values</th></thead><tr><td scope='col'>Pixel Count</td><td>" + purgenan(px0).length + "</td></tr><tr><td scope='col'>Mean</td><td>" + average(purgenan(px0)).toFixed(2) + "</td></tr><td scope='col'>Median</td><td>" + median(purgenan(px0)).toFixed(2) + "</td></tr><tr><td scope='col'>Max</td><td>" + Math.max.apply(Math, purgenan(px0)).toFixed(2) + "</td></tr><tr><td scope='col'>Min</td><td>" + Math.min.apply(Math, purgenan(px0)).toFixed(2) + "</td></tr></table>"

};

function makeTableStatDIReport(px0, tid) {

    var v = document.getElementById(tid);
    v.innerHTML = "<table class='table table-striped' id='myTable'><thead class='thead-dark'><th scope='col'>Features</th><th scope='col'>Values</th></thead><tr><td scope='col'>Pixel Count</td><td>" + px0.n + "</td></tr><tr><td scope='col'>SNR</td><td>" + px0.v.toFixed(2) + "</td></tr></table>"

};

APP.config(
    ["$stateProvider", "$urlRouterProvider",
        function ($stateProvider, $urlRouterProvider) {

            //  $urlRouterProvider.otherwise("/mroptimum/home");
            $stateProvider



                .state("pmr", {
                    cache: false,
                    url: "/pmr",
                    templateUrl: "reportpages/reportPmr.html",
                    controller: "pmr"
                })

                .state("mr", {
                    cache: false,
                    url: "/mr",
                    templateUrl: "reportpages/reportMr.html",
                    controller: "mr"
                })
                .state("di", {
                    cache: false,
                    url: "/di",
                    templateUrl: "reportpages/reportDi.html",
                    controller: "di"
                })
                .state("acm", {
                    cache: false,
                    url: "/acm",
                    templateUrl: "reportpages/reportAcm.html",
                    controller: "acm"
                })
        } //urlprovider
    ]);

