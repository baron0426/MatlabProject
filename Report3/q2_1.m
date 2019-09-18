clear all;
load 'hall.mat';
sample = double(hall_gray(57:64, 57:64));
N = 8;
n = 0 : 1: (N-1);
DCTN = sqrt(2/N)*diag([sqrt(1/2), ones(1,N-1)])*cos(n'*(2*n + 1)*pi/(2*N));
sample_DCT = DCTN * sample * DCTN';
sample_DCT(1,1) = sample_DCT(1,1) - 128*8;
sample_mod = DCTN' * sample_DCT * DCTN;


