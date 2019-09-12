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
N = pic_size(1);
M = pic_size(2);
n = 0 : 1: (pic_size(1)-1);
m = 0 : 1: (pic_size(2)-1);
DCTN = sqrt(2/N)*diag([sqrt(1/2), ones(1,N-1)])*cos(n'*(2*n + 1)*pi/(2*N));
DCTM = sqrt(2/M)*diag([sqrt(1/2), ones(1,M-1)])*cos(m'*(2*m + 1)*pi/(2*M));
hall_gray_DCT = DCTN*double(hall_gray)*DCTM';
hall_gray_DCT_proc1 = hall_gray_DCT;
hall_gray_DCT_proc2 = hall_gray_DCT;
hall_gray_DCT_proc1(1:4) = 0;
hall_gray_DCT_proc2(M-3:M) = 0;
hall_gray_DCT_proc3 = hall_gray_DCT';
hall_gray_DCT_proc4 = rot90(hall_gray_DCT);
hall_gray_DCT_proc5 = rot90(hall_gray_DCT,2);
hall_gray_proc1 = DCTN'*hall_gray_DCT_proc1*DCTM;
hall_gray_proc2 = DCTN'*hall_gray_DCT_proc2*DCTM;
hall_gray_proc3 = DCTM'*hall_gray_DCT_proc3*DCTN;
hall_gray_proc4 = DCTM'*hall_gray_DCT_proc4*DCTN;
hall_gray_proc5 = DCTN'*hall_gray_DCT_proc5*DCTM;
subplot(2,3,1);
imshow(hall_gray,'InitialMagnification','fit');
title('Original');
subplot(2,3,2);
imshow(uint8(hall_gray_proc1),'InitialMagnification','fit');
title('FIRST 4 Col = 0');
subplot(2,3,3);
imshow(uint8(hall_gray_proc2),'InitialMagnification','fit');
title('LAST 4 Col = 0');
subplot(2,3,4);
imshow(uint8(hall_gray_proc3),'InitialMagnification','fit');
title('Transpose DCT Coeff');
subplot(2,3,5);
imshow(uint8(hall_gray_proc4),'InitialMagnification','fit');
title('Rot90 DCT Coeff');
subplot(2,3,6);
imshow(uint8(hall_gray_proc5),'InitialMagnification','fit');
title('Rot180 DCT Coeff');

