function [output, init_map] = lime_enhance(input_image, alpha, mu, rho, gamma, iter)
% obtaining illumination map

% input_image is raw image
% alpha, mu, rho are constant parameters for the solver
% iter = no. of lime solver iterations
% gamma is parameter for gamma correction (for illumination map)

% output is three-channel refined illumination map 
% init_map is single-channel initial illumination map

    B_norm = im2double(input_image);
    % converts the image to double precision.
    % image can be a grayscale intensity image, a truecolor image, or a binary image.
    % im2double rescales the output from integer data types to the range [0, 1].

    [~, ~, c] = size(B_norm);
    if c == 3
        init_map = get_initial_illumin_map(B_norm);
    else
        init_map = B_norm;
    end
    % single-channel refined illumination map
    [illum_map] = exec_lime_solver(init_map, alpha, mu, rho, iter); 
    
    abs_illum_map = abs(illum_map);
    T_gamma = abs_illum_map .^ gamma;
    % elementwise exponential function with gamma
    
    % mapping abs_illum_map to three channels
    Topt(:, :, 1) = T_gamma;
    Topt(:, :, 2) = T_gamma;
    Topt(:, :, 3) = T_gamma;
    output = Topt;

end