var CANVASSIZEW = 400;
var CANVASSIZEH = 400;


var COILSENSW = 1000;
var COILSENSH = 1000;






APP.controller('di', ["$scope", "$window", "drawingservice", "reportdata", "$rootScope", "mrosettings", function($scope, $window, service, reportdata, $rootScope, settings) {


    $scope.ROI = reportdata.getROI();
    $scope.Group = reportdata.getGroup();

    $scope.showGroup = false;


    $scope.$watch("Group", function(x) {

        if (isUndefined(x.objects)) {} else {
            if ($scope.Group.objects.length > 0) {

                $scope.showGroup = true;
            } else { $scope.showGroup = false; };
        }
    }, true);







    $rootScope.$watch(function() {
        MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
        return true;
    });










    $scope.DATA = reportdata.getDATA();
    $scope.JSONDATA = reportdata.getJSONDATA();


    $scope.imagetodraw = [];
    $scope.otherimagetodraw = {};

    var xl = getUIID();

    $scope.SNRTID = xl;




    var SL = $scope.DATA.imageinteractions.selectedSlice;
    var canvasTransform = reportdata.getCanvasTransform();


    $scope.articles = [{
            citeid: 1,
            autors: ["Kellman P", "McVeigh ER"],
            journal: "Magnetic Resonance in Medicine",
            pages: "p. 211-2",
            date: "2007",
            title: "Image reconstruction in SNR units: a general method for SNR measurement",

        },
        {
            citeid: 2,
            autors: ["Dietrich O", "Raya JG", "Reeder SB", "Reiser MF", "Schoenberg SO"],
            journal: "Journal of Magnetic Resonance Imaging",
            pages: "p. 2375-85",
            date: "2007",
            title: "Measurement of signal-to-noise ratios in MR images: influence of multichannel coils, parallel imaging, and reconstruction filters",

        },
        {
            citeid: 3,
            autors: ["Robson PM", "Grant AK", "Madhuranthakam AJ", "Lattanzi R", "Sodickson DK", "McKenzie CA"],
            journal: "Magnetic Resonance in Medicine, vol. 60(4)",
            pages: "p. 895-907",
            date: "2008",
            title: "Comprehensive quantification of signal-to-noise ratio and g-factor for image-based and k-space-based parallel imaging reconstructions",

        },
        {
            citeid: 4,
            autors: ["Wiens CN", "Kisch SJ", "Willig-Onwuachi JD", "McKenzie CA"],
            journal: "Magnetic Resonance in Medicine",
            pages: "1192-7",
            date: "2011",
            title: "Computationally rapid method of estimating signal-to-noise ratio for phased array image reconstructions",

        },
        {
            citeid: 5,
            autors: ["National Electrical Manufacturers Association (NEMA)"],
            journal: "NEMA Standards Publication MS 1‐2008 (R2014). Document ID: 100123",
            pages: "",
            date: "2011",
            title: "Determination of signal‐to‐noise ratio (SNR) in diagnostic magnetic resonance imaging",

        }
    ];








    var originandscale = getCanvasOriginAndScale($scope.DATA.Canvas, $scope.DATA.arrayData.w, $scope.DATA.arrayData.h);

    service.getImagedetailsfromName($scope.JSONDATA, 'Image 1', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(IM1) {
        service.getImagedetailsfromName($scope.JSONDATA, 'Image 2', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(IM2) {
            service.getImagedetailsfromName($scope.JSONDATA, 'Result Sum image', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR0) {
                service.getImagedetailsfromName($scope.JSONDATA, 'Result Difference Image', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR1) {
                    $scope.imagetodraw.push({ title: "Result Sum Image", arrayData: ARR0, transform: canvasTransform, ROI: true, LUT: $scope.DATA.viewinteractions.lut, di: { image0: IM1, image1: IM2 } });
                    $scope.imagetodraw.push({ title: "Result Difference Image", arrayData: ARR1, transform: canvasTransform, ROI: true, LUT: $scope.DATA.viewinteractions.lut, di: { image0: IM1, image1: IM2 } });
                    // console.log($scope.imagetodraw);
                })
            })

        });
    });




}]);

