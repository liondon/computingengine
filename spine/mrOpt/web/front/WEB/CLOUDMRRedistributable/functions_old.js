


var isROIinGroup=function(r,G){


        for(var i = 0; i < G.length; i++)
        {
            if(G[i].id == r)
            {
                return true;

            }
        }
        return false;    
    };



var fabricROItoJSON=function(x){
    
    return JSON.stringify(x.toJSON(["id","typeOF"]));
};

var JSONtofabricROI=function(x){
    
    return JSON.parse(x);
};



var fromGroupCoordTocanvas=function(ob,G){
    
    
    var width = G.width;
  var height = G.height;
    
    var left = G.left + ob.left + (width / 2);
    var top = G.top + ob.top + (height / 2);
    ob.left=left;
    ob.top=top;
    
    
    
      
    return ob
}
var getCloneRegionInGroup=function(G,property,v){
    R=undefined;
    
    G.forEachObject(function(obj,index){

        if (obj[property]==v){

            console.log(obj);
            var ob= fabric.util.object.clone(obj);
            console.log(ob);
            ob.top=ob.top+G.top;
            ob.left=ob.left+G.left;
            R=ob;
        }
    });
    return R;
};


var getRegionInGroup=function(G,property,v){
    R=undefined;
    
    G.forEachObject(function(obj,index){

        if (obj[property]==v){

                    
            R=obj;
        }
    });
    return R;
};




var getRegionsInGroup=function(G){
    R=[];
    G.forEachObject(function(obj,index){

        if (obj.id!=undefined){

            //
            
            R.push(obj);
        }
    });
    return R;
};


var createRegionFromROI=function(r){


    switch(r.type){
        case 'circle':
            var ob= new fabric.Circle(r);

            break;
        case 'rect':
            var ob=new fabric.Rect(r);
            break;
        case 'polygon':                    
            var ob=new fabric.Polygon(r.points.slice(),r);
            break;



    };
    //    console.log(ob);
    return ob;
};

var putRegiononCanvas=function(r,c){
    var origRenderOnAddRemove = c.renderOnAddRemove;

    var v=createRegionFromROI(jsonCopy(r));
    //    console.log(v);

    c.add(v);
    c.renderOnAddRemove = origRenderOnAddRemove;

}





function Quartile(data, q) {
    data=Array_Sort_Numbers(data);
    var pos = ((data.length) - 1) * q;
    var base = Math.floor(pos);
    var rest = pos - base;
    if( (data[base+1]!==undefined) ) {
        return data[base] + rest * (data[base+1] - data[base]);
    } else {
        return data[base];
    }
}

function Array_Sort_Numbers(inputarray){
    return inputarray.sort(function(a, b) {
        return a - b;
    });
}

function Array_Sum(t){
    return t.reduce(function(a, b) { return a + b; }, 0); 
}

function Array_Average(data) {
    return Array_Sum(data) / data.length;
}

function Array_Stdev(tab){
    var i,j,total = 0, mean = 0, diffSqredArr = [];
    for(i=0;i<tab.length;i+=1){
        total+=tab[i];
    }
    mean = total/tab.length;
    for(j=0;j<tab.length;j+=1){
        diffSqredArr.push(Math.pow((tab[j]-mean),2));
    }
    return (Math.sqrt(diffSqredArr.reduce(function(firstEl, nextEl){
        return firstEl + nextEl;
    })/tab.length));  
}




function formatBytes(bytes) {
    if(bytes < 1024) return bytes + " Bytes";
    else if(bytes < 1048576) return(bytes / 1024).toFixed(3) + " KB";
    else if(bytes < 1073741824) return(bytes / 1048576).toFixed(3) + " MB";
    else return(bytes / 1073741824).toFixed(3) + " GB";
};


function basename(path) {
    return path.split('/').reverse()[0];
}



function testNan(x) {
    var O;
    if(isNaN(x)){
        O=0;
    }else{
        O=parseInt(x)
    };
    return O;
};





