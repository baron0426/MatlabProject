clear all;
close all;
clc;
pic_cnt = 33;
L = 3; %here you can change the value of L
result = cell(1, pic_cnt);
for k = 1:1:pic_cnt
    pic = imread(['Faces/', num2str(k), '.bmp']);
    result{k} = generateColorVec(pic, L);
end
result = cell2mat(result);
v = mean(result,2);
dist = colorDist(result, v);
crit = max(dist);
save('q4_1_v.mat', 'v', 'crit', 'L');
