function [nablaT] = calc_grad(T)
% multiplying D with T to get gradient of T

% T is input matrix
% nablaT is gradient of T

% Dh1 transpose is of size N x N+1 and
% Dv            is of size M x M+1

    [m, n] = size(T);
    Dv1 = generate_Dv1(m); % Dv1, pp.3
    Dh1t = generate_Dv1(n);
    Dh1 = Dh1t'; % transposition to get Dh1
    
    % making Tv with size M+1 times N (matrix Xv (22) in LIME paper, pp.3)
    Tv = zeros(m + 1, n);
    Tv(1:m, 1:n) = T;
    Tv(m+1, 1:n-1) = T(1, 2:n);
    Tv(m+1, n) = T(1, 1);
    
    % vertical gradient of T
    gradTv = Dv1 * Tv; % Dv1*Xv, LIME paper (18) => DX
    
    % making Th with size M times N+1 (matrix Xh (21) in LIME paper)
    Th = zeros(m, n+1);
    Th(1:m, 1:n) = T;
    Th(1:m, n+1) = T(1:m, 1);
    
    % horizontal gradient of T
    gradTh = Th * Dh1; % Xh*Dh1, LIME paper (18) => DX
    
    % concatenating to get matrix of size 2M x N, LIME paper (18)
    vect_gradTh = reshape(gradTh, [m * n, 1]);
    vect_gradTv = reshape(gradTv, [m * n, 1]);
    DT = [vect_gradTh; vect_gradTv]; % DX in (18)
    nablaT = reshape(DT, [2 * m, n]);

end