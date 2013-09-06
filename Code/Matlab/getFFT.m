function [FFT] = getFFT(frame, params)

Nfft = params.Nfft;

FFT = abs(fft(frame, Nfft));

end