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
[Row, Col] = size(hall_gray);
hall_gray = num2cell(hall_gray);
%generate hide message
test_msg = 'I am Baron You.  I own the copyright.';
test_msg_out = dec2bin(test_msg);
test_msg_out = reshape(test_msg_out',1,[]);
test_msg_out = (test_msg_out == '1');
test_msg_out2 = false(1, Row*Col);
test_msg_out2(1:length(test_msg_out)) = test_msg_out;
test_msg_out2 = reshape(test_msg_out2, Row, Col);
test_msg_out2 = num2cell(test_msg_out2);
hall_gray_proc = cellfun(@q3_1_hide, hall_gray, test_msg_out2);
hall_gray = cell2mat(hall_gray);
subplot(1,2,1);
imshow(hall_gray,'InitialMagnification','fit');
title('Original')
subplot(1,2,2);
imshow(hall_gray_proc,'InitialMagnification','fit');
title('With Hided Message')


blockCntRow = floor(pic_size(1)/N);
blockCntCol = floor(pic_size(2)/N);
hall_gray_partition = mat2cell(double(hall_gray_proc),N*ones(1,blockCntRow),N*ones(1,blockCntCol));
hall_gray_partition_DCT_zigzag = cellfun(@DCT8andZigzagScan, hall_gray_partition, 'UniformOutput', false);
final_result = cell2mat(reshape(hall_gray_partition_DCT_zigzag', 1,[]));


%handle the DC component coding
DC = final_result(1,:);
DC_diff = filter([-1, 1], 1, DC, 2*DC(1));
DC_code = cellfun(@DCCoding, num2cell(DC_diff), 'UniformOutput', false);
DC_code = cell2mat(DC_code);

%handle the AC component coding
AC = final_result;
AC(1,:)= [];
[AC_rowCnt, AC_colCnt] = size(AC);
AC_code = cellfun(@ACCoding,mat2cell(AC,AC_rowCnt, ones(1,AC_colCnt)),'UniformOutput', false);
AC_code = cell2mat(AC_code);

%save result
[height, width] = size(hall_gray);
save('q3_1_jpegcodes.mat','height','width', 'DC_code','AC_code', 'hall_gray_proc');