function Identify()
load('q4_1_v.mat');
pic = imread('Faces/people5.jpg');
N = 8;
pic_size = size(pic);
x_left = N - mod(pic_size(1),N);
y_left = N - mod(pic_size(2),N);
if(x_left<N)
    pic((pic_size(1)+1):(pic_size(1)+x_left),:,:) = repmat(pic(pic_size(1),:,:),x_left,1,1);
end
if(y_left<N)
    pic(:,(pic_size(2)+1):(pic_size(2)+y_left),:) = repmat(pic(:,pic_size(2),:),1, y_left,1);
end
pic_size = size(pic);
global Row Col result4;
[Row, Col,~] = size(pic);
blockCntRow = floor(pic_size(1)/N);
blockCntCol = floor(pic_size(2)/N);
pic = mat2cell(pic, N*ones(1,blockCntRow), N*ones(1,blockCntCol), 3);
L_cell = mat2cell(L*ones(blockCntRow, blockCntCol),ones(1,blockCntRow),ones(1,blockCntCol));
v_cell = mat2cell(repmat(v, blockCntRow, blockCntCol),length(v)*ones(1,blockCntRow),ones(1,blockCntCol));
N_cell = mat2cell(N*ones(blockCntRow, blockCntCol),ones(1,blockCntRow),ones(1,blockCntCol));
result = cellfun(@generateColorVec, pic, L_cell, 'UniformOutput', false);
result2 = cellfun(@colorDist, result, v_cell, 'UniformOutput', false);
result2 = cell2mat(result2);
result3 = zeros(blockCntRow, blockCntCol);
result3(result2 <= 0.62) = 1;
result3 = medfilt2(result3);
result3 = mat2cell(result3, ones(1,blockCntRow), ones(1,blockCntCol));
result4 = cellfun(@recovery8, result3, N_cell, 'UniformOutput', false);
result4 = cell2mat(result4);
pic = cell2mat(pic);
% picR = pic(:,:,1);
% picR(result4 == 1) =255;
% pic(:,:,1) = picR;
global rec1 n x2 y1 y2;
rec = ones(size(pic));
rec1 = zeros(Row,Col);
for i = 1:Row
    for j = 1:Col
        if rec1(i,j) == 1
            continue;
        end
        n = 0;
        if result4(i,j) == 1
            x1 = i; x2 = i; y1 = j; y2 = j;
            extend(i,j);
            rec1(x1:x2,y1:y2) = 1;
            if n >= 2
                rec(x1:x2,y1,:) = 0;
                rec(x1:x2,y2,:) = 0;
                rec(x1,y1:y2,:) = 0;
                rec(x2,y1:y2,:) = 0;
            end
        end
    end
end
pic_proc = double(pic).*rec;
pic_proc(:,:,1) = pic_proc(:,:,1)+255*~pic_proc(:,:,1);
figure;
imshow(uint8(pic_proc));
end
        
function extend(i,j)
global n Row Col x2 y1 y2 rec1 result4
rec1(i,j) = 1;
n = n+1;
t = 2;
if j+t <= Col && any(result4(i,j:j+t)) == 1 && sum(rec1(i,j:j+t)) < t
    y2 = j+1;
    extend(i,j+1);
end
if j-t > 0 && any(result4(i,j-t:j)) == 1 && sum(rec1(i,j-t:j)) < t
    y1 = j-1;
    extend(i,j-1);
end
if i+t <= Row && any(result4(i:i+t,j)) == 1 && sum(rec1(i:i+t,j)) < t
    x2 = i+1;
    extend(i+1,j);
end
end