var getROIImage=function(data,roi,canvas,canvasOrigin,canvasScale,vpTransform){
    //get the bounding box of the object in canvas     
    var bound = roi.getBoundingRect();

    var P={};
    P.bound=bound;
    P.ALL=this;

    //    console.log(canvasScale);
    //    console.log(bound);
    //    var width=data.h;
    var width=data.w;
    //    var height=data.w;
    var height=data.h;

    var px0=[];
    var arr=data.array;

    var pos;

    //console.log(data);

    Origin=canvasOrigin;
    var F=canvasScale;//myFabric.scaleF;

    // console.log(F);
    var c=0;
    var xi,yi;
    //point to canvas transformation
    var mInverse = fabric.util.invertTransform(vpTransform); //myFabric.Canvas.viewportTransform


    //    console.log(canvas);

    //this can be rasterize bc are real point in the image
    for(var yt=bound.top;yt<bound.top+bound.height;yt+=F){
        for(var xt=bound.left;xt<bound.left+bound.width;xt+=F){
            //points in the canvas
            var myP=new fabric.Point(xt, yt);
            // console.log(myP);

            //on the image worlfd
            var ps = fabric.util.transformPoint(myP, mInverse);

            if (c==0)    {
                c++
            };

            if(canvas.isTargetTransparent(roi, xt, yt)){
                px0.push(NaN);
            }else{
                xi=(ps.x/F)-Origin.x;
                yi=(ps.y/F)-Origin.y;

                pos =(( width * Math.round(yi)) + Math.round(xi));

                px0.push(arr[pos]);
                //                            console.log("in");
            }
        }


    };




    return px0;
};



function jsonCopy(src) {
    return JSON.parse(JSON.stringify(src));
}

function myLUT(bx,c,LUT,canvas){
    //brightness,arraymax and min{Max:,Min:},eval(scope.myfactory.functions.getlut()),





    var XL=getLUTboundaries(c,bx);

    var mi=XL.Min;
    var ma=XL.Max;

    var arr=makeArr(0,255,256);

    var myLUT={width:16,height:256};

    var data=createLUT(myLUT.height,myLUT.width,arr);
    myLUT.data=data;



    var M=[];
    var O=0;
    var R=0.0;
    var begin={top:5,left:5};
    var T=(ma-mi)/5;
    //        var T=Math.abs(ma-mi)/5;
    //       console.log("legend");

    var DURL= ArraytoImageURL(myLUT.data,{Min:0,Max:0},myLUT.height,myLUT.width,LUT);




    var o=[];
    var l1=[];
    var LE= new fabric.Group();
    for (var k=5;k>=0;k--){


        var R=mi+(T*k);

        O=myLUT.height*(5-k)/5;

        var v=R.toExponential(2);
        o.push(new fabric.Text(v.toString(), {
            fontFamily: 'Arial',
            fontSize:12,
            left:begin.left+18,
            top:begin.top+(O)-(16/2)

        }));
        LE.addWithUpdate(o[5-k]);    
        l1.push(makeLine([ begin.left+10 ,begin.top+(O), begin.left+18 ,begin.top+(O)]));  
        LE.addWithUpdate(l1[5-k]);    


    };








    fabric.Image.fromURL(DURL, function(img) {
        // console.log(LE);
        //                    console.log(img);
        var img1 = img.scale(1).set({ left: begin.left, top: begin.top,stroke: 'black',
                                     strokeWidth: 0.5 });
        var group = new fabric.Group([ img1,LE ], {  });
        var textBoundingRect = group.getBoundingRect();
        var background = new fabric.Rect({
            top: textBoundingRect.top-4,
            left: textBoundingRect.left-4,
            width: textBoundingRect.width+4,
            height: textBoundingRect.height+4,
            fill: 'rgb(242,242,242)'
        });




        //                                scope.data.Canvas.clear().dispose().add(LEGEND).renderAll();
        //        console.log(background);
        //        console.log(group);



        canvas.setZoom(canvas.height/background.height);

        canvas.clear().add(new fabric.Group([background, group], {left:0,top:0})).renderAll();




    });  



};





