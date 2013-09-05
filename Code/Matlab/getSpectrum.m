function [T, F, sFinal] = getSpectrum(sig, N, hopSize, fftSize)
 
[spec,F,T,P] = spectrogram(sig, N, hopSize, fftSize);

sFinal = log10(abs(spec)+eps);

F = F/abs(max(F));

end