function file_reader(b) {
  let bytes = b;
  var k = 0;
  return {
    position: function () {
      return k;
    },
    seek: function (x) {
      k = x;
      return k;
    },
    read_bytes: function (n) {
      k += n;
      return new Uint8Array(bytes.slice(k - n, k));
    },
    read_u32: function () {
      k += 4;
      return new Uint32Array(bytes.slice(k - 4, k))[0];
    },
    read_u64: function () {
      k += 8;
      return new BigInt64Array(bytes.slice(k - 8, k))[0];
    },
    advance: function (x) {
      k += x;
      return k;
    },
  };
}

async function anonymizeTWIX(file) {
  console.log("Here : ", file)
  var file_size = file.size;
  file_bytes = await file.slice(0, 11244).arrayBuffer();
  console.log(file_bytes);

  var bytes_reader = file_reader(file_bytes);
  var preamble = new Uint8Array(file_bytes); // Interpret as a bunch of ints
  var num_scans = 1;
  var file_format;
  var measOffset = [];
  var measLength = [];

  var int1 = bytes_reader.read_u32();
  var int2 = bytes_reader.read_u32();
  if (int1 < 10000 && int2 <= 64) {
    // Looks like a VD format
    file_format = "VD";
    var num_scans = int2; // The number of measurements in this file
    measID = bytes_reader.read_u32(); // Unused, but this is where they are
    fileID = bytes_reader.read_u32();

    VDHeaderPatientInfoViews = [];
    for (i = 0; i < num_scans; i++) {
      measOffset.push(Number(bytes_reader.read_u64())); // Where the header of the first measurement starts
      measLength.push(Number(bytes_reader.read_u64())); // nominally the length of the measurement
      VDHeaderPatientInfoViews.push(
        preamble.subarray(bytes_reader.position(), bytes_reader.advance(64))
      );
      bytes_reader.advance(64);
      bytes_reader.advance(8);
    }
  } else {
    file_format = "VB";
    measOffset.push(0); // There's only one measurement in VB files, so it starts at 0.
  }

  // if (header_size <= 0) {
  // 	alert("Unknown file format.")
  // 	return;
  // }

  console.log(`${file_format} file, ${num_scans} scan(s).`);
  // preamble is everything from the beginning to the end of the header. It's empty in VB files.
  // var preamble = preamble.slice(0, header_start + 19)

  var found_pii = new Set();

  if (file_format == "VD") {
    // VD seems to store patient info in here...
    for (i = 0; i < num_scans; i++) {
      var patient_info = VDHeaderPatientInfoViews[i];
      var len = patient_info.indexOf(0);
      if (len > 3) {
        var patient_info_string = utf8_decode(
          patient_info.subarray(0, patient_info.indexOf(0))
        );
        patient_info_pieces = patient_info_string.split(",");
        for (const piece of patient_info_pieces) {
          if (piece.length > 3) {
            found_pii.add(piece);
          }
        }
        found_pii.add(patient_info_string);
      }
      patient_info.fill(0);
      patient_info.fill(char("X"), 0, 16);
    }
  }
  headers = [];
  data_slices = [];
  for (var i = 0; i < num_scans; i++) {
    console.log(`Scan ${i+1}.`);
    var header_len = new Uint32Array(
      await file.slice(measOffset[i], measOffset[i] + 4).arrayBuffer()
    )[0];
    var header = new Uint8Array(
      await file.slice(measOffset[i], measOffset[i] + header_len).arrayBuffer()
    );
    const scan_text_header = header.subarray(19, header_len);
    console.log(utf8_decode(scan_text_header).slice(-150));
    console.log(`Header length: ${header_len}`);

    // var err = false;
    // for (var i = 0; i < scan_text_header.length; i++) {
    //   if (scan_text_header[i] < 9 || scan_text_header[i] > 127){
    //     if (!err) {
    //       console.log(i, (utf8_decode(scan_text_header.slice(i-50,i))));
    //       console.log(i, (utf8_decode(scan_text_header.slice(i, i+50))));
    //       err = true;
    //     }
    //   } else {
    //     err = false;
    //   }
    // }
  

    var new_found_values = anonymize_header(scan_text_header);
    for (const value of new_found_values) {
      found_pii.add(value);
    }

    headers.push(header);
    if (i < num_scans - 1) {
      data_slices.push(
        file.slice(measOffset[i] + header_len, measOffset[i + 1])
      );
    } else {
      data_slices.push(file.slice(measOffset[i] + header_len, file.size));
    }
  }

  preamble = preamble.slice(0, measOffset[0]); // this ends up empty in VB
  verify_anonymous(preamble, found_pii);
  for (const header of headers) {
    verify_anonymous(header, found_pii); // double check by scanning for patient info bytes
  }
  file_pieces = [preamble];
  for (var i = 0; i < num_scans; i++) {
    file_pieces.push(headers[i]);
    file_pieces.push(data_slices[i]);
  }

  var anonym_file = new File(file_pieces, file.name);
  if (anonym_file.size != file.size) {
    throw new Error("File size mismatch.");
  }
  console.log(file_pieces);
  return anonym_file;
  // var test_result = new Uint8Array(await anonym_file.arrayBuffer());
  // var test_file = new Uint8Array(await file.arrayBuffer());
  // console.log(arrays_equal(test_file,test_result));
}
async function submitTWIX(file, uploader) {
  console.log("anonymizing");
  anonym_file = await anonymizeTWIX(file);
  console.log("anonymized");
  if (uploader) {
    console.log("uploading");
    uploader.addFile(anonym_file);
  }
}

