function y = q5_makesound(fs, pitch, tc)
t = linspace(0, tc, tc*fs);
freq = 440*(2^(-0.75))*2^(pitch/12);
sound = sin(2*pi*freq*t)+0.2*sin(4*pi*freq*t)+0.3*sin(6*pi*freq*t);
w1 = linspace(0, 1, floor(0.1*tc*fs));
w2 = linspace(1, 0.8, floor(0.08*tc*fs));
w3 = linspace(0.8, 0, floor(0.2*tc*fs));
st = length(t);
s1 = length(w1);
s2 = length(w2);
s3 = length(w3);
sc = st-s1-s2-s3;
wc = linspace(0.8, 0.8, sc);
w = [w1 w2 wc w3];
y = sound .* w;
end