function [] = runScript(filename, dataSet, winType, N, H, Nfft)

%--------------------------------------------------------------------------
%                        Read in the audio file
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

%--------------------------------------------------------------------------
%                        Buffer the audio signal
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
fftSize    = Nfft/2+1;

%-Initialize some vectors
buf     = zeros(numFrames,N);
spec    = zeros(numFrames,Nfft);
magSpec = zeros(numFrames,fftSize);

%-Initial indices
startIdx = 1;
endIdx   = N;

%-Buffer the signal
for i = 1:numFrames
    buf(i,:) = sig(startIdx:endIdx) .* theWin;
    
    spec         = fft(buf(i,:), Nfft);
    magSpec(i,:) = abs(spec(1:fftSize));
    
    startIdx = startIdx + H;
    endIdx   = endIdx + H;
end

%-Write the parameters to one struct
params.N         = N;
params.H         = H;
params.Nfft      = Nfft;
params.numFrames = numFrames;
params.fs        = fs;

%--------------------------------------------------------------------------
%                                AED
%--------------------------------------------------------------------------

%-Call aed()
onsets = aed(buf, magSpec, params);

%-Make new signal matrix with only the frames that have events
onSig  = buf(onsets.rms.onsetBool == 1,:);
onSpec = magSpec(onsets.rms.onsetBool == 1,:);

params.numOnFrames = length(onsets.rms.thePkLoc);

%--------------------------------------------------------------------------
%                         Feature extraction
%--------------------------------------------------------------------------

%-Call getFeatures()
if params.numOnFrames >= 1 %-Make sure there are detected events
    features = getFeatures(onSig, onSpec, magSpec, params, onsets);
else
    disp('Cannot do feature extraction because no events were detected');
    return;
end

%--------------------------------------------------------------------------
%                             Save data
%--------------------------------------------------------------------------

%-Save the struct
save(matFilename, 'metadata', 'aed', 'features', 'params');

%--------------------------------------------------------------------------
%                             Plot data?
%--------------------------------------------------------------------------

end