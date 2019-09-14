clear all;
close all;
clc;
load('q4_1_v.mat');
pic = imread('Faces/people.jpg');
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
blockCntRow = floor(pic_size(1)/N);
blockCntCol = floor(pic_size(2)/N);
pic = mat2cell(pic, N*ones(1,blockCntRow), N*ones(1,blockCntCol), 3);
L_cell = mat2cell(L*ones(blockCntRow, blockCntCol),ones(1,blockCntRow),ones(1,blockCntCol));
v_cell = mat2cell(repmat(v, blockCntRow, blockCntCol),length(v)*ones(1,blockCntRow),ones(1,blockCntCol));
result = cellfun(@generateColorVec, pic, L_cell, 'UniformOutput', false);
result2 = cellfun(@colorDist, result, v_cell, 'UniformOutput', false);
result2 = cell2mat(result2);
result3 = zeros(blockCntRow, blockCntCol);
result3(result2 <= crit) = 1;
face_info = struct('xc',zeros(1,100),'yc',zeros(1,100),'len',zeros(1,100));
ind = 1;
for xc = 1:1:blockCntRow
    for yc = 1:1:blockCntCol
        len = 1;
        for len = 1:1:min(blockCntRow,blockCntCol)-max(xc,yc)-1
            if(sum(result3((xc:xc+len), (yc:yc+len))==1) >= 0.6*(len+1)^2)
                face_info.xc(ind) = xc;
                face_info.yc(ind) = yc;
                face_info.len(ind) = len;
                ind  = ind + 1;
            end   
        end
    end
end
