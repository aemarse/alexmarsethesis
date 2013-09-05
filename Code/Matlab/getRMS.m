function [RMS] = getRMS(frame)

RMS = sqrt(mean((frame .^ 2)));

end