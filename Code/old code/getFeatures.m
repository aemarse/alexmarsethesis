function [RMS, FFT, ZCR, SF, S_ENV, SC, MFCCs] = ...
    getFeatures(past, curr, params, i)

%-RMS
RMS = getRMS(curr);

%-ZCR
ZCR = getZCR(curr, params);

%-FFT
[p_FFT, c_FFT] = getFFT(past, curr, params);

%-Magnitude spectrum
p_FFT = abs(p_FFT);
c_FFT = abs(c_FFT);

%-Spectral envelope
S_ENV = getS_ENV(p_FFT, params);

%-Spectral centroid
SC = getSC(p_FFT, params);

%-MFCCs
MFCCs = getMFCCs(c_FFT, params);

%-Spectral flux
if i == 1
    SF = zeros(1,length(p_FFT));
else
    SF = getSF(p_FFT, c_FFT, i);
end

FFT = c_FFT';

end