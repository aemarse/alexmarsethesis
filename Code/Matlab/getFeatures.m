function [features] = getFeatures(onSig, onSpec, magSpec, params, onsets)

numFrames = params.numOnFrames;

%-Feature extraction
rms = getRMS(onSig, numFrames); %-RMS

[freqs amps] = getSineMod(onSpec, magSpec, params, onsets); %-Sinusoidal modeling

%-Save the features to a struct
features.rms = rms;

end