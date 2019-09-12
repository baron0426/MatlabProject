function out = getDCCategory(n)
    if(n == 0)
        out = 0;
    else
        out = floor(log2(abs(n)))+1;
    end
end