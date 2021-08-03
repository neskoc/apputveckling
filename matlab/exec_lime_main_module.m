function [Ti, Tout, enh_img, Iout] = exec_lime_main_module(orig_img, mu, rho, iter, flag)
% main module incluidng lime image enhancement, denoising and plotting of
% results

% orig_img is raw (input) image

% alpha, mu, rho are constant parameters for the solver
% iter = no. of lime solver iterations

% ds and ss are respective degree of smoothing and
% spatial smoothing for bilateral filter (imbilatfilt)

% flag kept 1 for displaying outputs

% Ti is initial illumination map
% Tout is refined Ti
% enh_img is enhanced image
% I_out is img_out after denoising

    alpha = 0.08; % same value for all images, original paper is using 0.15
    gamma = 0.8; % parameter for gamma correction
    
    [Tout, Ti] = lime_enhance(orig_img, alpha, mu, rho, gamma, iter);
    enh_img = im2double(orig_img) ./ Tout;
    
    % post processing:
    %   imbilatfilt applies an edge-preserving Gaussian bilateral filter to the grayscale or RGB image
    %   used instead of BM3D filter (block matching and 3D filtering) for denoising
    ds = 10;
    ss = 1.5;
    Iout = imbilatfilt(enh_img, ds, ss);
    
    if flag == 1
        subplot(1, 3, 1);
        imshow(orig_img);
        title('Original');
        
        subplot(1, 3, 2);
        imshow(enh_img);
        title('Enhanced');
        
        subplot(1, 3, 3);
        imshow(Iout);
        title('With reduced noise');
    end

end