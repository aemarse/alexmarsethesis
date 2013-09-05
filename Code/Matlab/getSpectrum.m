function [spec] = getSpectrum(sig, params)

[spec,F,T,P] = spectrogram(sig, params.N, params.H, params.Nfft);

sFinal = log10(abs(spec)+eps);

F = F/abs(max(F));

spec.T      = T;
spec.F      = F;
spec.sFinal = sFinal;

end