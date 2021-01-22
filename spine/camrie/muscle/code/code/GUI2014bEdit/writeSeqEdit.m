
function writeSeqEdit(val, inputInfoOld)

inputInfo = inputInfoOld;
cBW = val.sequence.rbw;
cFE = val.sequence.fe;
cFOVFE = val.sequence.fov0;
cFOVPE = val.sequence.fov1;
cMatSizeFE = val.sequence.matrixsize0;
cMatSizePE = val.sequence.matrixsize1;
cPE = val.sequence.pe;
cPEDirect = val.sequence.pedirection;
cRFDuration = val.sequence.rfpd;
cRFPts = val.sequence.nrfp;
cRFShape = val.sequence.rfshape;
cRF_FA = val.sequence.rffa;
cRxNum = val.coils.receivingCoilsNumber;
cSS = val.sequence.ss;
cSeqType = val.sequence.sequencename;
cSliceOrientation = val.sequence.sliceorientation;
cTE = val.sequence.TE;
cTI = val.sequence.TI;
cTR = val.sequence.TR;
cTxNum = val.coils.transmittingCoilsNumber;
cdummy = val.sequence.dTR;
csliceTH = val.sequence.slicethickness;
tempStr = {'GRE';'SE';'GRE_EPI';'GRE_TI';'StimEchoFID';'GRE_r';'GRE_EPI_TI';'GRE_ktPts'};

save('ReplSeq.mat');