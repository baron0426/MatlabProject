function music = makeFlagAnthem(fs, FREQ_INFO)
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
music(music==-1) = -0.9999;
audiowrite('output_flag.wav', music,fs);
end