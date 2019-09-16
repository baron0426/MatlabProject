function out = q3_1_hide(in, hide_msg)
    temp = de2bi(in);
    temp(1) = hide_msg;
    out = bi2de(temp);
end