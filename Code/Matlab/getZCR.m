function [ZCR] = getZCR(frame, params)

%{

Thoughts:
- indicates noisy part of sig
- indicates more noise than signal content

%}

N = params.win.N;

crossed  = zeros(1,N);
crossIdx = zeros(1,N);
theSign  = zeros(1,N);

for i = 1:N
  
  if i == 1
      theSign(i) = getSign(frame(i));
      continue;
  end
  
  theSign(i) = getSign(frame(i));

  if theSign(i) == 1 && theSign(i-1) == -1
      crossed(i) = 1;
  elseif theSign(i) == -1 && theSign(i-1) == 1
      crossed(i) = 1;
  end
  
end

numZCs    = length(find(crossed));
numPerSec = numZCs * params.file.fs/N;
freq      = numPerSec / 2;

% ZCR.numZCs    = numZCs;
% ZCR.numPerSec = numPerSec;
% ZCR.freq      = freq;

ZCR = numPerSec;
% ZCR = numZCs;
% ZCR = freq;

end

function [theSign] = getSign(samp)

if (samp > 0)
    theSign = 1;
elseif (samp < 0)
    theSign = -1;
else
    theSign = 0;
end

end