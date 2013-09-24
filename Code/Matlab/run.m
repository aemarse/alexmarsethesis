function [] = run(filename, N, H, Nfft)

%-Read in the file
fileDir  = '/Volumes/ALEX/data/xeno_canto/';
[sig fs] = readFile(fileDir, filename);

%-Collapse into mono
if size(sig, 2) == 2
    sig = (sig(:,1) + sig(:,2) / 2);
end

%-Band pass filter
% fc1 = 500/fs;
% fc2 = 8000/fs;
% sig = filterSig(sig, fc1, fc2);

%-Normalize
sig = sig/max(abs(sig));

%--------------------------------------------------------------------------
%                           Set the parameters
%--------------------------------------------------------------------------

%-Windowing params
params.win.N    = N;
params.win.H    = H;
params.win.Nfft = Nfft;

%-File params
params.file.fs       = fs;
params.file.filename = filename;

%-Feature params
params.feat.numFilts  = 20;
params.feat.numCoeff  = 13;
params.feat.lowFreq   = 800;
params.feat.highFreq  = 10000;
params.feat.minFreq   = 0;
params.feat.maxFreq   = params.file.fs/2;

%--------------------------------------------------------------------------
%                           Get the features
%--------------------------------------------------------------------------

% sineMod2(sig, params);

[features] = getFrames(sig, params);

%--------------------------------------------------------------------------
%                            Plot the data
%--------------------------------------------------------------------------

plotData(sig, features, params);

sound(sig, params.file.fs);

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