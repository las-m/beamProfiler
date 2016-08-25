function update_gaussian_fit(obj,event,hImage)
% This callback function updates the gaussian fit.

d = double(event.Data) + 1;
d = d/max(d(:));

% Display the current image frame. 
set(hImage, 'CData', d);
fig = findobj('Type','figure');
handles = guidata(fig);
ROIpos = round(handles.ROIpos);
axes(handles.ROI);
colormap(gca, parula);

crop = d(ROIpos(2):ROIpos(2)+ROIpos(4),ROIpos(1):ROIpos(1)+ROIpos(3));
% crop = crop/max(crop(:));
imagesc(crop);

if get(handles.pbDF, 'Value')
    fr = fit2DGauss(crop);
    axes(handles.axFR);
    plot(fr); 
    colormap(gca, parula);
    set(handles.axFR, 'Visible', 'Off');
    set(handles.txtInfo, 'String', {['wx = ' num2str(fr.wx)]; ['wy = ' num2str(fr.wx)]});
end

% Refresh the display.
drawnow
