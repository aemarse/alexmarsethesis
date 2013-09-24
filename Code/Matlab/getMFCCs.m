function [MFCCs] = getMFCCs(magSpec, params)

magSpec = magSpec(1:length(magSpec)/2+1);

%-Filter parameters
numFilts  = params.feat.numFilts;
numCoeff  = params.feat.numCoeff;
fftUnique = length(magSpec);
lowFreq   = params.feat.lowFreq;
highFreq  = params.feat.highFreq;
freqRange = [lowFreq highFreq];

minFreq = 0;
maxFreq = params.file.fs/2;

%-Freq stuff
linFreq    = linspace(minFreq,maxFreq,fftUnique);
melFreq    = convToMel(linFreq);
cutFreqsHz = convToHertz( convToMel(lowFreq)+[0:numFilts+1] * ...
    ((convToMel(highFreq) - convToMel(lowFreq))/(numFilts+1)));

%-Make the filter bank
filtBank = zeros(numFilts,fftUnique);

for i = 1:numFilts
    up = linFreq >= cutFreqsHz(i) & linFreq <= cutFreqsHz(i+1);

    filtBank(i,up) = (linFreq(up) - cutFreqsHz(i)) / ...
        (cutFreqsHz(i+1) - cutFreqsHz(i));

    down = linFreq >= cutFreqsHz(i+1) & linFreq <= cutFreqsHz(i+2);

    filtBank(i, down) = (cutFreqsHz(i+2) - linFreq(down)) ...
        / (cutFreqsHz(i+2) - cutFreqsHz(i+1));
end

%-Apply the filter bank to the magnitude spectrum
filtBank = filtBank * magSpec;

% Make the DCT matrix
DCT = sqrt(2.0/numFilts) * cos( repmat([0:numCoeff-1].',1,numFilts) ...
    .* repmat(pi*([1:numFilts]-0.5)/numFilts,numCoeff,1));

%-Get the cepstral coefficients
MFCCs = DCT * log10(filtBank);

%-Plot the MFCC matrix
% imagesc( [1:length(MFCCs)], [0:numCoeff-1], MFCCs );
% set(gca, 'YDir', 'normal');

end