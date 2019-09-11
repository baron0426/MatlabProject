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
%determine the size of the block
block_row = floor(pic_size(1)/8);
block_col = floor(pic_size(2)/8);
B = ones(block_row, block_col);

%generating the 'chessboard'
chessboard = [B, (1-B);(1-B), B];
chessboard = repmat(chessboard,4,4);

%generate the red circle
hall_procR = hall_color(:,:,1);
hall_procG = hall_color(:,:,2);
hall_procB = hall_color(:,:,3);
%cover the red circle on the original picture
hall_procR(chessboard == 1) = 0;
hall_procG(chessboard == 1) = 0;
hall_procB(chessboard == 1) = 0;
hall_proc = zeros(pic_size);
hall_proc = uint8(hall_proc);
hall_proc(:,:,1) = hall_procR;
hall_proc(:,:,2) = hall_procG;
hall_proc(:,:,3) = hall_procB;
image(hall_proc);