error = [];
for k = 1:1:length(AC_code)
len = length(AC_code{k});
if(~isequal(AC_code{k}(len-3:len), [1,0,1,0]))
error = [error k];
end
end