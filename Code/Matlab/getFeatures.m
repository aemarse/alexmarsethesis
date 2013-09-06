function [RMS, SPEC] = getFeatures(frame, params, i)

[RMS]          = getRMS(frame);
[T, F, sFinal] = getSpectrum(frame, params);

SPEC.T      = T;
SPEC.F      = F;
SPEC.sFinal = sFinal;

% features.RMS(i) = RMS;
% features.SPEC   = SPEC;

end