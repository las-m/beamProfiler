% Access an image acquisition device.
vidobj = videoinput('pointgrey', 1, 'Mono8_1280x960');

% Convert the input images to grayscale.
vidobj.ReturnedColorSpace = 'grayscale';

% Retrieve the video resolution.
vidRes = vidobj.VideoResolution;

% Create a figure and an image object.
f = figure('Visible', 'off');

% The Video Resolution property returns values as width by height, but
% MATLAB images are height by width, so flip the values.
imageRes = fliplr(vidRes);

subplot(1,2,1);

hImage = imshow(zeros(imageRes));

% Set the axis of the displayed image to maintain the aspect ratio of the
% incoming frame.
axis image;

setappdata(hImage,'UpdatePreviewWindowFcn',@update_gaussian_fit);

preview(vidobj, hImage);

pause(30);

stoppreview(vidobj);
delete(f);

delete(vidobj)
clear vidobj
