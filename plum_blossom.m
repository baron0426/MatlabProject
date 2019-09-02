tc = [1 0.5 1 0.5 0.75 0.25 0.25 0.25 1.5 0.5 0.5 0.5 1.25 0.25 3 1 0.5 1 0.5 0.75 0.25 0.25 0.25 1.5 0.5 0.5 0.5 1 0.5 3];
pitch = [ 7 4 9 4 2 4 0 -3 -5 -3 0 -3 7 9 4 7 4 9 4 2 4 0 -3 -3 -5 -3 7 4 2 0];
a = size(pitch);
a = a(2);
music = zeros(1,200000);
last = 1;
for i=1:a
	last_next = last+tc(i)*fs-1;
	music(last:last_next) = music(last:last_next)  + makesound(fs, pitch(i), tc(i));
	last = last_next - tc(i)*0.05*fs;
end
sound(music,fs);
audiowrite('plum.wav', music,fs);