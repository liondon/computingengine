function gradAmp = calSpoilGrad(phaseDis,gradDuration,voxelDim,gamma)
% This function is used to calculate gradient amplitude for a desired phase
% dispersion with given number of isochromats in a voxel. 

% It does not matter whether there is only one isochromat per voxel.

% phaseDis typically in 2*pi or 4*pi
% gradDuration in ms
% voxelDim in m
% gradAmp in mT/m
    
gradAmp = (phaseDis) / gamma / voxelDim / (gradDuration/1000) * 1000; % in mT/m

end