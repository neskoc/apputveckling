% set flag = 1 if enhanced image is going to be showed
% Ti / Tout are in and enhanced illumination maps,
% img_out and Iout are enhanced and image with reduced noise.

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

row = 5; % max value = 9
params = optimized_params(row, 1:2);
mu = params(1);
rho = params(2);
iter = 30; % number of iterations for lime solver (default 50)

level = 5; % decides the depth of the haar transform
th_type = "soft"; % soft or hard threashold policy for filtering


% orig_img = imread('spine.tif');
% orig_img = imread('building.bmp');
% orig_img = imread('testbild.jpg');
% orig_img = imread('testbildcolor.jpg');
% orig_img = imread('cars.bmp');
% orig_img = imread('land.bmp');
% orig_img = imread('GreenRoom33.jpg');
% orig_img = imread('lamp.bmp');
orig_img = imread('moon.bmp');
[Ti, Tout, enh_img, Inr] = exec_lime_main_module(orig_img, mu, rho, iter, level, th_type);
 
disp('Cumulative difference:');
sum(abs(enh_img - Inr), "all")