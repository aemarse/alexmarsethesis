load('/Users/aemarse/Documents/devel/Thesis/Code/Matlab/resynthesis2.mat')

theFreqs = theFreqs * params.file.fs/2 / (params.win.Nfft/2+1);
freqOsc1 = theFreqs(1:end, 1);
% yFreq    = interp( freqOsc1, ceil(params.win.Ns/length(freqOsc1)));
yFreq    = interp( freqOsc1, ceil(params.file.fs/length(freqOsc1)));

ampOsc1 = theAmps(1:end, 1);
yAmp    = interp( ampOsc1, ceil(params.file.fs/length(ampOsc1)));

phaseOsc1 = thePhase(1:end, 1);
yPhase    = interp(unwrap(phaseOsc1), (ceil(params.file.fs/length(phaseOsc1))));

a = (0:(length(yFreq)-1)*1)/params.file.fs;
T = yFreq .* a';

theSin = yAmp .* sin(2 * pi * T + yPhase);

theSin = theSin/max(abs(theSin));

plot(theSin);
sound(theSin, params.file.fs);

%-cubicspline

who = 0;