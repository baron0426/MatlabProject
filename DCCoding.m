function out = DCCoding(n)
load('JpegCoeff.mat', 'DCTAB');
cat_num = getDCCategory(n);
cat_code_length = DCTAB(cat_num+1,1);
magnitude_bin = dec2bin(n);
magnitude_bin = (magnitude_bin=='1');
out = logical(zeros(1, cat_code_length+cat_num));
out(1:cat_code_length) = logical(DCTAB(cat_num+1, 2:1+cat_code_length));
out(cat_code_length+1:cat_code_length+cat_num) = magnitude_bin;
end