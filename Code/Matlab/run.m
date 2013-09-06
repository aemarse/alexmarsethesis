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

sig = sig/max(abs(sig));

params.N    = N;
params.H    = H;
params.Nfft = Nfft;

[frame features] = getFrames(sig, params);

plotData(sig, features, params, fs);

end