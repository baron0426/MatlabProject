% 2.4
clear all, close all, clc;
load('hall.mat');
hall_gray_matrix = hall_gray(1:120,1:120);
a = dct2(hall_gray_matrix)';        % 转置
b = rot90(a');                      % 旋转90度
c = rot90(b);                       % 旋转180度
hall_gray_1 = uint8(idct2(a));
hall_gray_2 = uint8(idct2(b));
hall_gray_3 = uint8(idct2(c));
figure;
subplot(2,2,1);
imshow(hall_gray_matrix);
title('Unmodified');
subplot(2,2,2);
imshow(hall_gray_1);
title('Transpose');
subplot(2,2,3);
imshow(hall_gray_2);
title('Rotation 90');
subplot(2,2,4);
imshow(hall_gray_3);
title('Rotation 180');
