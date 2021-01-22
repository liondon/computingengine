var ROIWHATSAVEANDLOAD = ["id", "typeOF", "visible", "groupped"];
//max-width:{{Math.ceil(1.4*canvassizew/214)*250}}px
var DISPLAY = '<div class="cmLcontainer" style="align-items:stretch"> <div class="cmLflexitem" style="width:{{Math.ceil(1.4*canvassizew/233)*(233+89-55)}}px;min-width:{{1.1*canvassizeh}}"> <ul class="list-group"> <li class="list-group-item"> <div class="cmLflexitem"> <cm-viewer-display snapshotname="{{data.snapshotname}}" jsondata="jsondata" data="TMP" canvassizew={{canvassizew}} canvassizeh={{canvassizeh}} actionbuttons="data.actionbuttons" reportfunction="reportfunction"></cm-viewer-display> </div> </li> </ul> </div> <div class="cmLflexitem"> <ul class="list-group"> <li class="list-group-item"> <div class="cmLflexitem" style="width:{{377+377+34+34}}px;"> <cm-roi-display jsondata="jsondata" data="TMP" usermovingfunction="data.usermovingfunction" userroiupload="data.userroiupload" userroiget="data.userroiget"></cm-roi-display> </div> </li> </ul> </div></div>';


var VIEWERDISPLAY = '<div class="cmRcontainerLeft"> <div class="cmRflexitem"> <div class="cmLcontainer"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB "><span class="cmFontSubTitle">{{data.thetitle}}</span></div> </div> </div> <div class="cmRflexitem"> <div class="cmLcontainer"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cminputElement"> <cm-select-input label="Data" model="data.imageinteractions.selectedImage" list="available.Images" optionsvaluesfield="id" fieldsshow="imageName"></cm-select-input> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cminputElement"> <cm-select-input label="Value" model="data.imageinteractions.selectedValue" list="available.Value" optionsvaluesfield="v" fieldsshow="n"></cm-select-input> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cminputElement"> <cm-select-input label="Slice" model="data.imageinteractions.selectedSlice" list="available.Slices" optionsvaluesfield="id" fieldsshow="name"></cm-select-input> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cminputElement"> <cm-select-input label="Color Map" model="data.viewinteractions.lut" list="available.COLORMAP" optionsvaluesfield="iName" fieldsshow="eName"></cm-select-input> </div> </div> </div> <div class="cmRflexitem"> <div class="cmLcontainerUW " style="min-width: {{1.3*canvassizew}}px;min-height: {{canvassizeh}}px;margin-top:13px;margin-bottom:21px"> <div class="cmLflexitem"> <canvas id="xviewerx"></canvas> </div> <div class="cmLflexitem"> <canvas id="xviewerxL"></canvas> </div> </div> </div> <div class="cmRflexitem"> <div class=cmLcontainer> <button ng-click="data.functions.PAN()" class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cmFlatbuttons" title="move the image"><span class="fas fa-hand-paper fa-2x"></span></button> <button ng-click="data.functions.restetTransform()" class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cmFlatbuttons" title="reset the transformation"><i class="fas fa-compress fa-2x"></i></button> <button cm-screenshot="data.functions.getViewName()" class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cmFlatbuttons" saveas="{{snapshotname}}" canvasid="xviewerx" legendid="xviewerxL" title="save a snapshot"><i class="fas fa-camera fa-2x"></i></button> <button ng-if="reportbutton" ng-click="data.functions.getReport()" class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cmFlatbuttons"><i class="fas fa-file-alt fa-2x"></i></button> <button ng-repeat="b in actionbuttons" ng-click="b.function()" class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cmFlatbuttons"><span ng-class="b.icon" title="{{b.tootlip}}"></span></button> </div> </div> <div class="cmRflexitem"> <div class=cmLcontainer> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cminputElement"> <cm-slider-input label="Min" model="data.viewinteractions.Min" min="0" max="255"></cm-slider-input> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cminputElement"> <cm-slider-input label="Max" model="data.tmp.FMax" min="0" max="255"></cm-slider-input> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cminputElement"> <cm-slider-input label="Zoom" model="data.transform.Zoom" min="10" max="400"></cm-slider-input> </div> <!-- <div class="cmRflexitem"> <div class="cmLcontainer"> <div ng-repeat="(key, value) in jsondata.settings"> <div class="cmLflexitem"><span class="cmlabel"> {{key}}:</span><span class="cmlabel"> {{value}}</span></div> </div> </div> </div> --> </div> </div></div>';






var CMROIDISPLAY = '<style> .table-wrapper-scroll-y { display: block; max-height: 277px; overflow-y: auto; -ms-overflow-style: -ms-autohiding-scrollbar; }</style><div class="cmLcontainer"> <div class="cmLflexitem" style="width:377"> <div class="cmRcontainerLeft"> <div class="cmRflexitem cmMarginSpaceLR cmMarginSpaceTB"> <div class="cmLcontainer"> <button ng-click="addRoi(\'rect\')" class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cmFlatbuttons" title="add Rect Region"> <i class="far fa-square fa-2x "></i></button> <button ng-click="addRoi(\'circle\')" class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cmFlatbuttons" title="add Circle Region"> <i class=" far fa-circle fa-2x "></i></button> <button ng-click="addRoi(\'polygon\')" class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cmFlatbuttons" title="add a Poligonal Region"> <i class=" fas fa-draw-polygon fa-2x "></i></button> </div> </div> <div class="cmRflexitem cminputElement cmMarginSpaceLR cmMarginSpaceTB"> <div class="cmLcontainer"> <div class="cmLflexitem cmMarginSpaceLR"> <input ng-click="exoploreCanvas()" ng-model="data.ROITMP.explorer" type="checkbox"> </div> <div class="cmLflexitem cmMarginSpaceLR"> <p id="expv"></p> </div> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <span ng-hide="data.ROITMP.explorer">Cursor</span> </div> </div> </div> <div class="cmRflexitem cminputElement cmMarginSpaceLR cmMarginSpaceTB"> <cm-slider-input label="Opacity" model="data.ROITMP.opacity" min="0" max="100"></cm-slider-input> </div> <div class="cmRlexitem cmMarginSpaceLR cmMarginSpaceTB cminputElement"> <cm-color-input label="ROI Color" model="data.ROITMP.color"></cm-color-input> </div> <div class="cmRflexitem"> <table class="table table-wrapper-scroll-y"> <thead> <th class="Trotate" style="width:36%"> <span>ROI</span></th> <th class="Trotate" style="width:48%"> <span>Actions</span></th> <th class="Trotate" style="width:8%"><span>Show</span></th> <th class="Trotate" style="width:8%"><span>Group</span></th> </thead> <tr ng-if="data.ROI.length==0"> <td>--</td> <td>--</td> <td>--</td> <td>--</td> </tr> <tr ng-repeat="ss in data.ROI track by $index" ng-hide="ss.id==data.GROUP.id"> <td> <div class="cmLcontainer" style="align-items:center"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> <i class="far fa-square fa-sm" ng-if="ss.typeOF==\'square\'" style="color: {{ss.fill}};"></i> <i class="far fa-circle fa-sm" ng-if="ss.typeOF==\'circle\'" style="color: {{ss.fill}};"></i> <i class="fas fa-draw-polygon fa-sm" ng-if="ss.typeOF==\'polygon\'" style="color: {{ss.fill}};"></i> </div> <input ng-model="ss.id" style="width: 60%;font-size: 13px" class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> </div> </td> <td> <button ng-click="removeRoi(ss.id)"><i class="far fa-trash-alt"></i></button> <button ng-click="backupROI(ss)"><i class="far fa-save"></i></button> <button ng-click="activateRoi(ss.id)"> <i class="fas fa-vector-square"></i></button> </td> <td style="text-align:center;"> <input type="checkbox" ng-model="ss.visible" ng-click="showRegion(ss)"> </td> <td style="text-align:center;"> <input type="checkbox" ng-model="ss.groupped" ng-click="setGroup(ss)"> </td> </tr> <tr ng-repeat="ss in data.GROUP.regions track by $index" style="background-color: azure"> <td> <div class="cmLcontainer" style="align-items:center"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"><i class="far fa-square fa-sm" ng-if="ss.typeOF==\'square\'" style="color: {{ss.fill}};"></i> <i class="far fa-circle fa-sm" ng-if="ss.typeOF==\'circle\'" style="color: {{ss.fill}};"></i> <i class="fas fa-draw-polygon fa-sm" ng-if="ss.typeOF==\'polygon\'" style="color: {{ss.fill}};"></i></div> <input ng-model="ss.id" style="width: 60%;font-size: 13px" class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB"> </div> </td> <td> <button ng-click="backupGROUPROI()"><i class="far fa-save"></i></button> <button ng-click="activateGroup() "><i class="fas fa-vector-square "></i></button> </td> <td style="text-align:center; "> <input type="checkbox" ng-model="ss.visible " ng-click="showGroup(ss.visible)"> </td> <td style="text-align:center; "> <input type="checkbox" ng-model="ss.groupped " ng-click="setGroup(ss)"> </td> </tr> </table> </div> <div class="cmRflexitem "> <div class="cmRcontainerLeft "> <div class="cmRflexitem "> <div class="cmLcontainer "> <button class="cmLflexitem " ng-click="undoROI() " ng-disable="data.lastROI===null "><span class="fas fa-trash-restore-alt fa-2x "></span></button> <button class="cmLflexitem " ng-click="saveAllROIs() "> <span class="far fa-save e fa-2x "></span> </button> </div> </div> </div> <div class="cmRflexitem " ng-if="data.serverROIs.length>0"> <div class="cmLflexitem cmMarginSpaceLR cmMarginSpaceTB cminputElement"> <div class="input-group"> <span class="input-group-addon" ng-if="data.serverROIs.length>1">{{data.serverROIs.length}} ROIs Stored</span> <span class="input-group-addon" ng-if="data.serverROIs.length==1">{{data.serverROIs.length}} ROI Stored</span> <input type="text" class="form-control" list="{{data.serverroidl}}" ng-model="data.S" ng-change="ROIselected(data.S)" /> <datalist id="{{data.serverroidl}}"> <option ng-repeat="v in data.serverROIs" value="{{v.ID}}"> {{v.Alias}}</option> </datalist> </div> </div> </div> <!--Rc--> </div> </div> </div> <div class="cmLflexitem" style="width:377px"> <div class="cmRcontainerLeft"> <div class="cmRflexitem"> <p id="{{data.HISTOGRAM.id}}" style="width: 377-21px"></p> </div> <div class="cmRflexitem"> <p id="{{data.TABLE.optionaltext}}"></p> </div> <div class="cmRflexitem"> <p id="{{data.TABLE.id}}"></p> </div> </div> </div></div>';



