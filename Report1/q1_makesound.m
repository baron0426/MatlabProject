function y = q1_makesound(fs, pitch, tc) %generate sound signal for question 1
t = 0:(1/fs):tc;
freq = 440*(2^(-0.75))*2^(pitch/12);
y = sin(2*pi*freq*t);
end
