function [Iout_forward] = full_haar2d(X, level)
    [m, n] = size(X);
    % requirement: level < max_levlels = min(lev_rows - 1, lev_cols - 1) where
    % lev_rows = log2(m);
    % lev_cols = log2(n);

    Iout_forward = X;
    [m, n] = size(Iout_forward);

    for i = 1 : level
        % dim reduction for 2dhaar transform depending on the transform level
        dim_reduction = 2^(i-1);
        [w1, w2, w3, w4] = haar2d(Iout_forward(1:m/dim_reduction, 1:n/dim_reduction));
        Iout_forward(1:m/dim_reduction, 1:n/dim_reduction) = [w1 w2; w3 w4];
    end
end