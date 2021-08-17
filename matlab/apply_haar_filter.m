function [Res] = apply_haar_filter(M, level, th_type, HH_matrix)
% type = 1 => soft threshold
% type <> 1 => hard threshold
    th = sigthresh(M, level, HH_matrix);
    if th_type == "soft"
        M(abs(M) >= th) = M(abs(M) >= th) - sign(M(abs(M) >= th))*th;
    else
        M(abs(M) < th) = 0;
    end
    Res = M;
end