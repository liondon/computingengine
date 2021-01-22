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

function loadscript(url){
    var head = document.getElementsByTagName('head')[0];
    var s1 = document.createElement("script");
    s1.type = "text/javascript";
    s1.src = url;
    head.appendChild(s1);
};

function loadscriptIf(variable,url){

    if (typeof variable !== 'undefined') {
        var head = document.getElementsByTagName('head')[0];
        var s1 = document.createElement("script");
        s1.type = "text/javascript";
        s1.src = url;
        head.appendChild(s1);
    };
};


function getmrojsonType (jsondata) {
                    if (isUndefined(jsondata)){
                     return undefined;   
                    }else{
                    return jsondata.type;
                    }
                }



function objectEquals(x, y) {
    // if both are function
    if (x instanceof Function) {
        if (y instanceof Function) {
            return x.toString() === y.toString();
        }
        return false;
    }
    if (x === null || x === undefined || y === null || y === undefined) { return x === y; }
    if (x === y || x.valueOf() === y.valueOf()) { return true; }

    // if one of them is date, they must had equal valueOf
    if (x instanceof Date) { return false; }
    if (y instanceof Date) { return false; }

    // if they are not function or strictly equal, they both need to be Objects
    if (!(x instanceof Object)) { return false; }
    if (!(y instanceof Object)) { return false; }

    var p = Object.keys(x);
    return Object.keys(y).every(function (i) { return p.indexOf(i) !== -1; }) ?
        p.every(function (i) { return objectEquals(x[i], y[i]); }) : false;
}


function linearfit2pts(p0, p1) {
    var slope = (p1.y - p0.y) / (p1.x - p0.x);
    var intercept = (-slope * p0.x) + p0.y;

    return {
        q: intercept,
        m: slope
    };

};

function isJson(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}



function getBaseName(str)
{
    return str.replace(/\.[^/.]+$/, "");
}
function getFilextension(fname) {
     return fname.slice((fname.lastIndexOf(".") - 1 >>> 0) + 2);

};

function isFunction(functionToCheck) {
 return functionToCheck && {}.toString.call(functionToCheck) === '[object Function]';
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






function jsonCopy(src) {
    return JSON.parse(JSON.stringify(src));
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





//function iterationCopy(src) {
//    let target = {};
//    for (let prop in src) {
//        if (src.hasOwnProperty(prop)) {
//            target[prop] = src[prop];
//        }
//    }
//    return target;
//}



function getUIID() {

    return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
};








var mult = function (a1, a2) {
    var result = [];
    for(var i = 0; i < a1.length; i++) {
        result[i] = a1[i] * a2[i];
    }
    return result;
}





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



function findAndGetv0(array, property, value) {
    var out=[];
    array.forEach(function(result, index) {

        if(result[property] === value) {
            //Remove from array
            out.push(result);
        }    
    });
    return out;
}

function findAndGet(array, property, value) {
    var out=[];
    array.forEach(function(result, index) {

        if(result[property] == value) {
            //Remove from array
            out.push(result);
        }    
    });
    return out;
}



function findAndGetWithPromise(array, property, value) {
    return new Promise(function(resolve){
        var out=[];
        array.forEach(function(result, index) {

            if(result[property] === value) {
                //Remove from array
                out.push(result);
            }    
        });
        resolve(out);

    });
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
    resolve(out);
 });
};

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


