function out = colorDist(v1,v2)
    v1 = sqrt(v1);
    v2 = sqrt(v2);
    out = 1-(v2'*v1);
end