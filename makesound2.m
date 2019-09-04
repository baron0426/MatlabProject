function y = makesound2(fs, pitch, tc, amp)
t = linspace(0, tc, tc*fs);
freq = 440*(2^(-0.75))*2^(pitch/12);
K  = 2*pi*freq : 2*pi*freq : 2*6*pi*freq;
sound = amp*sin(kron(K', t));
w1 = linspace(0, 1, floor(0.01*tc*fs));
w2 = linspace(1, 0.9, floor(0.15*tc*fs));
w3 = linspace(0.9, 0, floor(0.2*tc*fs));
st = length(t);
s1 = length(w1);
s2 = length(w2);
s3 = length(w3);
sc = st-s1-s2-s3;
wc = linspace(0.9, 0.9, sc);
w = [w1 w2 wc w3];
y = sound .* w;
end