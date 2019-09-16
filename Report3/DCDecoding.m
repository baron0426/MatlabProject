function DC_decode = DCDecoding(DC_code, blockCnt)
load('JpegCoeff.mat','DCTAB');
DC_decode = zeros(1, blockCnt);
last = 1;
max_sizecode_length = max(DCTAB(:,1));
code_length = length(DC_code);
m = 1;
while(last<=code_length)
    for k = 2:1:max_sizecode_length
        query = find(~any((~(DCTAB(:,2:1+k) == DC_code(last:last+k-1))), 2));
        if(length(query) == 1)
            sizee = query - 1;
            last = last+k;
            break;
        end
    end
    if(sizee ~= 0)
        last_next = last + sizee;
        if(DC_code(last))
            magnitude = bi2de(flip(DC_code(last:last_next-1)));
        else
            magnitude = -1 * bi2de(flip(~(DC_code(last:last_next-1))));
        end
        last = last_next;
    DC_decode(m) = magnitude;
    else
        DC_decode(m) = 0;
    end
    m = m +1;
end
%DC_decode = filter(-1, [1,-1],DC_decode,2*DC_decode(1));
end