function denoised_img = haar_denoise_2d(data, thresh_fac)
% Non-decimated Haar wavelet denoising of an image:
% -> forward transform
% -> thresholding (coef >= thresh_fact),
% -> reconstruction (reverse transform).

% Inputs:
%   data: 2d image to be denoised
%   thresh_fact: adjust the treshold by this factor

% Output: denoised 2d image

    [l10, l20] = size(data);
    x = data;

    n1 = ceil(log2(l10));
    n2 = ceil(log2(l20));
    l1 = 2^n1;
    l2 = 2^n2;

    if (l1 > l10 || l2 > l20)
        x = zeros(l1, l2, 'double');
        x(1:l10, 1:l20) = data;
    end

    x0 = mean2(x);
    % xm_in = double.empty(l1, l2, 0);
    % xm_int = double.empty(l2, l1, 0);
    % xm1 = double.empty(l1, l2, 0);
    xm_in = zeros(l1, l2, 'double');
    xm1 = zeros(l1, l2, 'double');
    xm_int = xm_in.';
    xm1t = xm_int;

    tlt = 2 * log(2) * thresh_fac^2;

    cx = double.empty(l1, l2, 0);
    cx = cumsum(cumsum(x - x0),2);

    xnoise = zeros(l1, l2, 'double');
    xnoise0 = zeros(l1, l2, 'double');

    for l = 1 : n1-1
        % transform in x, creating xm_in
        sclx = 2^l;

        xm_in = transform(cx, xm_in, sclx);

        xnoise0(:) = 0.;
        for m = 1 : n2-1
            scly = 2^m;

            xm1t = transform(xm_in.', xm1.', scly);
            xm1 = xm1t.';

            % zero the significant elements of the transformed data, so that the insignificant part can later be subtracted away
            thresh = tlt * (n1 + n2 - l - m);
            xm1(xm1.^2 >= thresh) = 0;

            % now do the reverse transformation
            xm1t = transform(cumsum(xm1.', "reverse"), xm1.', scly);
            xm1 = xm1t.';
            xnoise0 = xnoise0 + xm1 / (2 * scly)^2;
        end

        xnoise0 = transform(cumsum(xnoise0, "reverse"), xnoise0, sclx);
        xnoise = xnoise + xnoise0 / (2 * sclx)^2;
    end

    x_flipped = flip(x);
    x_flipped = x_flipped - xnoise;
    x = flip(x_flipped);

    denoised_img =  x(1:l10, 1:l20);
end

% -------------------------------------------------------------------------
function haar_array = transform(x, y, s)
% transform x to y on scale s

    [l1, ~] = size(x);
    y(1:l1-2*s, :) = 2*x(s+1:l1-s, :) - x(1:l1-2*s, :) - x(2*s+1:l1, :);
    y(l1-2*s+1:l1-s, :) = 2*x(l1-s+1:l1, :) - x(l1-2*s+1:l1-s, :) - x(1:s, :) - x(l1, :);
    y(l1-s+1:l1, :) = 2*x(1:s, :) - x(l1-s+1:l1, :) - x(s+1:2*s, :) + x(l1, :);
    haar_array = y;
end