var putRegiononCanvas = function(r, c) {
    var origRenderOnAddRemove = c.renderOnAddRemove;

    var v = createRegionFromROI(jsonCopy(r));
    //    console.log(v);

    c.add(v);
    c.renderOnAddRemove = origRenderOnAddRemove;

}
var createRegionFromROI = function(r) {


    switch (r.type) {
        case 'circle':
            var ob = new fabric.Circle(r);

            break;
        case 'rect':
            var ob = new fabric.Rect(r);
            break;
        case 'polygon':
            var ob = new fabric.Polygon(r.points.slice(), r);
            break;



    };
    //    console.log(ob);
    return ob;
};




// scope.$watch("myfactory.Canvas",function(){console.log(scope.myfactory.functions.getCanvas().getObjects())},true);




//ROI

function getCanvasOriginAndScale(c, width, height) {
    return new Promise(resolve => {
        var canvasSizeR = {};
        canvasSizeR.w = c.width / width;
        canvasSizeR.h = c.height / height;

        var A = [canvasSizeR.w, canvasSizeR.h];
        var possibleScaling = A.GetMaxMin();

        resolve({
            scale: possibleScaling.Min,
            origin: {
                x: parseInt((c.width - (width * possibleScaling.Min)) / 2),
                y: parseInt((c.height - (height * possibleScaling.Min)) / 2)
            }
        });
    });


};

function getCanvasRegions(canvas) {
    return new Promise(resolve => {
        resolve(canvas.getObjects());
    });
};



function getROIData(data, roi, canvas, canvasOrigin, canvasScale, vpTransform) {
    //get the bounding box of the object in canvas   


    return new Promise(resolve => {
        var bound = roi.getBoundingRect();

        var P = {};
        P.bound = bound;
        P.ALL = this;

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
        for (var xt = bound.left; xt < bound.left + bound.width; xt += F) {
            for (var yt = bound.top; yt < bound.top + bound.height; yt += F) {
                //points in the canvas
                var myP = new fabric.Point(xt, yt);
                // console.log(myP);

                //on the image worlfd
                var ps = fabric.util.transformPoint(myP, mInverse);

                if (c == 0) {
                    c++
                };

                if (canvas.isTargetTransparent(roi, xt, yt)) {} else {
                    xi = (ps.x / F) - Origin.x;
                    yi = (ps.y / F) - Origin.y;

                    pos = ((width * Math.round(yi)) + Math.round(xi));

                    px0.push(arr[pos]);
                    //                            console.log("in");
                } //else{console.log("out");};
            }


        };




        resolve(px0);
    });
};


function makePlotlyHistogram(px0, name, id) {
    if (px0 != undefined) {
        //        console.log(px0);
        var trace = {
            x: px0,
            type: 'histogram',
            name: 'pixel values'
        };

        var data = [trace];


        //controllo roi
        var layout = {
            title: name + ' histogram',
            xaxis: {
                title: 'values',
                titlefont: {
                    family: 'Courier New, monospace',
                    size: 18,
                    color: '#7f7f7f'
                }
            },
            yaxis: {
                title: 'Pixel Count',
                titlefont: {
                    family: 'Courier New, monospace',
                    size: 18,
                    color: '#7f7f7f'
                }
            }
        };


        Plotly.newPlot(id, data, layout);




    }
}





var getRegionInGroup = function(G, property, v) {
    R = undefined;

    G.forEachObject(function(obj, index) {

        if (obj[property] == v) {


            R = obj;
        }
    });
    return R;
};

var fromGroupCoordTocanvas = function(ob, G) {


    var width = G.width;
    var height = G.height;

    var left = G.left + ob.left + (width / 2);
    var top = G.top + ob.top + (height / 2);
    ob.left = left;
    ob.top = top;




    return ob
}

function calculateDISNR(AR0, AR1) {
    return new Promise(resolve => {
        var sum = [];
        var sub = [];
        var t = {
            v: undefined,
            n: undefined
        };
        for (var g = 0; g < AR0.length; g++) {
            sum[g] = AR0[g] + AR1[g];
            sub[g] = AR0[g] - AR1[g];
        }


        t.v = (average(purgenan(sum)) / 2) / (std(purgenan(sub)) / Math.SQRT2);
        t.n = AR0.length;
        resolve(t);
    });

}



parseDataonPoint = function(xt, yt, data, canvas, canvasOrigin, canvasScale, vpTransform) {
    //j is the position of the json file on server
    return new Promise(resolve => {


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


        var myP = new fabric.Point(xt, yt);
        var ps = fabric.util.transformPoint(myP, mInverse);
        xi = (ps.x / F) - Origin.x;
        yi = (ps.y / F) - Origin.y;
        pos = ((width * Math.round(yi)) + Math.round(xi));

        px0.push(arr[pos]);

        resolve(px0);
    });

};

function makeLine(coords) {
    return new fabric.Line(coords, {
        fill: 'black',
        stroke: 'black',
        strokeWidth: 1
    });
}


function getNumberAsPowerof(number, powerof) {
    //  return Math.pow(powerof, Math.floor(number).toString().length - 1);
    switch (powerof) {
        case 10:

            return Math.pow(10, Math.floor(Math.log10(parseFloat(number))));
    }
}


function subPlotShape(N) {
    //   console.log(N);
    switch (N) {

        case 16:
            var S = {
                "c": 4,
                "r": 4
            };
            break;
        case 20:
            var S = {
                "c": 5,
                "r": 4
            };
            break;
        case 32:
            var S = {
                "c": 6,
                "r": 6
            };
            break;
        case 64:
            var S = {
                "c": 8,
                "r": 8
            };
            break;


    };
    return S;
}

function subPlotShapeArray(N) {
    //   console.log(N);
    switch (N) {

        case 16:
            var S = {
                "c": 4,
                "r": 4
            };
            break;
        case 20:
            var S = {
                "c": 5,
                "r": 4
            };
            break;
        case 32:
            var S = {
                "c": 6,
                "r": 6
            };
            break;
        case 64:
            var S = {
                "c": 8,
                "r": 8
            };
            break;


    };
    var O = [];
    for (var a = 0; a < S.r; a++) {
        for (var b = 0; b < S.c; b++) {
            O.push({
                "r": a,
                "c": b
            });
        };
    };
    return O;
}

function reshapemroptimumDataToD3heatmap(array, height, width) {

    return new Promise(resolve => {

        var arr = [
            [],
            []
        ];

        for (var y = 0; y < height; y++) {
            arr[y] = [];
            for (var x = 0; x < width; x++) {

                arr[y][x] = array[y * width + x];

            }
        }

        resolve(arr);
    });
};



function index2subPromise(x, width, height) {
    return new Promise(resolve => {

        resolve({
            y: math.mod(x, width),
            x: math.mod(math.floor(math.mod(x, width)), height)
        })
    });
};

function index2sub(x, width, height) {

    return {
        y: math.mod(x, width),
        x: math.mod(math.floor(math.mod(x, width)), height)
    }
};
///////////////////////////////////////////////////////////////
function getCanvasSize(canvas) {
    return {
        w: canvas.width,
        h: canvas.height
    }
};


function resetCanvasTransform(c) {
    c.setViewportTransform([1, 0, 0, 1, 0, 0]);
};

function canvasPAN(c) {
    var panning = false;
    c.on('mouse:up', function(e) {
        panning = false;
        c.off('mouse:move');
        c.off('mouse:down');
        c.off('mouse:up');
    });
    c.on('mouse:down', function(e) {
        panning = true;
    });
    c.on('mouse:move', function(e) {
        if (panning && e && e.e) {
            var units = 10;
            var delta = new fabric.Point(e.e.movementX, e.e.movementY);
            c.relativePan(delta);
        }
    });

};


