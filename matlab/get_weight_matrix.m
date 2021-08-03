function [W] = get_weight_matrix(Ti,ker_size)
% making the weight matrix using second strategy

% Ti is the initial illumination map
% ker_size is the size of the Gaussian kernel

% W is the calculated weight matrix

    [m, n] = size(Ti);
    p = m * n;
    
    % obtaining gradient of Ti (nablaTi)
    nablaTi = calc_grad(Ti);
    NablaTi_vect = reshape(nablaTi, [2 * p, 1]); % vectorize nablaTi to a size 2*p x 1
    
    % separating parts used for W_x and W_y
    dtx = NablaTi_vect(1:p);
    dty = NablaTi_vect(p + 1 : 2 * p);
    
    % obtaining W_x and W_y
    w_gauss = fspecial('gaussian', [ker_size, 1], 2);
    disp('gaussian filter:');
    disp(w_gauss);
    conv_x = conv(dtx, w_gauss, 'same');
    conv_y = conv(dty, w_gauss, 'same');
    W_x = 1 ./ (abs(conv_x) + 0.0001);
    W_y = 1 ./ (abs(conv_y) + 0.0001);
    
    % concatenating W_x and W_y to get W
    W_xy = [W_x, W_y]; % Concatenate arrays
    W = reshape(W_xy, [2 * m, n]);

end
