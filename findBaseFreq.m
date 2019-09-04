function [baseFreq_amp, baseFreq] = findBaseFreq(sample, fs)
sample = repmat(sample, 100, 1);
NFFT = 1000000;
sample_F = fft(sample, NFFT);
axis_f = fs*linspace(0,1,NFFT);
sample_F_ABS = 1/NFFT*abs(sample_F);
plot(axis_f(1:NFFT/2), sample_F_ABS(1:NFFT/2));
ERRTOL = 50; %Error Tolerance in Hz
ERRTOL_CNT = floor(ERRTOL*NFFT/fs);
[max_amp, baseFreq_CNT] = max(sample_F_ABS);
[max_amp2, baseFreq_CNT2]= max(sample_F_ABS((floor(baseFreq_CNT/2)-ERRTOL_CNT): (floor(baseFreq_CNT/2)+ERRTOL_CNT)));
baseFreq_CNT2 = baseFreq_CNT2 + (floor(baseFreq_CNT/2)-ERRTOL_CNT) - 1;
[max_amp3, baseFreq_CNT3]= max(sample_F_ABS((floor(baseFreq_CNT/3)-ERRTOL_CNT): (floor(baseFreq_CNT/3)+ERRTOL_CNT)));
baseFreq_CNT3 = baseFreq_CNT3 + (floor(baseFreq_CNT/3)-ERRTOL_CNT) - 1;
CRITERIA_R = 0.33; %Setting a relative criteria
if(max_amp3 >= CRITERIA_R * max_amp)
    baseFreq_amp = max_amp3;
    baseFreq = fs*baseFreq_CNT3/NFFT;
    baseFreq_CNT = baseFreq_CNT3;
elseif(max_amp2 >= CRITERIA_R*max_amp)
    baseFreq_amp = max_amp2;
    baseFreq = fs*baseFreq_CNT2/NFFT;
    baseFreq_CNT = baseFreq_CNT2;
else
    baseFreq_amp = max_amp;
    baseFreq = fs*baseFreq_CNT/NFFT;
end
for k = 2:1:6
    
end
end