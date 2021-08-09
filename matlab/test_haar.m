
% orig_img = imread('spine.tif');
% orig_img = imread('building.bmp');
% orig_img = imread('testbild.jpg');
orig_img = imread('testbildcolor.jpg');
% orig_img = imread('cars.bmp');
% orig_img = imread('land.bmp');
% orig_img = imread('GreenRoom33.jpg');
% orig_img = imread('lamp.bmp');
% orig_img = imread('moon.bmp');

level = 1;
th_type = "hard";

[m, n, c] = size(orig_img);

% c == 3 => color image with 3 components
if c == 3
    % Convert original from RGB to HSV image
    Ihsv = rgb2hsv(orig_img); 
    % In the rgb2hsv the values of hue, saturation and value are all
    % normalised to be between 0 and 1.

    Vbf_norm = Ihsv(:,:,3);
    x = Vbf_norm * 255;
else
    x = orig_img;
end

lev_rows = ceil(log2(m));
lev_cols = ceil(log2(n));
nr_of_rows = 2^lev_rows;
nr_of_cols = 2^lev_cols;

if (nr_of_rows > m || nr_of_cols > n)
    x = zeros(nr_of_rows, nr_of_cols, 'double');
    if c == 3
        x(1:m, 1:n) = Vbf_norm * 255;
    else
        x(1:m, 1:n) = orig_img;
    end
end

[w1,w2,w3,w4] = haar2d(x);
Iout(1:nr_of_rows/2,1:nr_of_cols/2) = w1; % / max(w1,[],"all");
Iout(1:nr_of_rows/2,nr_of_cols/2+1:nr_of_cols) = w2; % / max(w2,[],"all");
Iout(nr_of_rows/2+1:nr_of_rows,1:nr_of_cols/2) = w3; % / max(w3,[],"all");
Iout(nr_of_rows/2+1:nr_of_rows,nr_of_cols/2+1:nr_of_cols) = w4; % / max(w4,[],"all");
Wx_max = floor(m/2^level);
Wy_max = floor(n/2^level);

%    [sigthresh(w2(1:Wx_max,1:Wy_max), level, w2(1:Wx_max,1:Wy_max)) sigthresh(w3(1:Wx_max,1:Wy_max), level, w2(1:Wx_max,1:Wy_max)) sigthresh(w4(1:Wx_max,1:Wy_max), level, w2(1:Wx_max,1:Wy_max))]
w2(1:Wx_max,1:Wy_max) = apply_haar_filter(w2(1:Wx_max,1:Wy_max), level, th_type, w2(1:Wx_max,1:Wy_max));
w3(1:Wx_max,1:Wy_max) = apply_haar_filter(w2(1:Wx_max,1:Wy_max), level, th_type, w2(1:Wx_max,1:Wy_max));
w4(1:Wx_max,1:Wy_max) = apply_haar_filter(w2(1:Wx_max,1:Wy_max), level, th_type, w2(1:Wx_max,1:Wy_max));

Iout_forward = [w1 w2; w3 w4];
Iout_inverse = ihaar2d(Iout_forward);

if c == 3
    % nr = noise reduced
    Inr_hsv = Ihsv; % original image hsv-format
    Inr_hsv(:,:,3) = Iout_inverse(1:m, 1:n) / 255; % replace intensity with filtered one
    Inr = hsv2rgb(Inr_hsv) * 255; % transform to rgb format for plot
else
    Inr = Iout_inverse;
end
Inr = cast(Inr(1:m, 1:n,:),'uint8'); % cast to uint8 for plotting

subplot(1, 3, 1);
imshow(orig_img);
title('Original');

subplot(1, 3, 2);
imshow(Iout, []);
title('Transformed');

subplot(1, 3, 3);
imshow(Inr);
title('Recovered');