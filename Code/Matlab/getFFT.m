function [p_FFT, c_FFT] = getFFT(past, curr, params)

Nfft = params.win.Nfft;

p_FFT = fft(past, Nfft);
c_FFT = fft(curr, Nfft);

end