function imageandlut(c,im,legend){
    //    console.log(im);



    c.width = parseInt(im.width+legend.width);
    c.height = im.height;


    var contextScreenshot = c.getContext("2d");
    // Draw the layers in order

    contextScreenshot.fillStyle = "black";
    contextScreenshot.fillRect(0, 0, c.width, c.height);

    contextScreenshot.drawImage(legend, 0, 0,);
    contextScreenshot.drawImage(im, legend.width, 0);
    //    contextScreenshot.drawImage(legend, c.width*4/5, 0);


}



function formatBytes(bytes) {
    if(bytes < 1024) return bytes + " Bytes";
    else if(bytes < 1048576) return(bytes / 1024).toFixed(3) + " KB";
    else if(bytes < 1073741824) return(bytes / 1048576).toFixed(3) + " MB";
    else return(bytes / 1073741824).toFixed(3) + " GB";
};


function basename(path) {
    return path.split('/').reverse()[0];
}



function testNan(x) {
    var O;
    if(isNaN(x)){
        O=0;
    }else{
        O=parseInt(x)
    };
    return O;
};


function median(numbers) {
    // median of [3, 5, 4, 4, 1, 1, 2, 3] = 3
    var median = 0, numsLen = numbers.length;
    numbers.sort();

    if (
        numsLen % 2 === 0 // is even
    ) {
        // average of two middle numbers
        median = (numbers[numsLen / 2 - 1] + numbers[numsLen / 2]) / 2;
    } else { // is odd
        // middle number only
        median = numbers[(numsLen - 1) / 2];
    }

    return median;
}




function makePolygonFromSkratch (polygonPoints,idv) {

    console.log(polygonPoints);

    var left = fabric.util.array.min(polygonPoints, "x");
    var top = fabric.util.array.min(polygonPoints, "y");

    polygonPoints.push(new fabric.Point(polygonPoints[0].x, polygonPoints[0].y));

    return new fabric.Polygon(polygonPoints.slice(), {
        id:idv,
        left: left,
        top: top,
        typeOF:"polygon",
        fill: 'red',
        stroke: 'black',
        opacity:0.5
    });
};

function getUIID() {

    return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
};

function iterationCopy(src) {
    let target = {};
    for (let prop in src) {
        if (src.hasOwnProperty(prop)) {
            target[prop] = src[prop];
        }
    }
    return target;
}



function makeArr(startValue, stopValue, cardinality) {
    var arr = [];
    var currValue = startValue;
    var step = (stopValue - startValue) / (cardinality - 1);
    for (var i = 0; i < cardinality; i++) {
        arr.push(currValue + (step * i));
    }
    return arr;
}


function createLUT(height,width,XX){
    var data =[];
    for (var i = height; i >0 ; i--)
    {
        for (var j = width; j >0; j--)
        {
            data.push(XX[i]);
        }

    }
    return data;
};


function subPlotShape(N) {

    switch(N){

        case 16:
            var S={"c":4,"r":4};
            break;
        case 20:
            var S={"c":5,"r":4};
            break;
        case 32:
            var S={"c":6,"r":6};
            break;
        case 64:
            var S={"c":8,"r":8};
            break;


    };
    var O=[];
    for(var a=0;a<S.r;a++){
        for (var b=0;b<S.c;b++){
            O.push({"r":a,"c":b});
        };
    };
    return O;
}



var mult = function (a1, a2) {
    var result = [];
    for(var i = 0; i < a1.length; i++) {
        result[i] = a1[i] * a2[i];
    }
    return result;
}


function makeLine(coords) {
    return new fabric.Line(coords, {
        fill: 'black',
        stroke: 'black',
        strokeWidth: 1
    });
}