APP.controller('acm', ["$scope", "drawingservice", "reportdata", "$rootScope", "mrosettings", "$timeout", function($scope, service, reportdata, $rootScope, settings, $timeout) {
    var xl = getUIID();

    $scope.aSNRTID = xl;


    // console.log("start ACM");

    $scope.DATA = reportdata.getDATA();
    $scope.JSONDATA = reportdata.getJSONDATA();



    $scope.plotCoilsens = function() {

        var Subplot = subPlotShape($scope.otherimagetodraw.coils.length);


        var dataPlot = [];
        var layout = {
            title: 'Receive Coil Sensitivities',
            width: COILSENSW,
            height: COILSENSH,
            grid: { rows: Subplot.r, columns: Subplot.c, pattern: 'independent' },

            xaxis: {
                showgrid: true,
                zeroline: true,
                showline: true,
                showticklabels: false,

            },

            yaxis: {
                showgrid: true,
                zeroline: true,
                showline: true,
                showticklabels: false,

            }

        };




        Plotly.plot('coilsensitivityshow', dataPlot, layout);

        $scope.otherimagetodraw.coils.forEach(function(arrayofdata, index) {


            reshapemroptimumDataToD3heatmap(arrayofdata.arrayData.array, arrayofdata.arrayData.w, arrayofdata.arrayData.h).then(function(im) {

                if (index == 0) {
                    dataPlot.push({
                        z: im,
                        type: 'heatmap',
                        zmin: 0,
                        zmax: 1,
                        showscale: true,
                        //                                xaxis: 'x'+X_.x, 
                        xaxis: 'x' + (index + 1).toString(),
                        //                                yaxis: 'y'+X_.y,
                        yaxis: 'y' + (index + 1).toString(),
                        name: arrayofdata.title,
                        title: arrayofdata.title,
                        grid: { rows: Subplot.r, columns: Subplot.c, pattern: 'independent' },
                    });
                } else {
                    dataPlot.push({
                        z: im,
                        type: 'heatmap',
                        zmin: 0,
                        zmax: 1,
                        showscale: false,
                        //                                xaxis: 'x'+X_.x, 
                        xaxis: 'x' + (index + 1).toString(),
                        //                                yaxis: 'y'+X_.y,
                        yaxis: 'y' + (index + 1).toString(),
                        showticklabels: false,
                        name: arrayofdata.title,
                        title: arrayofdata.title,
                        grid: { rows: Subplot.r, columns: Subplot.c, pattern: 'independent' },
                    });

                }



                //                        set the axis property
                layout["xaxis" + (index + 1).toString()] = {
                    showgrid: true,
                    zeroline: true,
                    showline: true,
                    showticklabels: false,
                    tickwidth: 0

                };

                layout["yaxis" + (index + 1).toString()] = {
                    showgrid: true,
                    zeroline: true,
                    showline: true,
                    showticklabels: false,
                    tickwidth: 0,
                    autorange: "reversed"
                };


                Plotly.update('coilsensitivityshow', dataPlot, layout);

            });

        });
        //                 Plotly.plot('coilsensitivityshow', dataPlot, layout);  

    };


    $scope.ROI = reportdata.getROI();
    $scope.Group = reportdata.getGroup();


    $scope.showGroup = false;

    $scope.$watch("Group", function(x) {
        //console.log(x);
        if (isUndefined(x.objects)) {} else {
            if ($scope.Group.objects.length > 0) {

                $scope.showGroup = true;
            } else { $scope.showGroup = false; };
        }
    }, true);




    $rootScope.$watch(function() {
        console.log("LATEX a palla");
        MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
        return true;
    });













    $scope.imagetodraw = [];
    $scope.otherimagetodraw = {};





    var SL = $scope.DATA.imageinteractions.selectedSlice;
    var canvasTransform = reportdata.getCanvasTransform();



    if (getmrojsonType($scope.JSONDATA) == 'SENSE') {
        $scope.articles = [{
                citeid: 1,
                autors: ["Kellman P", "McVeigh ER"],
                journal: "Magnetic Resonance in Medicine",
                pages: "p. 211-2",
                date: "2007",
                title: "Image reconstruction in SNR units: a general method for SNR measurement",

            },
            {
                citeid: 2,
                autors: ["Dietrich O", "Raya JG", "Reeder SB", "Reiser MF", "Schoenberg SO"],
                journal: "Journal of Magnetic Resonance Imaging",
                pages: "p. 2375-85",
                date: "2007",
                title: "Measurement of signal-to-noise ratios in MR images: influence of multichannel coils, parallel imaging, and reconstruction filters",

            },
            {
                citeid: 3,
                autors: ["Robson PM", "Grant AK", "Madhuranthakam AJ", "Lattanzi R", "Sodickson DK", "McKenzie CA"],
                journal: "Magnetic Resonance in Medicine, vol. 60(4)",
                pages: "p. 895-907",
                date: "2008",
                title: "Comprehensive quantification of signal-to-noise ratio and g-factor for image-based and k-space-based parallel imaging reconstructions",

            },
            {
                citeid: 4,
                autors: ["Wiens CN", "Kisch SJ", "Willig-Onwuachi JD", "McKenzie CA"],
                journal: "Magnetic Resonance in Medicine",
                pages: "1192-7",
                date: "2011",
                title: "Computationally rapid method of estimating signal-to-noise ratio for phased array image reconstructions",

            },
            {
                citeid: 5,
                autors: ["National Electrical Manufacturers Association (NEMA)"],
                journal: "NEMA Standards Publication MS 1‐2008 (R2014). Document ID: 100123",
                pages: "",
                date: "2011",
                title: "Determination of signal‐to‐noise ratio (SNR) in diagnostic magnetic resonance imaging",

            }, {
                citeid: 6,
                autors: ["Pruessmann KP", "Weiger M", "Scheidegger MB", "Boesiger P"],
                journal: "Magnetic Resonance in Medicin",
                pages: "952-62",
                date: "1999",
                title: "SENSE: sensitivity encoding for fast MRI.",

            }
        ];


    } else {

        $scope.articles = [{
                citeid: 1,
                autors: ["Kellman P", "McVeigh ER"],
                journal: "Magnetic Resonance in Medicine",
                pages: "p. 211-2",
                date: "2007",
                title: "Image reconstruction in SNR units: a general method for SNR measurement",

            },
            {
                citeid: 2,
                autors: ["Dietrich O", "Raya JG", "Reeder SB", "Reiser MF", "Schoenberg SO"],
                journal: "Journal of Magnetic Resonance Imaging",
                pages: "p. 2375-85",
                date: "2007",
                title: "Measurement of signal-to-noise ratios in MR images: influence of multichannel coils, parallel imaging, and reconstruction filters",

            },
            {
                citeid: 3,
                autors: ["Robson PM", "Grant AK", "Madhuranthakam AJ", "Lattanzi R", "Sodickson DK", "McKenzie CA"],
                journal: "Magnetic Resonance in Medicine, vol. 60(4)",
                pages: "p. 895-907",
                date: "2008",
                title: "Comprehensive quantification of signal-to-noise ratio and g-factor for image-based and k-space-based parallel imaging reconstructions",

            },
            {
                citeid: 4,
                autors: ["Wiens CN", "Kisch SJ", "Willig-Onwuachi JD", "McKenzie CA"],
                journal: "Magnetic Resonance in Medicine",
                pages: "1192-7",
                date: "2011",
                title: "Computationally rapid method of estimating signal-to-noise ratio for phased array image reconstructions",

            },
            {
                citeid: 5,
                autors: ["National Electrical Manufacturers Association (NEMA)"],
                journal: "NEMA Standards Publication MS 1‐2008 (R2014). Document ID: 100123",
                pages: "",
                date: "2011",
                title: "Determination of signal‐to‐noise ratio (SNR) in diagnostic magnetic resonance imaging",

            }
        ];
    }


    var originandscale = getCanvasOriginAndScale($scope.DATA.Canvas, $scope.DATA.arrayData.w, $scope.DATA.arrayData.h);

    $scope.acmsettings = $scope.JSONDATA.settings;





    service.getImagedetailsfromName($scope.JSONDATA, 'Noise Covariance', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR0) {
        reshapemroptimumDataToD3heatmap(ARR0.array, ARR0.w, ARR0.h).then(function(im) {

            plotlyHeatmap(im, "Noise Covariance Matrix", CANVASSIZEW, CANVASSIZEH, "noisecovariance");
        });

    });


    service.getImagedetailsfromName($scope.JSONDATA, 'Noise Coefficients', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR0) {
        reshapemroptimumDataToD3heatmap(ARR0.array, ARR0.w, ARR0.h).then(function(im) {
            plotlyHeatmap(im, "Noise Coefficient Matrix", CANVASSIZEW, CANVASSIZEH, "noisecoefficient", 0, 1);
        });

    });



    service.getImagedetailsfromName($scope.JSONDATA, 'SNR Map', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR0) {
        $scope.SNR = { title: "SNR Map", arrayData: ARR0, transform: canvasTransform, ROI: false, LUT: $scope.DATA.viewinteractions.lut };

        makeTableStatReport(ARR0.array, $scope.aSNRTID);
    });









    getAvailableImagesAndData($scope.JSONDATA).then(function(the_images) {
        //console.log(the_images);
        if (isUndefined($scope.acmsettings.SaveCoils)) {


        } else {
            service.getImagedetailsfromName($scope.JSONDATA, 'Inverse g Factor', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR0) {
                reshapemroptimumDataToD3heatmap(ARR0.array, ARR0.w, ARR0.h).then(function(im) {

                    plotlyHeatmap(im, "Inverse g Factor", CANVASSIZEW, CANVASSIZEH, "igfactor", 0, 1);
                });
            });



            service.getImagedetailsfromName($scope.JSONDATA, 'g Factor', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR0) {
                reshapemroptimumDataToD3heatmap(ARR0.array, ARR0.w, ARR0.h).then(function(im) {
                    plotlyHeatmap(im, "g Factor", CANVASSIZEW, CANVASSIZEH, "gfactor");
                });
            });

            if ($scope.acmsettings.SaveCoils) {


                $timeout($scope.plotCoilsens, 300);


                findAndGetWithRegexpWithPromise(the_images, 'imageName', "Coil Sens.").then(function(x0) {

                    $scope.otherimagetodraw.coils = [];

                    x0.forEach(function(image, index) {


                        //                    service.getImagedetailsfromName($scope.JSONDATA,'SNR Map',parseInt(SL),$scope.DATA.imageinteractions.selectedValue).then(function(ARR0){
                        //                        $scope.SNR={title: "SNR Map",arrayData:ARR0,transform:canvasTransform,ROI:false,LUT:$scope.DATA.viewinteractions.lut};
                        //                        makeTableStat(ARR0.array,$scope.aSNRTID);
                        //                    });

                        service.parseImageDetails({ images: x0 }, index, parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR0) {
                            //console.log(ARR0);
                            $scope.otherimagetodraw.coils.push({ title: image.imageName, arrayData: ARR0, ROI: false });


                        });
                    });


                });


            } else {
                //console.log("no sensitivities");
            };

















        };












    });

}]);




