clear all;
clc;
load 'guitar.mat';
realwave2 = resample(realwave, 250, 243);
wave2proc2 = zeros(25,1);
for i = 1:10
    wave2proc2 = wave2proc2 + realwave2(25*(i-1)+1: 25*i);
end
wave2proc2 = wave2proc2 / 10;
wave2proc2 = repmat(wave2proc2,10,1);
wave2proc2 = resample(wave2proc2, 243,250);
wave2proc3 = repmat(wave2proc2, 100,1);
fs = 8000;
axis_t = linspace(0, 24299/fs, 24300);
axis_f = linspace(0, fs,10000000);
F1= (1/length(axis_f))*fft(wave2proc3, length(axis_f));%use fft
figure(1)
plot(axis_f(1:length(axis_f)/2), abs(F1(1:length(axis_f)/2))); 
axis_f2 = linspace(0, fs,10000);
B = axis_f2.'*axis_t;
B = exp(-j*2*pi*B);
F2 = B * wave2proc3/fs; % use the conventional way
figure(2)
plot(axis_f2(1:length(axis_f2)/2), abs(F2(1:length(axis_f2)/2)));
