function out = zigzag(n)
mat_size = n^2;
col_seq = zeros(1,mat_size);
row_seq = zeros(1,mat_size);
last_col = 1;
last_row = 1;
for k = 1:1:n
    temp = makePalindromeSequence(k);
    if(mod(k,2)==0)
        last_col_next = last_col+length(temp);
        col_seq(last_col:last_col_next-1) = temp;
        last_col = last_col_next;
    else
        last_row_next = last_row+length(temp);
        row_seq(last_row:last_row_next-1) = temp;
        last_row = last_row_next;  
    end
end
temp = 1:1:n;
if(mod(n,2)==1)
    last_col_next = last_col+length(temp);
    col_seq(last_col:last_col_next-1) = temp;
    last_col = last_col_next;
else
    last_row_next = last_row+length(temp);
    row_seq(last_row:last_row_next-1) = temp;
    last_row = last_row_next;
end
for k = 2:1:n
    temp = k:1:n;
    last_col_next = last_col+length(temp);
    last_row_next = last_row+length(temp);
    if(mod(k,2) + mod(n,2) == 1)
        col_seq(last_col:last_col_next-1) = flip(temp);
        row_seq(last_row:last_row_next-1) = temp;
    else
        col_seq(last_col:last_col_next-1) = temp;
        row_seq(last_row:last_row_next-1) = flip(temp);
    end
    last_col = last_col_next;
    last_row = last_row_next;
end
out = sub2ind([n,n],row_seq,col_seq);
end


function out = makePalindromeSequence(n)
    t1 = 1:1:n;
    t2 = flip(t1);
    t2(1) = [];
    out = [t1, t2];
end