APP.controller('pmr', ["$scope", "$window", "drawingservice", "reportdata", "$rootScope", "mrosettings", function($scope, $window, service, reportdata, $rootScope, settings) {




    $rootScope.$watch(function() {
        MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
        return true;
    });

    $scope.articles = [{
            citeid: 1,
            autors: ["Kellman P", "McVeigh ER"],
            journal: "Magnetic Resonance in Medicine",
            pages: "p. 211-2",
            date: "2007",
            title: "Image reconstruction in SNR units: a general method for SNR measurement",

        },
        {
            citeid: 2,
            autors: ["Dietrich O", "Raya JG", "Reeder SB", "Reiser MF", "Schoenberg SO"],
            journal: "Journal of Magnetic Resonance Imaging",
            pages: "p. 2375-85",
            date: "2007",
            title: "Measurement of signal-to-noise ratios in MR images: influence of multichannel coils, parallel imaging, and reconstruction filters",

        },
        {
            citeid: 3,
            autors: ["Robson PM", "Grant AK", "Madhuranthakam AJ", "Lattanzi R", "Sodickson DK", "McKenzie CA"],
            journal: "Magnetic Resonance in Medicine, vol. 60(4)",
            pages: "p. 895-907",
            date: "2008",
            title: "Comprehensive quantification of signal-to-noise ratio and g-factor for image-based and k-space-based parallel imaging reconstructions",

        },
        {
            citeid: 4,
            autors: ["Wiens CN", "Kisch SJ", "Willig-Onwuachi JD", "McKenzie CA"],
            journal: "Magnetic Resonance in Medicine",
            pages: "1192-7",
            date: "2011",
            title: "Computationally rapid method of estimating signal-to-noise ratio for phased array image reconstructions",

        },
        {
            citeid: 5,
            autors: ["National Electrical Manufacturers Association (NEMA)"],
            journal: "NEMA Standards Publication MS 1‐2008 (R2014). Document ID: 100123",
            pages: "",
            date: "2011",
            title: "Determination of signal‐to‐noise ratio (SNR) in diagnostic magnetic resonance imaging",

        }
    ];


    $scope.DATA = reportdata.getDATA();
    $scope.JSONDATA = reportdata.getJSONDATA();


    $scope.imagetodraw = [];
    $scope.otherimagetodraw = {};

    var xl = getUIID();

    $scope.SNRTID = xl;

    $scope.ROI = reportdata.getROI();
    $scope.Group = reportdata.getGroup();

    $scope.showGroup = false;
    $scope.$watch("Group", function(x) {
        //console.log(x);
        if (isUndefined(x.objects)) {} else {
            if ($scope.Group.objects.length > 0) {

                $scope.showGroup = true;
            } else { $scope.showGroup = false; };
        }
    }, true);

    var SL = $scope.DATA.imageinteractions.selectedSlice;
    var canvasTransform = reportdata.getCanvasTransform();


    //get the data fir the snr map

    service.getImagedetailsfromName($scope.JSONDATA, 'SNR Map', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR0) {
        reshapemroptimumDataToD3heatmap(ARR0.array, ARR0.w, ARR0.h).then(function(im) {

            $scope.SNR = { title: "SNR Map", arrayData: ARR0, transform: canvasTransform, ROI: false, LUT: $scope.DATA.viewinteractions.lut };

            makeTableStatReport(ARR0.array, $scope.SNRTID);
        });
    });


    //get the data fir the snr map
    service.getImagedetailsfromName($scope.JSONDATA, 'STD Image', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR0) {
        reshapemroptimumDataToD3heatmap(ARR0.array, ARR0.w, ARR0.h).then(function(im) {

            reshapemroptimumDataToD3heatmap(ARR0.array, ARR0.w, ARR0.h).then(function(im) {

                plotlyHeatmap(im, "Noise Image", CANVASSIZEW, CANVASSIZEH, "inoise");
            });
        });
    });


    var originandscale = getCanvasOriginAndScale($scope.DATA.Canvas, $scope.DATA.arrayData.w, $scope.DATA.arrayData.h);













}]);

