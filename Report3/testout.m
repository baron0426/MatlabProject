subplot(1,2,1);
imshow(hall_gray(25:64,1:40),'InitialMagnification','fit');
title('Original');
subplot(1,2,2);
test = uint8(decode_pic);
imshow(test(25:64,1:40),'InitialMagnification','fit');
title('JPEG Encoded and Decoded');