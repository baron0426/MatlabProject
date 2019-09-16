function out = ACCoding(in)
load('JpegCoeff.mat', 'ACTAB');
in_len = length(in);
out = false(1,60*in_len);
last = 1;
run = 0;
for n = 1:1:in_len
    if(in(n:in_len) == 0)
        last_next = last + 4;
        out(last:last_next-1) = logical([1,0,1,0]);
        last = last_next;
        break;
    end
    if(in(n) == 0)
        run = run + 1;
        if(run == 16)
            last_next = last + 11;
            out(last:last_next-1) = logical([1,1,1,1,1,1,1,1,0,0,1]);
            last = last_next;
            run = 0;
        end
    else
        sizee = getDCCategory(in(n));
        code_length = ACTAB(10*run+sizee,3);
        last_next = last + code_length;
        out(last:last_next-1) = logical(ACTAB(10*run+sizee,4:3+code_length));
        last = last_next;
        magnitude_bin = dec2bin(abs(in(n)));
        if(in(n)>=0)
            magnitude_bin = (magnitude_bin=='1');
        else
            magnitude_bin = (magnitude_bin=='0');
        end
        last_next = last + sizee;
        out(last:last_next-1) = magnitude_bin;
        last = last_next;
        run = 0;
        if(n == in_len)
            last_next = last + 4;
            out(last:last_next-1) =  logical([1,0,1,0]);
            last = last_next;
        end
    end
end
out = out(1:last_next-1);
end