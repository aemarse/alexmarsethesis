function [locs, vals] = aed(sig, params)

% sig = sig(1:floor(length(sig)/2));

%-Short time signal energy - Fagerlund 2004
N         = 128;
H         = 64;
theWin    = hanning(N);
numFrames = floor((length(sig)-(N-H))/H);

theFrames = zeros(numFrames,N);
stse = zeros(numFrames,1);

startIdx = 1;
endIdx   = N;

for i = 1:numFrames
    theFrames(i,:) = sig(startIdx:endIdx) .* theWin;
    stse(i)        = sum(20*log10(abs(theFrames(i,:)).^2 + eps));
    
    startIdx = startIdx + H;
    endIdx   = endIdx + H;
end

%------Need to normalize to 0dB

%-LPF the stse function
[b,a] = butter(5,0.015,'low');
stse  = filter(b,a,stse);

%-Peak pick the stse function
[pks locs pkVal pkLoc thePkVal thePkLoc] = peakPick(stse, params);

subplot(2,1,1),plot(sig); axis tight;
subplot(2,1,2),plot(stse); axis tight; hold on;
subplot(2,1,2),plot(thePkLoc, thePkVal, 'rx');

% sound(sig, params.file.fs);

%------Need to do the noise level estimate
En0    = min(stse);
thresh = En0/2;
marker = 0;

onsets  = zeros(1,numFrames);
offsets = zeros(1,numFrames);

for i = 1:numFrames
    
    if stse(i) >= thresh
        if marker == 1
            continue;
        else
            onsets(i) = 1;
            marker    = 1;
        end
    else
        if marker == 1
            offsets(i) = 1;
            marker     = 0;
            continue;
        else
            En0    = stse(i);
            thresh = En0/2;
        end
    end
    
end

%--------------------------------------------------------------------------

%-Short time spectrum maximum - Fagerlund 2004
N         = 256;
H         = 64;
Nfft      = 1024;
theWin    = hanning(N);
numFrames = floor((length(sig)-(N-H))/H);

theFrames = zeros(numFrames,N);
theSpec   = zeros(numFrames,Nfft);

startIdx = 1;
endIdx   = N;

for i = 1:numFrames
   
    theFrames(i,:) = sig(startIdx:endIdx) .* theWin;
    theSpec(i,:)   = abs(fft(theFrames(i,:), Nfft));
    
    startIdx = startIdx + H;
    endIdx   = endIdx + H;
    
end

end