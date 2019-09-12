% 2.12
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
        c0 = round(c./(QTAB/2));
        a(:,n) = ZIGZAG(c0);
        n = n+1;
    end
end

% DC编码
Cd = filter([-1,1],1,a(1,:),2*a(1,1)); % 利用filter函数作差分运算，注意初始Cd（0） = a（1,1）,即假设a（0,1） = 2*a（1，1）
DC = zeros(1,100*N*M/64); 
s = 1;
e = 1;
for i = 1:length(Cd)
    if Cd(i) == 0
        category = 0;
    else
        category = floor(log2(abs(Cd(i))))+1;
    end
    Category = DCTAB(category+1, 2:DCTAB(category+1,1)+1);
    Magnitude = dec2bin(abs(Cd(i)))-'0';
    if Cd(i) < 0
        Magnitude = ~Magnitude;
    end
    e = s+length(Category)+length(Magnitude)-1;
    DC(s:e) = [Category,Magnitude];
    s = e+1;
end
DC = DC(1:s);

% AC编码
AC = zeros(1,100*N*M/64);
Run = 0;
s = 1;
e = 1;
for i = 1:N*M/64
    for j = 2:64
        if any(a(j:64,i)) == 0
            e = s+3;
            AC(s:e) = [1,0,1,0];
            s = e+1;
            break;
        else
            if a(j,i) == 0
                Run = Run+1;
                if Run == 16
                    Run = 0;
                    e = s+10;
                    AC(s:e) = [1,1,1,1,1,1,1,1,0,0,1];
                    s = e+1;
                end
            else
                Size = floor(log2(abs(a(j,i))))+1;
                Runsize = ACTAB(Run*10+Size,4:ACTAB(Run*10+Size,3)+3);
                Amplitude = dec2bin(abs(a(j,i)))-'0';
                if a(j,i) < 0
                    Amplitude = ~Amplitude;
                end
                e = s+length(Runsize)+length(Amplitude)-1;
                AC(s:e) = [Runsize,Amplitude];
                s = e+1;
                Run = 0;
            end
        end
    end
end
AC = AC(1:s);

save('jpegcodes_half.mat','DC','AC','N','M');

% 计算压缩比
ratio = M*N*8/(length(DC)+length(AC)+2*8);

load('jpegcodes_half.mat');

a = zeros(64,N*M/64);

% 解码DC
decodeDC = zeros(1,N*M/64);
s = 1;
for i = 1:N*M/64
    for j = 1:10
        Category = 0;
        if DC(s:s+DCTAB(j,1)-1) == DCTAB(j,2:2+DCTAB(j,1)-1)
            Category = j-1;
            s = s+DCTAB(j,1);
            break;
        end
    end
    if Category == 0
        decodeDC(1,i) = 0;
        s = s+1;
    else
        part = DC(s:s+Category-1);
        if DC(s) == 0
            part = ~part;
        end
        for k = 1:length(part)
            decodeDC(1,i) = decodeDC(1,i)+2^(Category-1)*part(k);
            Category = Category-1;
        end
        if DC(s) == 0
            decodeDC(1,i) = -decodeDC(1,i);
        end
        s = s+length(part);
    end
end
a(1,:) = filter(1,[-1,1],decodeDC(1,:),2*decodeDC(1,1));

% 解码AC
decodeAC = zeros(63,N*M/64);
s = 1;
for i = 1:N*M/64
    e = 1;
    while(e <= 63)
        if  s+10 <= length(AC) && all(AC(s:s+10) == [1,1,1,1,1,1,1,1,0,0,1])
            decodeAC(e:e+15,i) = zeros(16,1);
            e = e+16;
            s = s+11;
            continue;
        end
        if s+3 <= length(AC) && all(AC(s:s+3) == [1,0,1,0])
            s = s+4;
            break;
        end
        for j = 1:160
            Run = 0;
            Size = 0;
            if s+ACTAB(j,3)-1 <=length(AC) && all(AC(s:s+ACTAB(j,3)-1) == ACTAB(j,4:ACTAB(j,3)+3))
                Run = ACTAB(j,1);
                Size = ACTAB(j,2);
                s = s+ACTAB(j,3);
                break;
            end
        end
        part = AC(s:s+Size-1);
        if AC(s) == 0
            part = ~part;
        end
        e = e+Run;
        for k = 1:length(part)
            decodeAC(e,i) = decodeAC(e,i)+2^(Size-1)*part(k);
            Size = Size-1;
        end
        if AC(s) == 0
            decodeAC(e,i) = -decodeAC(e,i);
        end
        s = s+length(part);
        e = e+1;
    end
end
a(2:64,:) = decodeAC;

hall_gray_1 = uint8(zeros(N,M));
x = 1;
y = 1;
for i = 1:N*M/64
    c0 = unzigzag(a(:,i));
    c = c0.*QTAB/2;
    part1 = idct2(c)+128;
    hall_gray_1(x:x+7,y:y+7) = uint8(part1);
    y = y+8;
    if y > M
        y = 1;
        x = x+8;
    end
end

MSE = sum(sum((hall_gray-hall_gray_1).^2))/N/M;
PNSR = 10*log(255^2/MSE);

figure;
subplot(1,2,1);
imshow(hall_gray);
title('Unmodified');
subplot(1,2,2);
imshow(hall_gray_1);
title('Decode');

function rvalue = unzigzag(p)
q = [1, 2, 6, 7, 15,16,28,29;
     3, 5, 8, 14,17,27,30,43;
     4, 9, 13,18,26,31,42,44;
     10,12,19,25,32,41,45,54;
     11,20,24,33,40,46,53,55;
     21,23,34,39,47,52,56,61;
     22,35,38,48,51,57,60,62;
     36,37,49,50,58,59,63,64];
 rvalue = p(q);
end