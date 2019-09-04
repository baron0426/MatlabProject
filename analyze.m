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
if(a2>=(a1*1.2))
A = [A i];
end
end
A = [A length(music)];
B = [];
partitionCnt = length(A)-1;
%test the automated split result
%for i = 1:1:partitionCnt
 %   while 1
  %      sound(music(A(i): A(i+1)),fs);
   %     ok = input("OK? ");
    %    if(ok == 0 || ok == 1)
     %       B = [B ok];
      %      break;
       % end
    %end
%end
sample = music(A(6)+100:A(7));
sound(sample,fs)
[baseFreq_amp, baseFreq] = findBaseFreq(sample, fs);

