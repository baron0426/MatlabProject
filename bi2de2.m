function out = bi2de(in)
    p = 0:1:(length(in)-1);
    p = 2.^p;
    out = p*in';
end