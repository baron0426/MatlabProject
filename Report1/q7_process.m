clear all; %main program for question 7
close all;
clc;
load '../guitar.mat';
realwave2 = resample(realwave, 250, 243);
wave2proc2 = zeros(25,1);
for k = 1:10
    wave2proc2 = wave2proc2 + realwave2(25*(k-1)+1: 25*k);
end
wave2proc2 = wave2proc2 / 10;
wave2proc2 = repmat(wave2proc2,10,1);
wave2proc2 = resample(wave2proc2, 243,250);
diff = wave2proc2 - wave2proc;
fs = 8000;
sizee = length(wave2proc);
axis_t = linspace(0, (sizee-1)/fs, sizee);
figure;
hold on;
xlabel("time(s)");
ylabel("Amplitude");
plot(axis_t, wave2proc);
plot(axis_t, wave2proc2);
plot(axis_t, diff);
legend('wave2proc', 'wave2proc2', 'diff');
hold off;