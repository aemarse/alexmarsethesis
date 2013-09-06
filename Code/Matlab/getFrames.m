function [frame features] = getFrames(sig, params)

theWin = hamming(params.N);

numFrames = floor((length(sig) - (params.N - params.H)) / params.H);

frame = zeros(numFrames, params.N);

startIdx = 1;
endIdx   = params.N;

for i = 1:numFrames
   
   frame = sig(startIdx:endIdx) .* theWin;
   
   [RMS(i), spec] = getFeatures(frame, params, i);
   
   T(i)        = spec.T;
   F(i,:)      = spec.F;
   sFinal(i,:) = spec.sFinal;
   
   startIdx = startIdx + params.H;
   endIdx   = endIdx + params.H;
   
end

SPEC.T = T;
SPEC.F = F;
SPEC.S = sFinal;

features.RMS  = RMS;
features.SPEC = SPEC;

end