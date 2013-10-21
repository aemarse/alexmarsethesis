function [onsets] = aed(buf, magSpec, params)

numFrames = params.numFrames;

%-RMS detection function
[onsetBool, thePkLoc, thePkVal] = rmsDet(buf, params);

onsets.rms.onsetBool = onsetBool;
onsets.rms.thePkLoc  = thePkLoc;
onsets.rms.thePkVal  = thePkVal;

%-Spectral Flux detection function?

end