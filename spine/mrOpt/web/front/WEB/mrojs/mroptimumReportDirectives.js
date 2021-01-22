var APP = angular.module('myApp', ["ui.router", "angular.filter", "ui.bootstrap", "CM", "MROPTIMUMDIRECTIVE", "CMBDDRAWER"])





.service('reportdata', ["$q", function($q) {
    this.DATA = {};
    this.JSONDATA = {}
    this.USER = {};
    this.ROI = [];
    this.GROUP = {};
    this.Transform = [];



    this.setCanvasTransform = function(DATA) {
        this.Transform = DATA;

    }

    this.getCanvasTransform = function() {
        return this.Transform;

    }

    this.setDATA = function(DATA) {
        this.DATA = DATA;

    }
    this.setJSONDATA = function(DATA) {

        this.JSONDATA = DATA;
        //console.log("JSONDATA set");
    }
    this.setUSER = function(DATA) {
        this.USER = DATA;
        //console.log("USER set");

    }

    this.getDATA = function() {
        return this.DATA;
    }
    this.getJSONDATA = function() {

        return this.JSONDATA;
    }
    this.getUSER = function() {
        return this.USER;
    }
    this.setROI = function(DATA) {
        console.log(DATA);
        this.ROI = DATA;
    }

    this.addROI = function(DATA) {
        // console.log("ROI " + DATA.id + " set");

        this.ROI.push(DATA);
    }
    this.getROI = function() {
        return this.ROI;
    }
    this.setGroup = function(DATA) {
        //console.log("GROUP set");

        this.GROUP = DATA;
    }

    this.getGroup = function() {

        return this.GROUP;
    }




}])








.directive('citeMroptimum', [function() {
    return {
        scope: {},
        template: '<div style="background-color: var(--NYUcolor01);border:1px;border-radius:25px;padding: 20px;"></br><div class="cmFontSubTitle" style="margin-top:0px" >Please cite our work</div><div class="cmText" style="padding-bottom:20px" ><cm-article-bibliography  autors="R.autors" title="R.title" date="R.date" journal="R.journal" pages="R.pages" ></cm-article-bibliography></div>',
        link: function(scope, element, attrs) {

            scope.R = {
                autors: ["Montin E", "Wiggins R", "Block KT", "Lattanzi R"],
                journal: "27th Scientific Meeting of the International Society for Magnetic Resonance in Medicine (ISMRM). Montreal (Canada), 11-16 May",
                date: "2019",
                pages: "p. 4617",
                title: "A web-based application for signal-to-noise ratio evaluation",
            }
        }
    }
}])


.directive('mroptimumReportSnrReference', [function() {
    return {
        scope: {
            articles: "="

        },
        template: '<div class="cmParagraph"><div class="cmFontTitle">References</div><cm-bibliography  articles="articles"></cm-bibliography></div>',
        link: function(scope, element, attrs) {


        }
    }
}])


.directive('mroptimumReportSnrHeading', [function() {
    return {
        scope: {
            user: "="
        },
        //        https://www.w3.org/Style/Examples/007/figures.en.html
        template: '<figure style="text-align: center;"><img width:100% src="mroico/icoMROPT.jpg" ><div class="cmFontTitle" style="margin-top:0.2em;">SNR Analysis Report</div>{{date}}</br><span class="cmlabel" >User: </span>{{user.name}} {{user.surname}}</figure>',
        link: function(scope, element, attrs) {

            scope.date = getmydate('mmNgg,YYYY');

        }

    }
}])


