% 4.1.(b)
clear all, close all, clc;

L = 3;
u = zeros(1,2^(3*L));
v = zeros(1,2^(3*L));
for i = 1:33
    color = imread([num2str(i),'.bmp']);
    [N,M,P] = size(color);
    color_modified = floor(color/2^(8-L)); % 向右移（8-L）位
    cn = color_modified(:,:,1)*2^(2*L)+color_modified(:,:,2)*2^L+color_modified(:,:,3); % 拼接颜色
    for j = 1:N*M
        u(cn(j)+1) = u(cn(j)+1)+1;       % cn的数字直接累加在相应的位置上
    end
    u = u/N/M;
    v = v+u;
end
v = v/33;
save('train.mat','v','u','L');

