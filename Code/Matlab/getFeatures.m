function [RMS, FFT, ZCR, SF, S_ENV, SC, MFCCs] = getFeatures(past, curr, params, i)

RMS            = getRMS(curr);
ZCR            = getZCR(curr, params);

[p_FFT, c_FFT]  = getFFT(past, curr, params);
% [maxVal maxPos] = max(abs(c_FFT));
% 
% Wn = maxPos;
% Fn = maxVal;
% 
% An = 20 * log10(abs(c_FFT(Fn, Wn)));

p_FFT          = abs(p_FFT);
c_FFT          = abs(c_FFT);

S_ENV          = getS_ENV(p_FFT, params);
SC             = getSC(p_FFT, params);
MFCCs          = getMFCCs(c_FFT, params.fs);

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