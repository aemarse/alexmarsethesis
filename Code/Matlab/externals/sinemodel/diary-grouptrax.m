
% read one of the waveforms (monophonic, to make it easy)
[d,sr] = wavread('~/Desktop/mirexvalid/bassoon_var5a.wav');
% resample to 8 kHz
d = resample(d(:,1),80,441);
sr = 8000;
% take spectrogram - 512 pt window = 64 ms (for good freq resolution), 8 ms (64 point) hop for smooth evolution
D = specgram(d,512,sr,512,448);
tt = [1:size(D,2)]*64/sr;  % actual times of each column
ff = [0:256]*sr/512;  % actual Hz of each row
% Extract tracks
[trax,mags] = extractrax(abs(D));
% Convert the trax return into Hz
F = (trax)*sr/512;  
% Build groups of tracks by common onset
[gps,exts] = grouptrax(trax,mags);
% Plot them on top of the spectrogram (just first 50 groups and first 500 tracks in this case)
plotgroups(F(1:500,:),gps(1:50,1:500),abs(D),'c',tt,ff)
% Resynthesize all the tracks in every 4th group
txs = find(sum(gps(1:4:50,1:500)));  % each row of gps is a boolean indicating which tracks are involved
x = synthtrax(F(txs,:),mags(txs,:),sr,64,15);
soundsc(x,sr);  % Sounds quite good!
