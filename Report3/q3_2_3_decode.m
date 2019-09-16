clear all;
close all;
clc;
load('q3_2_3_jpegcodes.mat');
load('JpegCoeff.mat','DCTAB','ACTAB');
blockCntRow = floor(height/8);
blockCntCol = floor(width/8);
blockCnt = blockCntRow*blockCntCol;
DC_decode = zeros(1, blockCnt);
last = 1;
max_sizecode_length = max(DCTAB(:,1));
code_length = length(DC_code);
m = 1;
while(last<=code_length)
    for k = 2:1:max_sizecode_length
        query = find(~any((~(DCTAB(:,2:1+k) == DC_code(last:last+k-1))), 2));
        if(length(query) == 1)
            sizee = query - 1;
            last = last+k;
            break;
        end
    end
    if(sizee ~= 0)
        last_next = last + sizee;
        if(DC_code(last))
            magnitude = bi2de(flip(DC_code(last:last_next-1)));
        else
            magnitude = -1 * bi2de(flip(~(DC_code(last:last_next-1))));
        end
        last = last_next;
    DC_decode(m) = magnitude;
    else
        DC_decode(m) = 0;
    end
    m = m +1;
end
DC_decode = filter(-1, [1,-1],DC_decode,2*DC_decode(1));
AC_decode = cell(1,blockCnt);
last = 1;
max_sizecode_length = max(ACTAB(:,3));
code_length = length(AC_code);
m = 1;
ind = 1;
AC_decode{m} = zeros(63,1);
while(last<=code_length)
    if(AC_code(last:last+3) == logical([1,0,1,0]))
        last = last+4;
        if(last <= code_length)
        	m = m + 1;
            ind = 1;
            AC_decode{m} = zeros(63,1);
        end
        continue;
    elseif(last+10<=code_length)
        if(AC_code(last:last+10) == logical([1,1,1,1,1,1,1,1,0,0,1]))
        AC_decode{m}(ind:ind+15) = zeros(16,1);
        ind = ind + 16;
        last = last+11;
        continue;
        end
    end
        for k = 2:1:max_sizecode_length
            query = find(~any((~(ACTAB(:,4:3+k) == AC_code(last:last+k-1))), 2));
            if(length(query) == 1)
                if(query == 4 || query == 62)
                    k = k + 1; %ZRL and EOB are not included in the ACTAB, 
                               % which destroy the prefix encoding
                               % property! It is essential to add this
                               % conditioning!  HOW CAN YOU GIVE ME AN
                               % INCOMPLETE ACTAB WITHOUT MENTIONING IN THE
                               % INSTRUCTIONS?
                end
                run = ACTAB(query,1);
                sizee = ACTAB(query,2);
                last = last+k;
                break;
            end
        end
         AC_decode{m}(ind:ind+run-1) = zeros(run,1);
         ind = ind + run;
         last_next = last + sizee;
         if(AC_code(last))
            magnitude = bi2de(flip(AC_code(last:last_next-1)));
         else
            magnitude = -1 * bi2de(flip(~(AC_code(last:last_next-1))));
         end
         last = last_next;
         AC_decode{m}(ind) = magnitude;
         ind = ind + 1;
    
end
AC_decode = cell2mat(AC_decode);
decode_result = [DC_decode; AC_decode];
clear last;
clear last_next;
clear ind;
clear m;
clear k;
clear magnitude;
clear run;
clear sizee;
clear max_sizecode_length;
clear query;
clear DCTAB;
clear ACTAB;
[decode_result_rowCnt,~] = size(decode_result);
decode_pic = cellfun(@IZigzagScanandIDCT8,mat2cell(decode_result,decode_result_rowCnt ,ones(1,blockCnt)),'UniformOutput', false);
decode_pic = cell2mat(reshape(decode_pic, blockCntCol, blockCntRow)');
% %extract hide message
recovered_msg_ind = cellfun(@q3_2_3_findInd,mat2cell(decode_result,decode_result_rowCnt ,ones(1,blockCnt)));
recovered_msg = decode_result(sub2ind(size(decode_result), recovered_msg_ind, 1:1:blockCnt));
recovered_msg(recovered_msg == -1) = 0;
recovered_msg = logical(recovered_msg);
recovered_msg(length(recovered_msg) - mod(length(recovered_msg),7)+1 : length(recovered_msg)) = [];
recovered_msg = reshape(recovered_msg, 7,[])';
recovered_msg = bi2de(recovered_msg, 'left-msb');
recovered_msg(recovered_msg == 0) = [];
recovered_msg = char(recovered_msg)';
disp(recovered_msg);


load 'hall.mat';
subplot(1,2,1);
imshow(hall_gray,'InitialMagnification','fit');
title('Original');
subplot(1,2,2);
imshow(uint8(decode_pic),'InitialMagnification','fit');
title('JPEG with hidden message');
temp = (decode_pic - double(hall_gray)).^2;
MSE = 1/(height*width)*sum(temp(:));
PSNR = 10*log10(255^2/MSE);