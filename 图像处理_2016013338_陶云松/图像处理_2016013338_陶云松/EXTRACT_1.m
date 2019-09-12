% 3.1.（2）
function M = EXTRACT_1()
load('hall.mat');
load('hide_1_half.mat');

hall_color_2 = hall_color_1(:,:,1)-hall_color(:,:,1);   % 提取末位
[P,W] = size(hall_color_2);
a = zeros(7,floor(P*W/7));
for i = 1:P*W
    a(i) = hall_color_2(i);
end
a = a';
L = length(a(:,1));
M = [];
for i = 1:L            % 将字符拼接成字符串
    string = [num2str(a(i,1)),num2str(a(i,2)),num2str(a(i,3)),num2str(a(i,4)),...
        num2str(a(i,5)),num2str(a(i,6)),num2str(a(i,7))];
    N = char(bin2dec(string));       % 还原为字符
    M = [M,N];            % 拼接字符
end

end
    