APP.controller('mr', ["$scope", "$window", "drawingservice", "reportdata", "$rootScope", "mrosettings", function($scope, $window, service, reportdata, $rootScope, settings) {




    $rootScope.$watch(function() {
        MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
        return true;
    });

    $scope.articles = [{
            citeid: 1,
            autors: ["Kellman P", "McVeigh ER"],
            journal: "Magnetic Resonance in Medicine",
            pages: "p. 211-2",
            date: "2007",
            title: "Image reconstruction in SNR units: a general method for SNR measurement",

        },
        {
            citeid: 2,
            autors: ["Dietrich O", "Raya JG", "Reeder SB", "Reiser MF", "Schoenberg SO"],
            journal: "Journal of Magnetic Resonance Imaging",
            pages: "p. 2375-85",
            date: "2007",
            title: "Measurement of signal-to-noise ratios in MR images: influence of multichannel coils, parallel imaging, and reconstruction filters",

        },
        {
            citeid: 3,
            autors: ["Robson PM", "Grant AK", "Madhuranthakam AJ", "Lattanzi R", "Sodickson DK", "McKenzie CA"],
            journal: "Magnetic Resonance in Medicine, vol. 60(4)",
            pages: "p. 895-907",
            date: "2008",
            title: "Comprehensive quantification of signal-to-noise ratio and g-factor for image-based and k-space-based parallel imaging reconstructions",

        },
        {
            citeid: 4,
            autors: ["Wiens CN", "Kisch SJ", "Willig-Onwuachi JD", "McKenzie CA"],
            journal: "Magnetic Resonance in Medicine",
            pages: "1192-7",
            date: "2011",
            title: "Computationally rapid method of estimating signal-to-noise ratio for phased array image reconstructions",

        },
        {
            citeid: 5,
            autors: ["National Electrical Manufacturers Association (NEMA)"],
            journal: "NEMA Standards Publication MS 1‐2008 (R2014). Document ID: 100123",
            pages: "",
            date: "2011",
            title: "Determination of signal‐to‐noise ratio (SNR) in diagnostic magnetic resonance imaging",

        }
    ];


    $scope.DATA = reportdata.getDATA();
    $scope.JSONDATA = reportdata.getJSONDATA();


    $scope.imagetodraw = [];
    $scope.otherimagetodraw = {};

    var xl = getUIID();

    $scope.SNRTID = xl;


    $scope.ROI = reportdata.getROI();
    $scope.Group = reportdata.getGroup();

    $scope.showGroup = false;
    $scope.$watch("Group", function(x) {
        //console.log(x);
        if (isUndefined(x.objects)) {} else {
            if ($scope.Group.objects.length > 0) {

                $scope.showGroup = true;
            } else { $scope.showGroup = false; };
        }
    }, true);

    var SL = $scope.DATA.imageinteractions.selectedSlice;
    var canvasTransform = reportdata.getCanvasTransform();


    getAvailableImages($scope.JSONDATA).then(function(the_images) {



        var originandscale = getCanvasOriginAndScale($scope.DATA.Canvas, $scope.DATA.arrayData.w, $scope.DATA.arrayData.h);

        service.getImagedetailsfromName($scope.JSONDATA, 'SNR Map', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR0) {
            $scope.SNR = { title: "SNR Map", arrayData: ARR0, transform: canvasTransform, ROI: false, LUT: $scope.DATA.viewinteractions.lut };

            makeTableStatReport(ARR0.array, $scope.SNRTID);

        });

    });




    service.getImagedetailsfromName($scope.JSONDATA, 'Std Image', parseInt(SL), $scope.DATA.imageinteractions.selectedValue).then(function(ARR0) {
        reshapemroptimumDataToD3heatmap(ARR0.array, ARR0.w, ARR0.h).then(function(im) {

            plotlyHeatmap(im, "Image Noise", CANVASSIZEW, CANVASSIZEH, "inoise");
        })

    });






}]);

