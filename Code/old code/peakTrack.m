function [amps, freqs] = peakTrack(peaks, locs, params, i)

% pkDiff    = zeros(1, params.feat.numPeaks);
% trackBool = zeros(1, params.feat.numPeaks);
% theAmps   = zeros(1, params.feat.numPeaks);
% theFreqs  = zeros(1, params.feat.numPeaks);

%-Absolute difference b/t sinusoids of neighboring fft frames
pkDiff = abs(locs(i,:) - locs(i-1,:));

%-Test the diffs against a threshold
trackBool = pkDiff <= params.feat.maxDist;

%-Construct a vector w/ the only tracked peak freq bins
for h = 1:size(pkDiff,2)

    if trackBool(h) == 1
%         theAmps(i-1,h)  = peaks(i-1,h);
        amps(h)    = peaks(i,h);
%         theFreqs(i-1,h) = locs(i-1,h);
        freqs(h)   = locs(i,h);
      
%         thePhase(i-1,h) = fftPhase(locs(i-1,h));
%         thePhase(i,h)   = fftPhase(locs(i,h));
    else
        amps(h)  = 0;
        freqs(h) = 0;
    end

end

pkDiff    = pkDiff(2:end,:);
trackBool = trackBool(2:end,:);

% theAmps = theAmps(2,:);
% theFreqs = theFreqs(2,:);

end