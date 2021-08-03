% Example on reading, manipulating and displaying images. 
% Benny L. June 17, 2021.

clear  % Clears the workspace
% close all % Closes the figures

% imfile='images/autumn.tif';
% imfile='matlab/images/dgb.jpg';
imfile='matlab/images/spine.tif';
I=imread(imfile); % Read in image

% Read what type of image it is:
info=imfinfo(imfile);

% Process image according to its type
if strcmp(info.ColorType,'indexed') + strcmp(info.ColorType,'grayscale')
    disp('Case 1. ');
    disp(info.ColorType);
    disp('Here you can process the image, if it is a Indexed or Grayscale image');

% Convert image to double precision, in order to process: 
    Vbf = double(I); % Vbf is before processing
%   Do some processing of the intensity:
    V = max(Vbf(:)) - Vbf; % Here the intensity is just inverted
    Iout = uint8(V); % Convert image back to integer, uint8 format

else
    disp('Case 2 '),disp(info.ColorType)
    % Here you can process the image, if it is a truecolor image

    % Convert original from RGB to HSV image, usually a good start if you
    % want to manipulate the intensity (V) only and not the colors:
    Ihsv = rgb2hsv(I); 
    % In the rgb2hsv the values of hue, saturation and value are all
    % normalised to be between 0 and 1.

     Vbf = Ihsv(:,:,3);  
    % Vbf now contains the luminance (intensity) only. In this example it
    % is called Vbf where bf stands for 'before', since it is before
    % processing.

    % Some intensity transformations: ------------------------------
     V = 1 - Vbf; % Here the intensity is just inverted, as example on a modification.  
    % V=histeq(Vbf); % Here the histogram is equalised
    % V=ones(size(Vbf))*0.5; % This sets all intensities to the same level
    
    % Put back the intensity plane into the image. Later you want to modify
    % the intensity for image enhancement before putting it back:
     Ihsv(:,:,3) = V;
    
    % Other manipulations: ----------------------------------------
    
    % This puts full saturation to all colors: 
%      Sat=ones(size(Vbf)); 
%      Ihsv(:,:,2)=Sat;
    
   %   Or try some more odd things:
   %  Ihsv(:,:,2)=Vbf;
   %  Ihsv(:,:,2)=I(:,:,3);
   %  Ihsv(:,:,1)=0.3;
    
    Iout = hsv2rgb(Ihsv); % Convert image back to RGB form
    
    % Another example: We may want to look at the levels of R, G and B
    % separately:
%     figure(3)
%     subplot(2,2,1), imshow(I), title('Original color image') 
%     subplot(2,2,2), imshow(I(:,:,1)), title('Red channel') 
%     subplot(2,2,3), imshow(I(:,:,2)), title('Green channel') 
%     subplot(2,2,4), imshow(I(:,:,3)), title('Blue channel') 

end

% Visualize some images and parameters:
figure(10)
subplot(2,2,1), imshow(I), title('Original image')
subplot(2,2,2), imshow(Iout), title('Modified image')
subplot(2,2,3), histogram(Vbf(:),64), title('Histogram, intensity of original image')
subplot(2,2,4), histogram(V(:),64), title('Histogram, intensity of modified image (V)')