function parseImages(JSONARRAY){
    console.log(JSONARRAY)
    var v=JSONARRAY.images;
    for(var i=0;i<v.length;i++){
        v[i].id=i;
    }
    return v;
};

function isUndefined(x){
    if (typeof x === "undefined"){
        return true;
    }else{
        return false;
    }
};


const monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];



function getmydate(x){
    
 var d= new Date();
    switch(x){
     case 'y-m-g':
     case 'yyyy-mm-gg':
     case 'yyyy-mm-gg':
        var c=d.getFullYear().toString() +"-"+d.getMonth().toString()+"-"+ d.getDate().toString();
            break;
    case 'mmNgg,YYYY':
        var c=monthNames[d.getMonth()]+" "+ d.getDate().toString() +", " +d.getFullYear().toString();
            break;
    }
        return c;
}




function parseImageSlices(JSONARRAY,IMnumber) {
    if ( isUndefined(JSONARRAY.images[IMnumber].slice[0])){
        var q=0;
    }else{
        var q=JSONARRAY.images[IMnumber].slice.length;

    } 

    return q;
};

function parseImageDetails(JSONARRAY,IMnumber,slice,IMType) {


    if(isUndefined(JSONARRAY.images.length)){ 
        var q=JSONARRAY.images.slice;
    }else {
        if ( isUndefined(JSONARRAY.images[IMnumber].slice[slice])){
            var q=JSONARRAY.images[IMnumber].slice;
        }else{
            var q=JSONARRAY.images[IMnumber].slice[slice];
        }
    }




    switch (IMType){
        case 'abs':
            var V =complextoPolarR(q.Vr,q.Vi);
            break;
        case 'angle':
            var V=complextoPolarP(q.Vr,q.Vi);
            break;
        case 'real':
            var V=q.Vr;
            break;
        case 'imag':
            var V=q.Vi;
            break;
    };


    var data={array:V,h:q.w,w:q.h};

    return data;
}



function findAndGetWithRegexp(array, property, pattern) {

    const r =new RegExp(pattern);
    var out=[];
    array.forEach(function(result, index) {
        if(r.test(result[property])) {
            //keep

            var U=result;
            U.RID=index;
            out.push(U);
        }    
    });
    return out;
};


function findAndGetWithRegexpWithPromise(array, property, pattern) {
 return new Promise(function(resolve){
    const r =new RegExp(pattern);
    var out=[];
    array.forEach(function(result, index) {
        if(r.test(result[property])) {
            //keep

            var U=result;
            U.RID=index;
            out.push(U);
        }    
    });
    resolce(out);
 });
};






function findAndRemoveP(array, property, value) {
    //   console.log(value);
    //    console.log(property);

    return new Promise(function(resolve,reject){
        array.forEach(function(result, index) {
            //  console.log(result);
            if(result[property] === value) {
                //Remove from array
                array.splice(index, 1);

                resolve(true);
            };    
        });

    });
};








function CANELLALODIOSANTO(array, property, value) {
    //   console.log(value);
    //    console.log(property);

    return new Promise(function(resolve,reject){
        array.forEach(function(result, index) {
            //  console.log(result);
            if(result[property] === value) {
                //Remove from array
                array.splice(index, 1);

                resolve(array);

            };    
        });

    });

};





function findAndRemove(array, property, value) {

    array.forEach(function(result, index) {
        if(result[property] === value) {
            //Remove from array
            array.splice(index, 1);
        }    
    });
}


function findAndRemoveWithRegexp(array, property, pattern) {

    console.log(array);
    var r =new RegExp(pattern);

    array.forEach(function(o, index) {

        console.log(o[property]);
        if(r.test(o[property])) {
            //keep
            array.splice(index, 1);

        }    
    });
    return array;
};




