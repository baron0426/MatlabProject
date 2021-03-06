%generate sound signal for question 10
function y = findFreq_makesound(fs, freq, tc, amp)
t = linspace(0, tc, tc*fs);
amp_size = length(amp);
K  = 2*pi*freq : 2*pi*freq : 2*amp_size*pi*freq;
sound = amp*sin(kron(K', t));
w1 = linspace(0, 1, floor(0.01*tc*fs));
w2 = linspace(1, 1, floor(0.2*tc*fs));
w3 = linspace(1, 0.8, floor(0.1*tc*fs));
w4 = linspace(0.8, 0, floor(0.5*tc*fs));
st = length(t);
s1 = length(w1);
s2 = length(w2);
s3 = length(w3);
s4 = length(w4);
sc = st-s1-s2-s3-s4;
wc = linspace(0.8, 0.8, sc);
w = [w1 w2 w3 wc w4];
y = sound .* w;
end