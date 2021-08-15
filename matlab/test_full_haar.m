addpath('./images');

% orig_img = imread('spine.tif');
% orig_img = imread('building.bmp');
% orig_img = imread('testbild.jpg');
% orig_img = imread('testbildcolor.jpg');
% orig_img = imread('cars.bmp');
% orig_img = imread('land.bmp');
% orig_img = imread('GreenRoom33.jpg');
orig_img = imread('lamp.bmp');
% orig_img = imread('moon.bmp');

level = 5;
th_type = "soft"; % soft or hard threashold policy for filtering

[m, n, c] = size(orig_img);
% orig_img_w_noise = orig_img;

% c == 3 => color image with 3 components
% keep orig_img unchanged, use X to expand image size to power of 2
if c == 3
    % Convert original from RGB to HSV image
    Ihsv = rgb2hsv(orig_img);
    % In the rgb2hsv the values of hue, saturation and value are all
    % normalised to be between 0 and 1.

    Vbf_norm = Ihsv(:, :, 3);
    Vbf_norm_w_noise = imnoise(Vbf_norm, "gaussian", 0, 0.003);
    X = round(Vbf_norm_w_noise * 255);
    Ihsv_w_noise = Ihsv;
    Ihsv_w_noise(:, :, 3) = Vbf_norm_w_noise;
    orig_img_w_noise = hsv2rgb(Ihsv_w_noise);
else
    orig_img_w_noise = 255 * imnoise(rescale(orig_img), "gaussian", 0, 0.003);
    X = orig_img_w_noise;
end

lev_rows = ceil(log2(m));
lev_cols = ceil(log2(n));
mm = 2^lev_rows;
nn = 2^lev_cols;

if (mm > m || nn > n)
    X = zeros(mm, nn, 'double');
    if c == 3
        X(1:m, 1:n) = Vbf_norm_w_noise * 255;
    else
        X(1:m, 1:n) = orig_img_w_noise;
    end
end

Iout_hw = full_haar2d(X, level);
w1 = Iout_hw(             1 :   mm/2^level,              1 :   nn/2^level);
w2 = Iout_hw(             1 :   mm/2^level, nn/2^level + 1 : 2*nn/2^level);
w3 = Iout_hw(mm/2^level + 1 : 2*mm/2^level,              1 :   nn/2^level);
w4 = Iout_hw(mm/2^level + 1 : 2*mm/2^level, nn/2^level + 1 : 2*nn/2^level);

wx_max = floor(m / 2^level);
wy_max = floor(n / 2^level);

%    [sigthresh(w2(1:Wx_max,1:Wy_max), level, w2(1:Wx_max,1:Wy_max)) sigthresh(w3(1:Wx_max,1:Wy_max), level, w2(1:Wx_max,1:Wy_max)) sigthresh(w4(1:Wx_max,1:Wy_max), level, w2(1:Wx_max,1:Wy_max))]

w4(1:wx_max, 1:wy_max) = apply_haar_filter(w4(1:wx_max, 1:wy_max), level, th_type, w2(1:wx_max, 1:wy_max));
w3(1:wx_max, 1:wy_max) = apply_haar_filter(w3(1:wx_max, 1:wy_max), level, th_type, w2(1:wx_max, 1:wy_max));
w2(1:wx_max, 1:wy_max) = apply_haar_filter(w2(1:wx_max, 1:wy_max), level, th_type, w2(1:wx_max, 1:wy_max));

Iout_forward = Iout_hw;
Iout_forward(1:2*mm/2^level, 1:2*nn/2^level) = [w1 w2; w3 w4];
Iout_inverse = full_ihaar2d(Iout_forward, level);
% Iout_inverse = full_ihaar2d(Iout_hw, level);

if c == 3
    % nr = noise reduced
    Inr_hsv = Ihsv; % original image hsv-format
    Inr_hsv(:, :, 3) = Iout_inverse(1:m, 1:n) / 255; % replace intensity with filtered one
    Inr = hsv2rgb(Inr_hsv) * 255; % transform to rgb format for plot
else
    Inr = Iout_inverse;
end
Inr = cast(Inr(1:m, 1:n,:),'uint8'); % cast to uint8 for plotting

subplot(1, 2, 1);
imshow(orig_img_w_noise, []);
title('With gaussian noise');

subplot(1, 2, 2);
imshow(Inr);
title('Recovered');

figure, montage({orig_img_w_noise, Inr});

% subplot(1, 4, 1);
% imshow(orig_img);
% title('Original');
% 
% subplot(1, 4, 2);
% imshow(orig_img_w_noise, []);
% title('With gaussian noise');
% 
% subplot(1, 4, 3);
% imshow(Iout_hw, []);
% title('Transformed');
% 
% subplot(1, 4, 4);
% imshow(Inr);
% title('Recovered');