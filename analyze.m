clear all;
close all;
clc;
[music, fs] = audioread('fmt.wav');
size = length(music);
A = [];
unit = 400;
for i = (unit+1):unit:(size-unit+1)
a1 = max(abs(music((i-unit):(i-1))));
a2 = max(abs(music(i:i+unit-1)));
if(a2>=(a1*1.4))
A = [A i];
end
end
A = [A length(music)];
B = [];
partitionCnt = length(A)-1;
%B= [ 0     1     1     0     1     1     1     1     1     1     1     0     1     1     0     0     1     1     0     0     0     0     0     1     1     1     1     1     1     1     1     1    1     1     1     1     1     1     1     1     1];

%test the automated split result
for k = 1:1:partitionCnt
    while 1
       sound(music(A(k): A(k+1)),fs);
        ok = input("OK? ");
        if(ok == 0 || ok == 1)
            B = [B ok];
            break;
        end
    end
end
FREQ_INFO = zeros(partitionCnt,7);
CRIT = 0.1;
for k = 1:1:partitionCnt
    if(B(k) == 1)
        dist = A(k+1)-A(k)+1;
        sample = music(A(k)+floor(CRIT*dist):A(k+1)-floor(CRIT*dist));
        FREQ_INFO(k,:) = findBaseFreq(sample, fs);
    end
end
FREQ_INFO( ~any(FREQ_INFO,2), : ) = [];  %rows
%makeWulingSong(16000, FREQ_INFO);
