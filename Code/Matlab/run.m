function [] = run(filename, N, H, Nfft)

fileDir  = '/Volumes/ALEX/data/xeno_canto/';

[sig fs] = readFile(fileDir, filename);

if size(sig, 2) == 2
    sig = (sig(:,1) + sig(:,2) / 2);
end

% fc1 = 500/fs;
% fc2 = 8000/fs;
% 
% sig = filterSig(sig, fc1, fc2);

sig = sig/max(abs(sig));

params.N        = N;
params.H        = H;
params.Nfft     = Nfft;
params.fs       = fs;
params.filename = filename;

% sineMod2(sig, params);

[features] = getFrames(sig, params);

plotData(sig, features, params, fs);

sound(sig, fs);

end

function [sig fs] = readFile(fileDir, filename)

a = dir(fileDir);
b = struct2cell(a);

for i = 4:size(b,2)
    tempDir = [fileDir b{1,i} '/'];
    
    x = struct2cell(dir(tempDir));
    
    for h = 1:size(x,2)
        if strcmp(x{1,h}, filename)
            theDir = tempDir;
        end
    end
end

filename = sprintf('%s%s', theDir, filename);

if strcmp(filename(end-2:end), 'mp3')
    try
        [sig fs] = mp3read(filename);
    catch
        r = removeFile(filename);
        return
    end
elseif strcmp(filename(end-2:end), 'wav')
    try
        [sig fs] = wavread(filename);
    catch
        r = removeFile(filename);
        return
    end
else
    sprintf('Couldn''t read the file, for some unknown reason...must be a ghost!')
    return
end

end