.directive('mroptimumReportSnrDefinition', [function() {
    return {
        template: '<div class="cmParagraph"><div class="cmText">The signal-to-noise ratio, or SNR, refers to the amount of signal seen in magnetic resonance (MR) images with respect to the amount of noise. The signal is generated by the nuclear spin magnetization. The noise can be generated by the patient, the MR unit, external forces, and equipment. Here we consider only thermal noise introduced during data acquisition. The principal source of thermal noise in most MR scans is the subject or object to be imaged, followed by noise introduced by the electronic components during the acquisition of the signal in the receiver chain. We assume that thermal noise is a zero-mean, spatially uncorrelated Gaussian process, with equal variance in both the real and imaginary parts. The same distribution is assumed for all the radiofrequency (RF) detector coils in a receive array.</div></div><div class="cmParagraph"><div class="cmText">The SNR is a metric used to describe the performance of MR systems, and is employed for the evaluation of image quality, image contrast enhancement, pulse sequence and RF coil comparison, and quality assurance. Various methods have been proposed to measure the SNR (1-5) of MR images.</div></div>'
    }
}])

.directive('mroptimumReportSnrAcknowledgement', [function() {
    return {
        template: '<div class="cmParagraph"><div class="cmFontTitle">Acknowledgements</div><div class="cmText">MR Optimum is part of <cloudmr-tag></cloudmr-tag>, a multi-year project that will develop a comprehensive software platform for the design and evaluation of radiofrequency coils for applications in magnetic resonance imaging. The goal of <cloudmr-tag></cloudmr-tag> is to integrate multiple software tools into a flexible package, with an intuitive, standardized web-based graphical user interface and a modular architecture, to allow straightforward creation of stand-alone applications and incorporation of additional software components.</div></div><div class="cmParagraph"><div class="cmText"><cloudmr-tag></cloudmr-tag> is supported by the <a href="https://www.nibib.nih.gov/" target="_blank">National Institute Of Biomedical Imaging And Bioengineering </a>of the National Institutes of Health under Award Number <span style="text-weight:bold">R01EB024536</span>. The content is solely the responsibility of the authors and does not necessarily represent the official views of the National Institutes of Health.</div></div>'
    }
}])


.directive('plotlyImshow', ["$timeout", "cmtool", "drawingservice", "mrosettings", function($timeout, cmtool, service, settings) {
    return {
        scope: {
            thedata: "=",
            size: "="
        },
        template: '<style>@import url({{CSS}});<p id="{{data.CID}}"></p>',
        link: function(scope, element, attrs) {

            scope.CSS = settings.getCss();

            scope.start = function() {
                var xxl = getUIID();

                var data = { CID: xxl };

                var layoutCOE = {
                    title: scope.title,
                    width: scope.size.width,
                    height: scope.size.height

                };

                var dataCOE = [];
                Plotly.plot(data.CID, dataCOE, layoutCOE);

                $timeout(scope.start, 100);

            };
            scope.draw = function() {

                reshapemroptimumDataToD3heatmap(scope.thedata.array, scope.thedata.arrayData.w, scope.thedata.arrayData.h).then(function(im) {


                    // console.log(data.CID);
                    dataCOE.push({
                        z: im,
                        type: 'heatmap',
                        //                                                        zmin:0,
                        //                                                        zmax:1,
                        showscale: true,
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
                    });


                    Plotly.update(data.CID, dataCOE, layoutCOE);



                });
            };



            $timeout(scope.start, 0);




        }
    }
}])


