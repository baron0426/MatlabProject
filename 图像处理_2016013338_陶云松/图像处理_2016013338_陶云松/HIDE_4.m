% 3.2.3.(1)
function hall_color_1 = HIDE_4(M)
load('hall.mat');
load('JpegCoeff.mat');
[P,W] = size(hall_gray);
n = 1;
t = zeros(64,P*W/64);
for i = 1:8:P-7
    for j = 1:8:W-7
        part = hall_gray(i:i+7,j:j+7);
        c = dct2(part-128);
        c0 = round(c./QTAB);
        t(:,n) = ZIGZAG(c0);
        n = n+1;
    end
end

hall_color_1 = t;
hide = 0-ones(1,P*W/64);
b = dec2bin(M)-'0';
[p,q] = size(b);
a = zeros(p,7);
a(:,7-q+1:7) = b;
a = a';
a = a-~a;     % 将“0”变为“-1”
for k = 1:7*length(M)
    hide(k) = a(k);
end
for i = 1:P*W/64
    for j = 2:64       % 隐藏在每一列最后一位有效数字后一位
        if any(hall_color_1(j:64,i)) == 1 && j < 64
            continue;
        else
            hall_color_1(j,i) = hide(1,i);
            break;
        end
    end
end

% DC编码
Cd = filter([-1,1],1,hall_color_1(1,:),2*hall_color_1(1,1)); % 利用filter函数作差分运算，注意初始Cd（0） = a（1,1）,即假设a（0,1） = 2*a（1，1）
DC = zeros(1,100*P*W/64); 
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
AC = zeros(1,100*P*W/64);
Run = 0;
s = 1;
e = 1;
for i = 1:P*W/64
    for j = 2:64
        if any(hall_color_1(j:64,i)) == 0
            e = s+3;
            AC(s:e) = [1,0,1,0];
            s = e+1;
            break;
        else
            if hall_color_1(j,i) == 0
                Run = Run+1;
                if Run == 16
                    Run = 0;
                    e = s+10;
                    AC(s:e) = [1,1,1,1,1,1,1,1,0,0,1];
                    s = e+1;
                end
            else
                Size = floor(log2(abs(hall_color_1(j,i))))+1;
                Runsize = ACTAB(Run*10+Size,4:ACTAB(Run*10+Size,3)+3);
                Amplitude = dec2bin(abs(hall_color_1(j,i)))-'0';
                if hall_color_1(j,i) < 0
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

save('hide_4_half.mat','DC','AC','P','W');

% 计算压缩比
ratio = W*P*8/(length(DC)+length(AC)+2*8);
end