APP.controller('myCtrl', ["$scope", "$window", "drawingservice", "$state", "reportdata", function($scope, $window, service, $state, reportdata) {



    $scope.export = function() {
        html2canvas(document.getElementById('THEREPORT'), {
            onrendered: function(canvas) {
                var data = canvas.toDataURL();
                var docDefinition = {
                    content: [{
                        image: data,
                        width: 500,
                    }]
                };
                pdfMake.createPdf(docDefinition).download("test.pdf");
            }
        });
    }



    //we feed the service reportdata by collecting the json data, the user and the rois and then activate the transiction to the report state
    var thereportDATA = {};

    var thereportJSONDATA = {};

    var thereportROI = {};

    var thereportTransform = [];


    //    console.log($window.ROIS);
    //    console.log($window.DATA.ROI);  
    //    console.log($window.CANVASTRANSFORM);
    //    console.log($window.USER);
    //    console.log($window.JSONDATA);

    thereportDATA = jsonCopy($window.DATA);
    thereportROI = jsonCopy($window.DATA.ROI);
    thereportJSONDATA = jsonCopy($window.JSONDATA);
    thereportTransform = $window.CANVASTRANSFORM;
    $scope.USER = $window.USER;



    reportdata.setDATA(thereportDATA);
    reportdata.setJSONDATA(thereportJSONDATA);
    reportdata.setUSER($scope.USER);

    reportdata.setCanvasTransform(thereportTransform);


    thereportROI.forEach(function(o, index) {
        //        console.log(o);
        if (o.type != "group") {
            //                        block the rois 
            o.lockRotation = true;
            o.lockMovementX = true;
            o.lockMovementY = true;
            o.lockUniScaling = true;
            //            console.log($window.ROIS.objects[index].id);
            o.id = $window.ROIS.objects[index].id;
            reportdata.addROI(o);
        } else {
            // console.log("We have a group here :) with " + o.objects.length + " ROI ");
            if (o.objects.length > 0) {
                //reportdata.setGroup($window.DATA.ROI[index]);
                reportdata.setGroup(o);
                o.lockRotation = true;
                o.lockMovementX = true;
                o.lockMovementY = true;
                o.lockUniScaling = true;
            }

        }
    });





    switch (getmrojsonType(reportdata.getJSONDATA())) {
        case "PMR":
            $state.go("pmr");
            //console.log('transition to PMR  ');
            break;
        case "MR":
            $state.go("mr");
            //console.log('transition to MR  ');
            break;
        case "DI":
            $state.go("di");
            // console.log('transition to DI  ');
            break;
        case "RSS":
        case "RSSBART":
        case "B1":
        case "B1BART":
        case "SENSE":
        case "mSENSE":
        case "espirit":
            $state.go("acm");
            //console.log('transition to ACM  ');
            break;
    };



}])