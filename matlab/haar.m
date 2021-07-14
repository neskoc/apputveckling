% haar.m
% author: Robert Nowak  11/30/03
%
%  haar.m computes 1-level of the 2-d
%  Haar wavelet transform.
%
%  Input: x (an NxN image)
%  Output: 
%           w1 = N/2 x N/2 low-res image (scaling coefficients)
%           w2 = N/2 x N/2 horizontal wavelet coefficients
%           w3 = N/2 x N/2 vertical wavelet coefficients
%           w4 = N/2 x N/2 diagonal wavelet coefficients
%
% Usage: [w1,w2,w3,w4] = haar(x)

function [w1,w2,w3,w4] = haar(x);

n = length(x);

for i=1:n/2
    for j=1:n/2
        i0 = 2*(i-1);
        j0 = 2*(j-1);
        w1(i,j) = 1/2*(x(i0+1,j0+1)+x(i0+1,j0+2)+x(i0+2,j0+1)+x(i0+2,j0+2)); 
        w2(i,j) = 1/2*(x(i0+1,j0+1)+x(i0+1,j0+2)-x(i0+2,j0+1)-x(i0+2,j0+2)); 
        w3(i,j) = 1/2*(x(i0+1,j0+1)-x(i0+1,j0+2)+x(i0+2,j0+1)-x(i0+2,j0+2)); 
        w4(i,j) = 1/2*(x(i0+1,j0+1)-x(i0+1,j0+2)-x(i0+2,j0+1)+x(i0+2,j0+2)); 
    end
end
