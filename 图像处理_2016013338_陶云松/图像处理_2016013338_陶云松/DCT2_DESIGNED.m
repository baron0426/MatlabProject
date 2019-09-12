% 2.2
function a = DCT2_DESIGNED(p)
[N,~] = size(p);
D = zeros(N);              % 为DCT算子预留空间
D(1,:) = ones(1,N) / (N^0.5);      % 构造DCT算子第一行
% 利用kron函数（类似叉积）构造DCT算子剩余行
D(2:N,:) = (2/N)^0.5 * cos(pi/2/N * kron([1:N-1]',[1:2:2*N-1]));
a = D*double(p)*D';
end


