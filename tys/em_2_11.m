% 2.11
clear all, close all, clc;
load('jpegcodes.mat');
load('JpegCoeff.mat');
load('hall.mat');
[N,M] = size(hall_gray);

a = zeros(64,N*M/64);

% ����DC
decodeDC = zeros(1,N*M/64);          % Ԥ�������㹻���Ŀռ������Ч��
s = 1;                  % ��decodeDC���������������ʼ��
for i = 1:N*M/64
    for j = 1:10
        % ��CategoryԤ�ȸ���ֵ�������ж�Ϊδ�������������
        Category = 0;
        % ��һ�˶�DCTAB�ҵ�Category
        if DC(s:s+DCTAB(j,1)-1) == DCTAB(j,2:2+DCTAB(j,1)-1)
            Category = j-1;
            s = s+DCTAB(j,1);
            break;
        end
    end
    if Category == 0  % CategoryΪ0�����
        decodeDC(1,i) = 0;
        s = s+1;
    else             % Category��Ϊ0�����
        part = DC(s:s+Category-1);
        if DC(s) == 0    % ��ͷΪ0��ʾΪ������ȡ��1���Ĳ���
            part = ~part;
        end
        for k = 1:length(part)      % ת��Ϊʮ����
            decodeDC(1,i) = decodeDC(1,i)+2^(Category-1)*part(k);
            Category = Category-1;
        end
        if DC(s) == 0    % ע�⽫������ԭ
            decodeDC(1,i) = -decodeDC(1,i);
        end
        s = s+length(part);
    end
end
% ����filter����ʵ�ֽ��ֱ��룬ע���ʼCd��0�� = a��1,1��,������a��0,1�� = 2*a��1��1��
a(1,:) = filter(1,[-1,1],decodeDC(1,:),2*decodeDC(1,1));

% ����AC
decodeAC = zeros(63,N*M/64);     % Ԥ�������㹻���Ŀռ������Ч��
s = 1;           % ��decodeAC���������������ʼ��
for i = 1:N*M/64
    e = 1;
    while(e <= 63)       % �ж��Ƿ�ΪZRL
        if  s+10 <= length(AC) && all(AC(s:s+10) == [1,1,1,1,1,1,1,1,0,0,1])
            decodeAC(e:e+15,i) = zeros(16,1);
            e = e+16;
            s = s+11;
            continue;
        end              % �ж��Ƿ�ΪEOB
        if s+3 <= length(AC) && all(AC(s:s+3) == [1,0,1,0])
            s = s+4;
            break;
        end
        for j = 1:160
            Run = 0;
            Size = 0;
            % ��һ�˶�ACTAB�ҵ�Run��Size
            if s+ACTAB(j,3)-1 <=length(AC) && all(AC(s:s+ACTAB(j,3)-1) == ACTAB(j,4:ACTAB(j,3)+3))
                Run = ACTAB(j,1);
                Size = ACTAB(j,2);
                s = s+ACTAB(j,3);
                break;
            end
        end
        part = AC(s:s+Size-1);
        if AC(s) == 0      % ��ͷΪ0��ʾΪ������ȡ��1���Ĳ���
            part = ~part;
        end
        e = e+Run;
        for k = 1:length(part)     % ת��Ϊʮ����
            decodeAC(e,i) = decodeAC(e,i)+2^(Size-1)*part(k);
            Size = Size-1;
        end
        if AC(s) == 0       % ע�⽫������ԭ
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
    c0 = unzigzag(a(:,i));    % ��Zig-Zagɨ��
    c = c0.*QTAB;             % ������
    part1 = idct2(c)+128;     % DCT��任�����ؼ���128
    hall_gray_1(x:x+7,y:y+7) = uint8(part1);   % ƴ��
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

% ��Zig-Zagɨ�躯��
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