% Example on reading and displaying images, with comments. 
% Benny L. June 17, 2021.

clear  % Clears the workspace

% Put file name in variable. Be sure to have correct path to image folder.
% Uncomment the image you want to use.
% imfile='images/spine.tif'; 
% imfile='images/dgb.jpg'; 
 imfile='images/pout.tif'; 
% imfile='images/autumn.tif'; 

% Read image:
I=imread(imfile); % Read image

% Show image:
figure(1) % Command not needed but can be used to push plot in front
imshow(I)


% Read what type of image it is:
info=imfinfo(imfile);

% Show image type in command window:
disp('Image type: '), disp(info.ColorType)
