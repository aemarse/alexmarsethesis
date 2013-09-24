function [features] = getFrames(sig, params)

%-Make the window
theWin = hamming(params.win.N);

%-Determine the number of frames
numFrames = floor((length(sig) - (params.win.N - params.win.H)) / ...
    params.win.H);

%-Allocate the frame vectors
curr = zeros(1, params.win.N);
past = zeros(1, params.win.N);

%-Set the initial window indices
startIdx = 1;
endIdx   = params.win.N;

%-Compute features on the frames
for i = 1:numFrames

    %-Window the signal
    curr = sig(startIdx:endIdx) .* theWin;   

    %-Compute features on the window
    [RMS(i), FFT(i,:), ZCR(i,:), SF(i,:), S_ENV(i,:), SC(i), MFCCs(i,:)] ...
       = getFeatures(past, curr, params, i);

    %-Implement moving avg for MFCC
   
    %-Increment the window indices
    startIdx = startIdx + params.win.H;
    endIdx   = endIdx + params.win.H;
    
    %-Store the past window
    past = curr;
   
end

% Nw = params.win.N;
% NF = numFrames;
% time_frames = [0:NF-1]*Ts*0.001+0.5*Nw/fs;  % time vector (s) for frames 
% time = [ 0:length(speech)-1 ]/fs;

% NF = size(MFCCs,2);
% Nw = params.win.N;
% Ts = params.win.H/params.file.fs;
% time_frames = [0:NF-1]*Ts*0.001+0.5*Nw/params.file.fs;
% MFCCs = MFCCs';
% imagesc(time_frames, [1:params.feat.numCoeff], MFCCs(2:end,:));
% set(gca, 'YDir', 'normal');

% imagesc([1:length(MFCCs)], [0:params.feat.numCoeff-1], MFCCs);
% set(gca, 'YDir', 'normal');

%-Normalize the features
[RMS, ZCR] = normalizeFeats(RMS, ZCR);

%-Save to the features struct
features.RMS   = RMS;
features.FFT   = FFT;
features.ZCR   = ZCR;
features.SF    = SF(2,:);
features.S_ENV = S_ENV;
features.SC    = SC;
features.MFCCs = MFCCs(:,2:end);

end