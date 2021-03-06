function [Iout_inverse] = full_ihaar2d(X, level)
    % 2D Haar inverse wavelet transform
    % assuming the dimensions are the power of 2!
    % level determines number of ihaar2d iterations
    % Iout_inverse = higher-resolution image

    Iout_inverse = X;
    [m, n] = size(Iout_inverse);

    for i = level : -1 : 1
        % dim reduction for 2dhaar transform depending on the transform level
        dim_reduction = 2^(i-1);
        Iout_inverse(1:m/dim_reduction, 1:n/dim_reduction) = ihaar2d(Iout_inverse(1:m/dim_reduction, 1:n/dim_reduction));
    end
end
