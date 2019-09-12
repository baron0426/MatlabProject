clear all;
load 'hall.mat';
N = 8;
pic_size = size(hall_gray);
%assure that the length and height of the picture are of the multiples of 8
x_left = N - mod(pic_size(1),N);
y_left = N - mod(pic_size(2),N);
if(x_left<N)
    hall_gray((pic_size(1)+1):(pic_size(1)+x_left),:) = repmat(hall_gray(pic_size(1),:,:),x_left,1);
end
if(y_left<N)
    hall_gray(:,(pic_size(2)+1):(pic_size(2)+y_left)) = repmat(hall_gray(:,pic_size(2),:),1, y_left);
end
pic_size = size(hall_gray);
blockCntRow = floor(pic_size(1)/N);
blockCntCol = floor(pic_size(2)/N);
hall_gray_partition = mat2cell(double(hall_gray),N*ones(1,blockCntRow),N*ones(1,blockCntCol));
hall_gray_partition_DCT_zigzag = cellfun(@DCT8andZigzagScan, hall_gray_partition, 'UniformOutput', false);
final_result = cell2mat(reshape(hall_gray_partition_DCT_zigzag', 1,[]));