var createRegionFromROI = function(r) {


    switch (r.type) {
        case 'circle':
            var ob = new fabric.Circle(r);

            break;
        case 'rect':
            var ob = new fabric.Rect(r);
            break;
        case 'polygon':
            var ob = new fabric.Polygon(r.points.slice(), r);
            break;



    };
    //    console.log(ob);
    return ob;
};

parseDataonPoint = function(xt, yt, data, canvas, canvasOrigin, canvasScale, vpTransform) {
    //j is the position of the json file on server
    return new Promise(resolve => {


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


        var myP = new fabric.Point(xt, yt);
        var ps = fabric.util.transformPoint(myP, mInverse);
        xi = (ps.x / F) - Origin.x;
        yi = (ps.y / F) - Origin.y;
        pos = ((width * Math.round(yi)) + Math.round(xi));

        px0.push(arr[pos]);

        resolve(px0);
    });

};


function getCanvasOriginAndScale(c, width, height) {
    return new Promise(resolve => {
        var canvasSizeR = {};
        canvasSizeR.w = c.width / width;
        canvasSizeR.h = c.height / height;

        var A = [canvasSizeR.w, canvasSizeR.h];
        var possibleScaling = A.GetMaxMin();

        resolve({
            scale: possibleScaling.Min,
            origin: {
                x: parseInt((c.width - (width * possibleScaling.Min)) / 2),
                y: parseInt((c.height - (height * possibleScaling.Min)) / 2)
            }
        });
    });


};


function createFabricStringROI(x) {
    return new Promise(resolve => {


        var TOSAVE = {
            version: "3.6.2",
            objects: []
        };


        TOSAVE.objects.push(x.toJSON(ROIWHATSAVEANDLOAD));

        //var OOUT=jsonCopy(TOSAVE);

        resolve(TOSAVE);
    });
};


function getROIData(data, roi, canvas, canvasOrigin, canvasScale, vpTransform) {
    //get the bounding box of the object in canvas   


    return new Promise(resolve => {
        var bound = roi.getBoundingRect();

        var P = {};
        P.bound = bound;
        P.ALL = this;

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
        for (var xt = bound.left; xt < bound.left + bound.width; xt += F) {
            for (var yt = bound.top; yt < bound.top + bound.height; yt += F) {
                //points in the canvas
                var myP = new fabric.Point(xt, yt);
                // console.log(myP);

                //on the image worlfd
                var ps = fabric.util.transformPoint(myP, mInverse);

                if (c == 0) {
                    c++
                };

                if (canvas.isTargetTransparent(roi, xt, yt)) {} else {
                    xi = (ps.x / F) - Origin.x;
                    yi = (ps.y / F) - Origin.y;

                    pos = ((width * Math.round(yi)) + Math.round(xi));

                    px0.push(arr[pos]);
                    //                            console.log("in");
                } //else{console.log("out");};
            }


        };




        resolve(px0);
    });
};

var fromGroupCoordTocanvas = function(ob, G) {


    var width = G.width;
    var height = G.height;

    var left = G.left + ob.left + (width / 2);
    var top = G.top + ob.top + (height / 2);
    ob.left = left;
    ob.top = top;




    return ob
}
var getRegionInGroup = function(G, property, v) {
    R = undefined;

    G.forEachObject(function(obj, index) {

        if (obj[property] == v) {


            R = obj;
        }
    });
    return R;
};


function rotateCanvas(deg, canvas) {
    return new Promise(resolve => {


        var a = fabric.util.degreesToRadians(deg);


        var startingMatrix = undefined;
        try {
            if (isUndefined(canvas.viewportTransform)) {
                startingMatrix = [1, 0, 0, 1, 0, 0];

            } else {
                startingMatrix = canvas.viewportTransform
            };




            var X = {};
            X = {
                w: canvas.width,
                h: canvas.height
            };

            var goToCenterMatrix = [1, 0, 0, 1, X.w / 2, X.h / 2];

            var rotateMatrix = [Math.cos(a), Math.sin(a), -Math.sin(a), Math.cos(a), 0, 0];
            var goBackFromCenter = [1, 0, 0, 1, -X.w / 2, -X.h / 2];
            var finalMatrix = fabric.util.multiplyTransformMatrices(startingMatrix, goToCenterMatrix);


            finalMatrix = fabric.util.multiplyTransformMatrices(finalMatrix, rotateMatrix);




            canvas.setViewportTransform(fabric.util.multiplyTransformMatrices(finalMatrix, goBackFromCenter));

        } catch (err) {
            console.log("non riesco a ruotarlo!:)")
        }
    });
};

function makePlotlyHistogram(px0, name, id) {

    if (px0 != undefined) {
        //        console.log(px0);
        var trace = {
            x: px0,
            type: 'histogram',
            name: 'pixel values'
        };

        var data = [trace];


        //controllo roi
        var layout = {
            title: name + ' histogram',
            xaxis: {
                title: 'values',
                titlefont: {
                    family: 'Courier New, monospace',
                    size: 18,
                    color: '#7f7f7f'
                }
            },
            yaxis: {
                title: 'Pixel Count',
                titlefont: {
                    family: 'Courier New, monospace',
                    size: 18,
                    color: '#7f7f7f'
                }
            }
        };


        Plotly.newPlot(id, data, layout);




    }
}


function makeTableStat(px0, place) {
    //new version:)
    var v = document.getElementById(place.id);
    v.innerHTML = "<p id=\"dedede\"></p><table class='table table-striped' id=" + place.tableid + "> <thead class='thead-dark'> <th scope='col'>Features</th> <th scope='col'>Values</th> </thead> <tbody id=" + place.tablebodyid + "></tbody> <tbody> <tr> <td scope='col'>Pixel Count</td> <td>" + purgenan(px0).length + "</td> </tr> <tr> <td scope='col'>Mean</td> <td>" + average(purgenan(px0)).toFixed(2) + "</td> </tr> <tr> <td scope='col'>Median</td> <td>" + median(purgenan(px0)).toFixed(2) + "</td> </tr> <tr> <td scope='col'>Max</td> <td>" + Math.max.apply(Math, purgenan(px0)).toFixed(2) + "</td> </tr> <tr> <td scope='col'>Min</td> <td>" + Math.min.apply(Math, purgenan(px0)).toFixed(2) + "</td> </tr></table>"

};

function makeLine(coords) {
    return new fabric.Line(coords, {
        fill: 'black',
        stroke: 'black',
        strokeWidth: 1
    });
}

function getNumberAsPowerof(number, powerof) {
    //  return Math.pow(powerof, Math.floor(number).toString().length - 1);
    switch (powerof) {
        case 10:

            return Math.pow(10, Math.floor(Math.log10(parseFloat(number))));
    }
};

function createLUT(height, width, XX) {
    return new Promise(resolve => {

        var data = [];
        for (var i = height; i > 0; i--) {
            for (var j = width; j > 0; j--) {
                data.push(XX[i]);
            }

        }
        resolve(data);
    });
};

function makeArr(startValue, stopValue, cardinality) {
    return new Promise(resolve => {
        var arr = [];
        var currValue = startValue;
        var step = (stopValue - startValue) / (cardinality - 1);
        for (var i = 0; i < cardinality; i++) {
            arr.push(currValue + (step * i));
        }
        resolve(arr)
    });
};

function getgrayscalemageboundaries(realvalue, realdeltavalue, VIEWERRANGE) {
    // from the original min and max of the image move a percentage of that


    var RANGE = Math.abs(realvalue.Max - realvalue.Min);



    var D = {
        Max: realdeltavalue.Max * RANGE / VIEWERRANGE,
        Min: realdeltavalue.Min * RANGE / VIEWERRANGE
    };



    return {
        Max: realvalue.Max - D.Max,
        Min: realvalue.Min + D.Min
    };
};



function asyncArraytoImageURL(data, height, width, b, LUT) {
    //        function(array,height,width,brightness{Min:0,Max:0},LUT,B)
    //        create a fake canvas


    return new Promise(resolve => {

        var c = document.createElement('canvas');

        var UIID = getUIID();
        c.setAttribute('id', UIID);
        c.width = width;
        c.height = height;

        // create imageData object
        // create imageData objectset
        var idata = c.getContext('2d').createImageData(c.width, c.height);

        // set our buffer as source



        asyncArrayTobuffer(data, b, height, width, eval(LUT)).then(function(buffer) {


            //            console.log("I'have a buffer");
            idata.data.set(buffer);
            c.getContext('2d').putImageData(idata, 0, 0);
            resolve(c.toDataURL());

            c = null;
            $('#_' + UIID).remove();


        });

    });
}




