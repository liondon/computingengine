%function downloadfiles(val)
function okdown = downloadfiles(val, OutClass, conversionfile, Outputfile)

okdown = 1;

cd(val.path)
%Write Geometry Filename
'Geometry.geo'
okdown = convertandsave(val.path, val.geometry.link, OutClass, 'Geometry.geo', conversionfile, Outputfile);
if (okdown ==0) return; end

%Write Tissue Filename
try
    temp = strcat(val.path, 'Tissue.tiss')
    downloadif(temp, val.tissue.link)
catch e
    OutClass.logIT(e.message, 'error');
    OutClass.exportLOG(Outputfile);
    okdown = 0;
    return;
end

%Write DeltagB0 Filename
if isempty(val.fields.tdb) < 1
    'tdb'
    okdown = convertandsave(val.path, val.fields.tdb.link, OutClass, 'Delta.b0', conversionfile, Outputfile);
    if (okdown ==0) return; end
end

%B1plus Filenames
if isempty(val.fields.b1plus)<1
    for n = 1:length(val.fields.b1plus)
        temp = strcat('B1p', num2str(n), '.bpfld')
        okdown = convertandsave(val.path, val.fields.b1plus(n).link, OutClass, temp, conversionfile, Outputfile);
        if (okdown ==0) return; end
    end
end

%E1plus Filenames
if isempty(val.fields.etransmitted)<1
    for n = 1:length(val.fields.etransmitted)
        temp = strcat('E1p', num2str(n), '.epfld')
        okdown = convertandsave(val.path, val.fields.etransmitted(n).link, OutClass, temp, conversionfile, Outputfile);
        if (okdown ==0) return; end
    end
end

%B1minus Filenames
if isempty(val.fields.b1minus)<1
    for n = 1:length(val.fields.b1minus)
        temp = strcat('B1m', num2str(n), '.bmfld')
        okdown = convertandsave(val.path, val.fields.b1minus(n).link, OutClass, temp, conversionfile, Outputfile);
        if (okdown ==0) return; end
    end
end

%E1minus Filenames
if isempty(val.fields.ereceived)<1
    for n = 1:length(val.fields.ereceived)
        temp = strcat('E1m', num2str(n), '.emfld')
        okdown = convertandsave(val.path, val.fields.ereceived(n).link, OutClass, temp, conversionfile, Outputfile);
        if (okdown ==0) return; end
    end
end

%Gradx Filenames
if isempty(val.fields.gradx) < 1
    temp = strcat('Grad.x')
    okdown = convertandsave(val.path, val.fields.gradx.link, OutClass, temp, conversionfile, Outputfile);
    if (okdown ==0) return; end
end

%Grady Filenames
if isempty(val.fields.grady) < 1
    temp = strcat('Grad.y')
    okdown = convertandsave(val.path, val.fields.grady.link, OutClass, temp, conversionfile, Outputfile);
    if (okdown ==0) return; end
end

%Gradz Filenames
if isempty(val.fields.gradz) < 1
    temp = strcat('Grad.z')
    okdown = convertandsave(val.path, val.fields.gradz.link, OutClass, temp, conversionfile, Outputfile);
    if (okdown ==0) return; end
end

end

%%
function okdown = convertandsave(path, link, OutClass, NameFile, conversionfile, Outputfile)

okdown =1;

temptxt = strcat(path, 'a.txt');
try
    downloadif(temptxt, link);
catch e
    OutCglass.logIT(e.message, 'error');
    OutClass.exportLOG(Outputfile);
    okdown = 0;
    return;
end

'Saved Link'

%wineconversion = strcat('wine ', conversionfile)


% wineconversion = ['wine ' fullfile(path,'txt2bin.exe')];
% wineconversion
% system(wineconversion)

wineconversion = 'wine txt2bin.exe';
[status, result] = system(wineconversion);
if (strcmp(result, 'Output file failure')==1)
    OutClass.logIT(result, 'file error');
    OutClass.exportLOG(Outputfile)
    okdown = 0;
    return;
else
    temp = strcat(NameFile, ' converted');
    OutClass.logIT(temp, 'file converted');
end
%binfile = strcat(path, 'a.bin');
%filename = strcat(path, NameFile);
binfile = 'a.bin';
filename = NameFile;

copyfile(binfile, filename, 'f');

delete(temptxt);
delete(binfile);


end