function anonymize_header(data) {
  const patient_names = anonymizeByTag(
    data,
    ["PatientName", "PatientsName", "tPatientName", "tPatientsName"],
    replace_X
  );

  if (!patient_names) {
    return new Set();
  }
  if (patpatient_names.size == 0) {
    throw new Error("Anonymization failed: unable to detect patient name");
  }
  const patient_id = anonymizeByTag(data, "PatientID", replace_ID);
  const patient_bday = anonymizeByTag(data, "PatientBirthDay", replace_bday);
  const physician = anonymizeByTag(data, "tPerfPhysiciansName", replace_X);
  return new Set([
    ...patient_names,
    ...patient_id,
    ...patient_bday,
    ...physician,
  ]);
}

function verify_anonymous(data, tags) {
  console.log("checking for", tags);
  for (var i = 0; i < data.length; i++) {
    for (var tag_value of tags) {
      if (utf8_decode(data.slice(i, i + tag_value.length)) == tag_value) {
        console.log("Anonymization failed at location", i);
        console.log(
          utf8_decode(
            data.slice(Math.max(i - 50, 0), i + tag_value.length + 10)
          )
        );
        throw new Error("anonymization failed");
      }
    }
  }
}

function anonymizeByTag(data, tagNames, do_replace) {
  var found_at = 0;
  var old_found_at = found_at;
  var n = 0;
  var old_value;
  var old_values = new Set();
  if (!Array.isArray(tagNames)) {
    tagNames = [tagNames];
  }
  console.log("anonymizeByTag", tagNames);
  for (tag of tagNames) {
    do {
      old_found_at = found_at;
      [found_at, old_value] = processTagOnce(
        data,
        tag,
        do_replace,
        found_at + 1
      );
      if ( found_at > 0 && old_found_at > found_at) {
        throw new Error("Infinite loop detected")
      }
      if (old_value != null) {
        old_values.add(old_value);
        console.log(`old value ${old_value} at ${found_at}`);
      } 
      n++;
    } while (found_at > -1 && n<15);
    
    if (n >= 15) {
      throw new Error("Infinite loop detected")
    }
  }
  return old_values;
}
// Scan forward until it matches a tag we're obscuring, and obscure it
// Returns the end of the matched tag
function processTagOnce(data, tagName, do_replace, start = 0) {
  console.log('processTagOnce', tagName, do_replace);
  loc = find_tag(data, 'ParamString."' + tagName + '"', start);
  console.log('find_tag ==',loc)
  if (loc == -1) return [-1, null];

  // Find the braces that surround the tag contents
  braces_begin = data.indexOf(char("{"), loc) + 1;
  braces_end = data.indexOf(char("}"), loc);

  // looks like } {
  if (braces_begin > braces_end) {
    throw new Error(`Invalid tag detected: mismatched braces (looks like } { })`);
  }

  var tag_contents = data.subarray(braces_begin, braces_end);

  // Find the last quoted thing in the subarray...
  var val_end = tag_contents.lastIndexOf(char('"'));
  if (val_end == -1) return [braces_end, null]; // oh, it's just empty, never mind
  var val_begin = tag_contents.lastIndexOf(char('"'), val_end - 1) + 1;
  if (val_begin == -1) throw new Error("Invalid tag detected: missing opening quote"); // Can't find the opening quote

  var tag_value = tag_contents.subarray(val_begin, val_end);
  var old_tag_value = utf8_decode(tag_value.slice());
  do_replace(tag_value);

  return [braces_end + 1, old_tag_value];
}

function find_tag(data, name, start) {
  console.log("find_tag", name,start);
  var s = start || 0;
  var did_recover = false;
  do {
    // if (s < start) {
    // }
    var tag_begin = data.indexOf(char("<"), s);
    if (tag_begin == -1) return -1;
    var tag_end = data.indexOf(char(">"), tag_begin + 1);
    if (tag_end == -1) {
      console.log(`Warning: unclosed tag`, utf8_decode(data.subarray(tag_begin))); 
      if (data.length - tag_begin > 40) {
        throw new Error("unclosed tag")
      }
      return -1;
    }
    var tag_begin_check = data.indexOf(char("<"), tag_begin + 1);
    if (tag_begin_check > -1 && tag_begin_check < tag_end) {
      // It looks like <  <Tag>
      console.log(`Warning: invalid tag begin at ${tag_begin}, recovering.`, utf8_decode(data.subarray(tag_begin,tag_end+1)));      
      // throw new Error("Invalid tag detected");
      s = tag_begin+1;
      did_recover = true;
      continue;
    }
    var tag_value = utf8_decode(data.slice(tag_begin + 1, tag_end));
    if (did_recover) {
      console.log(tag_value);
      did_recover = false;
    }
    s = tag_end + 1;
    if (tag_value == name) {
      return tag_end;
    }
  } while (tag_begin != -1);
  return -1;
}

function utf8_decode(t) {
  return new TextDecoder("utf-8").decode(t);
}

function utf8_encode(t) {
  return new TextEncoder("utf-8").encode(t);
}

function replace_ID(tag_value) {
  return tag_value.fill(char("0"));
}

function replace_X(tag_value) {
  return tag_value.fill(char("X"));
}

function replace_bday(tag_value) {
  tag_value.fill(char(" "));
  tag_value.set(utf8_encode("19700101"));
  return tag_value;
}

function char(c) {
  return c.charCodeAt(0);
}

function arrays_equal(dv1, dv2) {
	if (dv1.length != dv2.length) return false;
	for (var i = 0; i < dv1.length; i++) {
		if (dv1[i] != dv2[i]) return false;
	}
	return true;
}
