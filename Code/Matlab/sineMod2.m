function [] = sineMod2(sig, params)

%-Params for the big win
N      = params.N;
H      = params.H;
NF     = floor((length(sig) - (N - H)) / H);
theWin = hamming(N);
frame  = zeros(1,N);

%-Params for the small win
params.Ns    = 256;
params.Hs    = params.Ns/4;
params.NFFTs = 1024;

%-Indices for big window
startIdx = 1;
endIdx   = N;

%-Loop through the number of frames
for i = 1:NF
    
    %-Window it
    frame = sig(startIdx:endIdx) .* theWin;
    
    %-Get the stft
    [S] = getSTFT(frame, params);
    
    %-Sub-window it and get the stft of each window
%     [subframes, FFT] = getSubFrames(frame, params);
    
    %-Compute the sinusoids HERE
    compSinusoids(S);
    
    %-Increment the indices
    startIdx = startIdx + H;
    endIdx   = endIdx + H;
    
end

end

% function [subframe, FFT] = getSubFrames(frame, params)
% 
% NFs = floor((length(frame) - (params.Ns - params.Hs)) / params.Hs);
% 
% startIdx = 1;
% endIdx   = params.Ns;
% 
% for i = 1:NFs
%     
%     subframe = frame(startIdx:endIdx);
%     
%     FFT(i,:) = getFFT(subframe, params);
%     
% end
% 
% end
% 
% function [FFT] = getFFT(frame, params)
% 
% FFT = abs(fft(frame, params.NFFTs));
% 
% end

function [S] = getSTFT(frame, params)

[S,F,T,P] = spectrogram(frame, params.Ns, params.Ns - params.Hs, ...
    params.NFFTs);

% S = 20*log10(abs(S)+eps); %more deets
S = abs(S);
% temp = floor(size(S,1)/2);
% S = S(1:temp,:);
% F = F/abs(max(F))*params.fs;
% F = F(1:temp);
figure('name', params.filename)
imagesc(T, F, S)
axis xy, colormap(jet), ylabel('Frequency'), xlabel('Time')
title('Log magnitude spectrum')

end

function [] = compSinusoids(S)

%-Peak picking the STFT
getPeaks(S);

%-

end

function [] = getPeaks(S)

numFrames = size(S, 2);

for i = 1:numFrames
    
    [SSval, SSidx] = sort(S(:,i), 'descend');
    
    peaks(i,:) = SSval(1:5);
    locs(i,:)  = SSidx(1:5);
    
end

end