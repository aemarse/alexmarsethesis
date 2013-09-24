function [features] = getFrames(sig, params)

theWin = hamming(params.win.N);

numFrames = floor((length(sig) - (params.win.N - params.win.H)) / ...
    params.win.H);

curr = zeros(1, params.win.N);
past = zeros(1, params.win.N);

startIdx = 1;
endIdx   = params.win.N;

for i = 1:numFrames
   
%    if i == 1
%        curr = sig(startIdx:endIdx) .* theWin;
%    else
%        curr = sig(startIdx:endIdx) .* theWin;
%    end

   curr = sig(startIdx:endIdx) .* theWin;   

   [RMS(i), FFT(i,:), ZCR(i,:), SF(i,:), S_ENV(i,:), SC(i), MFCCs(i,:)] ...
       = getFeatures(past, curr, params, i);

   %-Implement moving avg for FFT
   
   startIdx = startIdx + params.win.H;
   endIdx   = endIdx + params.win.H;
   
   past = curr;
   
end

% Nw = params.win.N;
% NF = numFrames;
% time_frames = [0:NF-1]*Ts*0.001+0.5*Nw/fs;  % time vector (s) for frames 
% time = [ 0:length(speech)-1 ]/fs;

imagesc([1:length(MFCCs)], [0:params.feat.numCoeff-1], MFCCs);
set(gca, 'YDir', 'normal');

[RMS, ZCR] = normalizeFeats(RMS, ZCR);

features.RMS   = RMS;
features.FFT   = FFT;
features.ZCR   = ZCR;
features.SF    = SF(2,:);
features.S_ENV = S_ENV;
features.SC    = SC;
features.MFCCs = MFCCs(:,2:end);

end