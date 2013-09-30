function s = makeSignal(ampEnv, freqEnv, s, fs, atten)

% s = makeSignal(ampEnv, freqEnv, s, fs, atten)
% generate signal using amp and freq envelopes
%
% ampEnv	: 	amplitude envelop
% freqEnv	:	freq. envelope
% s			: 	the cumulative signal (use in loop)
% fs		: 	sampling freq
% atten		:   attenuate signal by number of harmonics	
%
%
% Tae Hong Park
% Music Department
% Princeton University
%
% park@silvertone.princeton.edu
%

ampEnv = ampEnv/atten;

phase = 0;
for i=1:length(ampEnv)-1
	f 	= freqEnv(i);
	amp = ampEnv(i);
	%s(i) = s(i) + amp*sin(((2*pi*f)/fs)*i);
    
    phase = phase + 2*pi*f/fs;
    s(i) = s(i) + amp*sin(phase);
end
