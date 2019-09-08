fs = 8000; %setting sample rate
clap = [1 0.5 0.5 2 1 0.5 0.5 2]; %setting the beat of the music
pitch = [7 7 9 2 0 0 -3 2]; %setting the pitch of the music
tc = 0.5*clap; %approx. 0.5 second for 1 beat
len = length(pitch);
music = zeros(1,40000); %predefine the length of the output 
                         %to avoid lengthy execution time
last = 1;
for k=1:len
	temp = q1_makesound(fs, pitch(k),tc(k));
    last_next = last+length(temp)-1;
	music(last:last_next) = temp;
	last = last_next+1;
end
sound(music,fs);
audiowrite('q1_eastRed.wav', music,fs);