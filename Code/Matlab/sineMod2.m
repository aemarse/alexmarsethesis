function [] = sineMod2(sig, params)

%-Params for the big win
NF = floor((length(sig) - (params.win.N - params.win.H)) / params.win.H);
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
    
    %-Compute the sinusoids
    [amps, bins, phase] = computeSinusoids(frame, params);
    
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

%-Compute the sinusoids for modeling
function [theAmps, theBins, thePhase] = computeSinusoids(frame, params)

%-Compute the number of subframes
NFs = floor((length(frame) - (params.win.Ns - params.win.Hs)) / ...
    params.win.Hs);

pkDiff    = zeros(NFs-1, params.feat.numPeaks);
trackBool = zeros(NFs-1, params.feat.numPeaks);

%-Windowing incdices
startIdx = 1;
endIdx   = params.win.Ns;

%-Loop through the num of subframes
for i = 1:NFs
    
    %-Grab a subframe
    subframe = frame(startIdx:endIdx);
    
    %-Get the FFT of the subframes
    FFT = fft(subframe, params.win.NFFTs);
    
    %-Store only the unique portion of the FFT
    magSpec(i,:) = abs(FFT(1:length(FFT)/2+1));
    
    %-Also get the phase
    fftPhase(i,:) = angle(FFT(1:length(FFT)/2+1));
    
    %-Get the values and locations of the top 5 peaks in theFFT
    [peaks(i,:), locs(i,:)] = peakPick(magSpec(i,:), params);
    
    %-Track the sinusoids
    if i > 1
        
        %-Absolute difference b/t sinusoids of neighboring fft frames
        pkDiff(i,:) = abs(locs(i,:) - locs(i-1,:));
        
        %-Test the diffs against a threshold
        trackBool(i,:) = pkDiff(i,:) <= params.feat.maxDist;
        
        %-Construct a vector w/ the only tracked peak freq bins
        for h = 1:size(pkDiff,2)
            if trackBool(i,h) == 1
                theAmps(i-1,h)  = peaks(i-1,h);
                theAmps(i,h)    = peaks(i,h);
                theBins(i-1,h)  = locs(i-1,h);
                theBins(i,h)    = locs(i,h);
                thePhase(i-1,h) = fftPhase(locs(i-1,h));
                thePhase(i,h)   = fftPhase(locs(i,h));
            end
        end
        
    end
    
    %-Increment the windowing indices
    startIdx = startIdx + params.win.Hs;
    endIdx   = endIdx + params.win.Hs;
    
end

pkDiff    = pkDiff(2:end,:);
trackBool = trackBool(2:end,:);

% yAmp = interp(amps, floor(params.win.Ns/length(amps)));
% yFreq = interp((theBins(1:end, 1)*(params.file.fs/2))/(params.win.Nfft/2+1), floor(params.win.Ns/length(theBins(1:end,1))));
% yPhase = interp(unwrap(thePhase(1:end, 1)), floor(params.win.Ns/length(theBins(1:end,1))));

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