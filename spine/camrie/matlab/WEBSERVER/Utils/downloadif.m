function[out]=downloadif(destination,source)
%source is a local or a web link and destination is where i want to place the
%linked file

out= destination;

if(~isempty(regexp(source,'^http')))
out=websave(destination, source)
else
    copyfile(source,destination)    
end


end