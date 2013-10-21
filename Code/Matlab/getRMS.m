function [rms] = getRMS(buf, numFrames)

rms = zeros(numFrames,1);

for i = 1:numFrames
   rms(i) = sqrt(mean(buf(i,:) .^ 2));
end

end