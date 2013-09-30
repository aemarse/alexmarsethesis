function [amp, ampTime, freq, freqTime, maxAmp, maxTime] = sortData(filename, data, row, col)
% function [amp, ampTime, freq, freqTime, maxAmp, maxTime] = sortData(filename, data, row, col)
%
% Used in conjunction with readData.m
% It reads sinewave data parameters and sorts them into time, amplitude and frequency arrays
% for processing.
%
%
% Tae Hong Park
% Music Department
% Princeton University
%
% park@silvertone.princeton.edu

% --------------------------------------------------
% ampltude stuff, even rows are amps 
% time0 amp0, time1 amp1,  ...
% --------------------------------------------------
% get amp arrays t+amp
for i=1:row/2
	for j=1:col
		ampTemp(i,j) = data(2*i-1,j);
	end
end

% divide into time and amp arrays
for k=1:row/2
	for j=1:col/2
		ampTime(k, j) 	= ampTemp(k,j*2-1);
		amp(k, j) 		= ampTemp(k,j*2);
	end
end

% --------------------------------------------------
% frequency stuff, odd rows are freqs
% --------------------------------------------------
% get freq arrays t+amp
for i=1:row/2
	for j=1:col
		freqTemp(i,j) = data(2*i,j);
	end
end


% divide into time and freq array
for k=1:row/2
	for j=1:col/2
		freqTime(k, j) 	= freqTemp(k,j*2-1);
		freq(k, j) 			= freqTemp(k,j*2);	
	end
end

% ------------------------------------------------------
% find max amplitude and maximum time for normalization
% ------------------------------------------------------
for i=1:row/2
   temp(i) = max(amp(i,:));
	temp1(i) = max(ampTime(i,:));
	temp2(i) = max(freqTime(i,:));   
end

maxAmp 	= max(temp);				% maximum amplitude

maxTime1 = max(temp1);				% maximum duration
maxTime2 = max(temp2);

if maxTime1 > maxTime2
	maxTime = maxTime1;
else
	maxTime = maxTime2;
end