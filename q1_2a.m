clear all;
close all;
clc;
load 'hall.mat';
pic_size = size(hall_color);
%assure that the length and height of the picture are of the multiples of 8
x_left = 8 - mod(pic_size(1),8);
y_left = 8 - mod(pic_size(2),8);
if(x_left<8)
    hall_color((pic_size(1)+1):(pic_size(1)+x_left),:,:) = repmat(hall_color(pic_size(1),:,:),x_left,1,1);
end
if(y_left<8)
    hall_color(:,(pic_size(2)+1):(pic_size(2)+y_left),:) = repmat(hall_color(:,pic_size(2),:),1, y_left,1);
end
%determine the parameter of the circle
xc = floor(pic_size(1)/2);
yc = floor(pic_size(2)/2);
r = floor(min(pic_size(1:2))/2);

%generate the relevent index according to the parameter
R = r-0.5:0.01:r;
theta = 0:0.01:2*pi;
X = xc + R'*cos(theta);
Y = yc + R'*sin(theta);
X = floor(X);
Y = floor(Y);
X(X==0) = 1;
Y(Y==0) = 1;
linearInd = sub2ind(pic_size(1:2),X,Y);
%generate the red circle
hall_procR = hall_color(:,:,1);
hall_procG = hall_color(:,:,2);
hall_procB = hall_color(:,:,3);
%cover the red circle on the original picture
hall_procR(linearInd)=255;
hall_procG(linearInd) = 0;
hall_procB(linearInd) = 0;
hall_proc = zeros(pic_size);
hall_proc = uint8(hall_proc);
hall_proc(:,:,1)=hall_procR;
hall_proc(:,:,2) = hall_procG;
hall_proc(:,:,3) = hall_procB;
image(hall_proc);
imwrite(hall_proc, 'hall_withCircle.jpg');