function asyncArrayTobuffer(data, reduction, height, width, evalLUT) {
    //array, brightness evalLUT is the lut array
    //        old "bufferFromArrayWithBrightnessv2;

    return new Promise(resolve => {

        var buffer = new Uint8Array(width * height * 4);
        //    console.log(B);

        //maximum values to be drawn since 8bit, it ranges from 0 to 255
        var VIEWERMAX256 = {
            Min: 0,
            Max: 255
        };




        var IMAGEMAXANDMIN = data.GetMaxMin();
        //        console.log(IMAGEMAXANDMIN);

        //        % this function give me the grayscale minimum and maximum of the image
        var XGRAYSCALEBOUNDARY = getgrayscalemageboundaries(IMAGEMAXANDMIN, reduction, 255.0);



        var P0 = {
            x: XGRAYSCALEBOUNDARY.Min,
            y: VIEWERMAX256.Min
        };
        var P1 = {
            x: XGRAYSCALEBOUNDARY.Max,
            y: VIEWERMAX256.Max
        };


        //fit the points
        var FIT = linearfit2pts(P0, P1);

        var m = FIT.m;
        var q = FIT.q;

        var L = {};



        //            _/- or -\_
        //    the agorythm is repeated o that i tes tonly once if the slope is + or -
        if (FIT.m >= 0) {
            //                _/-
            var SATURATIONBAND = {
                Min: VIEWERMAX256.Min,
                Max: VIEWERMAX256.Max
            };



            var ff = [];
            var g = 0;
            for (var y = 0; y < height; y++) {
                for (var x = 0; x < width; x++) {
                    var pos = (y * width + x) * 4; // position in buffer based on x and y



                    g = data[pos / 4];

                    if (g < XGRAYSCALEBOUNDARY.Min || isNaN(g)) {
                        V = SATURATIONBAND.Min;
                    };

                    if (g > XGRAYSCALEBOUNDARY.Max) {
                        V = SATURATIONBAND.Max;
                    };

                    if (g <= XGRAYSCALEBOUNDARY.Max && g >= XGRAYSCALEBOUNDARY.Min) {
                        V = Math.ceil((m * parseFloat(g)) + q);

                    }


                    V2 = ((V) * 2);
                    try {
                        buffer[pos] = 255 * evalLUT[V2][1][0]; // some R value [0, 255]
                        buffer[pos + 1] = 255 * evalLUT[V2][1][1]; // some G value
                        buffer[pos + 2] = 255 * evalLUT[V2][1][2]; // some B value
                        buffer[pos + 3] = 255; // set alpha channel
                        //                ff.push(V2);
                    } catch (e) {

                        // console.log("error");
                    }


                }


            }


            resolve(buffer);




        } else {
            //%      -\_
            var SATURATIONBAND = {
                Min: VIEWERMAX256.Max,
                Max: VIEWERMAX256.Min
            };



            var ff = [];
            var g = 0;
            for (var y = 0; y < height; y++) {
                for (var x = 0; x < width; x++) {
                    var pos = (y * width + x) * 4; // position in buffer based on x and y



                    g = data[pos / 4];

                    if (g < XGRAYSCALEBOUNDARY.Max || isNaN(g)) {
                        V = SATURATIONBAND.Min;
                    };

                    if (g > XGRAYSCALEBOUNDARY.Min) {
                        V = SATURATIONBAND.Max;
                    };

                    if (g <= XGRAYSCALEBOUNDARY.Min && g >= XGRAYSCALEBOUNDARY.Max) {
                        V = Math.ceil((m * parseFloat(g)) + q);

                    }


                    V2 = ((V) * 2);

                    try {
                        buffer[pos] = 255 * evalLUT[V2][1][0]; // some R value [0, 255]
                        buffer[pos + 1] = 255 * evalLUT[V2][1][1]; // some G value
                        buffer[pos + 2] = 255 * evalLUT[V2][1][2]; // some B value
                        buffer[pos + 3] = 255; // set alpha channel
                        //                ff.push(V2);
                    } catch (e) {
                        //                console.log("V is:"+ V +" V2 is "+ V2);
                        //   console.log("error");
                    }



                }

            }


            resolve(buffer);


        };


    });

};




async function getAvailableSlices(jsonFile, selectedImage) {

    var OUT = [];
    var o = await parseImageSlices(jsonFile, selectedImage);
    if (o == 0) {

        a = o + 1;
        OUT.push({
            id: o,
            name: "Slice " + a.toString()
        });
    } else {
        for (var t = 0; t < o; t++) {
            a = t + 1;

            OUT.push({
                id: t,
                name: "Slice " + a.toString()
            });
        };


    }

    return OUT;
};

function parseImageSlices(jsonFile, IMnumber) {

    return new Promise(resolve => {
        //there can be just one image
        if (isUndefined(jsonFile)) {
            var q = 0;
        } else {
            if (jsonFile.images.length > 1) {
                if (isUndefined(jsonFile.images[IMnumber].slice[0])) {
                    var q = 0;
                } else {
                    var q = jsonFile.images[IMnumber].slice.length;

                }
            } else {
                if (isUndefined(jsonFile.images.slice[0])) {
                    var q = 0;
                } else {
                    var q = jsonFile.images.slice.length;

                }

            }
        }
        resolve(q);
    });
};






function getArrayfromJsonfileImagenumberAndSlice(jsonFile, IMnumber, SLnumber) {

    return new Promise(resolve => {
        //there can be just one image

        //c'e' piu' di una immagine
        if (jsonFile.images.length > 1) {
            //e se c'e' piu di una slice
            if (jsonFile.images[IMnumber].slice.length > 1) {
                var q = jsonFile.images[IMnumber].slice[SLnumber];
            } else {
                //c'e solo una slice
                var q = jsonFile.images[IMnumber].slice

            }

        } else { //c'e' solo un'immagine
            //e se c'e' piu di una slice
            if (jsonFile.images.slice.length > 1) {
                var q = jsonFile.images.slice[SLnumber];
            } else {
                //c'e solo una slice
                var q = jsonFile.images.slice;

            }

        }

        resolve(q)
    });
};

async function getAvailableImages(jsonFile) {

    var o = await parseImages(jsonFile);

    return o;
};

async function getAvailableImagesAndData(jsonFile) {

    var o = await parseImagesandDAta(jsonFile);

    return o;
};

function parseImagesandDAta(JSONARRAY) {
    return new Promise(resolve => {

        if (JSONARRAY.images.length > 1) {
            var v = [];
            for (var i = 0; i < JSONARRAY.images.length; i++) {

                v.push({ id: i, imageName: JSONARRAY.images[i].imageName, slice: JSONARRAY.images[i].slice });

            }
            resolve(v);
        } else {
            resolve([{
                id: 0,
                imageName: JSONARRAY.images.imageName,
                slice: JSONARRAY.images.slice

            }]);
        }
    });
};

function parseImages(JSONARRAY) {
    return new Promise(resolve => {

        if (JSONARRAY.images.length > 1) {
            var v = [];
            for (var i = 0; i < JSONARRAY.images.length; i++) {

                v.push({ id: i, imageName: JSONARRAY.images[i].imageName });

            }
            resolve(v);
        } else {
            resolve([{
                id: 0,
                imageName: JSONARRAY.images.imageName
            }]);
        }
    });
};


var CMBDDRAWER = angular.module("CMBDDRAWER", [])
    //that's the the big class to instantiate for the drawer
    .directive('cmDisplay', [function() {
        return {
            restrict: 'E',
            scope: {
                jsondata: "=",
                conf: "=",
                canvassizeh: '@', //in order to propagate faster on all the other layers
                canvassizew: '@' //in order to propagate faster on all the other layers


            },
            template: DISPLAY,
            link: function(scope, element, attrs) {


                scope.Math = window.Math;
                scope.data = { snapshotname: "Snapshot", actionbuttons: [], usermovingfunction: undefined, userroiupload: undefined };
                //the data
                scope.TMP = {
                    functions: {},
                    tmp: {},
                    imageinteractions: {},
                    thetitle: 'Result'

                };

                scope.$watch("conf", function(x) {
                    // console.log(x);
                    if (!(isUndefined(x))) {

                        if (!(isUndefined(x.snapshotname))) {
                            //                       if(x.snapshotname!=old.snapshotname){
                            scope.data.snapshotname = x.snapshotname;
                        }



                        if (!(isUndefined(x.actionbuttons))) {
                            //                       if(x.snapshotname!=old.snapshotname){
                            scope.data.actionbuttons = x.actionbuttons;
                        }


                        if (!(isUndefined(x.reportfunction))) {

                            scope.reportfunction = x.reportfunction;

                        }

                        if (!(isUndefined(x.usermovingfunction))) {
                            //                       if(x.snapshotname!=old.snapshotname){
                            scope.data.usermovingfunction = x.usermovingfunction;
                        }


                        if (!(isUndefined(x.userroiupload))) {
                            //                       if(x.snapshotname!=old.snapshotname){
                            scope.data.userroiupload = x.userroiupload;
                        }

                        if (!(isUndefined(x.userroiget))) {
                            //                       if(x.snapshotname!=old.snapshotname){
                            scope.data.userroiget = x.userroiget;
                        }


                        if (!(isUndefined(x.title))) {
                            //                       if(x.snapshotname!=old.snapshotname){

                            // console.log(x);
                            scope.TMP.thetitle = x.title;
                        }

                        if (!(isUndefined(x.title))) {
                            //                       if(x.snapshotname!=old.snapshotname){

                            // console.log(x);
                            scope.TMP.thetitle = x.title;
                        }


                    }
                }, true);

            }
        }
    }])


