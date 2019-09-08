%main program for question 8
%a continuous program based on q7_process.m
wave2proc3 = repmat(wave2proc2, 100,1);
axis_f = linspace(0, fs,1000000);
F1= (1/length(axis_f))*fft(wave2proc3, length(axis_f)); %use fft
figure(2)
plot(axis_f(1:length(axis_f)/2), abs(F1(1:length(axis_f)/2))); 
xlabel("Frequency(Hz)");
ylabel("Amplitude");
[pks, loc] = findpeaks(abs(F1(1:length(axis_f)/2)), length(axis_f)/fs, "MinPeakProminence",0.0002, "MinPeakDistance", 10);
pks2 = pks./pks(1);