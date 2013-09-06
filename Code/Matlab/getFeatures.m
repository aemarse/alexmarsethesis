function [RMS, FFT] = getFeatures(frame, params, i)

[RMS]          = getRMS(frame);
[FFT]          = getFFT(frame, params);

% [T, F, sFinal] = getSpectrum(frame, params);

% SPEC.T      = T;
% SPEC.F      = F;
% SPEC.sFinal = sFinal;

% features.RMS(i) = RMS;
% features.SPEC   = SPEC;

end