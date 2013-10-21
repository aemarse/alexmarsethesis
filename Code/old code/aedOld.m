function [locs, vals] = aedOld(sig, params)

% sig = sig(1:floor(length(sig)/2));

%--------------------------------------------------------------------------
%            Short time signal energy - Fagerlund 2004
%--------------------------------------------------------------------------
N          = 128;
H          = 64;
theWin     = hanning(N);
numFrames  = floor((length(sig)-(N-H))/H);
timeVec    = (0:length(sig)-1).*(H/params.file.fs);

%-Initialize some vectors
theFrames = zeros(numFrames,N);
stse      = zeros(numFrames,1);
rms       = zeros(numFrames,1);

%-Initial indices
startIdx = 1;
endIdx   = N;

%-Window the signal and get the short time signal energy
for i = 1:numFrames
    theFrames(i,:) = sig(startIdx:endIdx) .* theWin;
    stse(i)        = sum(20*log10(abs(theFrames(i,:)).^2 + eps));
    rms(i)         = sqrt(mean((theFrames(i,:).^2)));
    winStart(i)    = startIdx;
    winEnd(i)      = endIdx;
    
    startIdx = startIdx + H;
    endIdx   = endIdx + H;
end

%------Need to normalize to 0dB

%-LPF the stse function
[b,a] = butter(5,0.015,'low');
stse  = filter(b,a,stse);

%-LPF the rms function
[b,a] = butter(5,0.015,'low');
rms   = filter(b,a,rms);

%-Take the 1st order derivative of the RMS
diffRMS = diff(rms)/2;

%-Peak pick
% [thePkVal thePkLoc onLoc offLoc] = peakPick2(stse, params); %-STSE
[thePkVal thePkLoc onLoc offLoc] = peakPick2(diffRMS, params); %-RMS

%-Find the non-zero onset and offset locations
% [temp plotOn]  = find(onLoc>0);
% [temp plotOff] = find(offLoc>0);
% 
% [temp zPlotOn]  = find(zOnLoc>0);
% [temp zPlotOff] = find(zOffLoc>0);
% 
% plotMin = min(stse);
% plotMax = max(stse);

%-Plot the STSE
% subs = 310;
% subplot(subs + 1),plot(sig); axis tight;
% subplot(subs + 2),plot(stse); axis tight; hold on;
% subplot(subs + 2),plot(thePkLoc, thePkVal, 'rx');
% subplot(subs + 2), plot(onLoc(plotOn), stse(onLoc(plotOn)), 'gx');
% % subplot(subs + 2), plot(onLoc(plotOn), (plotMin:plotMax), 'g--');
% subplot(subs + 2), plot(offLoc(plotOff), stse(offLoc(plotOff)), 'kx');
% % subplot(subs + 2), plot(offLoc(plotOff), (plotMin:plotMax), 'c--');
% subplot(subs + 3); plot(diff(stse)/2); axis tight;

%-Plot the RMS
% subs = 210;
% subplot(subs + 1),plot(sig); axis tight;
% subplot(subs + 2),plot(diffRMS); axis tight; hold on;
% subplot(subs + 2),plot(thePkLoc, thePkVal, 'rx');
% subplot(subs + 2), plot(onLoc(plotOn), diffRMS(onLoc(plotOn)), 'gx');
% subplot(subs + 2), plot(zOnLoc(zPlotOn), diffRMS(zOnLoc(zPlotOn)), 'gx');
% subplot(subs + 2), plot(offLoc(plotOff), diffRMS(offLoc(plotOff)), 'kx');
% subplot(subs + 2), plot(zOffLoc(zPlotOff), diffRMS(zOffLoc(zPlotOff)), 'kx');
% subplot(subs + 3); plot(diffRMS); axis tight;

minHt     = 0.00025; %-Minimum peak height threshold
pkIdx     = find(thePkVal > minHt); %-Absolute threshold (temporarily)
thePkLoc  = thePkLoc(pkIdx); %-Pk location
thePkVal  = thePkVal(pkIdx); %-Pk value
onLoc     = onLoc(pkIdx); %-Onset location on RMS det func
offLoc    = offLoc(pkIdx); %-Offset location on RMS det func

winS       = winStart(onLoc);
winE       = winEnd(onLoc);

for i = 1:length(winS)
    temp         = sig(winS(i):winE(i));
    [pkT locT]   = max(temp);
    pkLocSig(i)  = winS(i)+locT+30;
    pkValSig(i)  = pkT;
%     onLocSig(i)  = onLoc;
%     offLocSig(i) = offLoc;
end

% fig = figure;
% hax = axes;

% winX = winE(1)-winS(1)+1;
% winY = hann(winX)';

subplot(2,1,1), plot(sig); axis tight; title('Signal'); hold on;
subplot(2,1,1), plot(pkLocSig, pkValSig, 'rx');
subplot(2,1,2), plot(diffRMS); axis tight; title('RMS energy'); hold on;
subplot(2,1,2), plot(thePkLoc, thePkVal, 'rx');

% for i = 1:length(winS)
%     subplot(2,1,1), plot([winS(i):winE(i)], winY, 'g');
% end

for i = 1:length(thePkLoc)
    subplot(2,1,2), plot([onLoc(i) onLoc(i)],[min(diffRMS) max(diffRMS)], 'k--');
    subplot(2,1,2), plot([offLoc(i) offLoc(i)],[min(diffRMS) max(diffRMS)], 'r--');
%     line([onLoc(i) onLoc(i)],get(hax,'YLim'),'Color',[1 0 0])
%     line([offLoc(i) offLoc(i)],get(hax,'YLim'),'Color',[0 0 0])
end

% sound(sig, params.file.fs);

%------Need to do the noise level estimate
% En0    = min(stse);
% thresh = En0/2;
% marker = 0;
% 
% onsets  = zeros(1,numFrames);
% offsets = zeros(1,numFrames);
% 
% for i = 1:numFrames
%     
%     if stse(i) >= thresh
%         if marker == 1
%             continue;
%         else
%             onsets(i) = 1;
%             marker    = 1;
%         end
%     else
%         if marker == 1
%             offsets(i) = 1;
%             marker     = 0;
%             continue;
%         else
%             En0    = stse(i);
%             thresh = En0/2;
%         end
%     end
%     
% end

%--------------------------------------------------------------------------
%            Short time spectrum maximum - Fagerlund 2004
%--------------------------------------------------------------------------
% N         = 256;
% H         = 64;
% Nfft      = 1024;
% theWin    = hanning(N);
% numFrames = floor((length(sig)-(N-H))/H);
% 
% theFrames = zeros(numFrames,N);
% theSpec   = zeros(numFrames,Nfft);
% 
% startIdx = 1;
% endIdx   = N;
% 
% for i = 1:numFrames
%    
%     theFrames(i,:) = sig(startIdx:endIdx) .* theWin;
%     theSpec(i,:)   = abs(fft(theFrames(i,:), Nfft));
%     
%     startIdx = startIdx + H;
%     endIdx   = endIdx + H;
%     
% end

end