function signal = addSyn(filename, interType, fs, timeScale, freqScale)
 
% signal = addSyn(filename, interType, fs, timeScale, freqScale)
%
% ADDITIVE SYNTHESIS TOY
% Uses additive synthesis method to generate a complex waveform.  It reads text based data 
% set consiting of amplitude and frequency paramters. The envelopes are interpolated either by
% linear or cubic spline interpolation to render smooth transitions.
%
% filename  :  filename with "score"	
% interType :  interpolation type [interp for amp. env., interp for freq. env.]
%              0 ->linear interpolation
%              1 -> cubic spline interpolation
% fs        :  sampling freq
% timeScale :  scalar multiplier to duration of each frequency's and amp's time parameters. 
%              i.e timeScale = 2 means twice the length for evolution of sound
% freqScale :  scalar multiplier to frequency's "Hz parameter". 
%              i.e freqScale = 2 means octave shift 
%
%
% File format (text) should adhere to the following rules and syntax.
% - Frequency is in Hz and time is in milliseconds. 
% - Each new line starts at the very left margin.
% - There should be only ONE character space between parapmeters.
% - Each line has to end with a carrige return.
%
% ampTime11   amp11   ampTime12  amp12  ...   ampTime1C
% freqTime21  freq21  freqTime22 freq22 ...	 ... 
% ...                                         ...
% ampTime1R   ... ...                         ampTimeRC		
% freqTime1R  ... ...                         freqTimeRC		
%
%
% example parameters, save as trumpetData.txt
%
% eg. signal = addSyn('trumpetData.txt', [1, 0], 10000, 1, 1); 
%
% 1 0 20 305 36 338 141 288 237 80 360 0
% 1 321 16 324 32 312 109 310 317 314 360 310
% 3 0 25 317 39 361 123 295 222 40 326 0
% 2 0 3 607 16 657 24 621 133 621 275 628 326 628 327 0
% 2 0 19 100 34 369 111 342 207 41 273 0
% 2 977 5 782 15 987 24 932 128 932 217 936 273 945 275 0
% 1 0 3 0 24 113 29 257 118 231 187 35 235 0
% 1 0 2 0 3 718 16 1335 24 1243 108 1240 199 1248 235 1248 236 0
% 1 0 27 52 34 130 110 126 191 13 234 0
% 1 1225 9 1569 12 1269 21 1573 37 1553 97 1552 181 1556 234 1566 235 0
% 1 0 46 83 64 100 100 100 189 11 221 0
% 1 1483 12 1572 23 1988 33 1864 114 1864 177 1868 221 1879 222 0
% 1 0 37 39 45 77 110 79 176 11 205 0 207 0
% 1 1792 9 1612 29 2242 36 2176 126 2170 205 2188 207 0
% 2 0 28 17 43 71 109 66 172 8 201 0
% 2 1590 29 2539 36 2491 114 2481 153 2489 201 2491 203 0
% 2 0 29 16 43 53 54 66 105 64 165 7 191 0
% 2 1993 25 2121 32 2821 37 2796 84 2798 105 2792 191 2797 192 0
% 1 0 27 6 41 25 56 29 72 22 95 24 180 0
% 1 1742 12 1849 32 3131 37 3111 114 3103 164 3116 180 3116 181 0
% 2 0 37 6 55 25 88 29 114 28 164 3 186 0
% 2 1398 41 3419 42 3419 91 3419 106 3406 150 3421 186 3421 187 0
% 7 0 39 3 43 8 88 11 118 9 138 3 165 0
% 6 0 7 1806 23 2942 36 2759 37 3746 50 3723 84 3731 110 3721 156 3741 165 3620 167 0
%
% Tae Hong Park
% Music Department
% Princeton University
%
% park@silvertone.princeton.edu
%  

% -----------------------------------------------------------------------------------------------
% read data from file
% -----------------------------------------------------------------------------------------------

data = readData(filename);
[row, col] = size(data);

[amp ampTime freq freqTime maxAmp maxTime] = sortData(filename, data, row, col);

% -----------------------------------------------------------------------------------------------
% Scale time and frequency according to user input
% -----------------------------------------------------------------------------------------------

ampTime  = ampTime*timeScale;
freqTime = freqTime*timeScale;
maxTime  = maxTime*timeScale;
freq     = freq*freqScale;

% -----------------------------------------------------------------------------------------------
% find index up until non-zero values in time axis
% -----------------------------------------------------------------------------------------------
for i=1:row/2
	indexAmp(i) 	= indexFinder(ampTime, i);
	indexFreq(i) 	= indexFinder(freqTime, i);
end

% -----------------------------------------------------------------------------------------------
% make complex signal changing over time
% -----------------------------------------------------------------------------------------------
samples = fs*(maxTime/1000)+1;			% total time
signal	= zeros(1, samples);

ampEnvPlot 	= 0;
freqEnvPlot = 0;

for numOfSig=1:row/2
	figure(1), title('Amplitude Envelope')									
	ampEnv 		= envelopeGenerator(amp, ampTime, indexAmp, numOfSig, maxAmp, samples, fs, interType(1));
	ampEnvPlot 	= ampEnvPlot + ampEnv;
	
	figure(2), title('Frequency Envelope')
	freqEnv 	= envelopeGenerator(freq, freqTime, indexFreq, numOfSig, 1, samples, fs, interType(2));
	freqEnvPlot = freqEnvPlot + freqEnv;
	
   signal = makeSignal(ampEnv, freqEnv, signal, fs, row/2);
end


% normalize signal and spit it out
signal = signal/max(signal);
sound(signal, fs);

