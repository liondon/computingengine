function strNew = slashCvrt(strOld)
    strNew = regexprep(strOld, '\', '\\\');
end