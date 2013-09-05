function [frame features] = getFrames(sig, params)

theWin = hamming(params.N);

numFrames = floor((length(sig) - (params.N - params.H)) / params.H);

frame = zeros(numFrames, params.N);

startIdx = 1;
endIdx   = params.N;

for i = 1:numFrames
   
   frame = sig(startIdx:endIdx) .* theWin;
   
   [RMS(i)] = getFeatures(frame, params, i);
   
   startIdx = startIdx + params.H;
   endIdx   = endIdx + params.H;
   
end

features.RMS  = RMS;
% features.SPEC = SPEC;

end