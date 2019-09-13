% 2.1
clear all, close all, clc;
load('hall.mat');
part = hall_gray(1:10,1:10);   % 取一小块
a = dct2(part-128);            % 先减像素再变换
b = dct2(part)-dct2(ones(10,10)*128); % 在变换域中减像素
display(a - b);                % 计算二者误差