function removeWhatIsnotRegexp(array, property, pattern) {

    console.log(array);
    var r =new RegExp(pattern);

    array.forEach(function(o, index) {

        console.log(o[property]);
        if(!(r.test(o[property]))) {
            //keep
            array.splice(index, 1);

        }    
    });
    return array;
};



function findAndGet(array, property, value) {
    var out=[];
    array.forEach(function(result, index) {

        if(result[property] === value) {
            //Remove from array
            out.push(result);
        }    
    });
    return out;
}



function findAndChange(array, property, valueOld,valueNew) {
    array.forEach(function(result, index) {
        if(result[property] === valueOld) {
            //Remove from array
            result[property]=valueNew;

        }    
    });
}



if (typeof Array.prototype.GetMaxMin === "undefined") {

    Array.prototype.GetMaxMin = function() {


        var max = Number.MIN_VALUE, min = Number.MAX_VALUE;
        for (var i = 0, len=this.length; i < len; i++) {
            if(isNaN(this[i])){

            }else{
                if (this[i] > max) max = this[i];
                if (this[i] < min) min = this[i];
            }
        }
        return { Max: max, Min: min};
    }
}



Array.prototype.GetMaxMinMean = function(x) {



    var M=average(purgenan(this));
    var S=std(purgenan(this));

    return { Max: M+(x*S), Min: M-(x*S)};
}


Array.prototype.GetMaxMinQuartile = function() {       



    return { Max: Quartile(purgenan(this),0.99), Min:Quartile(purgenan(this),0.01)};
}



var SelectObject = function (ObjectName,canvas) {
    canvas.getObjects().forEach(function(o) {
        if(o.id === ObjectName) {
            canvas.setActiveObject(o);
        }
    })
}



var complextoPolarR = function(re,im){

    var o=[]
    for(var y = 0; y < re.length; y++) {
        var a = math.complex(re[y], im[y]);
        var p=a.toPolar();

        o[y]=p.r;
        //o[y].phi=p.phi;
    };

    return o;
}

var complextoPolarP = function(re,im){

    var o=[]
    for(var y = 0; y < re.length; y++) {
        var a = math.complex(re[y], im[y]);
        var p=a.toPolar();
        // console.log(p);
        o[y]=p.phi;
        //o[y].phi=p.phi;
    };

    return o;
}



//var bufferFromArrayWithBrightness = function(data,b,height,width)
//{   
//   
//    var buffer = new Uint8Array(width * height * 4);
//    var B=data.GetMaxMin();
//    var m=(b.Max-b.Min)/(B.Max-B.Min);
//    var q=b.Max-(B.Max*m);
//
//
//
//    for(var y = 0; y < height; y++) {
//        for(var x = 0; x < width; x++) {
//            var pos = (y * width + x) * 4; // position in buffer based on x and y
//
//            //matlab array is different
//            //                for(var y = 0; y < width; y++) {
//            //                    for(var x = 0; x < height; x++) {
//            //                        var pos = (y * height + x) * 4; // position in buffer based on x and y
//
//
//
//
//            //                        V=Math.sqrt((Math.pow(j.Vr[pos/4],2)+Math.pow(j.Vi[pos/4],2))); //*255/3;
//            V=(m*data[pos/4])+q;
//            console.log(V);
//            buffer[pos  ] =V ;           // some R value [0, 255]
//            buffer[pos+1] = V;           // some G value
//            buffer[pos+2] = V;           // some B value
//            buffer[pos+3] = 255;           // set alpha channel
//
//        }
//    }    
//    return buffer;
//};


var ArraytoImageURL = function(data,b,height,width,LUT,B){
    var c = document.createElement('canvas');

    c.setAttribute('id', '_temp_canvas');
    c.width = width;
    c.height = height;

    // create imageData object
    // create imageData objectset
    var idata = c.getContext('2d').createImageData(c.width, c.height);

    // set our buffer as source

    //    var buffer =bufferFromArrayWithBrightness (data,b,c.height,c.width,eval(LUT));
    var buffer =bufferFromArrayWithBrightnessv2 (data,b,c.height,c.width,eval(LUT),B);
    idata.data.set(buffer);

    c.getContext('2d').putImageData(idata, 0, 0);
    var O=c.toDataURL();
    c = null;
    $('#_temp_canvas').remove();

    return O;
};


