% 3.2.3.£®2£©
function M = EXTRACT_4()
load('hall.mat');
load('JpegCoeff.mat');
load('hide_4_half.mat');

[P,W] = size(hall_gray);
hall_color_1 = zeros(64,P*W/64);

% Ω‚¬ÎDC
decodeDC = zeros(1,P*W/64);
s = 1;
for i = 1:P*W/64
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
hall_color_1(1,:) = filter(1,[-1,1],decodeDC(1,:),2*decodeDC(1,1));

% Ω‚¬ÎAC
decodeAC = zeros(63,P*W/64);
s = 1;
for i = 1:P*W/64
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
hall_color_1(2:64,:) = decodeAC;

a = zeros(7,floor(P*W/64/7));
for i = 1:P*W/64
    for j = 2:64
        if j < 64 && any(hall_color_1((j+1):64,i)) == 1
            continue;
        else
            if hall_color_1(j,i) == 1
                a(i) = 1;
                break;
            else
                a(i) = 0;
                break;
            end
        end
    end
end
a = a';
L = length(a(:,1));
M = [];
for i = 1:L
    string = [num2str(a(i,1)),num2str(a(i,2)),num2str(a(i,3)),num2str(a(i,4)),num2str(a(i,5)),num2str(a(i,6)),num2str(a(i,7))];
    N = char(bin2dec(string));
    M = [M,N];
end

hall_gray_1 = uint8(zeros(P,W));
x = 1;
y = 1;
for i = 1:P*W/64
    c0 = unzigzag(hall_color_1(:,i));
    c = c0.*QTAB;
    part1 = idct2(c)+128;
    hall_gray_1(x:x+7,y:y+7) = uint8(part1);
    y = y+8;
    if y > W
        y = 1;
        x = x+8;
    end
end

MSE = sum(sum((hall_gray-hall_gray_1).^2))/P/W;
PNSR = 10*log(255^2/MSE);

figure;
imshow(hall_gray_1);
end

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
