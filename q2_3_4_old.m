clear all;
load 'hall.mat';
pic_size = size(hall_gray);
%assure that the length and height of the picture are of the multiples of 8
x_left = 8 - mod(pic_size(1),8);
y_left = 8 - mod(pic_size(2),8);
if(x_left<8)
    hall_gray((pic_size(1)+1):(pic_size(1)+x_left),:) = repmat(hall_gray(pic_size(1),:,:),x_left,1);
end
if(y_left<8)
    hall_gray(:,(pic_size(2)+1):(pic_size(2)+y_left)) = repmat(hall_gray(:,pic_size(2),:),1, y_left);
end
pic_size = size(hall_gray);
blockCntRow = floor(pic_size(1)/8);
blockCntCol = floor(pic_size(2)/8);
hall_gray_partition = mat2cell(double(hall_gray),8*ones(1,blockCntRow),8*ones(1,blockCntCol));
subplot(3,3,1);
imshow(hall_gray,'InitialMagnification','fit');
title('Original');
hall_gray_partition_DCT = cell(blockCntRow,blockCntCol);
hall_gray_partition_proc1 = cell(blockCntRow,blockCntCol);
hall_gray_partition_proc2 = cell(blockCntRow,blockCntCol);
hall_gray_partition_proc3 = cell(blockCntRow,blockCntCol);
hall_gray_partition_proc4 = cell(blockCntRow,blockCntCol);
hall_gray_partition_proc5 = cell(blockCntRow,blockCntCol);
N = 8;
n = 0 : 1: N-1;
DCT = sqrt(2/N)*diag([sqrt(1/2), ones(1,N-1)])*cos(n'*(2*n + 1)*pi/(2*N));
for k = 1:1:blockCntRow
    for m  = 1:1:blockCntCol
        hall_gray_partition_DCT{k,m} = DCT*hall_gray_partition{k,m}*DCT';
        hall_gray_partition_proc1{k,m} = hall_gray_partition_DCT{k,m};
        hall_gray_partition_proc1{k,m}(:,5:8) = 0;
        hall_gray_partition_proc2{k,m} = hall_gray_partition_DCT{k,m};
        hall_gray_partition_proc2{k,m}(:,1:4) = 0;
        hall_gray_partition_proc3{k,m} = hall_gray_partition_DCT{k,m}';
        hall_gray_partition_proc4{k,m} = rot90(hall_gray_partition_DCT{k,m});
        hall_gray_partition_proc5{k,m} = rot90(hall_gray_partition_DCT{k,m}, 2);
    end
end
hall_gray_partition_1 = cell(blockCntRow,blockCntCol);
hall_gray_partition_2 = cell(blockCntRow,blockCntCol);
hall_gray_partition_3 = cell(blockCntRow,blockCntCol);
hall_gray_partition_4 = cell(blockCntRow,blockCntCol);
hall_gray_partition_5 = cell(blockCntRow,blockCntCol);
for k = 1:1:blockCntRow
    for m  = 1:1:blockCntCol
        hall_gray_partition_1{k,m} = DCT'*hall_gray_partition_proc1{k,m}*DCT;
        hall_gray_partition_2{k,m} = DCT'*hall_gray_partition_proc2{k,m}*DCT;
        hall_gray_partition_3{k,m} = DCT'*hall_gray_partition_proc3{k,m}*DCT;
        hall_gray_partition_4{k,m} = DCT'*hall_gray_partition_proc4{k,m}*DCT;
        hall_gray_partition_5{k,m} = DCT'*hall_gray_partition_proc5{k,m}*DCT;
    end
end
subplot(3,3,2);
imshow(uint8(cell2mat(hall_gray_partition_1)),'InitialMagnification','fit');
title('LAST 4 Col = 0');
subplot(3,3,3);
imshow(uint8(cell2mat(hall_gray_partition_2)),'InitialMagnification','fit');
title('FIRST 4 Col = 0');
subplot(3,3,4);
imshow(uint8(cell2mat(hall_gray_partition_3)),'InitialMagnification','fit');
title('先轉置再拼合');
subplot(3,3,5);
imshow(uint8(cell2mat(hall_gray_partition_4)),'InitialMagnification','fit');
title('先轉90度再拼合');
subplot(3,3,6);
imshow(uint8(cell2mat(hall_gray_partition_5)),'InitialMagnification','fit');
title('先轉180度再拼合');

hall_gray_partition_DCT = cell2mat(hall_gray_partition_DCT);
hall_gray_partition_proc6 = hall_gray_partition_DCT';
hall_gray_partition_proc7 = rot90(hall_gray_partition_DCT);
hall_gray_partition_proc8 = rot90(hall_gray_partition_DCT,2);
hall_gray_partition_proc6 = mat2cell(hall_gray_partition_proc6,8*ones(1,blockCntCol),8*ones(1,blockCntRow));
hall_gray_partition_proc7 = mat2cell(hall_gray_partition_proc7,8*ones(1,blockCntCol),8*ones(1,blockCntRow));
hall_gray_partition_proc8 = mat2cell(hall_gray_partition_proc8,8*ones(1,blockCntRow),8*ones(1,blockCntCol));
hall_gray_partition_6 = cell(blockCntCol,blockCntRow);
hall_gray_partition_7 = cell(blockCntCol,blockCntRow);
hall_gray_partition_8 = cell(blockCntRow,blockCntCol);
for k = 1:1:blockCntRow
    for m  = 1:1:blockCntCol
        hall_gray_partition_6{m,k} = DCT'*hall_gray_partition_proc6{m,k}*DCT;
        hall_gray_partition_7{m,k} = DCT'*hall_gray_partition_proc7{m,k}*DCT;
        hall_gray_partition_8{k,m} = DCT'*hall_gray_partition_proc8{k,m}*DCT;
    end
end
subplot(3,3,7);
imshow(uint8(cell2mat(hall_gray_partition_6)),'InitialMagnification','fit');
title('先拼合再轉置');
subplot(3,3,8);
imshow(uint8(cell2mat(hall_gray_partition_7)),'InitialMagnification','fit');
title('先拼合再轉90度');
subplot(3,3,9);
imshow(uint8(cell2mat(hall_gray_partition_8)),'InitialMagnification','fit');
title('先拼合再轉180度');