.directive('cmImshow', ["$timeout", "cmtool", "drawingservice", "mrosettings", function($timeout, cmtool, service, settings) {
    return {
        scope: {
            set: "=",
            thedata: "=",
            theroi: "=",
        },
        template: '<div class="mroLcontainerUW "><div class="mroLflexitem" ><canvas id="{{data.CID}}"></canvas></div><div class="mroLflexitem" ><canvas id="{{data.CLUT}}" ></canvas></div></div>',
        link: function(scope, element, attrs) {



            var CANVASSIZEW = 233;
            var CANVASSIZEH = 233;

            //            create a canvas
            var xx = getUIID();
            var xxl = getUIID();


            scope.data = {
                CID: xx,
                CLUT: xxl,
            };
            //                T:{
            //                    scale:scope.set.scale,
            //                    origin:scope.set.origin,
            //                    transform:[1, 0, 0, 1, 0, 0]}
            //            };







            scope.start = function() {
                scope.CSS = settings.getCss();

                scope.data.Canvas = new fabric.StaticCanvas(scope.data.CID, {
                    imageSmoothingEnabled: false,
                    width: CANVASSIZEW,
                    height: CANVASSIZEH

                });

                //                get canvas reference
                scope.thecanvas = scope.data.Canvas;

                scope.data.CanvasLUT = new fabric.StaticCanvas(scope.data.CLUT, {
                    imageSmoothingEnabled: true, // here you go
                    width: parseInt(CANVASSIZEW / 4),
                    height: CANVASSIZEH
                });


                scope.$watch("thedata", function(x) {
                    if (isUndefined(x)) {

                    } else {
                        scope.draw();
                        // console.log(scope.theroi);
                        if (isUndefined(scope.theroi)) {

                        } else {
                            $timeout(scope.drawROI, 200);
                        }
                    }
                }, true);


            }



            scope.draw = function() {
                //                console.log(scope.data.Canvas); 
                service.drawBackgroundInCanvas(scope.thedata.array, scope.thedata.h, scope.thedata.w, { Min: "0", Max: "0" }, "Gray", scope.data.Canvas);
                service.drawLegendInCanvas({ Min: "0", Max: "0" }, scope.thedata.array.GetMaxMin(), "gray", scope.data.CanvasLUT);
            }

            scope.drawROI = function() {
                //                console.log(scope.theroi);
                putRegiononCanvas(scope.theroi, scope.data.Canvas);
            }

            $timeout(scope.start, 0);





        }
    }
}])


