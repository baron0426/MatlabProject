clear all;
close all;
clc;
[music, fs] = audioread('../../fmt.wav');
sizee = length(music);
partition = [];
[yupper,ylower] = envelope(music,floor(fs/8),'peak'); %the order of FIR is an experience number
axis_t = linspace(0,(sizee-1)/fs,sizee);
env = yupper - ylower;
plot(axis_t, yupper-ylower);
[pks, loc] = findpeaks(env);
loc2 = [0 loc' sizee];
loc2size = length(loc2);
% for k = 1 : 1 : loc2size-1
% while 1
% dist = loc2(k+1) - loc2(k);
% start = loc2(k)+1 + 0.3*dist;
% start = floor(start);
% ending = loc2(k+1) - 0.3*dist;
% ending = floor(ending);
% sound(music(start:ending), fs);
% tmp = input("OK?");
% if (tmp == 1 || tmp == 0)
%     break
% end
% end
% end

FREQ_INFO = zeros(loc2size-1,20);
for k = 1:1:loc2size-1
    dist = loc2(k+1) - loc2(k);
    start = loc2(k)+1 + 0.3*dist;
    start = floor(start);
    ending = loc2(k+1) - 0.3*dist;
    ending = floor(ending);
    sample = music(start:ending);
    out = findFreq(sample, fs)
    FREQ_INFO(k,1:min(20,length(out))) = out(1:min(20,length(out)));
    pause(2);
end
test = makeWulingSong(fs, FREQ_INFO);
