% 4.2
function Identify()
load('train.mat');
color = imread('people.jpg');
global P x y;
P = 8;
[N,M,Q] = size(color);
x = floor(N/P);
y = floor(M/P);
u = zeros(x*y,2^(3*L));
color_modified = floor(color/2^(8-L));
cn = color_modified(:,:,1)*2^(2*L)+color_modified(:,:,2)*2^L+color_modified(:,:,3);
count = 1;
for i = 1:y
    for j = 1:x
        for k = 1:P
            for w = 1:P
                u(count,cn(j*P-P+k,i*P-P+w)+1) = u(count,cn(j*P-P+k,i*P-P+w)+1)+1;
            end
        end
        count = count+1;
    end
end
u = u/(P^2);
error = reshape((1-sum(sqrt(u).*sqrt(v),2)),x,y);
global error_1;
error_1 = (error < 0.06);

global rec1 n x2 y1 y2;
rec = ones(N,M,Q);
rec1 = zeros(x,y);
for i = 1:x
    for j = 1:y
        if rec1(i,j) == 1
            continue;
        end
        n = 0;
        if error_1(i,j) == 1
            x1 = i; x2 = i; y1 = j; y2 = j;
            extend(i,j);
            rec1(x1:x2,y1:y2) = 1;
            if n >= 2
                rec(x1*P-P+1:x2*P,y1*P-P+1,:) = 0;
                rec(x1*P-P+1:x2*P,y2*P-P+1,:) = 0;
                rec(x1*P-P+1,y1*P-P+1:y2*P,:) = 0;
                rec(x2*P-P+1,y1*P-P+1:y2*P,:) = 0;
            end
        end
    end
end
color_1 = double(color).*rec;
color_1(:,:,1) = color_1(:,:,1)+255*~color_1(:,:,1);
figure;
imshow(uint8(color_1));
end
        
function extend(i,j)
global n x y x2 y1 y2 rec1 error_1
rec1(i,j) = 1;
n = n+1;
t = 2;
if j+t <= y && any(error_1(i,j:j+t)) == 1 && sum(rec1(i,j:j+t)) < t
    y2 = j+1;
    extend(i,j+1);
end
if j-t > 0 && any(error_1(i,j-t:j)) == 1 && sum(rec1(i,j-t:j)) < t
    y1 = j-1;
    extend(i,j-1);
end
if i+t <= x && any(error_1(i:i+t,j)) == 1 && sum(rec1(i:i+t,j)) < t
    x2 = i+1;
    extend(i+1,j);
end
end
