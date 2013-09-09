function [S_ENV] = getS_ENV(fft, params)

N   = 5;
fc1 = 5000/params.fs;

[b, a] = butter(N, fc1, 'low');

S_ENV = filter(b, a, fft);

end