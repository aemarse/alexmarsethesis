function segment_audio(limits,signal_name,seg_name)
% clear all;
% close all;
% clc;

% Read audio signal
[signal,fs,nbits]=wavread(signal_name);

% for all limit pairs
for i=1:size(limits,1)
    
    ini=round(fs*limits(i,1)); % begin segment
    fin=round(fs*limits(i,2)); % end segment
    wavname=strcat(seg_name,sprintf('%d',i)); 
    wavwrite(signal(ini:fin),fs,nbits,wavname); % write the file

end