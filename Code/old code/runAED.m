function [] = runAED(filename, dataSet, winType, aedFlag, N, H, Nfft)

%-Incorporate spectral spread into aed for syllables
%-Within each each syllable, get the top 5 sinusoids

%--------------------------------------------------------------------------
%                            Error checking
%--------------------------------------------------------------------------

%-Check the number of args
if nargin < 7
    disp('Too few arguments');
    return;
elseif nargin > 7
    disp('Too many argument');
    return;
end

e = 1;

%-Check each argument type
if ~ischar(filename)
    disp('Make sure the ''filename'' argument is a string');
elseif ~ischar(dataSet)
    disp('Make sure the ''dataSet'' argument is a string');
elseif ~ischar(winType)
    disp('Make sure the ''winType'' argument is a string');
elseif ~ischar(aedFlag)
    disp('Make sure the ''aedFlag'' argument is a string');
elseif ~isnumeric(N)
    disp('Make sure the ''N'' argument is a number (try an integer)');
elseif ~isnumeric(H)
    disp('Make sure the ''H'' argument is a number (try an integer)');
elseif ~isnumeric(Nfft)
    disp('Make sure the ''Nfft'' argument is a number (try an integer)');
else
    e = 0;
end

%-If there has been an error, return
if e == 1
    return;
end

%--------------------------------------------------------------------------
%                            Get the signal
%--------------------------------------------------------------------------

%-The data directories to search in...get rid of this later
xeno = 'xeno_canto';
fsnd = 'freesound';

if strcmp(dataSet, xeno) == 0 && strcmp(dataSet, fsnd) == 0
    disp('Could not find the data set you were looking for...')
    disp('Try: ''xeno_canto'' or ''freesound''')
    return
end

%-Read in the file
[sig fs fileName] = readFile(filename, dataSet);

%-Get the mat filename and load in the mat
matFilename = [fileName(1:end-3) 'mat'];
load(matFilename);

%-Collapse into mono
if size(sig, 2) == 2
    sig = (sig(:,1) + sig(:,2) / 2);
end

%-Band pass filter (make this optional)
lowF  = 500;
highF = 10000;
fc1   = lowF/fs;
fc2   = highF/fs;
sig   = filterSig(sig, fc1, fc2);

%-Normalize
sig = sig/max(abs(sig));

%--------------------------------------------------------------------------
%                           Set the parameters
%--------------------------------------------------------------------------

%-WINDOWING parameters
params.win.N    = N;
params.win.H    = H;
params.win.Nfft = Nfft;

%-FILE parameters
params.file.fs       = fs;
params.file.filename = filename;

%--------------------------------------------------------------------------
%                                  AED
%--------------------------------------------------------------------------

%-Make the window
try
    theWin = window(winType, N); 
catch
    disp('Check the winType argument');
    return;
end

%-Get the number of frames
numFrames  = floor((length(sig)-(N-H))/H);
% timeVec    = (0:length(sig)-1).*(H/params.file.fs);

%-Initialize some vectors
theFrames = zeros(numFrames,N);
rms       = zeros(numFrames,1);
flux      = zeros(numFrames,1);

%-Initial indices
startIdx = 1;
endIdx   = N;

%-Flags for aed
rmsBool  = 0;
fluxBool = 0;

%-Do some aedFlag error checking
aedFlags = {'rms', 'flux', 'both'};
if ~strcmp(aedFlag, aedFlags)
    disp('Sorry, check  your aedFlag');
    return;
elseif strcmp(aedFlag, aedFlags{1})
    rmsBool = 1;
elseif strcmp(aedFlag, aedFlags{2})
    fluxBool = 1;
elseif strcmp(aedFlag, aedFlags{3})
    rmsBool  = 1;
    fluxBool = 1;
end

%-Window the signal and get the short time signal energy
for i = 1:numFrames
    
    theFrames(i,:) = sig(startIdx:endIdx) .* theWin; %-Get a frame
    
    %-Check the aed flags, and do the proper aed
    if rmsBool == 1
        rms(i) = sqrt(mean((theFrames(i,:).^2)));
    end
    if fluxBool == 1
        %-IMPLEMENT FLUX AED HERE
        flux(i) = rms(i);
    end
    
    %-Save the start and end indices of signal
    winStart(i) = startIdx;
    winEnd(i)   = endIdx;
    
    %-Increment
    startIdx = startIdx + H;
    endIdx   = endIdx + H;
end

%-LPF the detection functions
[b,a]  = butter(5,0.015,'low');
rms    = filter(b,a,rms);
[b,a]  = butter(5,0.015,'low');
flux   = filter(b,a,flux);

