function out = q3_2_3_findInd(in)
    out = length(in) - find(flip(in),1) + 1;
end