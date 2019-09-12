% 3.1.（1）
function hall_color_1 = HIDE_1(M)
load('hall.mat');

hall_color_1 = mod(hall_color(:,:,1),2);       % 取最低位
[P,W] = size(hall_color_1);
hide = zeros(P,W);
b = dec2bin(M)-'0';        % 将隐藏信息M转换为二进制矩阵
[p,q] = size(b);
a = zeros(p,7);
a(:,7-q+1:7) = b;          % 有的字符不足7位，补齐7位
a = a';                    
for k = 1:7*length(M)
    hide(k) = a(k);
end
for i = 1:P                % 填入隐藏信息
    for j = 1:W
        if hide(i,j) == 0
            hall_color_1(i,j) = 0;
        else
            hall_color_1(i,j) = 1;
        end
    end
end
hall_color_1 = hall_color_1+hall_color;        % 还原带有隐藏信息的矩阵

figure;
imshow(hall_color_1);
save('hide_1_half.mat','hall_color_1');
end
