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
%     [S] = getSTFT(frame, params);
    
    %-Sub-window it and get the fft of each window
    [FFT] = getPeaksOfFFT(frame, params);
    
    
    
    %-Compute the sinusoids HERE
%     [vals, locs] = compSinusoids(FFT);
    
    %-Increment the indices
    startIdx = startIdx + params.win.H;
    endIdx   = endIdx + params.win.H;
    
end

end

%--------------------------------------------------------------------------
%                           Helper functions
%--------------------------------------------------------------------------

%-Get the subframe FFT
function [theFFT] = getPeaksOfFFT(frame, params)

%-Compute the number of subframes
NFs = floor((length(frame) - (params.win.Ns - params.win.Hs)) / ...
    params.win.Hs);

%-Windowing incdices
startIdx = 1;
endIdx   = params.win.Ns;

%-Loop through the num of subframes
for i = 1:NFs
    
    %-Grab a subframe
    subframe = frame(startIdx:endIdx);
    
    %-Get the FFT of the subframes
    FFT = abs(fft(subframe, params.win.NFFTs));
    
    %-Store only the unique portion of the FFT
    theFFT(i,:) = FFT(1:length(FFT)/2+1);
    
    %-Get the values and locations of the top 5 peaks in the FFT
    [peaks(i,:), locs(i,:)] = peakPick(theFFT(i,:), params);
    
    startIdx = startIdx + params.win.Hs;
    endIdx   = endIdx + params.win.Hs;
    
end

%-Track the sinusoids


end

%-Compute the sinusoids
% function [vals, locs] = compSinusoids(FFT)
% 
% %-Peak picking the STFT
% % [vals, locs] = getPeaks(FFT);
% 
% %-
% 
% % if size(vals,2) == 0
% %     vals = zeros(size(vals,1),1);
% %     locs = zeros(size(vals,1),1);
% % end
% 
% end

%-Peak pick the FFT
% function [vals, locs] = getPeaks(FFT)
% 
% numFrames = size(FFT, 1);
% 
% absThresh = -50;
% 
% for i = 1:numFrames
%     
%     %-Get dB
%     FFT(i,:) = 20*log10(FFT(i,:)+eps);
%     
%     %-Absolute amplitude threshold - 50dB
%     [peaks, locs(i,:)] = find(FFT(i,:) > absThresh);
%     vals(i,:) = FFT(locs(i,:));
%     
% end
% 
% end

% function [FFT] = getFFT(frame, params)
% 
% FFT = abs(fft(frame, params.win.NFFTs));
% FFT = FFT(1:length(FFT)/2+1);
% 
% end
% 
% function [S] = getSTFT(frame, params)
% 
% [S,F,T,P] = spectrogram(frame, params.win.Ns, params.win.Ns - ...
%     params.win.Hs, params.win.NFFTs);
% 
% S = abs(S);
% F = F/abs(max(F))*params.file.fs;
% % figure('name', params.filename)
% % imagesc(T, F, S)
% % axis xy, colormap(jet), ylabel('Frequency'), xlabel('Time')
% % title('Log magnitude spectrum')
% 
% end