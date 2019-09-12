% 1.2.(b)
clear all, close all, clc;
load('hall.mat');
hall_color_1 = im2double(hall_color);
[x,y,z] = size(hall_color_1);
% 分成棋盘8*8的格子
x_1 = x/8;
y_1 = y/8;
black = zeros(x_1,y_1);
white = ones(x_1,y_1);
% 利用cat函数拼接黑白矩阵
new = cat(1,black,white);
new = cat(1,cat(1,new,new),cat(1,new,new));
new = cat(2,new,flipud(new));
new = cat(2,cat(2,new,new),cat(2,new,new));
% 将黑白矩阵与原彩色矩阵叠加
hall_color_BandW(:,:,1) = hall_color_1(:,:,1).*new;
hall_color_BandW(:,:,2) = hall_color_1(:,:,2).*new;
hall_color_BandW(:,:,3) = hall_color_1(:,:,3).*new;
imwrite(hall_color_BandW,'hall_color_BandW.jpg','JPEG');

