function envFinal = envelopeGenerator(signalAmp, signalTime, index, row, maxAmp, samples, fs, interpType)

% envFinal = envelopeGenerator(signalAmp, signalTime, index, row, maxAmp, samples, fs, interpType)
%
% signalAmp		: amplitude array
% signalTime	: time array
% maxTime		: time is in milliseconds
% fs				: sampling rate
% row				: freq/ampiltude components
% index			: last element index of signal
% maxAmp			: maxAmp in all components if ampEnv
% samples		: number of samples (duration)
% fs				: sampling rate
% interpType	: 0: linear, 1:cube spline
%
% Tae Hong Park
% Music Department
% Princeton University
%
% park@silvertone.princeton.edu
%

envFinal = zeros(1,samples);	

xA = signalTime(row, 1:index(row));
yA = signalAmp(row, 1:index(row));

xxA = [0:signalTime(row, index(row))/(fs*(signalTime(row, index(row))/1000)):signalTime(row, index(row))];

%xA
%yA
if interpType == 1
	env = spline(xA, yA, xxA);	% xA is 
else
	env = interp1(xA, yA, xxA);
end

for i=1:length(env)
	envFinal(i) = env(i)/maxAmp;						% fill bed of zeros with data	
end

% supress all NaNs, this happens during interpolation sometimes
envFinal(isnan(envFinal)) = 0;

plot(xA, yA, 'o', xxA, env), grid on, hold on;
zoom on;
