% 1.2.(a)
clear all, close all, clc;
load('hall.mat');
hall_color_1 = im2double(hall_color);  % 将强度图像转换为双精度值
[x,y,z] = size(hall_color_1);
new = ones(x,y);                       % 为圆所占的矩阵预留空间
r = 1/2 * min(x,y);
a = 0;
% 在圆的坐标上将“1”改为“0”
for n = 1:1001
    new(floor(x/2-r*sin(a)+1), floor(y/2+r*cos(a)+1)) = 0;
    a = a + 2*pi/1000;
end
% 将圆矩阵调整为与颜色矩阵相同大小，因为矩阵坐标有可能是偶数，画圆时会越界
new_1 = new(1:x,1:y);     
% 涂成红色
hall_color_modified(:,:,1) = hall_color_1(:,:,1).*new_1 + ~new_1;
hall_color_modified(:,:,2) = hall_color_1(:,:,2).*new_1;
hall_color_modified(:,:,3) = hall_color_1(:,:,3).*new_1;
imwrite(hall_color_modified,'hall_color_modified.jpg','JPEG');