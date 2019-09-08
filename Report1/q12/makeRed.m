function music = makeRed(fs, FREQ_INFO)
clap = [1 0.5 0.5 2 1 0.5 0.5 2]; %setting the beat of the music
pitch = [7 7 9 2 0 0 -3 2]; %setting the pitch of the music
tc = 0.5*clap;
music = zeros(1,900000);
a = length(pitch);
last = 1;
for i=1:a
    if(imag(pitch(i)) == 0)
        freq = 440*(2^(-0.75))*2^(pitch(i)/12);
        test = ones(length(FREQ_INFO(:,1)),1).*freq;
        test = abs(test-FREQ_INFO(:,1));
        [~, bestFit_index] = min(test);
        temp = makesound_harmonic(fs, pitch(i), tc(i), FREQ_INFO(bestFit_index, 2:20));
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
audiowrite('output_eastRed.wav', music,fs);
end