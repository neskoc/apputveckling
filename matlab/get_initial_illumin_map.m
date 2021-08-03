function [T_initial] = get_initial_illumin_map(normalized_image)
% obtaining initial illumination map

% normalized_image is normalized input image by im2double function

% T_initial is the initial illumination map for normalized_image

    [m, n, c] = size(normalized_image); % size will be (M x N x 3) for RGB image
    a = zeros(m, n); % for single-channel illumination map
    
    for i = 1 : 1 : m
        for j = 1 : 1 : n
            b = [normalized_image(i, j, 1), normalized_image(i, j, 2), normalized_image(i, j, 3)]; % R,G,B values at a location
            if max(b) == 0
                a(i, j) = 0.000001; %avoid division by 0 
            else
                a(i, j) = max(b);
            end
        end
    end
    T_initial = a;

end