function linethough2points(P,Q){

    //    console.log(P);
    //    console.log(Q);

    var M= (P.y-Q.y)/(P.x-Q.x);
    var Q= (((P.y-Q.y)/(P.x-Q.x))*Q.x)-Q.y;

    var FIT={q:Q,m:M};
    //    console.log(FIT);
    return FIT;
};


function getLUTboundaries(Ra,bq){
    //real balues, diminuzione
    //get the range
    var R=Math.abs(Ra.Max-Ra.Min);
    //get the reduction
    var D={Max:bq.Max*R/255,Min:bq.Min*R/255};
    // get the new X values
    //  console.log(D);
    var X={Max:Ra.Max-D.Max,Min:Ra.Min+D.Min};

    return X;
};
var bufferFromArrayWithBrightnessv2 = function(data,LL,height,width,GG,B)
{   //GG is the lut





    //  console.log(b);
    //https://library.weschool.com/lezione/retta-per-due-punti-equazione-formula-geometria-analitica-13091.html

    var buffer = new Uint8Array(width * height * 4);
    //    console.log(B);
    if (isUndefined(B)){
        var B=data.GetMaxMin();
    };

    var b2={Max: parseFloat(LL.Max),Min:parseFloat(LL.Min)};
    var X=getLUTboundaries(B,b2);


    //console.log(" real range "+B.Min +" " + B.Max);
    //console.log(" fake range "+X.Min +" " + X.Max);

    var Y={Max:255,Min:0};





    var FIT=linethough2points({x:X.Min,y:Y.Min},{x:X.Max,y:Y.Max});

    // console.log(FIT);
    var m=FIT.m;
    var q=FIT.q;

    var L={};

    //    console.log(m);
    //            _/- or -\_
    if (FIT.m>=0){L.Min=Y.Min,L.Max=Y.Max}else{L.Min=Y.Max,L.Max=L.Min};

    //    console.log(FIT);

    //    var m= (b.Min-b.Max)/(B.Min-B.Max);
    //    var q= ((B.Min*b.Max)-(B.Max*b.Min))/(B.Min-B.Max);

    //      console.log(L);

    var ff=[];
    var g=0;
    for(var y = 0; y < height; y++) {
        for(var x = 0; x < width; x++) {
            var pos = (y * width + x) * 4; // position in buffer based on x and y



            g=data[pos/4];

            if (g<X.Min ||isNaN(g)){
                V=0;
            };

            if (g>X.Max){
                V=255;
            };

            if (g<=X.Max && g>=X.Min){
                V=Math.floor((m*parseFloat(g))+q);


                if (V>L.Max){V=L.Max;};
                if (V<L.Min){V=L.Min;};
                if (isNaN(V)){V=0};



            }


            //console.log("g is " + g + " and V is " + V);
            //lut is 512 bright leevl 256
            V2=((V)*2);
            //            console.log(V2);
            try{
                buffer[pos  ] = 255*GG[V2][1][0];           // some R value [0, 255]
                buffer[pos+1] = 255*GG[V2][1][1];           // some G value
                buffer[pos+2] = 255*GG[V2][1][2];           // some B value
                buffer[pos+3] = 255;           // set alpha channel
                //                ff.push(V2);
            }catch(e){
                //                console.log("V is:"+ V +" V2 is "+ V2);
                console.log("error");
            }

            //            console.log(ff.length);

        }
    }  
    //    console.log("ff" );
    //    console.log( ff.GetMaxMin());
    return buffer;
};


