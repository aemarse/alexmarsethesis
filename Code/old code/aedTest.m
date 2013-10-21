function [] = aedTest(sig, params)

N         = 256;
H         = 64;
Nfft      = 1024;
uniBins   = Nfft/2+1;
% theWin    = hanning(N);
% numFrames = floor((length(sig)-(N-H))/H);

[S F T P] = spectrogram(sig, N, N-H, Nfft);
S         = abs(S);
uniqueS   = S(1:uniBins,:);

%-Spectral envelope via RMS
rmsSpEnv  = sqrt(mean((uniqueS.^2)));
% subplot(2,1,1), plot(rmsSpEnv); axis tight;

%-Spectral envelope via LPF
[b,a]       = butter(4,0.15,'low');
lpfSpEnv    = filter(b,a,uniqueS);
% subplot(2,1,2), imagesc(T,F,lpfSpEnv); axis xy; colormap(jet);

%-Get the max bin and amp of each time frame
[fMags fBins] = max(lpfSpEnv);

%-Convert the bins to Hz
% fHz = fBins * params.file.fs/2 / uniBins;

binThresh = 2;
pks       = 1;

for i = 2:length(fBins)
    
    %-Figure out how far apart the max is
    binDiff(i) = abs(fBins(i) - fBins(i-1));
    
    %-Figure out how the magnitudes change
    magDiff(i) = abs(fMags(i) - fMags(i-1));
    
    %-If the max is close enough
    if binDiff(i) < binThresh
        %-Track the peaks
        tracks(pks) = fBins(i);
        mags(pks)   = fMags(i);
        pks = pks + 1;
    end
    
end

% diffMags = diff(mags);
% diffBins = diff(bins);

% subplot(3,1,1), imagesc(T, F, S); axis xy, colormap(jet), ...
%     ylabel('Frequency'), xlabel('Time'), title('Log magnitude spectrum')

% subplot(2,1,1), imagesc(T, F, Sfilt); axis xy, colormap(jet), ...
%     ylabel('Frequency'), xlabel('Time'), ...
%     title('Log magnitude spectrum - Filtered')

% subplot(2,1,2), plot(Sfilt(locs,:));

% %-Initialize frame vector
% theFrame = zeros(numFrames,N);
% theDft   = zeros(numFrames,Nfft);
% dftUni   = zeros(numFrames,Nfft/2+1);
% dftEnv   = zeros(numFrames,1);
% 
% %-Initial indices
% startIdx = 1;
% endIdx   = N;
% 
% %-Window the signal and get the short time signal energy
% for i = 1:numFrames
%     theFrame    = sig(startIdx:endIdx) .* theWin;
%     theDft(i,:) = abs(fft(theFrame, Nfft));
%     dftUni(i,:) = theDft(i,1:Nfft/2+1);
%     dftEnv(i,:) = sum(sqrt(mean(dftUni(i,:).^2)));
%     
%     startIdx = startIdx + H;
%     endIdx   = endIdx + H;
% end
% 
% [b,a]  = butter(5,0.015,'low');
% dftEnv = filter(b,a,dftEnv);
% 
% plot(dftEnv);

end