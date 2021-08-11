function [Res] = apply_haar_filter(M, level, th_type, HH_matrix)
% type = 1 => soft threshold
% type <> 1 => hard threshold
    th = sigthresh(M, level, HH_matrix);
    if th_type == "soft"
        M(M >= th) = M(M >= th) - th;
    else
        M(M >= th) = 0;
    end
    Res = M;
end