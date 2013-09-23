function [features] = getFrames(sig, params)

theWin = hamming(params.N);

numFrames = floor((length(sig) - (params.N - params.H)) / params.H);

curr = zeros(1, params.N);
past = zeros(1, params.N);

startIdx = 1;
endIdx   = params.N;

for i = 1:numFrames
   
%    if i == 1
%        curr = sig(startIdx:endIdx) .* theWin;
%    else
%        curr = sig(startIdx:endIdx) .* theWin;
%    end

   curr = sig(startIdx:endIdx) .* theWin;   

   [RMS(i), FFT(i,:), ZCR(i,:), SF(i,:), S_ENV(i,:), SC(i), MFCCs(i,:)] ...
       = getFeatures(past, curr, params, i);

   startIdx = startIdx + params.H;
   endIdx   = endIdx + params.H;
   
   past = curr;
   
end

[RMS, ZCR] = normalizeFeats(RMS, ZCR);

features.RMS   = RMS;
features.FFT   = FFT;
features.ZCR   = ZCR;
features.SF    = SF(2,:);
features.S_ENV = S_ENV;
features.SC    = SC;
features.MFCCs = MFCCs(:,2:end);

end