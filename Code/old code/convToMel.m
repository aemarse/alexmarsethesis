function [ mel ] = convToMel( hertz )

    mel = 1127*log(1+hertz/700);

end

