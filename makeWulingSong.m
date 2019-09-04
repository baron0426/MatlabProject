function music = makeWulingSong(fs, FREQ_INFO)
clap1 = [1 0.75 0.25 0.5 0.5 1 1 0.75 0.25 0.5 0.5 1 1 0.75 0.25 0.5 0.5 1 1 2 1 1.122 0.708 0.304 0.5 0.5 1 1.122 0.708 0.304 0.5 0.5 1 1 0.75 0.25 0.5 0.5 1 1 2 1];
clap2 = [1.5 0.5 1 1 1 0.5 0.5 2 1.5 0.5 1 1 1 0.5 0.5 2 1.5 0.5 1 0.5 0.5 3 1 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5];
clap3 = [0.75 0.25 0.5 0.5 1 1 2 0.75 0.25 0.5 0.5 3 1];
clap4 = [0.75 0.25 0.5 0.5 2 0.75 0.25 0.5 0.5 2 1 0.75 0.25 1.5 0.5 2 2 4];
clap = [clap1 clap2 clap3 clap4];
tc = 0.5*clap;
pitch1 = [ 4 0 2 4 5 7 12 14 12 11 9 7 9 12 9 7 4 4 0 2 complex(0,1) 4 0 2 4 5 7 12 14 12 11 9 7 7 9 7 5 7 9 11 12 complex(0,1)];
pitch2 = [4 2 7 5 4 2 0 2 12 9 7 12 9 11 12 14 11 14 12 11 9 7 complex(0,1) 9 complex(0,1) 5 complex(0,1) 7 complex(0,1) 4 complex(0,1) 5 complex(0,1) 2 complex(0,1) 4 complex(0,1) 0 complex(0,1)];
pitch3 = [0 2 4 5 7 12 7 7 5 4 2 0 complex(0,1)];
pitch4 = [7 5 4 5 7 12 11 9 11 12 12 11 12 14 7 16 14 12];
pitch = [pitch1 pitch2 pitch3 pitch4];
music = zeros(1,900000);
a = length(pitch);
last = 1;
for i=1:a
    if(imag(pitch(i)) == 0)
        freq = 440*(2^(-0.75))*2^(pitch(i)/12);
        test = ones(length(FREQ_INFO(:,1)),1).*freq;
        test = abs(test-FREQ_INFO(:,1));
        [bestFit_freq, bestFit_index] = min(test);
        temp = makesound2(fs, pitch(i), tc(i), FREQ_INFO(bestFit_index, 2:7));
        last_next = last+length(temp)-1;
        music(floor(last):floor(last_next)) = music(floor(last):floor(last_next))  + temp;
    else
        temp = zeros(1,tc(i)*fs);
        last_next = last+length(temp)-1;
        music(floor(last):floor(last_next)) = music(floor(last):floor(last_next))  + temp;
    end
	last = last_next - tc(i)*0.05*fs;
end
music = music./abs(max(music));
music(music==1)= 0.9999;
sound(music,fs);
audiowrite('wuling3.wav', music,fs);
end