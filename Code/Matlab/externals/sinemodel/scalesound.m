function y = scalesound(d,r,timescale)
% y = scalesound(d,r,f)
%    Scale a sound x (sampling rate r) by an arbitrary timescale
%    factor f (>1 = make it last longer) using sinusoid + noise
%    decomposition. 
%     Based on the example of Talal Bin Amin
% 2011-09-27 Dan Ellis dpwe@ee.columbia.edu

%[d,r] = wavread('in_1_1.wav');

% Use a window that is at least 32ms, but also a power of 2
winlen = 2^ceil(log(r*.032)/log(2));

% Use factor-of-4 overlap in analysis windows for better phase
% continuity 
ifsubfact = 4;
% Calculate tracks, including phase information
[I,S]=ifgram(d,winlen,winlen,winlen/ifsubfact,r);
[R,M]=extractrax(abs(S));
F = colinterpvals(R,I);
P = -colinterpvals(R,unwrap(angle(S)));
[row1,col1]=size(F);
F = [0*F(:,1),F,0*F(:,col1)];
M = [0*M(:,1),M,0*M(:,col1)];  
P = [0*P(:,1),P,0*P(:,col1)];
% Resynthesize patching actual STFT phase at each bin
drp = synthphtrax(F,M,P,r,winlen,winlen/ifsubfact);
% sound(drp,r)
% Calculate residual as difference between original signal and
% phase-synchronized sinusoid reconstruction
minlen = min(length(d),length(drp));
dre = d([1:minlen]) - drp(1:minlen)';
% specgram(dre,256,r);
% colormap(1-gray)
% caxis([-60 0]) 
% sound(dre,r)

%% Modified resynthesis

% make analysis and sythesis hops different to effect time scaling
% in lpc.  But make sure they're still even integers.
if timescale > 1
  synthhop = winlen/2;
  hop = 2*round(synthhop/timescale/2);
else
  hop = winlen/2;
  synthhop = 2*round(hop*timescale/2);
end
[a,g,e] = lpcfit(dre, 12, winlen, hop);
drn2 = lpcsynth(a, g, [], winlen, synthhop);
drs2 = synthtrax(F,M,r,winlen,round(winlen/ifsubfact*timescale));
minlen = min(length(drn2),length(drs2));
% Add together time-stretched noise and sinusoid parts to get output
y = drs2(1:minlen)+drn2(1:minlen);
% Illustrate results
subplot(211)
specgram(d,winlen,r);
title('Original');
c = caxis();
caxis([-60 0]+max(c))
subplot(212)
specgram(y,winlen,r)
caxis([-60 10]+max(c))
title(['Resynthesis, timescaled by ',num2str(timescale),', including noise residual'])
colormap(1-gray)
%sound(dx2,r)


