% Test algorithm tm_aves

clear all;
close all;
clc;

file_wav_test='test_aves'; 


[signal,fs,nbits]=wavread(file_wav_test); % 
limits_tm=tm_aves(signal,0.5); % Get limits with Template matching algorithm

% Write audio segments. 

%segment_audio(limits_tm,file_wav_test,'tm') %If uncommented, it creates audio files for every
% detected vocalazation.