.directive('cmImshowDi', ["$timeout", "cmtool", "drawingservice", "mrosettings", function($timeout, cmtool, service, settings) {
    return {
        scope: {
            set: "=",
            thedata: "=",
            theroi: "=",
            thegroup: "=",
            di: "=",
            transform: "=",
            lut: "="

        },
        template: '<div class="mroLcontainer"><div class="mroLflexitem"><div class="mroLcontainerUW "><div class="mroLflexitem" ><canvas id="{{data.CID}}" ></canvas></div><div class="mroLflexitem" ><canvas id="{{data.CLUT}}"></canvas></div></div></div><div class="mroRflexitem"><p id="{{data.HID}}" style="width: 30vh"></p></div><div class="mroRflexitem"><p id="{{data.TID}}"></p></div></div>',
        link: function(scope, element, attrs) {

            //            scope.CSS=settings.getCss();


            // console.log('start');

            var CANVASSIZEW = 233;
            var CANVASSIZEH = 233;

            //            create a canvas
            var x = getUIID();
            var xl = getUIID();
            var xx = getUIID();
            var xxl = getUIID();


            scope.data = {
                HID: x,
                TID: xl,
                CID: xx,
                CLUT: xxl,
            };








            scope.start = function() {
                scope.data.Canvas = new fabric.Canvas(scope.data.CID, {
                    imageSmoothingEnabled: false,
                    width: CANVASSIZEW,
                    height: CANVASSIZEH

                });

                //                get canvas reference
                scope.thecanvas = scope.data.Canvas;

                scope.data.CanvasLUT = new fabric.StaticCanvas(scope.data.CLUT, {
                    imageSmoothingEnabled: true, // here you go
                    width: parseInt(CANVASSIZEW / 4),
                    height: CANVASSIZEH
                });


                scope.$watch("thedata", function(x) {
                    // console.log(x);
                    if (isUndefined(x)) {

                    } else {
                        scope.draw();
                        if (!(isUndefined(scope.theroi))) {
                            $timeout(scope.drawROI, 200);
                        }

                        if (!(isUndefined(scope.thegroup))) {
                            $timeout(scope.drawGROUP, 200);
                        }

                    }
                }, true);


            }



            scope.draw = function() {
                // console.log(scope.data.Canvas); 
                service.drawBackgroundInCanvasWithOPT(scope.thedata.array, scope.thedata.h, scope.thedata.w, { Min: "0", Max: "0" }, scope.lut, scope.data.Canvas).then(function(ff) {

                });
                service.drawLegendInCanvas({ Min: "0", Max: "0" }, scope.thedata.array.GetMaxMin(), scope.lut, scope.data.CanvasLUT);
            }

            scope.drawROI = function() {

                // console.log(scope.theroi); 
                putRegiononCanvas(scope.theroi, scope.data.Canvas);

                $timeout(scope.hist, 100);

            }


            scope.drawGROUP = function() {
                //create the group
                var G = new fabric.Group();
                //add it to the canvas
                scope.data.Canvas.add(G).renderAll();


                G.lockRotation = true;
                G.lockMovementX = true;
                G.lockMovementY = true;
                G.lockUniScaling = true;

                //for each object in the group
                //scope.thegroup.getObjects().forEach(function(obj){
                scope.thegroup.objects.forEach(function(obj) {
                    // console.log(obj);

                    switch (obj.type) {
                        case 'circle':
                            var TT = new fabric.Circle(obj);

                            break;
                        case 'rect':
                            var TT = new fabric.Rect(obj);
                            break;
                        case 'polygon':
                            var TT = new fabric.Polygon(obj.points.slice(), obj);
                            break;



                    };



                    //add it to the group
                    //                    G.addWithUpdate(fromGroupCoordTocanvas(obj,G));
                    G.addWithUpdate(fromGroupCoordTocanvas(TT, scope.thegroup));

                    scope.data.Canvas.renderAll();
                });



                $timeout(scope.hist, 100);

            }


            scope.hist = function() {

                getCanvasOriginAndScale(scope.data.Canvas, scope.thedata.w, scope.thedata.h).then(function(canvasoriginandscale) {


                    var O = scope.data.Canvas.getObjects();


                    O.forEach(function(o) {
                        // console.log(o);
                        getROIData(scope.thedata, o, scope.data.Canvas, canvasoriginandscale.origin, canvasoriginandscale.scale, scope.data.Canvas.viewportTransform).then(function(y) {

                            if (isUndefined(scope.theroi)) {

                                makePlotlyHistogram(y, "GROUP", scope.data.HID);
                            } else {
                                makePlotlyHistogram(y, scope.theroi.id, scope.data.HID);
                            }
                            scope.data.Canvas.setViewportTransform(scope.transform);





                            getROIData(scope.di.image0, o, scope.data.Canvas, canvasoriginandscale.origin, canvasoriginandscale.scale, scope.data.Canvas.viewportTransform).then(function(firstimage) {
                                getROIData(scope.di.image1, o, scope.data.Canvas, canvasoriginandscale.origin, canvasoriginandscale.scale, scope.data.Canvas.viewportTransform).then(function(secondimage) {
                                    calculateDISNR(firstimage, secondimage).then(function(WW) {
                                        // console.log(WW);
                                        makeTableStatDIReport(WW, scope.data.TID);
                                    });

                                });
                            })
                        });
                    })
                })
            };




            $timeout(scope.start, 0);



        }
    }
}])


