function [filename,extension] = filenameCvrt(str)

if iscell(str)==1
    str=str{1};
end;

    n = find(str=='.',1,'last');
    if ~isempty(n)
        filename = str(1:n-1);
        extension = str(n+1:length(str));
    else
        filename = str;
        extension = '';
    end;
end
