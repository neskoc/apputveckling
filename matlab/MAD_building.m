addpath('./images');

% Table with optimized parameters for different images
optimized_params = [
    0.01,  1.188;
    0.045, 1.134;
    0.8,   1.07 ;
    0.5,   1.09 ;
    0.01,  1.2  ;
    0.3,   1.15 ;
    0.01,  1.25 ;
    0.002, 1.035;
    0.01,  1.165
    ];

row = 1; % max value = 9
params = optimized_params(row, 1:2);
mu = params(1);
rho = params(2);
iter = 30; % number of iterations for lime solver (default 50)

alpha = 0.08; % same value for all images, original paper is using 0.15
gamma = 0.8; % parameter for gamma correction

orig_img = imread('building.bmp');

[Tout, Ti] = lime_enhance(orig_img, alpha, mu, rho, gamma, iter);
enh_img = im2double(orig_img) ./ Tout;

J = histeq(orig_img);

subplot(1, 3, 1);
imshow(orig_img);
title('Original');

subplot(1, 3, 2);
imshow(enh_img);
title('LIME enhanced');

subplot(1, 3, 3);
imshow(J);
title('After histeq');

% Inr = exec_full_haar_main_module(enh_img, level, th_type);

J_gray = rgb2gray(J);
enh_img_gray = 255*rgb2gray(enh_img);

enh_img_mad = mad(255*enh_img, 1, 'all');
J_mad = cast(mad(cast(J,'double'), 1, 'all'),'double');
[enh_img_mad J_mad]

enh_img_gray_mad = mad(enh_img_gray, 1, 'all');
J_gray_mad = cast(mad(cast(J_gray,'double'), 1, 'all'), 'double');
[enh_img_gray_mad J_gray_mad]