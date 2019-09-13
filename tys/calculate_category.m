% 2.6
function category = calculate_category(c)
if c == 0
    category = 0;
else
    category = floor(log2(abs(c)))+1;
end
end


