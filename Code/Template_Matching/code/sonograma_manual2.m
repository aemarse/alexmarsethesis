%[B,f,t] = specgram(x,nfft,fs,window,overlap)
 
% nfft      = fourier transform, use this to control the
%           number of frequency samples on the vertical axis of the
%           spectrogram
% fs        = sampling rate of the input signal window    = is the number
%           of input samples per vertical slice, use this to
%           control the analysis bandwidth;
% overlap   = number of samples by which adjacent windows overlap, use this
%           to control the number of vertical slices per second. 
% output B  =  table
% of complex amplitudes; f is a vector of frequency values used to label
% the rows, and t is a vector of time values used to label the columns.

function im = sonograma_manual2(signal,w_size,noverlap,nfft,fs)
%[B,f,t]=specgram(signal,1024,fs,256,192);
%[B,f,t]=specgram(signal,1024,fs,512,2); % la que funciona con template matching

F=1:400;
%[B,f,t]=spectrogram(signal,512,2,1024,fs); % la que funciona con template matching
% (X,WINDOW,NOVERLAP,NFFT,Fs)
[B,f,t]=spectrogram(signal,w_size,noverlap,nfft,fs);


%-----------------------
% calculate amplitude 50dB down from maximum
bmin=max(max(abs(B)))/3000; %  Calcula un minimo, se puede variar moviendo el 300.
%subplot(2,1,1);
t1=1:size(signal);t1=t1/fs;
plot(t1,signal);
axis ([0 20 -0.2 0.2]);
xlabel('Tiempo (s)');
ylabel('Amplitud (dB)');

%subplot(5,1,1);
% plot top 50dB as image
im=imagesc(20*log10(max(abs(B),bmin)/bmin)); % traza un threshold con bmin y saca log para tener valores en dB.

%im=imagesc(t,f,20*log10(abs(B))); % el log para sacar decibeles.


%
% label plot
axis xy;
xlabel('Tiempo (s)');
ylabel('Frequencia (Hz)');
%
% build and use a grey scale
lgrays=zeros(100,3);
for i=1:100
    lgrays(i,:) = 1-i/100;
end
colormap(lgrays);