%-1st order deriv of det funcs
diffRMS  = diff(rms)/2;
diffFLUX = diff(flux)/2;

%-Peak pick, based on the aedFlag
if strcmp(aedFlag, aedFlags{1}) || strcmp(aedFlag, aedFlags{3})
    [thePkVal thePkLoc onLoc offLoc] = runPeakPicker(rms, params);
    
    flag     = 'rms';
    metadata = writeMetadata(thePkVal, thePkLoc, onLoc, offLoc, flag);
   
    [thePkVal thePkLoc onLoc offLoc] = runPeakPicker(diffRMS, params);
    
    flag     = 'diffRMS';
    metadata = writeMetadata(thePkVal, thePkLoc, onLoc, offLoc, flag);
    
end
if strcmp(aedFlag, aedFlags{2}) || strcmp(aedFlag, aedFlags{3})
    [thePkVal thePkLoc onLoc offLoc] = runPeakPicker(flux, params);
    flag     = 'flux';
    metadata = writeMetadata(thePkVal, thePkLoc, onLoc, offLoc, flag);
    
    [thePkVal thePkLoc onLoc offLoc] = runPeakPicker(diffFLUX, params);
    flag     = 'diffFLUX';
    metadata = writeMetadata(thePkVal, thePkLoc, onLoc, offLoc, flag);
end

%-The start and end indexes of the onsets and offsets in the signal
% winS = winStart(onLoc);
% winE = winEnd(onLoc);

%-Figure out the pk locations on the original audio signal
% for i = 1:length(winS)
%     temp         = sig(winS(i):winE(i));
%     [pkT locT]   = max(temp);
%     pkLocSig(i)  = winS(i)+locT;
%     pkValSig(i)  = pkT;
% %     onLocSig(i)  = onLoc;
% %     offLocSig(i) = offLoc;
% end

%--------------------------------------------------------------------------
%                            Write to file
%--------------------------------------------------------------------------

% metadata.pkVals    = thePkVal;
% metadata.pkLocs    = thePkLoc;
% metadata.onLocs    = onLoc;
% metadata.offLocs   = offLoc;
% metadata.numEvents = length(thePkLoc);

%-Get the txt filename and load in the txt
% txtFilename = [fileName(1:end-3) 'txt'];
% [metadata]  = txtRead(txtFilename, metadata);

%-Save the struct
save(matFilename, 'metadata');

%--------------------------------------------------------------------------
%                                Plot
%--------------------------------------------------------------------------

subplot(2,1,1), plot(sig); axis tight; title('Signal'); hold on;
% subplot(2,1,1), plot(pkLocSig, pkValSig, 'rx');
subplot(2,1,2), plot(diffRMS); axis tight; title('RMS energy diff'); hold on;
subplot(2,1,2), plot(thePkLoc, thePkVal, 'rx');

for i = 1:length(thePkLoc)
    subplot(2,1,2), plot([onLoc(i) onLoc(i)],[min(diffRMS) max(diffRMS)], 'k--');
    subplot(2,1,2), plot([offLoc(i) offLoc(i)],[min(diffRMS) max(diffRMS)], 'r--');
end

end

function [metadata] = writeMetadata(thePkVal, thePkLoc, onLoc, offLoc, flag)

if strcmp(flag, 'rms')
    metadata.aed.rms.pkVals    = thePkVal;
    metadata.aed.rms.pkLocs    = thePkLoc;
    metadata.aed.rms.onLocs    = onLoc;
    metadata.aed.rms.offLocs   = offLoc;
    metadata.aed.rms.numEvents = length(thePkLoc);
elseif strcmp(flag, 'diffRMS')
    metadata.aed.diffRMS.pkVals    = thePkVal;
    metadata.aed.diffRMS.pkLocs    = thePkLoc;
    metadata.aed.diffRMS.onLocs    = onLoc;
    metadata.aed.diffRMS.offLocs   = offLoc;
    metadata.aed.diffRMS.numEvents = length(thePkLoc);
elseif strcmp(flag, 'flux')
    metadata.aed.flux.pkVals    = thePkVal;
    metadata.aed.flux.pkLocs    = thePkLoc;
    metadata.aed.flux.onLocs    = onLoc;
    metadata.aed.flux.offLocs   = offLoc;
    metadata.aed.flux.numEvents = length(thePkLoc);
elseif strcmp(flag, 'diffFLUX')
    metadata.aed.diffFLUX.pkVals    = thePkVal;
    metadata.aed.diffFLUX.pkLocs    = thePkLoc;
    metadata.aed.diffFLUX.onLocs    = onLoc;
    metadata.aed.diffFLUX.offLocs   = offLoc;
    metadata.aed.diffFLUX.numEvents = length(thePkLoc);
end

end