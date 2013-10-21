function [sig] = filterSig(x, fc1, fc2)

[b,a]  = butter(2, [fc1 fc2]);
sig    = filter(b, a, x);

end