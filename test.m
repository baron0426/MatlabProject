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
       if(temp(m) <= 0.001)
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