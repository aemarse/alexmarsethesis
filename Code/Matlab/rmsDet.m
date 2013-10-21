function [onsetBool, thePkLoc, thePkVal] = rmsDet(buf, params)

numFrames = params.numFrames;

rms = getRMS(buf, numFrames); %-Get the rms

%-LPF the detection function
[b,a]   = butter(5,0.015,'low');
rmsFilt = filter(b,a,rms);

[onsetBool thePkLoc thePkVal] = pickPeaks(rmsFilt, params); %-Peak pick the rms

end