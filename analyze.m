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
sample = music(A(5)+100:A(6));
sample = repmat(sample, 100, 1);
NFFT = 1000000;
sample_F = fft(sample, NFFT);
axis_f = fs*linspace(0,1,NFFT);
sample_F_ABS = 1/NFFT*abs(sample_F);
plot(axis_f(1:NFFT/2), sample_F_ABS(1:NFFT/2));
unit_F = 1250;
freq = zeros(1,50);
amp = [];
found = 0;
for n = (unit_F+1):unit_F:length(sample_F_ABS)
    if(found == 1)
        break;
    end
    max1 = abs(max(sample_F_ABS((n-unit_F):(n-1))));
    [max2, potentbaseFreq] = max(sample_F_ABS((n):(n+unit_F-1)));
    max2 = abs(max2);
    if((max2 >= max1 * 3) && (max2>=0.002))
       freq(1) = potentbaseFreq*fs/size(sample_F_ABS); 
       found = 1;
    end
end
