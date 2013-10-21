function [] = runFeatures(filename, dataSet, N, H, Nfft)

%-Incorporate spectral spread into aed for syllables
%-Within each each syllable, get the top 5 sinusoids

%--------------------------------------------------------------------------
%                            Get the signal
%--------------------------------------------------------------------------

xeno = 'xeno_canto';
fsnd = 'freesound';

if strcmp(dataSet, xeno) == 0 && strcmp(dataSet, fsnd) == 0
    disp('Could not find the data set you were looking for...')
    disp('Try: ''xeno_canto'' or ''freesound''')
    return
end

%-Read in the audio file
[sig fs fileName] = readFile(filename, dataSet);

%-Get the mat filename and load in the mat
matFilename = [fileName(1:end-3) 'mat'];
load(matFilename);

%--------------------------------------------------------------------------
%                          Feature extraction
%--------------------------------------------------------------------------

% [S F T] = spectrogram(sig, N, N-H, Nfft, fs); %-Spectrogram
% S       = abs(S); %-Magnitude spectrum

numEvents = length(metadata.txtEvents);

%-Loop through 
for i = 1:numEvents
    %-Get the onset and offset times in samples
    onsetIdx(i)  = floor(metadata.txtEvents(i).onsetStartTime*fs);
    offsetIdx(i) = floor(metadata.txtEvents(i).onsetEndTime*fs);
    
    %-Get the magnitude spectrum
    eventSig     = sig(onsetIdx(i):offsetIdx(i));
    eventFFT     = fft(eventSig, Nfft);
    eventMagSpec = abs(eventFFT(1:Nfft/2+1));
    
    %-Calculate features here
    getSineMod(eventMagSpec, fs);
    
end

%-Plot the events?

