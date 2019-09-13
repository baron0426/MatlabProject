% 1.2.(a)
clear all, close all, clc;
load('hall.mat');
hall_color_1 = im2double(hall_color);  % ��ǿ��ͼ��ת��Ϊ˫����ֵ
[x,y,z] = size(hall_color_1);
new = ones(x,y);                       % ΪԲ��ռ�ľ���Ԥ���ռ�
r = 1/2 * min(x,y);
a = 0;
% ��Բ�������Ͻ���1����Ϊ��0��
for n = 1:1001
    new(floor(x/2-r*sin(a)+1), floor(y/2+r*cos(a)+1)) = 0;
    a = a + 2*pi/1000;
end
% ��Բ�������Ϊ����ɫ������ͬ��С����Ϊ���������п�����ż������Բʱ��Խ��
new_1 = new(1:x,1:y);     
% Ϳ�ɺ�ɫ
hall_color_modified(:,:,1) = hall_color_1(:,:,1).*new_1 + ~new_1;
hall_color_modified(:,:,2) = hall_color_1(:,:,2).*new_1;
hall_color_modified(:,:,3) = hall_color_1(:,:,3).*new_1;
imwrite(hall_color_modified,'hall_color_modified.jpg','JPEG');