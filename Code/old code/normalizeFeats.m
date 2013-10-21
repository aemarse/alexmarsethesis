function [RMS, ZCR] = normalizeFeats(RMS, ZCR)
    
RMS = RMS/max(RMS);
ZCR = ZCR/max(ZCR);

end