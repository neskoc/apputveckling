function [Ti, Tout, enh_img, Inr] = exec_lime_main_module(orig_img, mu, rho, iter, level, th_type)
% main module incluidng lime image enhancement, denoising and plotting of
% results

% orig_img is raw (input) image

% alpha, mu, rho are constant parameters for the solver
% iter = no. of lime solver iterations

% Ti is initial illumination map
% Tout is refined Ti
% enh_img is enhanced image
% Inr is img_out after denoising (noise reduction = nr)

    alpha = 0.08; % same value for all images, original paper is using 0.15
    gamma = 0.8; % parameter for gamma correction
    
    [Tout, Ti] = lime_enhance(orig_img, alpha, mu, rho, gamma, iter);
    enh_img = im2double(orig_img) ./ Tout;
    
    % post processing
    % 1. discrete 2d-haar wavelet transform transforms image the to time/freqency domain
    %    level decides the depth of the haar transform
    % 2. high frequency wavelet coefficients are either reduced (soft
    %    threasholding) or set to zero (hard threasholding)
    %    th_type = "hard"/"soft"
    % 3. discrete 2d-inverse haar transform transforms haar coefficients
    %    back to the "ordinary" image

    Inr = exec_full_haar_main_module(enh_img, level, th_type);

    subplot(1, 3, 1);
    imshow(orig_img);
    title('Original');
    
    subplot(1, 3, 2);
    imshow(enh_img);
    title('Enhanced');
    
    subplot(1, 3, 3);
    imshow(cast(Inr, 'uint8')); % % cast to uint8 for plotting
    title('With reduced noise');
end