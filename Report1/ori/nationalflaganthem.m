clear all;
clc;
fs = 16000;
clap1 = [1 0.75 0.25 1 1 1 0.75 0.25 1 1 1 1 1 0.75 0.25 0.75 0.25 1 2];
clap2 = [1 0.75 0.25 1 1 1 0.75 0.25 1 1 1 1 1 0.5 0.5 0.75 0.25 1 2];
clap3 = [1.5 0.5 1 1 1 0.75 0.25 0.75 0.25 1 1.5 0.5 1 1 0.75 0.25 0.5 0.5 2];
clap4 = [1.5 0.5 0.75 0.25 1 1.5 0.5 0.75 0.25 1 1 0.5 0.5 0.5 0.5 0.5 0.5 1 0.75 0.25 1 1];
clap5 = [1.5 0.5 0.75 0.25 1 1.5 0.5 0.75 0.25 1 1 0.5 0.5 0.5 0.5 0.5 0.5 1 0.75 0.25 2];
clap = [clap1 clap2 clap3 clap4 clap5];
tc = 0.6*clap;
pitch1 = [4 0 4 7 7 12 11 9 9 7 9 7 7 4 0 5 5 4 2];
pitch2 = [4 0 2 4 7 12 11 9 9 7 9 7 7 5 4 2 4 2 0];
pitch3 = [2 4 5 5 9 9 9 7 5 4 4 7 12 12 14 12 11 9 7];
pitch4 = [16 16 14 12 11 14 12 11 9 7 12 12 7 9 7 5 4 2 4 5 4 complex(0,1)];
pitch5 = [16 16 14 12 11 14 12 11 9 7 12 12 7 11 9 7 5 4 5 2 0];
pitch = [pitch1 pitch2 pitch3 pitch4 pitch5];
a = length(pitch);
music = zeros(1,750000);
last = 1;
for i=1:a
    if(imag(pitch(i)) == 0)
        A = makesound(fs, pitch(i), tc(i));
        last_next = last+length(A)-1;
        music(floor(last):floor(last_next)) = music(floor(last):floor(last_next))  + A;
    else
        A = zeros(1,tc(i)*fs);
        last_next = last+length(A)-1;
        music(floor(last):floor(last_next)) = music(floor(last):floor(last_next))  + A;
    end
	last = last_next - tc(i)*0.05*fs;
end
sound(music,fs);
audiowrite('flaganthem.wav', music,fs);