% 2.9
clear all, close all, clc;
load('hall.mat');
load('JpegCoeff.mat');
[N,M] = size(hall_gray);
n = 1;
a = zeros(64,N*M/64);
for i = 1:8:N-7
    for j = 1:8:M-7
        part = hall_gray(i:i+7,j:j+7);
        c = dct2(part-128);
        c0 = round(c./QTAB);
        a(:,n) = ZIGZAG(c0);
        n = n+1;
    end
end

% DC编码
% 利用filter函数实现差分编码，注意初始Cd（0） = a（1,1）,即假设a（0,1） = 2*a（1，1）
Cd = filter([-1,1],1,a(1,:),2*a(1,1)); 
DC = zeros(1,100*N*M/64);      % 预先申请足够长的空间以提高效率
s = 1;                         % 向DC向量中填充代码的起始点
for i = 1:length(Cd)
    if Cd(i) == 0
        category = 0;
    else
        category = floor(log2(abs(Cd(i))))+1;
    end
    % 计算出Category之后从DCTAB中找到相应二进制代码
    Category = DCTAB(category+1, 2:DCTAB(category+1,1)+1);
    Magnitude = dec2bin(abs(Cd(i)))-'0';
    if Cd(i) < 0
        Magnitude = ~Magnitude;    % 如果为负数，取“1”的补码
    end
    e = s+length(Category)+length(Magnitude)-1; % 向DC向量中填充代码的终止点
    DC(s:e) = [Category,Magnitude];
    s = e+1;
end
DC = DC(1:s);           % 截取有用的片段

% AC编码
AC = zeros(1,100*N*M/64);     % 预先申请足够长的空间以提高效率
Run = 0;
s = 1;           % 向AC向量中填充代码的起始点
e = 1;           % 向AC向量中填充代码的终止点
for i = 1:N*M/64
    for j = 2:64           % 判断EOB符号是否出现
        if any(a(j:64,i)) == 0
            e = s+3;
            AC(s:e) = [1,0,1,0];
            s = e+1;
            break;
        else                % 判断ZRL符号是否出现
            if a(j,i) == 0
                Run = Run+1;
                if Run == 16
                    Run = 0;
                    e = s+10;
                    AC(s:e) = [1,1,1,1,1,1,1,1,0,0,1];
                    s = e+1;
                end
            else
                % 计算Size、Amplitude
                Size = floor(log2(abs(a(j,i))))+1;
                Runsize = ACTAB(Run*10+Size,4:ACTAB(Run*10+Size,3)+3);
                Amplitude = dec2bin(abs(a(j,i)))-'0';
                if a(j,i) < 0
                    Amplitude = ~Amplitude; % 如果为负数，取“1”的补码
                end
                e = s+length(Runsize)+length(Amplitude)-1;
                AC(s:e) = [Runsize,Amplitude];
                s = e+1;
                Run = 0;
            end
        end
    end
end
AC = AC(1:s);          % 截取有用的片段

save('jpegcodes.mat','DC','AC','N','M');

% 计算压缩比
ratio = M*N*8/(length(DC)+length(AC)+2*8);