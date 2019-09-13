% 2.8
%clear all, close all, clc;
load('hall.mat');
load('JpegCoeff.mat');
[N,M] = size(hall_gray);
n = 1;
a = zeros(64,N*M/64);         % 预先申请量化后系数矩阵的空间
for i = 1:8:N-7
    for j = 1:8:M-7
        part = hall_gray(i:i+7,j:j+7);      % 分块
        c = dct2(part-128);                 % DCT，且记住像素减去128
        c0 = round(c./QTAB);                % 量化
        a(:,n) = ZIGZAG(c0);                % Zig-Zag扫描
        n = n+1;
    end
end

        
        