.directive('cmScreenshot', ['$parse', 'cmtool', function($parse, cmtool) {
    return {
        restrict: 'A',
        scope: {
            canvasid: '@',
            legendid: '@',
            saveas: '@'
        },
        link: function(scope, element, attrs) {

            // Bind to the onclick event of our button
            element.bind('click', function(e) {


                var myImage = document.getElementById(scope.canvasid);
                var myLegend = document.getElementById(scope.legendid);



                var IM = scope.saveas;
                IM = prompt("Specify a name for the image that will be saved", IM);

                if (IM != null) {


                    var c = document.createElement('canvas');

                    //                                            var c = document.getElementById("FAKE");
                    c.width = myImage.width + parseInt(myImage.width * 0.25);
                    c.height = myImage.height + 10;
                    //                                            


                    var contextScreenshot = c.getContext("2d");
                    // Draw the layers in order

                    contextScreenshot.fillStyle = "black";
                    contextScreenshot.fillRect(0, 0, c.width, c.height);
                    //                                            contextScreenshot.fillStyle = "white";
                    //                                            contextScreenshot.fillRect(0, myImage.height, c.width, c.height);

                    contextScreenshot.drawImage(myImage, 0, 0);
                    contextScreenshot.drawImage(myLegend, myImage.width, 0);


                    contextScreenshot.font = "10px Arial";
                    contextScreenshot.fillStyle = "white";
                    contextScreenshot.fillText("Cloud MR www.cloudmrhub.com ", 0, myImage.height + 10);



                    // Save to a data URL as a jpeg quality 9
                    //                                            var imgUrl = c.toDataURL("image/jpeg", .9);
                    //                                            console.log(imgUrl);

                    c.toBlob(function(blob) {
                        saveAs(blob, IM + ".png");
                    })


                }

            });
        }

    }
}])




//'<style>@import url({{CSS}});</style><div class="mroRcontainer"><div class="mroRflexitem"><div class=mroLcontainer><div class="mroLflexitem"><div class="mroSelectContainer"><span class="cmlabel mroSelect">Data</span><select class="form-control mroSelect" ng-model="data.imageinteractions.selectedImage"><option ng-repeat="field in available.Images"class="mroSelect" value=\'{{field.id}}\'> {{field.imageName}}</option></select></div></div><div class="mroLflexitem"><div class="mroSelectContainer"><span class="cmlabel mroSelect">Value</span><select class="form-control mroSelect" ng-model="data.imageinteractions.selectedValue"><option ng-repeat="item in available.Value" class="mroSelect"value=\'{{item.v}}\'>{{item.n}}</option></select></div></div><div class="mroLflexitem"><div class="mroSelectContainer"><span class="cmlabel mroSelect">Slice</span><select class="form-control mroSelect"ng-model="data.imageinteractions.selectedSlice"><option ng-repeat="sl in available.Slices" value=\'{{sl.id}}\'class="mroSelect"> {{sl.name}}</option></select></div></div><div class="mroLflexitem"><div class="mroSelectContainer"><span class="cmlabel mroSelect">Color Map</span><select class="form-control mroSelect "ng-model="data.viewinteractions.lut"><option ng-repeat="lu in available.COLORMAP"value=\'{{lu.iName}}\'class="mroSelect">{{lu.eName}}</option></select></div></div></div></div><div class="mroRflexitem"><div class="mroLcontainerUW "><div class="mroLflexitem"><canvas id="{{data.CID}}"></canvas></div><div class="mroLflexitem"><canvas id="{{data.CLUT}}"></canvas></div></div></div><div class="mroRflexitem"><div class=mroLcontainer><button ng-click="data.functions.PAN()" class="mroLflexitem"><span class="fas fa-hand-paper fa-2x"></span></button><button ng-click="data.functions.restetTransform()" class="mroLflexitem"><i class="fas fa-compress fa-2x"></i></button><button cm-screenshot="data.functions.getViewName()" class="mroLflexitem"cid="data.CID" lid="data.CLUT"><i class="fas fa-camera fa-2x"></i></button><button ng-click="getReport()" class="mroLflexitem"><span class="fas fa-file-alt fa-2x"></span></button></div></div><div class="mroRflexitem"><div class=mroLcontainer><div class="mroLflexitem"><div class="mroSelectContainer"><span class="cmlable mroSelect">Min</span><input ng-model="data.viewinteractions.Min" type="range" min="0"max="255" class="mroSelect"></div></div><div class="mroLflexitem"><div class="mroSelectContainer"><span class="cmlable mroSelect">Max</span><input ng-model="data.tmp.FMax" type="range" min="0" max="255"ng-change="data.functions.changeB(\'Max\',data.tmp.FMax)" class="mroSelect"></div></div><div class="mroLflexitem"><div class="mroSelectContainer"><span class="cmlable mroSelect">Zoom</span><input ng-model="data.transform.Zoom" type="range" min="10" max="400" class="mroSelect"></div></div></div></div><div class="mroRflexitem"><div class=mroLcontainer><div ng-repeat="(key, value) in jsondata.settings"><div class="mroLflexitem"><span class="cmlabel"> {{key}}:</span><span class="cmlabel"> {{value}}</span></div></div></div></div></div>'




.directive('cmViewerDisplay', ["$timeout", "drawingservice", "$window", function($timeout, service, $window) {
    return {
        restrict: 'E',
        scope: {
            jsondata: "=",
            data: "=",
            canvassizew: "@",
            canvassizeh: "@",
            actionbuttons: "=", //[{icon,function,tooltip}]
            snapshotname: "@", //name of the snapshot stuff
            reportfunction: "=" //configuration file for report, json file with url

        },
        template: VIEWERDISPLAY,
        link: function(scope, element, attrs) {



            // element.on('load',loadscript("http://cloudmrhub.com/apps/MROPTIMUM/mrojs/js-colormaps.js"));
            var canvas_1;


            var xx = "xviewerx";
            var xxl = "xviewerxL";

            var CANVASSIZEW = scope.canvassizew;
            var CANVASSIZEH = scope.canvassizeh;





            scope.reportbutton = false;





            var Canvas = new fabric.Canvas(xx, {
                imageSmoothingEnabled: false,
                width: CANVASSIZEW,
                height: CANVASSIZEH

            });

            var CanvasLUT = new fabric.StaticCanvas(xxl, {
                imageSmoothingEnabled: true, // here you go
                width: parseInt(CANVASSIZEW / 4),
                height: CANVASSIZEH
            });






            scope.start = function() {
                scope.data.Canvas = Canvas;
                scope.available = {
                    COLORMAP: COLORMAP,
                    Value: [{
                        n: 'Abs',
                        v: 'abs'
                    }, {
                        n: 'Real',
                        v: 'real'
                    }, {
                        n: 'Imaginary',
                        v: 'imag'
                    }, {
                        n: 'Phase',
                        v: 'angle'
                    }]
                };

                var DV = service.canvasDefualtTransformationParameters();
                //set the main canvas id
                scope.data.CID = xx;
                //set the main canvas lut id
                scope.data.CLUT = xxl;
                //got the standard trandformation
                scope.data.T = DV;
                //the actual array
                scope.data.arrayData = {};

                scope.data.viewinteractions = service.ViewerDefualtViewerParameters();

                scope.data.imageinteractions = service.ViewerDefualtDrawParameters();



                scope.data.transform = {
                    deg: 0,
                    Zoom: "100"
                };
                scope.data.tmp.FMax = "255";




                scope.$watch('data.tmp.FMax', function(x) { scope.data.viewinteractions.Max = (255 - parseInt(x)).toString(); }, false);







                scope.data.functions.getViewName = function() {
                    return "myImage";
                }

                scope.data.functions.PAN = function() {
                    canvasPAN(Canvas);

                };

                scope.data.functions.restetTransform = function() {
                    resetCanvasTransform(Canvas);
                    scope.data.transform.Zoom = "100";
                };




                scope.data.functions.rotate = function(x) {



                    rotateCanvas(x, Canvas);

                };



                if (isUndefined(scope.reportfunction)) {
                    scope.reportbutton = false;
                } else {
                    scope.data.functions.getReport = function() {

                        var data = jsonCopy(scope.data);
                        var rois = scope.data.Canvas.toJSON(ROIWHATSAVEANDLOAD);
                        var transformation = jsonCopy(scope.data.Canvas.viewportTransform);
                        scope.reportfunction(scope, rois, transformation);



                    }
                    scope.reportbutton = true;

                }






            }




            scope.view = function(reparse, from) {

                if (!isUndefined(scope.jsondata)) {

                    if (!isUndefined(Canvas)) {

                        if (isUndefined(reparse)) {
                            //  var myArray=scope.jsondata.functions.getBackground();


                            //the canvas where i want to render the data
                            //  var c=document.getElementById(scope.data.CID);
                            //   console.log(c); <canvas id....
                            //get the array of data from the main dataset 
                            service.parseImageDetails(scope.jsondata, parseInt(scope.data.imageinteractions.selectedImage), parseInt(scope.data.imageinteractions.selectedSlice), scope.data.imageinteractions.selectedValue).then(function(ARR) {

                                scope.data.arrayData = ARR;
                                //                    draw on the canvas
                                service.drawBackgroundInCanvas(ARR.array, ARR.h, ARR.w, scope.data.viewinteractions, scope.data.viewinteractions.lut, Canvas);
                                service.drawLegendInCanvas(scope.data.viewinteractions, ARR.array.GetMaxMin(), scope.data.viewinteractions.lut, CanvasLUT);
                            });

                        } else {
                            if (scope.data.arrayData.length > 1) {
                                var ARR = scope.data.arrayData;
                                service.drawBackgroundInCanvas(ARR.array, ARR.h, ARR.w, scope.data.imageinteractions.viewinteractions, scope.data.viewinteractions.lut, Canvas);
                                service.drawLegendInCanvas(scope.data.viewinteractions, ARR.array.GetMaxMin(), scope.data.viewinteractions.lut, CanvasLUT);
                            } else {
                                scope.view(undefined, 230);
                            }
                        }


                    }
                }
            };


            //                                scope.getReport = function() {
            //
            //                                    console.log(scope.data.viewinteractions);
            //                                    var popupWindow = $window.open('mroReport.html', '_blank');
            //                                    popupWindow.JSONDATA = scope.jsondata;
            //                                    popupWindow.DATA = scope.data;
            //
            //                                    popupWindow.USER = cmTASK.getUserLog();
            //
            //
            //                                };

            scope.$watch("data.transform.Zoom", function(x) {
                if (!isUndefined(x) && !isUndefined(Canvas)) {
                    Canvas.setZoom(parseInt(x) / 100);
                }
            }, true);



            scope.$watch("data.imageinteractions", function(x, old) {
                if (x.selectedImage != old.selectedImage) { //if i changed the data results i've to reparse the imagedata bec "Data" might have a different numbe rof slices
                    getAvailableSlices(scope.jsondata, scope.data.imageinteractions.selectedImage).then(function(s) {
                        scope.available.Slices = s;
                        scope.data.imageinteractions.selectedSlice = '0';
                        scope.view(undefined, 'imageinteractions');
                    });
                } else {
                    scope.view(undefined, 'imageinteractions');
                }

            }, true);


            scope.$watch("data.viewinteractions", function(x) {
                scope.view("no need to reparse the data", 'viewinterations');
            }, true);





            $timeout(scope.start, 10);

            scope.$watch("jsondata", function(x, old) {

                if (!(isUndefined(x))) {
                    scope.start();
                    //                the data are changed i've to reload'
                    getAvailableSlices(scope.jsondata, scope.data.imageinteractions.selectedImage).then(function(s) {
                        scope.available.Slices = s;
                    });
                    getAvailableImages(scope.jsondata).then(function(im) {

                        scope.available.Images = im;
                    });
                    scope.view(undefined, 'jsondata changed');
                }
            }, true);


        }
    }
}])


