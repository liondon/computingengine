function submitTWIX(file,uploader) {

	console.log("File size:",file.size)
    
    
        
	
	
	

    var reader = new FileReader();
	reader.readAsArrayBuffer(file.slice(0, 11244)); // This might be too short for some files and fail

	reader.onloadend = function(evt) {
      if (evt.target.readyState == FileReader.DONE) { // DONE == 2
		var data = new Uint32Array(evt.target.result) // Interpret as a bunch of 32bit uints
		var preamble = new Uint8Array(evt.target.result) // Interpret as a bunch of bytes
		var num_scans,meas_id,file_id,header_start
		var file_format
		if (data[0] < 10000 && data[1] <= 64) { // Looks like a VD format
			file_format = 'VD'
			var num_scans = data[1]; // The number of measurements in this file
			if (num_scans > 1) { // Only supporting simple files for now
				alert("Only supports dat files with a single scan.");
				return;
			}
    		measID = data[2];  // Unused, but this is where they are
    		fileID = data[3];
    		header_start = data[4]; // Where the header of the first measurement starts 

		    // % header_start: points to beginning of header, usually at 10240 bytes
		    console.log(num_scans,measID,fileID,header_start)
		    // console.log(new TextDecoder("utf-8").decode(new Uint8Array(preamble).slice(0,11240)))
		    //var measOffset = new Uint64Array(data.slice(4,6))[0]
		    //var measLength = new Uint64Array(data.slice(6,8))[0]

		} else {
			file_format = 'VB'
			header_start = 0 // There's only one measurement in VB files, so it starts at 0.
		}
		var header_size = data[header_start/4];

		if (header_size <= 0) {
			alert("Unknown file format.")
			return;
		}
		
		// preamble is everything from the beginning to the end of the header. It's empty in VB files.
		var preamble = preamble.slice(0,header_start+19)
		if (file_format == 'VD') {
			// VD seems to store patient info in here... 
			var patient_info = preamble.subarray(32,64+32)
			var as_txt = utf8(patient_info)
			for (var i=0; i<patient_info.length; i++){
				if (patient_info[i] == 0) break;
				if (/[0-9]/.exec(as_txt[i] )) patient_info.set(asUint8Array("0"),i);
				else if (as_txt[i] != ',') patient_info.set(asUint8Array("X"),i);
			}
		}
		// return;
		var headerBlob = file.slice(header_start+19,header_start+header_size); // skip the binary part
		var headerReader = new FileReader();
		headerReader.onload = function(event) {
		    var header = new Uint8Array(event.target.result);
			var found_tag_values = anonymize_header(header); // anonymize the header
			verify_anonymous(header,found_tag_values); // double check by scanning for patient info bytes
			verify_anonymous(preamble,found_tag_values);

			var anonym_file = new File([preamble, // Recombine the edited pieces into a new file
										header,
										file.slice(header_start+header_size)], file.name)
			if (anonym_file.size != file.size) {
				throw new Error("File size mismatch.")
			}
//			if (confirm('FOR DEMO ONLY. CONTINUE?')) {
				uploader.addFile(anonym_file)
//			}
		};
		headerReader.readAsArrayBuffer(headerBlob);
    };
  }

  function anonymize_header(data){
  	found_tag_values = new Set()
	anonymizeByTag(data, "PatientID", replace_ID);
	anonymizeByTag(data, "PatientBirthDay", replace_bday);
	anonymizeByTag(data, "PatientName", replace_X);
	anonymizeByTag(data, "PatientsName", replace_X);
	anonymizeByTag(data, "tPatientName", replace_X);
	anonymizeByTag(data, "tPatientsName", replace_X);
	anonymizeByTag(data, "tPerfPhysiciansName", replace_X);
	return found_tag_values;
  }  
}

function verify_anonymous(data,tags) {
	// console.log("checking for",found_tags)
    for (var i=0;i<data.length; i++){
		for (var tag of found_tag_values){
	    	if (arrays_equal(data.slice(i,i+tag.length),asUint8Array(tag))) {
	    		console.log(i)
	    		console.log(utf8(data.slice(i,i+100)));
	    		throw new Error("anonymization failed");
	    	}
	    }
	}
}


var found_tag_values = new Set()

function anonymizeByTag(data, tagName, do_replace) {
	var found_at = 0
	do {
		found_at = processTagOnce(data,tagName,do_replace,found_at+1)
	} while (found_at > -1)
}
// Scan forward until it matches a tag we're obscuring, and obscure it
// Returns the end of the matched tag
function processTagOnce(data,tagName,do_replace,start=0) {
  loc = find_tag(data,'ParamString."'+tagName+'"',start);
  if (loc == -1) return -1;

  // Find the braces that surround the tag contents
  braces_begin = data.indexOf(char('{'),loc)+1

  braces_end = data.indexOf(char('}'),loc)

  // looks like } {
  if (braces_begin > braces_end ) throw new Error('Invalid tag detected');

  var tag_contents = data.subarray(braces_begin,braces_end)

  // Find the last quoted thing in the subarray...
  var val_end = tag_contents.lastIndexOf(char('"'))
  if (val_end == -1) return braces_end; // oh, it's just empty, never mind
  var val_begin = tag_contents.lastIndexOf(char('"'),val_end-1)+1
  if (val_begin == -1) throw new Error('Invalid tag detected'); // Can't find the opening quote

  var tag_value = tag_contents.subarray(val_begin,val_end);
  found_tag_values.add(utf8(tag_value));
  tag_value.set(asUint8Array(do_replace(val_end-val_begin)));
  return braces_end+1;
}

function find_tag(data, name, start) {
  var s = start || 0
  var name = asUint8Array(name);
  do {
	  var tag_begin = data.indexOf(char('<'),s)
	  if ( tag_begin == -1 ) return -1
	  var tag_begin_check = data.indexOf(char('<'),tag_begin+1)
	  var tag_end = data.indexOf(char('>'),tag_begin+1)
	  if (tag_begin_check > -1 && tag_begin_check < tag_end) {
	  	throw new Error('Invalid tag detected');
	  }
	  var tag_value = new Uint8Array(data.slice(tag_begin+1,tag_end))
	  // console.log("tag_value", tag_value, new TextDecoder("utf-8").decode(tag_value))
	  // console.log("name", name, new TextDecoder("utf-8").decode(name))
	  s = tag_end+1
	  if (arrays_equal(tag_value,name)) {
	  	return tag_end
	  }
   } while (tag_begin != -1)
   return -1
}

function utf8(t){
	return new TextDecoder("utf-8").decode(t)
}

function asUint8Array(input) {
  if (input instanceof Uint8Array) {
    return input;
  } else if (typeof(input) === 'string') {
    // This naive transform only supports ASCII patterns. UTF-8 support
    // not necessary for the intended use case here.
    var arr = new Uint8Array(input.length);
    for (var i = 0; i < input.length; i++) {
      var c = input.charCodeAt(i);
      if (c > 127) {
        //throw new TypeError("Only ASCII patterns are supported");
      }
      arr[i] = c;
    }
    return arr;
  } else {
    // Assume that it's already something that can be coerced.
    return new Uint8Array(input);
  }
}

function replace_ID(len) {
  return "0".repeat(len);
}

function replace_X(len) {
  return "X".repeat(len);
}

function replace_bday(len) {
  return "19700101"
}

function arrays_equal(dv1, dv2)
{
    if (dv1.length != dv2.length) return false;
    for (var i=0; i < dv1.length; i++)
    {
        if (dv1[i] != dv2[i]) return false;
    }
    return true;
}
function char(c) {
	return c.charCodeAt(0)
}