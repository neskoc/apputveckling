function [Topt] = exec_lime_solver(Ti, alpha, mu0, rho, iter)
% solver for the optimization problem

% Ti is initial illumination map
% alpha, mu0, rho are constant parameters for the solver
% iter = no. of solver iterations

% Topt is refined illumination map

    [m, n] = size(Ti);

    Z = zeros(2 * m, n);
    G = Z;
    k = 0;
    mu = mu0; % initialization
    
    % W = Z + 1; % weight matrix using first strategy
    W = get_weight_matrix(Ti, 5); % calculate weight matrix using second strategy
    
    while k < iter

        % update T(k)
        U = Z / mu;
        A = alpha * W / mu; 
        T = updateT(Ti, mu, G, U); % acc. to T sub-problem (II-A1)

        % update G(k)
        gradT = calc_grad(T); % gradient of T
        G = shrinkage(A, (gradT + U)); % acc. to G sub-problem (II-A2)

        % update Z(k) and mu
        B = gradT - G;
        Z = mu * (B + U); % Z and mu sub-problem (II-A3)
        mu = mu * rho;

        k = k + 1;
    end
    Topt = T;
end

% -------------------------------------------------------------------------
function [T] = updateT(Ti, mu, G, U)
% updating T using (15) in LIME paper

% Ti is previous value of T
% U = Z / mu,
% and
% G, Z, mu are variables in the optimization problem

% T is updated Ti

    V = G - U; % G = G(k), U = Z(k) - mu
    Dtransp_V = mltply_Dtransposed_with(V); % multiplying D-transposed with X
    Tnum = 2 * Ti + mu * Dtransp_V;
    % fftshift: Shift zero-frequency component to center of spectrum
    % fft2: 2-D fast Fourier transform
    Tnum = fftshift(fft2(Tnum)); % numerator for updating T
    
    [m, n] = size(Ti);
    Tden = calc_Tdenom(m, n, mu); % denominator for updating T

    T = ifft2(ifftshift(Tnum ./ Tden));
end

% -------------------------------------------------------------------------
function [S] = shrinkage(A, X)
% performing shrinkage operation: II-A3 (26)
% S = sign(X) .* max(abs(X) - A, Z)

% A is matrix for thresholds
% X is matrix for shrinkage

% S is the resultant matrix

    [m, n] = size(A);
    Z = zeros(m, n);
    S = sign(X) .* max(abs(X) - A, Z);
end
