function out = q3_2_hide(in, hide_msg)
    temp = de2bi(abs(in));
    temp(1) = hide_msg;
    out = in/abs(in) * bi2de(temp);
end