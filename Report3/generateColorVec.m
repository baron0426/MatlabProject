function out = generateColorVec(pic, L)
pic_R = pic(:,:,1);
pic_G = pic(:,:,2);
pic_B = pic(:,:,3);
color_type  = (2^(2*L))*floor(double(pic_R)./(2^(8-L))) +...
    (2^(L))*floor(double(pic_G)./(2^(8-L))) + floor(double(pic_B)./(2^(8-L)));
length_out = 2^(3*L);
out = zeros(length_out, 1);
for n = 0:1:length_out-1
    out(n+1) = sum(color_type(:)==n);
end
out = out ./sum(out);
end