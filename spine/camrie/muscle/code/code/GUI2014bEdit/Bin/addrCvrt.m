function [pathName,fileName] = addrCvrt(str)
    if iscell(str) ~= 1
        n = find(str=='\',1,'last');

        pathName = str(1:n);
        if isempty(pathName)
            pathName = '';
        end;

        fileName = str(n+1:length(str));
        if isempty(fileName)
            fileName = '';
        end;
    else
        tempM = size(str);
        fileName = cell(tempM(2),tempM(1));
        pathName = cell(tempM(2),tempM(1));
        for m = 1:tempM(1)
            n = find(str{m}=='\',1,'last');
            pathName{m} = str{m}(1:n);
            fileName{m} = str{m}(n+1:length(str{m}));
        end;
    end;
end