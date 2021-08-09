% Example 2, on reading, analysing and displaying images. 
% Benny L. June 17, 2021.

clear  % Clears the workspace

% Put file name in variable. Be sure to have correct path to image folder.
% imfile='images/spine.tif'; 
 imfile='images/dgb.jpg'; 
% imfile='images/pout.tif'; 
% imfile='images/autumn.tif'; 

I=imread(imfile); % Read in image

% Read what type of image it is:
info=imfinfo(imfile);

% Test on image type, and process image according to its type
if strcmp(info.ColorType,'indexed') + strcmp(info.ColorType,'grayscale'),
    disp('Case 1 '),disp(info.ColorType)
    figure(1), imshow(I), title('Indexed or Grayscale image type')
    % Here you can process the image, if Indexed or Grayscale image.
    % Example on minor processing and also subplots:
    Iout=I*2;
    figure(2)
    subplot(2,1,1), imshow(I), title('Original image')
    subplot(2,1,2), imshow(Iout), title('Modified image')
else
    disp('Case 2 ')
    disp(info.ColorType)
    % Here you can process the image, if it is a Truecolor image
    figure(3),imshow(I), title('Truecolor image type')
end

