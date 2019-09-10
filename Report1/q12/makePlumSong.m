function music = makePlumSong(fs, FREQ_INFO)
tc = [1 0.5 1 0.5 0.75 0.25 0.25 0.25 1.5 0.5 0.5 0.5 1.25 0.25 3 1 0.5 1 0.5 0.75 0.25 0.25 0.25 1.5 0.5 0.5 0.5 1 0.5 3];
pitch = [ 7 4 9 4 2 4 0 -3 -5 -3 0 -3 7 9 4 7 4 9 4 2 4 0 -3 -3 -5 -3 7 4 2 0];
music = zeros(1,900000);
a = length(pitch);
last = 1;
for i=1:a
    if(imag(pitch(i)) == 0)
        freq = 440*(2^(-0.75))*2^(pitch(i)/12);
        test = ones(length(FREQ_INFO(:,1)),1).*freq;
        test = abs(test-FREQ_INFO(:,1));
        [bestFit_freq, bestFit_index] = min(test);
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
audiowrite('output_plum.wav', music,fs);
end