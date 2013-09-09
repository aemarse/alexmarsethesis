function [p_FFT, c_FFT] = getFFT(past, curr, params)

Nfft = params.Nfft;

p_FFT = abs(fft(past, Nfft));
c_FFT = abs(fft(curr, Nfft));

end