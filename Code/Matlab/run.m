function [] = run(filename, N, H, Nfft)

try
    [sig fs] = wavread(filename);
catch
    sprintf('Could not read in file %s\nDeleting it now...', filename)
    delete(filename);
    delete(sprintf('%s%s', filename(1:end-3), 'mat'));
    return
end

if size(sig, 2) == 2
    sig = (sig(:,1) + sig(:,2) / 2);
end

% fc1 = 500/fs;
% fc2 = 10000/fs;
% 
% sig = filterSig(sig, fc1, fc2);

sig = sig/max(abs(sig));

params.N        = N;
params.H        = H;
params.Nfft     = Nfft;
params.fs       = fs;
params.filename = filename;

[features] = getFrames(sig, params);

plotData(sig, features, params, fs);

sound(sig, fs);

end