function [SC] = getSC(past, params)

num   = 0;
denom = 0;

for i = 1:length(past) - 1
    
    idx = i * params.file.fs/2;
    
    num   = num + (past(i)*idx);
    denom = num + past(i);
    
end

SC = num/denom;

end