.service('drawingservice', ["$q", function($q) {

    this.canvasDefualtTransformationParameters = function() {
        return {
            scale: 1,
            origin: {
                x: 0,
                y: 0
            },
            transform: [1, 0, 0, 1, 0, 0]
        };


    };

    this.ViewerDefualtDrawParameters = function() {
        return {
            selectedValue: "abs",
            selectedImage: "0",
            selectedSlice: "0"
        };


    };

    this.ViewerDefualtViewerParameters = function() {
        return {
            Min: "0",
            Max: "0",
            FMax: "255",
            lut: "Gray",
        };

    };




    this.parseImageDetails = function(JSONARRAY, IMnumber, slice, IMType) {

        var deferred = $q.defer();

        getArrayfromJsonfileImagenumberAndSlice(JSONARRAY, IMnumber, slice).then(function(q) {

            var V;
            switch (IMType) {
                case 'abs':
                    V = complextoPolarR(q.Vr, q.Vi);
                    break;
                case 'angle':
                    V = complextoPolarP(q.Vr, q.Vi);
                    break;
                case 'real':
                    V = q.Vr;
                    break;
                case 'imag':
                    V = q.Vi;
                    break;
            };


            deferred.resolve({
                array: V,
                h: q.w,
                w: q.h
            });
        });


        return deferred.promise;

    };

    var parsalimmmagine = this.parseImageDetails;

    this.getImagedetailsfromName = function(JSONARRAY, imagename, slice, IMType) {
        var deferred = $q.defer();


        getAvailableImages(JSONARRAY).then(function(the_images) {
            findAndGetWithPromise(the_images, 'imageName', imagename).then(function(ARRAYOFIMAGE) {


                parsalimmmagine(JSONARRAY, ARRAYOFIMAGE[0].id, slice, IMType).then(function(array) {

                    deferred.resolve(array);

                });
            });
        });
        return deferred.promise;
    };

    this.drawBackgroundInCanvas = async function(array, height, width, brightness, LUT, c) {


        var canvasSizeR = {};
        canvasSizeR.w = c.width / width;
        canvasSizeR.h = c.height / height;

        var A = [canvasSizeR.w, canvasSizeR.h];
        var possibleScaling = A.GetMaxMin();

        var OPT = {
            scale: possibleScaling.Min,
            origin: {
                x: parseInt((c.width - (width * possibleScaling.Min)) / 2),
                y: parseInt((c.height - (height * possibleScaling.Min)) / 2)
            }
        };



        //        create the imurl
        var imurl = await asyncArraytoImageURL(array, height, width, brightness, LUT);
        //        plotit 
        fabric.Image.fromURL(imurl, function(img) {
            // console.log("Drawing on canvas");

            img.left = OPT.origin.x;
            img.top = OPT.origin.y;
            img.scaleY = OPT.scale;
            img.scaleX = OPT.scale;

            c.setBackgroundImage(img, c.renderAll.bind(c), {});
        });


    };


    this.drawBackgroundInCanvasWithOPT = async function(array, height, width, brightness, LUT, c, options) {

        var OPT = {};

        if (isUndefined(options)) {
            var canvasSizeR = {};
            canvasSizeR.w = c.width / width;
            canvasSizeR.h = c.height / height;

            var A = [canvasSizeR.w, canvasSizeR.h];
            var possibleScaling = A.GetMaxMin();

            OPT = {
                scale: possibleScaling.Min,
                origin: {
                    x: parseInt((c.width - (width * possibleScaling.Min)) / 2),
                    y: parseInt((c.height - (height * possibleScaling.Min)) / 2)
                }
            };

        } else {
            OPT = options;
        }

        //        create the imurl
        var imurl = await asyncArraytoImageURL(array, height, width, brightness, LUT);
        //        plotit 

        fabric.Image.fromURL(imurl, function(img) {
            img.left = OPT.origin.x;
            img.top = OPT.origin.y;
            img.scaleY = OPT.scale;
            img.scaleX = OPT.scale;

            c.setBackgroundImage(img, c.renderAll.bind(c), {});
        });


    };



    this.drawLegendInCanvas = async function(reduction, imagemaxandmin, LUT, canvas) {
        //brightness,arraymax and min{Max:,Min:},eval(scope.myfactory.functions.getlut()),




        var XL = getgrayscalemageboundaries(imagemaxandmin, reduction, 255.0);

        var mi = XL.Min;
        var ma = XL.Max;

        var arr = await makeArr(0, 255, 256);

        var theLegend = {
            width: 16,
            height: 256
        };


        theLegend.data = await createLUT(theLegend.height, theLegend.width, arr);




        var M = [];
        var O = 0;
        var R = 0.0;
        var begin = {
            top: 5,
            left: 5
        };
        var T = (ma - mi) / 5;
        //        var T=Math.abs(ma-mi)/5;
        //       console.log("legend");



        var DURL = await asyncArraytoImageURL(theLegend.data, theLegend.height, theLegend.width, {
            Min: 0,
            Max: 0
        }, LUT);




        var o = [];
        var l1 = [];
        var LE = new fabric.Group();




        var POWEROF = getNumberAsPowerof(mi + (T * 5), 10);

        console.log * (POWEROF);

        for (var k = 5; k >= 0; k--) {


            var R = mi + (T * k);

            O = theLegend.height * (5 - k) / 5;

            if (k == 5) {
                var v = R.toExponential(2);


            } else {
                var v = (R / POWEROF).toFixed(2);
            }
            o.push(new fabric.Text(v.toString(), {
                fontFamily: 'Arial',
                fontSize: 10,
                left: begin.left + 18,
                top: begin.top + (O) - (10 / 2)

            }));
            LE.addWithUpdate(o[5 - k]);
            l1.push(makeLine([begin.left + 10, begin.top + (O), begin.left + 18, begin.top + (O)]));
            LE.addWithUpdate(l1[5 - k]);


        };




        fabric.Image.fromURL(DURL, function(img) {
            // console.log(LE);
            //                    console.log(img);
            var img1 = img.scale(1).set({
                left: begin.left,
                top: begin.top,
                stroke: 'black',
                strokeWidth: 0.5
            });
            var group = new fabric.Group([img1, LE], {});
            var textBoundingRect = group.getBoundingRect();
            var background = new fabric.Rect({
                top: textBoundingRect.top - 4,
                left: textBoundingRect.left - 4,
                width: textBoundingRect.width + 4,
                height: textBoundingRect.height + 4,
                //                fill: 'rgba(242,242,242,0)'
                fill: 'white'

            });




            canvas.setZoom(canvas.height / background.height);

            canvas.clear().add(new fabric.Group([background, group], {
                left: 0,
                top: 0
            })).renderAll();




        });



    };


    this.getCanvasID = function(c) {
        //        from canvas variable get it's id' but does not work

        return c.getElement().id;
    };


    this.getFabricCanvasFromID = function(c) {
        var newCanvas = document.getElementById(c);
        return this.getCanvasID(newCanvas);
    };




    //    ROI

    this.newRoi = function(n, type, canvas) {

        var deferred = $q.defer();

        var O = getCanvasSize(canvas);

        O.x = O.w / 2;
        O.y = O.h / 2;
        O.visible = true;
        O.groupped = false;
        var OBJ = {};
        switch (type) {
            case 'rect':
                this.NewRect(n, O).then(function(r) {

                    deferred.resolve(r);
                });

                break;

            case 'circle':
                this.NewCircle(n, O).then(function(r) {

                    deferred.resolve(r);
                });
                break;

            case 'polygon':
                this.NewPolygon(n, canvas).then(function(r) {
                    console.log('deddered');
                    deferred.resolve(r);
                });
                break;
        };



        return deferred.promise;
    };

    this.NewRect = function(idv, o) {
        var deferred = $q.defer();

        var ob = new fabric.Rect({
            id: idv,
            left: o.x,
            top: o.y,
            fill: '#FF0000',
            width: 30,
            opacity: 0.5,
            height: 30,
            typeOF: "square",
            visible: o.visible,
            groupped: o.groupped
        });

        deferred.resolve(ob);

        return deferred.promise;
    };


    this.NewCircle = function(idv, o) { //ho tolto il callback
        var deferred = $q.defer();

        var ob = new fabric.Circle({
            id: idv,
            left: o.x,
            top: o.y,
            fill: '#FF0000',
            radius: 10,
            opacity: 0.5,
            typeOF: "circle",
            visible: o.visible,
            groupped: o.groupped

        });
        deferred.resolve(ob);

        return deferred.promise;
    };


    this.NewPolygon = function(idv, thecanvas) {
        var deferred = $q.defer();
        var polygonPoints = [];
        var lines = [];
        var isDrawing = true;

        thecanvas.on('mouse:dblclick', function(o) {

            if (isDrawing) {
                finalize();
            } else {
                isDrawing = false;
            }
        });



        thecanvas.on('mouse:move', function(evt) {
            if (lines.length && isDrawing) {
                var _mouse = this.getPointer(evt.e);
                lines[lines.length - 1].set({
                    x2: _mouse.x,
                    y2: _mouse.y
                }).setCoords();




                thecanvas.renderAll();
            }
        });



        thecanvas.on('mouse:down', function(evt) {
            if (isDrawing) {
                var _mouse = this.getPointer(evt.e);
                var _x = _mouse.x;
                var _y = _mouse.y;
                var line = new fabric.Line([_x, _y, _x, _y], {
                    id: "___myL",
                    strokeWidth: 1,
                    selectable: false,
                    stroke: '#FF0000'
                });

                polygonPoints.push(new fabric.Point(_x, _y));

                lines.push(line);

                thecanvas.add(line);
            }
        });

        function makePolygon(idv) {

            var left = fabric.util.array.min(polygonPoints, "x");
            var top = fabric.util.array.min(polygonPoints, "y");

            polygonPoints.push(new fabric.Point(polygonPoints[0].x, polygonPoints[0].y));

            return new fabric.Polygon(polygonPoints.slice(), {
                id: idv,
                left: left,
                top: top,
                typeOF: "polygon",
                fill: 'red',
                opacity: 0.5,
                visible: true,
                groupped: false
            });
        }

        function finalize() {

            deferred.resolve(makePolygon(idv));

            isDrawing = false;

            var objects = thecanvas.getObjects();


            findAndGetWithPromise(objects, 'id', '___myL').then(function(a) {

                a.forEach(function(theline) { thecanvas.remove(theline) });

            });





            thecanvas.off('mouse:move');
            thecanvas.off('mouse:down');
            thecanvas.off('mouse:up');
            deferred.resolve(true);
            lines.length = 0;
            polygonPoints.length = 0;
        }
        return deferred.promise;
    };




}])



