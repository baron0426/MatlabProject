function out = zigzag(n)
mat_size = n^2;
col_seq = zeros(1,mat_size);
last = 1;
for k = 2:2:n
    temp = makePalindromeSequence(k);
    last_next = last+length(temp);
    col_seq(last:last_next-1) = temp;
    last = last_next;
end
if(mod(n,2)==1)
    temp = 1:1:n;
    last_next = last+length(temp);
    col_seq(last:last_next-1) = temp;
    last = last_next;    
end
for k = 2:1:n
    temp = k:1:n;
    if(mod(k,2) + mod(n,2) == 1)
        temp = flip(temp);
    end
    last_next = last+length(temp);
    col_seq(last:last_next-1) = temp;
    last = last_next;
end
row_seq = zeros(1,mat_size);
last = 1;
for k = 1:2:n
    temp = makePalindromeSequence(k);
    last_next = last+length(temp);
    row_seq(last:last_next-1) = temp;
    last = last_next;
end
if(mod(n,2)==0)
    temp = 1:1:n;
    last_next = last+length(temp);
    row_seq(last:last_next-1) = temp;
    last = last_next;    
end
for k = 2:1:n
    temp = k:1:n;
    if(mod(k,2) + mod(n,2) ~= 1)
        temp = flip(temp);
    end
    last_next = last+length(temp);
    row_seq(last:last_next-1) = temp;
    last = last_next;
end
out = {col_seq, row_seq};
end


function out = makePalindromeSequence(n)
    t1 = 1:1:n;
    t2 = flip(t1);
    t2(1) = [];
    out = [t1, t2];
end