function limits=tm_aves(stest,th)
% TM_AVES: Detects bird vocalazation in field recordings using
% a template matching approach.
%   INPUTS:
%       signal  - sound signal sampled at 44.1kHz and 16bits
%       th      - threshold value. Must be between 0 and 1.
%    
%   OUTPUTS:
%      [limits] - A vector with time limits were vocalazation are
%      present.
%
% Copyright Juan Sebastian Ulloa 2012 (lisofomia@gmail.com)

% Check threshold value and set default
if nargin < 2 || isempty(th)
    th = 0.7;
elseif ~isnumeric(th) || ~isreal(th)
    sel = (max(x0)-min(x0))/4;
    warning('TM_AVES:InvalidSel',...
        'The threshold must be a real scalar.  A threshold of 0.7 will be used')
elseif numel(th) > 1
    warning('TM_AVES:InvalidSel',...
        'The threshold must be a scalar.  The first threshold value in the vector will be used.')
    sel = sel(1);
end

% ------ Load audio signals ------- %
fs=44100;
w_size=512;
noverlap=256;
nfft=512;
fs_frame =floor((fs-w_size)/(w_size-noverlap)) + 1;


% -- Load Template signal -- 
% Load wav file
file_wav_find='Acropternis_orthonyx_10880-903';
[sfind]=wavread(file_wav_find); % load signal
nfreq=nfft/2+1;
ntemp=round(length(sfind)/fs*fs_frame);

% Get images
i_find=sonograma_manual2(sfind,w_size,noverlap,nfft,fs); % i_find = handle graphic object for s_find sonogram
A_template= getimage(i_find);
A_template= scaledata(A_template,1,256);
A_template=A_template(10:50,:);


% --- Load search image ----
figure;
i_test=sonograma_manual2(stest,w_size,noverlap,nfft,fs);
A_test= getimage(i_test);
A_test= scaledata(A_test,1,256);
A_test=A_test(10:50,:);

% ----- Cross-Correlation ----- %
cc = normxcorr2(A_template,A_test); %257 en ypeak
t=1:size(A_test,2);t=t/fs_frame;
[max_cc, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
xcros=scaledata(cc(41,:),0,1);
%figure; surf(cc); shading flat; xlabel('Frames');zlabel('Detection score');ylabel('Frecuency')

% Find peaks and compare. Save the best ones
[xp1 yp1] =peakfinder(xcros,0.1,th);

%----- Create output -------%
y_aux=[xp1' yp1' ones(length(xp1),1)*size(A_template,2)];
y_aux(:,1)=y_aux(:,1)-size(A_template,2);
y_final=zeros(length(A_test),1);
for i=1:size(y_aux,1)
   y_final(y_aux(i,1):y_aux(i,1)+y_aux(i,3))=y_aux(i,2);  
   
end

limits=[];
for i=1:size(y_aux,1)
    limits=[limits; y_aux(i,1),y_aux(i,1)+y_aux(i,3)];
end
limits=limits/(size(A_test,2)*fs/size(stest,1)); % translate results to time


figure;
subplot(2,1,1); plot(xcros)
subplot(2,1,2); plot(y_final)