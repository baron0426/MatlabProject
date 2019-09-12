clear all;
load 'hall.mat';
N = 8;
n = 0 : 1: N-1;
sample = hall_gray(96+1:96+N, 40+1:40+N);
sample = double(sample);
DCT = sqrt(2/N)*diag([sqrt(1/2), ones(1,N-1)])*cos(n'*(2*n + 1)*pi/(2*N));

sample_DCT = DCT*sample*DCT';
%sample_DCT2 = dct2(sample);

%sample_DCT(1,1) = sample_DCT(1,1) - (128*8);
%sample_IDCT  = DCT'*sample_DCT*DCT;