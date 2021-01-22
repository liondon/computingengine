function []=previewMROPtimum(x,fn)


addpath(genpath('../MATLABCODE/'));

tmp='/data/tmp/';


 [a,b,c]=fileparts(x);
 f=fullfile(tmp,[b c]);

urlwrite(x,f);

KS=CLOUDMRRD();
KS.setFilename(f);
% KS.getImageKSpace();

SL=KS.getNumberImageSlices();



for t=1:SL
    im=KS.getKSpaceImageSlice('avg',1,1,t);
       
    IM(:,:,t)=KS.getSOSImage(im);
end



L=CLOUDMROutput();
L.addToExporter('image2D','my Image',IM);



delete(f);


L.exportResults(fn);