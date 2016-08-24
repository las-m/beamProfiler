function update_gaussian_fit(obj,event,hImage)
% This callback function updates the gaussian fit.

% Copyright 2007 The MathWorks, Inc.

% Display the current image frame. 
set(hImage, 'CData', event.Data);
fig = findobj('Type','figure');
handles = guidata(fig);
ROIpos = round(handles.ROIpos);

axes(handles.ROI);
d = event.Data;
crop = d(ROIpos(2):ROIpos(2)+ROIpos(4),ROIpos(1):ROIpos(1)+ROIpos(3));
crop = crop/max(crop(:));
surf(crop);

if get(handles.pbDF, 'Value')
    hold on;
    fr = fit2DGauss(double(crop));
    plot(fr); 
    hold off; 

    set(handles.txtInfo, 'String', {['wx = ' num2str(fr.wx)]; ['wy = ' num2str(fr.wx)]});
end

% Refresh the display.
drawnow
