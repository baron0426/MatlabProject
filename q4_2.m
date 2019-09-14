clear all;
close all;
clc;
load('q4_1_v.mat');
pic = imread('Faces/people.jpg');
face_info = struct('xc',zeros(1,100),'yc',zeros(1,100),'xd',zeros(1,100),'yd',zeros(1,100));
ind = 1;
[height, width, ~] = size(pic);
for xc = 1:1:height
    for yc = 1:1:width
        for xd = (xc+1):1:height
            for yd = (yc+1):1:width
                test = generateColorVec(pic(xc:xd,yc:yd,:), L); %generate a test vector base on color
                if(colorDist(test,v) <= crit) %determine the distance between the test vector and the criteria vector
                    face_info.xc(ind) = xc;
                    face_info.yc(ind) = yc;
                    face_info.xd(ind) = xd;
                    face_info.yd(ind) = yd;
                    ind = ind + 1;
                end
            end
        end
    end
end