var bufferFromArrayWithBrightness = function(data,b,height,width,GG)
{   //GG is the lut



    b.Min=parseInt(b.Min);
    b.Max=parseInt(b.Max);



    var buffer = new Uint8Array(width * height * 4);
    var B=data.GetMaxMin();


    var m= (b.Min-b.Max)/(B.Min-B.Max);
    var q= ((B.Min*b.Max)-(B.Max*b.Min))/(B.Min-B.Max);

    var ff=[];
    for(var y = 0; y < height; y++) {
        for(var x = 0; x < width; x++) {
            var pos = (y * width + x) * 4; // position in buffer based on x and y

            //matlab array is different
            //                for(var y = 0; y < width; y++) {
            //                    for(var x = 0; x < height; x++) {
            //                        var pos = (y * height + x) * 4; // position in buffer based on x and y




            //                        V=Math.sqrt((Math.pow(j.Vr[pos/4],2)+Math.pow(j.Vi[pos/4],2))); //*255/3;
            V=Math.floor(m*parseFloat(data[pos/4]));
            //            V=Math.floor(((-a0*parseFloat(data[pos/4]))-a2)/a1);
            //            console.log(V);

            if (V>b.Max){V=b.Max;};
            if (V<b.Min || isNaN(V)){V=b.Min;};


            V2=(V*2)+1;

            buffer[pos  ] = 255*GG[V2][1][0];           // some R value [0, 255]
            buffer[pos+1] = 255*GG[V2][1][1];           // some G value
            buffer[pos+2] = 255*GG[V2][1][2];           // some B value
            buffer[pos+3] = 255;           // set alpha channel
            ff.push(V2);
        }
    }  
    //    console.log(ff.GetMaxMin());
    return buffer;
};

//var getRegionvalues=function(obj,J,t,Origin,canvas,px0){
//
//    var bound = obj.getBoundingRect();
//
//
//    //get the image and parse it
//    var b=undefined;
//
//    var P={};
//    P.bound=bound;
//    P.t=t;
//    P.ALL=this;
//
//
//
//
//
//
//
//
//
//    var q;
//    console.log(J);
//
//    if (J.slice.isArray){
//        q=J.slice[sl];
//    }else{
//        q=J.slice;
//    }
//
//
//    console.log(q);
//
//
//    var width=q.h;
//    var height=q.w;
//
//
//    //        var c=complextoPolarR(q.Vr,q.Vi);
//    //        var d=complextoPolarP(q.Vr,q.Vi);
//
//
//
//    var arr;
//
//
//    switch (t){
//        case 'abs':
//            arr =complextoPolarR(q.Vr,q.Vi);
//            break;
//        case 'angle':
//            arr=complextoPolarP(q.Vr,q.Vi);
//            break;
//        case 'real':
//            arr=q.Vr;
//            break;
//        case 'imag':
//            arr=q.Vi;
//            break;
//    };
//
//
//
//
//
//    var pos;
//    //        Origin=myFabric.getImageOrigin();
//
//    var c=0;
//    var xi,yi;
//    //point to canvas transformation
//    var mInverse = fabric.util.invertTransform(canvas.viewportTransform);
//
//    for(var xt=bound.left;xt<bound.left+bound.width;xt++){
//        for(var yt=bound.top;yt<bound.top+bound.height;yt++){
//            //points in the canvas
//            var myP=new fabric.Point(xt, yt);
//            //on the image worlfd
//            var ps = fabric.util.transformPoint(myP, mInverse);
//
//            if (c==0)    {
//
//
//
//
//                c++
//                //      console.log(" inv " + ps );
//            };
//
//
//
//            if(obj.containsPoint(myP)){
//                xi=ps.x-Origin.x;
//                yi=ps.y-Origin.y;
//                pos =(( width * Math.round(yi)) + Math.round(xi));
//                px0.push(arr[pos]);
//
//            };
//        }
//
//    }
//
//    return px0;
//};




