% haar2.m
%  haar.m computes 1st level of the 2-d
%  Haar wavelet transform.
%
%  Input: x (an MxN image)
%  Output: 
%           w1 = M/2 x N/2 low-res image (scaling coefficients)
%           w2 = M/2 x N/2 horizontal wavelet coefficients
%           w3 = M/2 x N/2 vertical wavelet coefficients
%           w4 = M/2 x N/2 diagonal wavelet coefficients
%
% Usage: [w1,w2,w3,w4] = haar2(x)

function [w1,w2,w3,w4] = haar2d(x)

    lr_filter = [ 1,  1;
                  1,  1] / 4.;
    hc_filter = [-1, -1;
                  1,  1] / 4.;
    vc_filter = [-1,  1;
                 -1,  1] / 4.;
    dc_filter = [ 1, -1;
                 -1,  1] / 4.;
 
    w1 = conv2(x, lr_filter,'valid');
    w1 = w1(1:2:end,1:2:end);
    w2 = conv2(x, hc_filter,'valid');
    w2 = w2(1:2:end,1:2:end);
    w3 = conv2(x, vc_filter,'valid');
    w3 = w3(1:2:end,1:2:end);
    w4 = conv2(x, dc_filter,'valid');
    w4 = w4(1:2:end,1:2:end);
end
