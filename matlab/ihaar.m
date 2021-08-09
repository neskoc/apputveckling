function X = ihaar(X, level)
    % Simple 2D Haar inverse wavelet transform
    % assuming the dimensions are the power of 2!
    [m, n] = size(X);
    m = m / 2^level;
    n = n / 2^level;
    for i = 1 : level
        % vertical
        A = X(1:m, 1:2*n) + X(m+1:2*m, 1:2*n);
        D = X(1:m, 1:2*n) - X(m+1:2*m, 1:2*n);
        X(1:2:2*m, 1:2*n) = A;
        X(2:2:2*m, 1:2*n) = D;
        % horizontal
        A = X(1:2*m, 1:n) + X(1:2*m, n+1:2*n);
        D = X(1:2*m, 1:n) - X(1:2*m, n+1:2*n);
        X(1:2*m, 1:2:2*n) = A;
        X(1:2*m, 2:2:2*n) = D;
        % step
        m = m * 2;
        n = n * 2;
    end
end
