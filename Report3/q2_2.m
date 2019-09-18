clear all;
load 'hall.mat';
sample = double(hall_gray(57:64, 57:64));
N = 8;
n = 0 : 1: (N-1);
DCTN = sqrt(2/N)*diag([sqrt(1/2), ones(1,N-1)])*cos(n'*(2*n + 1)*pi/(2*N));
sample_DCT = DCTN * sample * DCTN';
sample_DCT2 = dct2(sample);
disp(sample_DCT2 - sample_DCT);