var bufferFromArrayWithBrightness2 = function(data,b,height,width)
{   

    var buffer = new Uint8ClampedArray(width * height * 4);




    for(var y = 0; y < height; y++) {
        for(var x = 0; x < width; x++) {
            var pos = (y * width + x) * 4; // position in buffer based on x and y

            //matlab array is different
            //                for(var y = 0; y < width; y++) {
            //                    for(var x = 0; x < height; x++) {
            //                        var pos = (y * height + x) * 4; // position in buffer based on x and y




            //                        V=Math.sqrt((Math.pow(j.Vr[pos/4],2)+Math.pow(j.Vi[pos/4],2))); //*255/3;
            V=parseInt(data[pos/4]+b.Max-b.Min);

            buffer[pos  ] =V ;           // some R value [0, 255]
            buffer[pos+1] = V;           // some G value
            buffer[pos+2] = V;           // some B value
            buffer[pos+3] = 255;           // set alpha channel

        }
    }    
    return buffer;
};





var bufferFromArrayWithBrightnessandContrast = function(data,b,height,width)
{

    //    var buffer = new Uint8ClampedArray(width * height * 4);
    var buffer = new Uint8Array(width * height * 4);
    var range=data.GetMaxMin();
    var br=b.Min;
    var co=b.Max/1000.0;


    for(var y = 0; y < height; y++) {
        for(var x = 0; x < width; x++) {
            var pos = (y * width + x) * 4; // position in buffer based on x and y

            //matlab array is different
            //                for(var y = 0; y < width; y++) {
            //                    for(var x = 0; x < height; x++) {
            //                        var pos = (y * height + x) * 4; // position in buffer based on x and y




            //                        V=Math.sqrt((Math.pow(j.Vr[pos/4],2)+Math.pow(j.Vi[pos/4],2))); //*255/3;

            r=parseInt(((data[pos/4]-range.Min)/range.Max)*255);
            V=(co*(r-128)) +br+128;
            if (V>255){
                V=255;
            }else if(V<0){
                V=0;
            }
            buffer[pos  ] =V ;           // some R value [0, 255]
            buffer[pos+1] = V;           // some G value
            buffer[pos+2] = V;           // some B value
            buffer[pos+3] = 255;           // set alpha channel

        }
    }    
    return buffer;
};


var bufferFromArray = function(data,height,width)
{
    var buffer = new Uint8Array(width * height * 4);


    for(var y = 0; y < height; y++) {
        for(var x = 0; x < width; x++) {
            var pos = (y * width + x) * 4; // position in buffer based on x and y

            //matlab array is different
            //                for(var y = 0; y < width; y++) {
            //                    for(var x = 0; x < height; x++) {
            //                        var pos = (y * height + x) * 4; // position in buffer based on x and y

            //                        V = math.complex(j.Vr[pos/4],j.Vi[pos/4]);  


            V=data[pos/4]; //*255/3;
            buffer[pos  ] =V ;           // some R value [0, 255]
            buffer[pos+1] = V;           // some G value
            buffer[pos+2] = V;           // some B value
            buffer[pos+3] = 255;           // set alpha channel

        }
    }
    return buffer;
};







function purgenan(a) {
    var par = []
    for (var i = 0; i < a.length; i++) {
        if (!isNaN(a[i])) {
            par.push(a[i]);
        }
    }
    return par;
};


function average(elmt){
    var sum = 0;
    for( var i = 0; i < elmt.length; i++ ){
        sum += elmt[i]; //don't forget to add the base
    }

    var avg = sum/elmt.length;
    return   avg;
};


function std(elmt){
    var avg=average(elmt);

    var squareDiffs = elmt.map(function(value){
        var diff = value - avg;
        var sqrDiff = diff * diff;
        return sqrDiff;
    });


    var avgSquareDiff = average(squareDiffs);

    var stdDev = Math.sqrt(avgSquareDiff);
    return stdDev;


};


