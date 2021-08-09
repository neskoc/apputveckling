function [Y] = ihaar2d(X)
    % 2D Haar inverse wavelet transform
    % assuming the dimensions are the power of 2!
    % Y = higher-resolution image
    [m, n] = size(X);
    Y = zeros(m,n, 'double');
    w1 = X(1:m/2, 1:n/2);
    w2 = X(1:m/2, n/2+1:n);
    w3 = X(m/2+1:m, 1:n);
    w4 = X(m/2+1:m, n/2+1:n);
     for i = 1 : m/2
         ii = i * 2 - 1;
         for j = 1 : n/2
            jj = j * 2 - 1;

            Y(ii, jj)     = w1(i,j) + w2(i,j) + w3(i,j) + w4(i,j);
            Y(ii, jj+1)   = w1(i,j) + w2(i,j) - w3(i,j) - w4(i,j);
            Y(ii+1, jj)   = w1(i,j) - w2(i,j) + w3(i,j) - w4(i,j);
            Y(ii+1, jj+1) = w1(i,j) - w2(i,j) - w3(i,j) + w4(i,j);
         end
     end
end
