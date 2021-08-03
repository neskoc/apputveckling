function [Dtransp_V] = mltply_Dtransposed_with(V)
% multiplying D-transposed with V

% V is the input matrix,
% V = G - U;
% G = G(k), U = Z(k) - mu

% Dtransp_V is the result

    [p, n] = size(V); %size of G is 2M times N
    m = floor(p/2);
    % vectorize V, take half elements for horizontal and half for vertical gradient
    vect_V = reshape(V, [p * n, 1]);
    Vh = reshape(vect_V(1:m*n), [m, n]);
    matrix_Vv = reshape(vect_V(m*n+1:p*n), [m, n]);
    
    % obtaining Dh2 and Dv2 for calculating the gradients
    Dvi = generate_Dv1(m); % size MxM
    Dv2 = -Dvi;
    Dh2i = generate_Dv1(n);
    Dh2 = Dh2i(1:n, 1:n);
    Dh2(1:n, 1) = Dh2(1:n, 1) + Dh2i(1:n, n+1); % size N^2 + 1
    
    % making Vv with size NxN+1
    Vv = zeros(m+1, n);
    Vv(2:m+1, 1:n) = matrix_Vv;
    Vv(1, 2:n) = matrix_Vv(m,1: n-1);
    Vv(1, 1) = matrix_Vv(m, n);
    
    %calculating the gradients 
    gradVv = Dv2 * Vv;
    gradVh = Vh * Dh2;
    Dtransp_V = gradVh + gradVv;

end