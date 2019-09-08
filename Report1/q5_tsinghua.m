clear all;
clc;
fs = 16000;
clap1 = [1 0.5 0.5 1 1 1 0.5 0.5 1 1 1 1 0.5 0.5 1 1 0.5 0.5 2 ];
clap2 = [1 1 0.5 0.5 1 1 1 0.5 0.5 1 1 1 0.5 0.5 1 1 1 0.5 0.5 2];
clap3 = [1.5 0.5 1 1 1.5 0.5 2 1.5 0.5 1 1 1 0.5 0.5 2];
clap4 = [1.5 0.5 1 1 1 0.5 0.5 2 1.5 0.5 1 1 1 0.5 0.5 2];
clap5 = [1 2 1 1 2 1 1 1 1 1 1 1 2 1 2 1 1 2 1 1 1 1 1 1 0.5 0.5 2];
clap = [clap1 clap2 clap3 clap4 clap5];
tc = 0.6*clap;
pitch1 = [3 3 7 10 10 12 15 12 10 10 7 7 10 7 3 0 3 7 10];
pitch2 = [12 12 12 15 10 7 5 7 5 3 5 10 10 9 10 12 12 14 12 10];
pitch3 = [15 15 12 15 10 12 10 12 12 10 7 5 5 7 10];
pitch4 = [3 3 3 7 5 7 5 3 12 12 10 7 5 7 5 3];
pitch5 = [15 15 complex(0,1) 12 12 complex(0,1) 10 10 12 10 5 7 10 15 15 complex(0,1) 19 19 complex(0,1) 10 10 12 10 5 7 5 3];
pitch = [pitch1 pitch2 pitch3 pitch4 pitch5];
a = length(pitch);
music = zeros(1,900000);
last = 1;
for i=1:a
    if(imag(pitch(i)) == 0)
        A = q5_makesound(fs, pitch(i), tc(i));
        last_next = last+length(A)-1;
        music(floor(last):floor(last_next)) = music(floor(last):floor(last_next))  + A;
    else
        A = zeros(1,tc(i)*fs);
        last_next = last+length(A)-1;
        music(floor(last):floor(last_next)) = music(floor(last):floor(last_next))  + A;
    end
	last = last_next - tc(i)*0.05*fs;
end
music = music./abs(max(music));
music(music==1)=0.999;
music(music==-1)=-0.999;
sound(music,fs);
audiowrite('q5_tsinghua.wav', music,fs);