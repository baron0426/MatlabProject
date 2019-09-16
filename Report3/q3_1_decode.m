clear all;
close all;
clc;
load('q3_1_jpegcodes.mat');
%extract hide message
hall_gray_proc = num2cell(hall_gray_proc);
recovered_msg = logical(cellfun(@q3_1_extract, hall_gray_proc));
recovered_msg = reshape(recovered_msg, 1, []);
recovered_msg(length(recovered_msg) - mod(length(recovered_msg),7)+1 : length(recovered_msg)) = [];
recovered_msg = reshape(recovered_msg, 7, [])';
recovered_msg = bi2de(recovered_msg, 'left-msb');
recovered_msg(recovered_msg == 0) = [];
recovered_msg = char(recovered_msg)';
hall_gray_proc = cell2mat(hall_gray_proc);
% subplot(1,2,1);
% imshow(hall_gray_proc,'InitialMagnification','fit');
% title('With Hided Message');
% text(recovered_msg);

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
    elseif(AC_code(last:last+10) == logical([1,1,1,1,1,1,1,1,0,0,1]))
        AC_decode{m}(ind:ind+15) = zeros(16,1);
        ind = ind + 16;
        last = last+11;
    else
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
decode_pic = uint8(decode_pic);
decode_pic = num2cell(decode_pic);
recovered_msg2 = logical(cellfun(@q3_1_extract, decode_pic));
recovered_msg2 = reshape(recovered_msg2, 1, []);
recovered_msg2(length(recovered_msg2) - mod(length(recovered_msg2),7)+1 : length(recovered_msg2)) = [];
recovered_msg2 = reshape(recovered_msg2, 7, [])';
recovered_msg2 = bi2de(recovered_msg2, 'left-msb');
recovered_msg2(recovered_msg2 == 0) = [];
recovered_msg2 = char(recovered_msg2)';
decode_pic = cell2mat(decode_pic);

disp(['Original Message: ',recovered_msg]);
disp(['After JPEG Encoding and Decoding: ',recovered_msg2]);

