function [RMS, FFT, ZCR, SF, S_ENV, SC] = getFeatures(past, curr, params, i)

RMS            = getRMS(curr);
[p_FFT, c_FFT] = getFFT(past, curr, params);
ZCR            = getZCR(curr, params);
S_ENV          = getS_ENV(p_FFT, params);
SC             = getSC(p_FFT, params);

if i == 1
    SF = zeros(1,length(p_FFT));
else
    SF = getSF(p_FFT, c_FFT, i);
end

FFT = c_FFT';

% [T, F, sFinal] = getSpectrum(frame, params);

% SPEC.T      = T;
% SPEC.F      = F;
% SPEC.sFinal = sFinal;

% features.RMS(i) = RMS;
% features.SPEC   = SPEC;

end