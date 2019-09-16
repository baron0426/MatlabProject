function out = q3_2_1_hide(in, hide_msg)
    temp = de2bi(abs(in));
    temp(1) = hide_msg;
    if(in == 0)
        out = double(hide_msg);
    else
    out = in/abs(in) * bi2de(temp);
    end
end