.directive('cmImshowWithHistogramAndCrop', ["$timeout", "cmtool", "drawingservice", "mrosettings", function($timeout, cmtool, service, settings) {
    return {
        scope: {
            set: "=",
            thedata: "=",
            theroi: "=",
            thegroup: "=",
            transform: "=",
            lut: "="
        },
        template: '<div class="mroLcontainer" style="align-items:center"><div class="mroLflexitem"><div class="mroLcontainerUW"><div class="mroLflexitem" ><canvas id="{{data.CID}}"></canvas></div><div class="mroLflexitem" ><canvas id="{{data.CLUT}}" ></canvas></div></div></div><div class="mroLflexitem" ><p id="{{data.HID}}" style="max-width: 30vh"></p></div><div class="mroLflexitem"  id="{{data.CCROP}}"></div><div class="mroLflexitem"  id="{{data.TID}}"></div></div>',
        link: function(scope, element, attrs) {



            var CANVASSIZEW = 233;
            var CANVASSIZEH = 233;

            //            create a canvas
            var x = getUIID();
            var xl = getUIID();
            var xx = getUIID();
            var xxl = getUIID();
            var xxx = getUIID();
            var xxxl = getUIID();


            scope.data = {
                HID: x,
                TID: xl,
                CID: xx,
                CLUT: xxl,
                CCROP: xxx,
                TID: xxxl,

            };
            //                T:{
            //                    scale:scope.set.scale,
            //                    origin:scope.set.origin,
            //                    transform:[1, 0, 0, 1, 0, 0]}
            //            };










            scope.start = function() {
                scope.CSS = settings.getCss();
                scope.data.Canvas = new fabric.Canvas(scope.data.CID, {
                    imageSmoothingEnabled: false,
                    width: CANVASSIZEW,
                    height: CANVASSIZEH

                });

                //                get canvas reference
                //                scope.thecanvas=scope.data.Canvas;

                scope.data.CanvasLUT = new fabric.StaticCanvas(scope.data.CLUT, {
                    imageSmoothingEnabled: true, // here you go
                    width: parseInt(CANVASSIZEW / 4),
                    height: CANVASSIZEH
                });

                //                scope.data.CanvasCrop = new fabric.Canvas(scope.data.CCROP,{
                //                    imageSmoothingEnabled: false,  
                //                    width:CANVASSIZEW,
                //                    height:CANVASSIZEH
                //
                //                });

                //                get canvas reference
                //                scope.thecanvas=scope.data.Canvas;
                //
                //                scope.data.CanvasCropLUT = new fabric.StaticCanvas(scope.data.CCROPLUT,{
                //                    imageSmoothingEnabled: true, // here you go
                //                    width:parseInt(CANVASSIZEW/4),
                //                    height:CANVASSIZEH
                //                });


                scope.$watch("thedata", function(x) {
                    if (isUndefined(x)) {

                    } else {
                        scope.draw();
                        if (!(isUndefined(scope.theroi))) {
                            $timeout(scope.drawROI, 200);
                        }

                        if (!(isUndefined(scope.thegroup))) {
                            $timeout(scope.drawGROUP, 200);
                        }

                    }
                }, true);


            }



            scope.draw = function() {
                //                console.log(scope.data.Canvas);
                service.drawBackgroundInCanvasWithOPT(scope.thedata.array, scope.thedata.h, scope.thedata.w, { Min: "0", Max: "0" }, scope.lut, scope.data.Canvas).then(function(ff) {

                });
                service.drawLegendInCanvas({ Min: "0", Max: "0" }, scope.thedata.array.GetMaxMin(), scope.lut, scope.data.CanvasLUT);
            }

            scope.drawROI = function() {

                putRegiononCanvas(scope.theroi, scope.data.Canvas);
                $timeout(scope.hist, 100);



                $timeout(scope.cropview, 30);


            }


            scope.drawGROUP = function() {
                // console.log(scope.thegroup);
                if (!isUndefined(scope.thegroup.objects)) {
                    //create the group
                    var G = new fabric.Group();
                    //add it to the canvas
                    scope.data.Canvas.add(G).renderAll();


                    G.lockRotation = true;
                    G.lockMovementX = true;
                    G.lockMovementY = true;
                    G.lockUniScaling = true;

                    //for each object in the group
                    //scope.thegroup.getObjects().forEach(function(obj){
                    scope.thegroup.objects.forEach(function(obj) {
                        // console.log(obj);

                        switch (obj.type) {
                            case 'circle':
                                var TT = new fabric.Circle(obj);

                                break;
                            case 'rect':
                                var TT = new fabric.Rect(obj);
                                break;
                            case 'polygon':
                                var TT = new fabric.Polygon(obj.points.slice(), obj);
                                break;



                        };



                        //add it to the group
                        //                    G.addWithUpdate(fromGroupCoordTocanvas(obj,G));
                        G.addWithUpdate(fromGroupCoordTocanvas(TT, scope.thegroup));
                        scope.data.Canvas.renderAll();
                    });

                }
                //require the crop view
                $timeout(scope.cropview, 30);

                $timeout(scope.hist, 100);

            }





            scope.cropview = function() {

                getCanvasOriginAndScale(scope.data.Canvas, scope.thedata.w, scope.thedata.h).then(function(canvasoriginandscale) {

                    // console.log(scope.data.Canvas.getObjects());

                    scope.data.Canvas.getObjects().forEach(function(o) {
                        var bound = o.getBoundingRect();


                        var NX = runITlength(bound.left, bound.width + bound.left, canvasoriginandscale.scale);
                        var NY = runITlength(bound.top, bound.height + bound.top, canvasoriginandscale.scale);
                        getROIImage(scope.thedata, o, scope.data.Canvas, canvasoriginandscale.origin, canvasoriginandscale.scale, scope.data.Canvas.viewportTransform).then(function(y) {

                            reshapemroptimumDataToD3heatmap(y, NY, NX).then(function(im) {
                                var m = average(y);
                                var s = std(y);
                                plotlyHeatmap(im, o.id, 300, 300, scope.data.CCROP, m - (2 * s), m + (2 * s));
                            });

                            //
                            //                            console.log(y);
                            //                            service.drawBackgroundInCanvasWithOPT(y,NY,NX,{Min:"0",Max:"0"},"Gray",scope.data.CanvasCrop).then(function(ff){
                            //
                            //                            });
                            //                            service.drawLegendInCanvas({Min:"0",Max:"0"},y.GetMaxMin(),"gray",scope.data.CanvasCropLUT);





                        });
                    });
                })
            };

            scope.hist = function() {



                getCanvasOriginAndScale(scope.data.Canvas, scope.thedata.w, scope.thedata.h).then(function(canvasoriginandscale) {


                    var O = scope.data.Canvas.getObjects();


                    O.forEach(function(o) {
                        getROIData(scope.thedata, o, scope.data.Canvas, canvasoriginandscale.origin, canvasoriginandscale.scale, scope.data.Canvas.viewportTransform).then(function(y) {
                            if (isUndefined(scope.theroi)) {

                                makePlotlyHistogram(y, "GROUP", scope.data.HID);
                            } else {
                                makePlotlyHistogram(y, scope.theroi.id, scope.data.HID);
                            }
                            scope.data.Canvas.setViewportTransform(scope.transform);

                            makeTableStatReport(y, scope.data.TID);



                        });
                    });
                })
            };




            $timeout(scope.start, 0);



        }
    }
}])