.directive('cmRoiDisplay', ["$timeout", "drawingservice", "cmtool", "$q", function($timeout, service, cmtool, $q) {
    return {
        restrict: 'E',
        scope: {
            jsondata: "=",
            data: "=", //directive data with all inside:)
            usermovingfunction: "=",
            userroiupload: "=", //function to upload ROI
            userroiget: "=" //function to upload ROI

        },
        template: CMROIDISPLAY,
        link: function(scope, element, attrs) {

            var xx = getUIID();
            var xxh = getUIID();
            var xxt = getUIID();
            var xxtb = getUIID();
            var xxo = getUIID();
            var xxd = getUIID();
            scope.init = function() {

                console.log("init canvas");

                scope.data.HISTOGRAM = {
                    id: xx
                };
                scope.data.TABLE = {
                    id: xxh,
                    tableid: xxt,
                    tablebodyid: xxtb,
                    optionaltext: xxo
                };


                scope.data.GROUP = new fabric.Group();
                scope.data.GROUP.id = "__GROUP__";
                scope.data.GROUP.regions = [];


                scope.data.Canvas.add(scope.data.GROUP).renderAll();

                scope.data.serverroidl = xxd;
                scope.data.ROITMP = {
                    opacity: "50",
                    color: '#FF0000',

                };



            };



            scope.removeallrois = function() {


                var deferred = $q.defer();
                //                var T=scope.data.Canvas.getObjects().length;
                //            
                //                scope.data.Canvas.getObjects().forEach(function(o,index){
                //                    console.log(o);
                //                    scope.data.Canvas.remove(o).renderAll();
                //                    if(index==T-1){
                deferred.resolve(true);
                //                    }
                //                });


                scope.data.Canvas.clear();
                deferred.resolve(true);
                return deferred.promise;
            }

            scope.start = function() {
                // console.log("reset and start the canvas");
                scope.data.ROI = [];
                scope.basicroiactivitystart(scope.data.Canvas);
                scope.getServerRois();


                scope.removeallrois().then(function(o) {

                    scope.data.GROUP = new fabric.Group();
                    scope.data.GROUP.id = "__GROUP__";
                    scope.data.GROUP.regions = [];
                    scope.data.Canvas.add(scope.data.GROUP);
                    scope.data.ROI = scope.data.Canvas.getObjects();

                });




                scope.data.ROITMP = {
                    opacity: "50",
                    color: '#FF0000',

                };
                scope.data.ROITMP.explorer = false;
                scope.userMovingFunction = function(evt, data) {

                    try {

                        scope.usermovingfunction(evt, data, data.TABLE);
                    } catch (e) {}
                };





            }

            scope.roiUploader = function(thestring, alias) {
                var deferred = $q.defer();
                if (isFunction(scope.userroiupload)) {
                    scope.userroiupload(thestring, alias).then(function(o) {
                        deferred.resolve(o);
                    });
                } else {
                    deferred.resolve('nouploadfunction');


                }



                return deferred.promise;
            };



            scope.roiGetter = function() {
                var deferred = $q.defer();
                if (isFunction(scope.userroiget)) {
                    scope.userroiget().then(function(o) {
                        deferred.resolve(o);
                    });
                } else {
                    deferred.resolve('nouploadfunction');


                }



                return deferred.promise;
            };


            scope.movingHandler = function(evt) {
                //function that start everytime you move the handler
                //scope.userMovingFunction(evt,scope.data);
                scope.userMovingFunction(evt, scope.data);
                moveHandler(evt)
            }




            scope.$watch('data.ROITMP.color', function(n, o) {

                scope.changeROIColor();
            }, true);

            scope.$watch('data.ROITMP.opacity', function(n, o) {
                if (isUndefined(n)) {

                } else {
                    scope.changeROIOpacity(scope.data.ROITMP.opacity);
                }
            }, true);

            scope.changeROIColor = function() {
                try {
                    scope.data.Canvas.getActiveObject().set("fill", scope.data.ROITMP.color);
                    scope.data.Canvas.renderAll();
                } catch (e) {}


            };


            scope.changeROIOpacity = function(x) {
                try {
                    scope.data.Canvas.getActiveObject().set("opacity", parseFloat(x) / 100);
                    scope.data.Canvas.renderAll();
                } catch (e) {};
            };



            scope.addRoi = function(t) {
                //add new ROI

                service.newRoi("ROI #" + scope.data.ROI.length, t, scope.data.Canvas).then(function(x) {

                    scope.data.ROI = scope.data.Canvas.add(x).renderAll().getObjects();
                    //                    console.log('doppio deferred');
                    //getCanvasRegions(scope.data.Canvas).then(function(r){ scope.data.ROI=r; console.log(scope.data.ROI);});
                });
            };



            //            scope.$watch("data.Canvas",function(x){  
            //                if(isUndefined(x)){}else{basicroiactivitystart(scope.data.Canvas);}},true);


            scope.$watch("data.ROITMP.explorerValue", function(x) {
                //    console.log(scope.data.ROITMP.explorerValue)
            });


            scope.$watch("jsondata", function(x) {
                // console.log("changed json in roiviewer");
                if (!(isUndefined(x))) {
                    //the data are changed i've to reload'
                    scope.start();
                    // console.log(scope.data);

                }
            }, true);


            scope.basicroiactivitystart = function(c) {
                c.on('object:selected', scope.movingHandler);
                c.on('object:over', scope.movingHandler);
                c.on('object:modified', scope.movingHandler);
                c.on('selection:cleared', function(evt) {
                    c.discardActiveObject().renderAll();
                });
            };



            scope.basicroiactivitystop = function(c) {
                c.off('object:selected');
                c.off('object:over');
                c.off('object:modified');
                c.off('selection:cleared');
            };


            scope.exoploreCanvas = function() {
                var v = scope.data.ROITMP.explorer;
                //   console.log(v);

                if (v) {
                    scope.basicroiactivitystop(scope.data.Canvas);
                    scope.data.Canvas.on('mouse:move', function(e) {
                        getMouseCoordsonMove(e);
                    });


                } else {
                    scope.data.Canvas.off('mouse:move')
                    scope.basicroiactivitystart(scope.data.Canvas);
                    var myEl = angular.element(document.querySelector('#expv'));
                    var myEl2 = angular.element(document.getElementById('test'));
                    myEl2.innerHTML = '';
                    myEl.text('');
                }


            };




            function getMouseCoordsonMove(event) {
                var pointer = scope.data.Canvas.getPointer(event.e);
                var posX = pointer.x;
                var posY = pointer.y;



                getCanvasOriginAndScale(scope.data.Canvas, scope.data.arrayData.w, scope.data.arrayData.h).then(function(x) {
                    parseDataonPoint(posX, posY, scope.data.arrayData, scope.data.Canvas, x.origin, x.scale, scope.data.Canvas.viewportTransform).then(function(px0) {
                        var myEl = angular.element(document.querySelector('#expv'));
                        myEl.text(px0[0].toFixed(3) + " (" + px0[0].toExponential(3) + ") ");
                    });
                });

            };




            scope.backupGROUPROI = function() {

                var TOSAVE = {
                    version: "3.6.2",
                    objects: []
                };


                scope.data.GROUP.forEachObject(function(o, i) {
                    var clone = fabric.util.object.clone(o);
                    var clone = fromGroupCoordTocanvas(clone, scope.data.GROUP);
                    TOSAVE.objects.push(clone.toJSON(ROIWHATSAVEANDLOAD));

                });

                var a = prompt("Save Group ROIs with the following name");

                scope.roiUploader(TOSAVE, a).then(function(o) {
                    scope.roiGetter().then(function(r) { scope.data.serverROIs = r; });
                });
            };





            scope.backupROI = function(x) {
                var id = x.id;
                createFabricStringROI(x).then(function(theregionasastring) {
                    console.log(id);
                    console.log(theregionasastring);

                    scope.roiUploader(theregionasastring, id).then(function(o) {
                        scope.roiGetter().then(function(r) { scope.data.serverROIs = r; });
                    });
                });




            };



            scope.getServerRois = function() {
                scope.roiGetter().then(function(r) { scope.data.serverROIs = r; });
            };



            scope.showRegion = function(x) {

                //    console.log(x);

                if (x.visible) {
                    x.opacity = 0.5;
                } else {
                    x.opacity = 0;
                }


                scope.data.Canvas.renderAll();

            };



            scope.removeRoi = function(x) {



                var O = findAndGet(scope.data.Canvas.getObjects(), 'id', x);

                //  console.log(O);
                O.forEach(function(r) {
                    scope.data.ROI = scope.data.Canvas.remove(r).renderAll().getObjects();
                    scope.data.lastROI = JSON.stringify(r.toJSON(ROIWHATSAVEANDLOAD));
                });

            }

            scope.activateGroup = function() {

                //                                    console.log(scope.data.GROUP);
                scope.data.Canvas.setActiveObject(scope.data.GROUP).renderAll();
                scope.movingHandler({
                    target: scope.data.GROUP
                });
            }


            scope.showGroup = function(stato) {

                if (stato) {
                    scope.data.GROUP.opacity = 100;
                    scope.data.Canvas.renderAll();

                } else {
                    scope.data.GROUP.opacity = 0;
                    scope.data.Canvas.renderAll();
                }

                scope.data.GROUP.regions.forEach(function(r) {
                    r.visible = stato;
                });
            };



            scope.activateRoi = function(x) {
                scope.data.Canvas.getObjects().forEach(function(o, i) {
                    if (o.id == x) {
                        scope.data.Canvas.discardActiveObject().setActiveObject(o).renderAll();
                        scope.data.ROITMP.color = o.fill;
                        scope.data.ROITMP.opacity = (100 * o.opacity).toString();

                    }
                });
            };

            scope.ROIselected = function(x) {

                if (!(isUndefined(x))) {
                    var A = findAndGet(scope.data.serverROIs, "ID", x);
                    scope.loadROI(A[0]["filename"]);
                } else {
                    scope.roiGetter().then(function(r) { scope.data.serverROIs = r; });

                }
            };



            scope.loadROI = function(x) {
                //   console.log(x);
                cmtool.getJson(x).then(function(data) {


                    try {
                        var thedata_ = JSON.parse(data);

                        thedata_.objects.forEach(function(o) {

                            var origRenderOnAddRemove = scope.data.Canvas.renderOnAddRemove;

                            scope.asynccreateRegionFromROI(o).then(function(v) {
                                //  console.log(v);
                                v.groupped = false;
                                v.visible = true;
                                scope.data.ROI = scope.data.Canvas.add(v).renderAll().getObjects();
                                scope.data.Canvas.renderOnAddRemove = origRenderOnAddRemove;
                            });

                        });

                    } catch (e) {
                        data.objects.forEach(function(o) {

                            var origRenderOnAddRemove = scope.data.Canvas.renderOnAddRemove;

                            scope.asynccreateRegionFromROI(o).then(function(v) {

                                v.groupped = false;
                                v.visible = true;
                                scope.data.ROI = scope.data.Canvas.add(v).renderAll().getObjects();
                                scope.data.Canvas.renderOnAddRemove = origRenderOnAddRemove;
                            });

                        });
                    }



                });
            };

            scope.asynccreateRegionFromROI = function(r) {
                var deferred = $q.defer();
                //     console.log(r);

                switch (r.type) {
                    case 'circle':
                        deferred.resolve(new fabric.Circle(r));

                        break;
                    case 'rect':
                        deferred.resolve(new fabric.Rect(r));
                        break;
                    case 'polygon':
                        deferred.resolve(new fabric.Polygon(r.points.slice(), r));
                        break;



                };

                return deferred.promise;



            }


            scope.undoROI = function() {




                if (scope.data.lastROI === null) {
                    //     console.log("no memories:)");
                } else {

                    var origRenderOnAddRemove = scope.data.Canvas.renderOnAddRemove;

                    var v = createRegionFromROI(jsonCopy(JSON.parse(scope.data.lastROI)));
                    //    console.log(v);

                    scope.data.ROI = scope.data.Canvas.add(v).renderAll().getObjects();
                    scope.data.Canvas.renderOnAddRemove = origRenderOnAddRemove;
                    scope.data.lastROI = null;
                };
            };

            scope.saveAllROIs = function() {




                var TOSAVE = scope.data.Canvas.toJSON(ROIWHATSAVEANDLOAD);



                scope.data.GROUP.forEachObject(function(o, i) {
                    var clone = fabric.util.object.clone(o);
                    var clone = fromGroupCoordTocanvas(clone, scope.data.GROUP);
                    TOSAVE.objects.push(clone.toJSON(ROIWHATSAVEANDLOAD));

                });







                var a = prompt("Save all ROIs with the following name");

                scope.roiUploader(TOSAVE, a).then(function(o) {
                    scope.roiGetter().then(function(r) { scope.data.serverROIs = r; });
                });

            };





            scope.setGroup = function(O) {




                var G = findAndGet(scope.data.Canvas.getObjects(), 'id', scope.data.GROUP.id);




                if (O.groupped) {


                    //                    copytheroi to pu it again
                    scope.data.GROUP.regions.push(jsonCopy(O.toJSON(ROIWHATSAVEANDLOAD)));

                    G[0].addWithUpdate(O);
                    scope.data.Canvas.remove(O).setActiveObject(G[0]).renderAll();


                    scope.data.ROI = scope.data.Canvas.remove(O).renderAll().getObjects();
                } else {


                    var OG = getRegionInGroup(G[0], 'id', O.id);

                    var COG = OG.toJSON(ROIWHATSAVEANDLOAD);

                    COG = fromGroupCoordTocanvas(COG, G[0]);


                    findAndRemove(scope.data.GROUP.regions, 'id', O.id);

                    //       console.log(OG);

                    OG.set('dirty', true)
                    G[0].removeWithUpdate(OG);

                    COG.groupped = false;




                    var origRenderOnAddRemove = scope.data.Canvas.renderOnAddRemove;

                    scope.asynccreateRegionFromROI(COG).then(function(v) {
                        //                                            console.log(v);
                        scope.data.ROI = scope.data.Canvas.add(v).renderAll().getObjects();
                        scope.data.Canvas.renderOnAddRemove = origRenderOnAddRemove;
                    });



                }




            }




            function moveHandler(evt) {
                //normal move handler
                var Xn = 0
                var Xv = 0

                var XN = [];
                var XV = [];



                getCanvasOriginAndScale(scope.data.Canvas, scope.data.arrayData.w, scope.data.arrayData.h).then(function(x) {

                    getROIData(scope.data.arrayData, evt.target, scope.data.Canvas, x.origin, x.scale, scope.data.Canvas.viewportTransform).then(function(y) {
                        makePlotlyHistogram(y, evt.target.id, scope.data.HISTOGRAM.id);
                        makeTableStat(y, scope.data.TABLE);
                    });

                });
            };

            $timeout(scope.init, 10);

        }
    }
}])