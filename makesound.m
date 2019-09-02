function y = makesound(fs, pitch, tc)
t = linspace(0, tc, tc*fs);
freq = 440*(2^(-0.75))*2^(pitch/12);
sound = sin(2*pi*freq*t)+0.2*sin(4*pi*freq*t)+0.3*sin(6*pi*freq*t);
w1 = linspace(0, 1, 0.1*tc*fs);
w2 = linspace(1, 0.8, 0.08*tc*fs);
w3 = linspace(0.8, 0, 0.2*tc*fs);
st = size(t);
s1 = size(w1);
s2 = size(w2);
s3 = size(w3);
sc = st(2) - s1(2) - s2(2)- s3(2);
wc = linspace(0.8, 0.8, sc);
w = [w1 w2 wc w3];
y = sound .* w;
y = y./(max(abs(y)));
end