//            
//            getROIData(scope.thedata,scope.theroi,scope.data.Canvas,x.origin,x.scale,scope.data.Canvas.viewportTransform).then(function(y){console.log(y); makePlotlyHistogram(y,evt.target.id,scope.data.HISTOGRAM.id); makeTableStat(y,scope.data.TABLE.id);
//                                                                                                                                                
//            
//            
////            



function runITlength(a, b, f) {

    o = [];
    for (var yt = a; yt < b; yt += f) {
        o.push(1);

    };



    return o.length;

};




function arrayResultsDraw(px0, name, hid, tid) {

    makeHistOnHtml(px0, name, hid);
    //makeStat(px0);

};


//function makeHistOnHtml(px0,name,id){
//    if (px0!=undefined)
//    {
//        //        console.log(px0);
//        var trace = {
//            x: px0,
//            type: 'histogram',
//            name: 'pixel values'
//        };
//
//        var data = [trace];
//
//
//        //controllo roi
//        var layout = {
//            title: 'Histogram of the ROI ' + name,
//            xaxis: {
//                title: 'values',
//                titlefont: {
//                    family: 'Courier New, monospace',
//                    size: 18,
//                    color: '#7f7f7f'
//                }
//            },
//            yaxis: {
//                title: 'Pixel Count',
//                titlefont: {
//                    family: 'Courier New, monospace',
//                    size: 18,
//                    color: '#7f7f7f'
//                }
//            }
//        };
//
//
//        Plotly.newPlot(id, data,layout);
//
//
//
//
//    }
//
//}; 
//
//
//
//function makeStat(px0,tid){
//
//    var v = document.getElementById(tid);
//    v.innerHTML="<table class='table table-striped' id='myTable'><thead class='thead-dark'><th scope='col'>Features</th><th scope='col'>Values</th></thead><tr><td scope='col'>Pixel Count</td><td>" + purgenan(px0).length+ "</td></tr><tr><td scope='col'>Mean</td><td>" +  average(purgenan(px0)).toFixed(2)+ "</td></tr><td scope='col'>Median</td><td>" +median(purgenan(px0)).toFixed(2)+ "</td></tr><tr><td scope='col'>Max</td><td>" + Math.max.apply(Math,purgenan(px0)).toFixed(2)+ "</td></tr><tr><td scope='col'>Min</td><td>" +  Math.min.apply(Math,purgenan(px0)).toFixed(2)+ "</td></tr></table>"
//
//};















