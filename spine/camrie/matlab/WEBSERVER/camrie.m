function output = camrie(jsonfile, OutputJson,logJson,parentdir,outputMat)
    %to test camrie('/data/project/CAMRIE/matlab/jsontest.json','o.json', 'l.json', '/data/tmp/')
    %cd /data/project/CAMRIE/matlab/WEBSERVER/; addpath(genpath(pwd));camrie('/data/project/CAMRIE/matlab/jsontestTXT.json','o.json', 'l.json', '/data/tmp/')
    cd 'GUI2014bEdit'

    output = camrieAPI(jsonfile, OutputJson,logJson,parentdir);
    
    
    if exist('outputMat','var')
        save(outputMat,'output')
    end
