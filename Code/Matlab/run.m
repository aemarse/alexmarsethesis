function [] = run(filename, N, H, Nfft)

%-Read in the file
fileDir  = '/Volumes/ALEX/data/xeno_canto/';
[sig fs fileName] = readFile(fileDir, filename);

%-Get the mat filename and load in the mat
matFilename = [fileName(1:end-3) 'mat'];
load(matFilename);

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

%-WINDOWING
%-Big win
params.win.N    = N;
params.win.H    = H;
params.win.Nfft = Nfft;
%-Small win
params.win.Ns    = 256;
params.win.Hs    = params.win.Ns/2;
params.win.NFFTs = 1024;

%-FILE
params.file.fs       = fs;
params.file.filename = filename;

%-FEATURE
%-mfcc
params.feat.numFilts  = 20;
params.feat.numCoeff  = 13;
params.feat.lowFreq   = 800;
params.feat.highFreq  = 10000;
params.feat.minFreq   = 0;
params.feat.maxFreq   = params.file.fs/2;
%-sinusoidal modeling
params.feat.numPeaks = 10;
params.feat.maxDist  = 5;

%--------------------------------------------------------------------------
%                                 AED
%--------------------------------------------------------------------------

[pkLocs pkVals] = aed(sig, params);

%--------------------------------------------------------------------------
%                           Get the features
%--------------------------------------------------------------------------

%-Get the MFCCs
MFCCs = calcMFCCs(sig, params);

%-Sinusoidal modeling
% sineMod2(sig, params);
[tracks, resynth] = sineMod4(sig, params);

%-Get the triangular filter bank to be used with the MFCCs
% filtBank             = getTrifbank( params );
% params.feat.filtBank = filtBank;

%-Feature computation
% [features] = getFrames(sig, params);

%--------------------------------------------------------------------------
%                      Write the data to a struct
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%                            Plot the data
%--------------------------------------------------------------------------

% plotData(sig, features, params);

sound(sig, params.file.fs);

end

%--------------------------------------------------------------------------
%                          Utility functions
%--------------------------------------------------------------------------

%-Read in the file
function [sig fs filename] = readFile(fileDir, filename)

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