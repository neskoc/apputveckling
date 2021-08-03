function [Dy] = generate_Dv1(m)
% creating the matrix Dy for calculating gradient using matrix multiplication

% m is size to get Dy of size m times m+1
% Dy is the required output

% ex. m = 5
%  -1  1  0  0  0  0
%   0 -1  1  0  0  0
%   0  0 -1  1  0  0
%   0  0  0 -1  1  0
%   0  0  0  0 -1  1

    A = zeros(m, m+1);
    for i = 1 : 1 : m
         A(i, i)= -1;
         A(i, i + 1) = 1;
    end
    Dy = A;

end
