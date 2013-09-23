function [MFCCs] = getMFCCs(magSpec, fs)

magSpec = magSpec(1:length(magSpec)/2+1);

%-Filter parameters
numFilts  = 20;
numCoeff  = 13;
fftUnique = length(magSpec);
lowFreq   = 800;
highFreq  = 10000;
freqRange = [lowFreq highFreq];

minFreq = 0;
maxFreq = fs/2;

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

%-Apply the filter bank
filtBank = filtBank * magSpec;

% Type III DCT matrix routine (see Eq. (5.14) on p.77 of [1])
DCT = sqrt(2.0/numFilts) * cos( repmat([0:numCoeff-1].',1,numFilts) ...
    .* repmat(pi*([1:numFilts]-0.5)/numFilts,numCoeff,1));

%-Get the cepstral coefficients
% MFCCs = dct(log(filtBank));
MFCCs = DCT * log(filtBank);

end