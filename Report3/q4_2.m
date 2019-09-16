clear all;
close all;
clc;
load('q4_1_v.mat');
pic = imread('Faces/people8.jpg');
N = 16;
pic_size = size(pic);
x_left = N - mod(pic_size(1),N);
y_left = N - mod(pic_size(2),N);
if(x_left<N)
    pic((pic_size(1)+1):(pic_size(1)+x_left),:,:) = repmat(pic(pic_size(1),:,:),x_left,1,1);
end
if(y_left<N)
    pic(:,(pic_size(2)+1):(pic_size(2)+y_left),:) = repmat(pic(:,pic_size(2),:),1, y_left,1);
end
pic_size = size(pic);
blockCntRow = floor(pic_size(1)/N);
blockCntCol = floor(pic_size(2)/N);
pic = mat2cell(pic, N*ones(1,blockCntRow), N*ones(1,blockCntCol), 3);
L_cell = mat2cell(L*ones(blockCntRow, blockCntCol),ones(1,blockCntRow),ones(1,blockCntCol));
v_cell = mat2cell(repmat(v, blockCntRow, blockCntCol),length(v)*ones(1,blockCntRow),ones(1,blockCntCol));
N_cell = mat2cell(N*ones(blockCntRow, blockCntCol),ones(1,blockCntRow),ones(1,blockCntCol));
result = cellfun(@generateColorVec, pic, L_cell, 'UniformOutput', false);
result2 = cellfun(@colorDist, result, v_cell, 'UniformOutput', false);
result2 = cell2mat(result2);
result3 = zeros(blockCntRow, blockCntCol);
result3(result2 <= 0.6) = 1;
result3 = medfilt2(result3);
result3 = mat2cell(result3, ones(1,blockCntRow), ones(1,blockCntCol));
result4 = cellfun(@recovery8, result3, N_cell, 'UniformOutput', false);
result4 = cell2mat(result4);
pic = cell2mat(pic);
% picR = pic(:,:,1);
% picR(result4 == 1) =255;
% pic(:,:,1) = picR;
imshow(pic,'InitialMagnification','fit');
B= bwboundaries(result4,8, 'noholes');
hold on;
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
end
hold off;