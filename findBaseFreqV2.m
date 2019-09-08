function out = findBaseFreqV2(sample, fs)
sound(sample,fs);
sample = repmat(sample, 10000, 1);
Amp = zeros(1,6);
NFFT = 1000000;
sample_F = fft(sample, NFFT);
axis_f = fs*linspace(0,1,NFFT);
sample_F_ABS = 1/NFFT*abs(sample_F);
plot(axis_f(1:NFFT/2), sample_F_ABS(1:NFFT/2));
%ERRTOL = 50; %Error Tolerance in Hz
%ERRTOL_CNT = floor(ERRTOL*NFFT/fs);
[F_pks, F_loc] = findpeaks(sample_F_ABS(1:NFFT/2),  "MinPeakProminence",0.0002, "MinPeakDistance", 50*NFFT/fs);
 hold on;
 xlim([0 axis_f(NFFT/2)]);
 plot(axis_f(F_loc), F_pks, 'o');
 hold off;
F_loc_len = length(F_loc);
FreqList = zeros(F_loc_len,F_loc_len);
FreqList(1,1) = F_loc(1);
for k = 2:1:F_loc_len
   temp = F_loc(k) ./ (FreqList(1,:));
   temp = abs(temp - round(temp));
   notBaseFreq = 0;
   [~,start_row] = min(FreqList);
   [~,start_col] = min(FreqList');
   for m = 1:1:length(temp)
       if(temp(m) <= 0.01)
           notBaseFreq = 1;
           break;
       end
   end
   if(notBaseFreq)
       FreqList(start_row(m),m) = F_loc(k);
   else
       FreqList(1, start_col(1)) = F_loc(k);
   end
end
FreqList(~any( FreqList, 2 ), :) = [];
FreqList(:, ~any( FreqList, 1 )) = [];
FreqList_Freq = zeros(size(FreqList));
FreqList_Amp = zeros(size(FreqList));
FreqList_Freq(:)=axis_f(max(FreqList(:),1));
FreqList_Amp(:)=sample_F_ABS(max(FreqList(:),1));
FreqList_Freq(FreqList==0) = 0;
FreqList_Amp(FreqList==0) = 0;
[~,MAX_ENERGY_IND] = max(sum(FreqList_Amp.^2,1));
baseFreq = FreqList_Freq(1,MAX_ENERGY_IND);
temp = FreqList_Amp(:,MAX_ENERGY_IND);
temp = temp';
temp = temp/abs(max(temp));
y = findFreq_makesound(fs, baseFreq, 1, temp);
y = y ./abs(max(y));
pause(1);
sound(y, fs);
out = [baseFreq temp];
end


