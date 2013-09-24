function [] = sineMod2(sig, params)

%-Params for the big win
NF     = floor((length(sig) - (params.win.N - params.win.H)) / ...
    params.win.H);

theWin = hamming(params.win.N);
frame  = zeros(1,params.win.N);

%-Indices for big window
startIdx = 1;
endIdx   = params.win.N;

%-Loop through the number of frames
for i = 1:NF
    
    %-Window it
    frame = sig(startIdx:endIdx) .* theWin;
    
    %-Get the stft
    [S] = getSTFT(frame, params);
    
    %-Sub-window it and get the stft of each window
    [subframes, FFT] = getSubFrames(frame, params);
    
    %-Compute the sinusoids HERE
    [vals, locs] = compSinusoids(FFT);
    
    %-Increment the indices
    startIdx = startIdx + params.win.H;
    endIdx   = endIdx + params.win.H;
    
end

end

function [subframe, FFT] = getSubFrames(frame, params)

NFs = floor((length(frame) - (params.win.Ns - params.win.Hs)) / ...
    params.win.Hs);

startIdx = 1;
endIdx   = params.win.Ns;

for i = 1:NFs
    
    subframe = frame(startIdx:endIdx);
    
    FFT(i,:) = getFFT(subframe, params);
    
end

end

function [FFT] = getFFT(frame, params)

FFT = abs(fft(frame, params.win.NFFTs));
FFT = FFT(1:length(FFT)/2+1);

end

function [S] = getSTFT(frame, params)

[S,F,T,P] = spectrogram(frame, params.win.Ns, params.win.Ns - ...
    params.win.Hs, params.win.NFFTs);

S = abs(S);
F = F/abs(max(F))*params.file.fs;
% figure('name', params.filename)
% imagesc(T, F, S)
% axis xy, colormap(jet), ylabel('Frequency'), xlabel('Time')
% title('Log magnitude spectrum')

end

function [vals, locs] = compSinusoids(FFT)

%-Peak picking the STFT
[vals, locs] = getPeaks(FFT);

%-

if size(vals,2) == 0
    vals = zeros(size(vals,1),1);
    locs = zeros(size(vals,1),1);
end

end

function [vals, locs] = getPeaks(FFT)

numFrames = size(FFT, 1);

absThresh = -50;

for i = 1:numFrames
    
    %-Get dB
    FFT(i,:) = 20*log10(FFT(i,:)+eps);
    
    %-Absolute amplitude threshold - 50dB
    [peaks, locs(i,:)] = find(FFT(i,:) > absThresh);
    vals(i,:) = FFT(locs(i,:));
    
end

end