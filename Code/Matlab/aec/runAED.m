function [] = runAED(filename, dataSet, winType, aedFlag, N, H, Nfft)

%--------------------------------------------------------------------------
%                         ABOUT THIS FUNCTION
%--------------------------------------------------------------------------
%- Written by Alex Marse (2013)

%-USAGE EXAMPLE:
%-runAED('Larus delawarensis_Ring-billed Gull_53947.wav', 'xeno_canto',...
%-'hanning', 'rms', 256, 64, 1024);

%-FUNCTIONALITY
%-This function will perform aed on a signal. It loads the signal into
%-Matlab, windows the signal, gets detection functions from the windows,
%-runs these functions through a peak picker, and plots the results.

%-INPUTS
%-filename: the filename of the file to be used (string)
%-dataSet : the data set in which the file is located (string)
%-          options: 'xeno_canto', 'freesound'
%-winType : the type of window to be used (string)
%-aedFlag : the flag for aed (string); options: 'rms', 'flux', 'both'
%-N       : thw window size for time windowing
%-H       : the hop size for time windowing
%-Nfft    : the fft size

%-OUTPUTS
%-None, currently

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

%-Error check the dataSet input
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

%-If the signal is too long, cut it at say...15 seconds for now?
% maxSigLen = 1;
% if length(sig)/fs > maxSigLen
%     sig = sig(1:maxSigLen*fs);
% end

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

%-Initialize aed data struct
aed.init = 0;

%-Peak pick, based on the aedFlag
%-If the flag is rms or both
if strcmp(aedFlag, aedFlags{1}) || strcmp(aedFlag, aedFlags{3})
    
    %-Peak pick
    [thePkVal thePkLoc onLoc offLoc] = runPeakPicker(rms, params);
    flag = 'rms';
    
    %-Write aed data to struct
    aed  = writeMetadata(aed, thePkVal, thePkLoc, onLoc, offLoc, flag);
    [thePkVal thePkLoc onLoc offLoc] = runPeakPicker(diffRMS, params);
    flag = 'diffRMS';
    aed  = writeMetadata(aed, thePkVal, thePkLoc, onLoc, offLoc, flag);
    
end
%-If the flag is flux or both
if strcmp(aedFlag, aedFlags{2}) || strcmp(aedFlag, aedFlags{3})
    [thePkVal thePkLoc onLoc offLoc] = runPeakPicker(flux, params);
    flag = 'flux';
    aed  = writeMetadata(aed, thePkVal, thePkLoc, onLoc, offLoc, flag);
    
    [thePkVal thePkLoc onLoc offLoc] = runPeakPicker(diffFLUX, params);
    flag = 'diffFLUX';
    aed  = writeMetadata(aed, aedthePkVal, thePkLoc, onLoc, offLoc, flag);
end

%-Save the struct
save(matFilename, 'metadata', 'aed');

%--------------------------------------------------------------------------
%                                Plot
%--------------------------------------------------------------------------

clf
close all

numFigs = 1; %-Initial value for the number of figure to plot

%-Get the proper plotting parameters (rms, flux) from the aed struct,
%-depending on the aedFlag
if strcmp(aedFlag, aedFlags{1}) || strcmp(aedFlag, aedFlags{3})
    
    det         = rms;
    thePkLocDet = aed.rms.pkLocs;
    thePkValDet = aed.rms.pkVals;
    onLocDet    = aed.rms.onLocs;
    offLocDet   = aed.rms.offLocs;
    
    diffDet      = diffRMS;
    thePkLocDiff = aed.diffRMS.pkLocs;
    thePkValDiff = aed.diffRMS.pkVals;
    onLocDiff    = aed.diffRMS.onLocs;
    offLocDiff   = aed.diffRMS.offLocs;
    
elseif strcmp(aedFlag, aedFlags{2}) || strcmp(aedFlag, aedFlags{3})
    
    det         = flux;
    thePkLocDet = aed.flux.pkLocs;
    thePkValDet = aed.flux.pkVals;
    onLocDet    = aed.flux.onLocs;
    offLocDet   = aed.flux.offLocs;
    
    diffDet      = diffFLUX;
    thePkLocDiff = aed.diffFLUX.pkLocs;
    thePkValDiff = aed.diffFLUX.pkVals;
    onLocDiff    = aed.diffFLUX.onLocs;
    offLocDiff   = aed.diffFLUX.offLocs;
    
else 
    numFigs = 2; %-If the aedFlag is 'both', we'll probably need two figs?
end

%-Plot the data (signal, detection func, 1st deriv of detection func)
for i = 1:numFigs
    
    figure;
    
    subplot(3,1,1), plot(sig); axis tight; title('Signal'); hold on;
    
    %-TO DO: Fix the title to reflect the proper plot(rms, diff rms, flux, etc.)
    subplot(3,1,2), plot(det); axis tight; title('RMS energy'); hold on;
    subplot(3,1,2), plot(thePkLocDet, thePkValDet, 'rx');
    for h = 1:length(thePkLocDet)
        subplot(3,1,2), plot([onLocDet(h) onLocDet(h)],[min(det) max(det)], 'k--');
        subplot(3,1,2), plot([offLocDet(h) offLocDet(h)],[min(det) max(det)], 'r--');
    end
    
    subplot(3,1,3), plot(diffDet); axis tight; title('RMS energy'); hold on;
    subplot(3,1,3), plot(thePkLocDiff, thePkValDiff, 'rx');
    for h = 1:length(thePkLocDiff)
        subplot(3,1,3), plot([onLocDiff(h) onLocDiff(h)],[min(diffDet) max(diffDet)], 'k--');
        subplot(3,1,3), plot([offLocDiff(h) offLocDiff(h)],[min(diffDet) max(diffDet)], 'r--');
    end
    
end

end

function [aed] = writeMetadata(aed, thePkVal, thePkLoc, onLoc, offLoc, flag)
%-This function writes the aed data to the aed struct, based on a flag

if strcmp(flag, 'rms')
    aed.rms.pkVals    = thePkVal;
    aed.rms.pkLocs    = thePkLoc;
    aed.rms.onLocs    = onLoc;
    aed.rms.offLocs   = offLoc;
    aed.rms.numEvents = length(thePkLoc);
elseif strcmp(flag, 'diffRMS')
    aed.diffRMS.pkVals    = thePkVal;
    aed.diffRMS.pkLocs    = thePkLoc;
    aed.diffRMS.onLocs    = onLoc;
    aed.diffRMS.offLocs   = offLoc;
    aed.diffRMS.numEvents = length(thePkLoc);
elseif strcmp(flag, 'flux')
    aed.flux.pkVals    = thePkVal;
    aed.flux.pkLocs    = thePkLoc;
    aed.flux.onLocs    = onLoc;
    aed.flux.offLocs   = offLoc;
    aed.flux.numEvents = length(thePkLoc);
elseif strcmp(flag, 'diffFLUX')
    aed.diffFLUX.pkVals    = thePkVal;
    aed.diffFLUX.pkLocs    = thePkLoc;
    aed.diffFLUX.onLocs    = onLoc;
    aed.diffFLUX.offLocs   = offLoc;
    aed.diffFLUX.numEvents = length(thePkLoc);
end

end