function makePolygon(X) {
    return new fabric.Polygon(X.points.slice(), X);
};



var getROIImage = function(data, roi, canvas, canvasOrigin, canvasScale, vpTransform) {
    //get the bounding box of the object in canvas   
    return new Promise(function(resolve) {
        var bound = roi.getBoundingRect();

        var P = {};
        P.bound = bound;
        P.ALL = this;

        //    console.log(canvasScale);
        //    console.log(bound);
        //    var width=data.h;
        var width = data.w;
        //    var height=data.w;
        var height = data.h;

        var px0 = [];
        var arr = data.array;

        var pos;

        //console.log(data);

        Origin = canvasOrigin;
        var F = canvasScale; //myFabric.scaleF;

        // console.log(F);
        var c = 0;
        var xi, yi;
        //point to canvas transformation
        var mInverse = fabric.util.invertTransform(vpTransform); //myFabric.Canvas.viewportTransform


        //    console.log(canvas);

        //this can be rasterize bc are real point in the image
        for (var yt = bound.top; yt < bound.top + bound.height; yt += F) {
            for (var xt = bound.left; xt < bound.left + bound.width; xt += F) {
                //points in the canvas
                var myP = new fabric.Point(xt, yt);
                // console.log(myP);

                //on the image worlfd
                var ps = fabric.util.transformPoint(myP, mInverse);

                if (c == 0) {
                    c++
                };

                if (canvas.isTargetTransparent(roi, xt, yt)) {
                    px0.push(NaN);

                } else {
                    xi = (ps.x / F) - Origin.x;
                    yi = (ps.y / F) - Origin.y;

                    pos = ((width * Math.round(yi)) + Math.round(xi));

                    px0.push(arr[pos]);
                    //                            console.log("in");
                }
            }


        };

        resolve(px0);
    });
};





function plotlyHeatmap(im, title, width, height, ID, min, max) {

    var layoutCOE = {
        title: title,
        width: width,
        height: height,
        yaxis: {
            autorange: "reversed"
        }

    };
    var dataCOE = [];
    Plotly.plot(ID, dataCOE, layoutCOE);

    var thedata = {
        z: im,
        type: 'heatmap',
        showscale: true,
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
    }

    if (!(isUndefined(min))) {
        thedata.zmin = min;
    }
    if (!(isUndefined(max))) {
        thedata.zmax = max;
    }

    dataCOE.push(thedata);
    Plotly.update(ID, dataCOE, layoutCOE);




}