function update_gaussian_fit(obj,event,hImage)
% This callback function updates the gaussian fit.

d = double(event.Data) + 1;

% Display the current image frame. 
set(hImage, 'CData', d);
fig = findobj('Type','figure');
handles = guidata(fig);
ROIpos = round(handles.ROIpos);
axes(handles.ROI);
colormap(gca, parula);

d = (d-min(d(:)))/(max(d(:))-min(d(:)));

crop = d(ROIpos(2):ROIpos(2)+ROIpos(4),ROIpos(1):ROIpos(1)+ROIpos(3));
% crop = crop/max(crop(:));
imagesc(crop);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);

if get(handles.pbDF, 'Value')
    fr = fit21DGauss(crop);
    axes(handles.axFR);
    plot(fr); 
    colormap(gca, parula);
    shading interp;
    set(handles.axFR, 'Visible', 'Off');
    set(handles.txtInfo, 'String', {['wx = ' num2str(fr.wx)]; ['wy = ' num2str(fr.wx)]});
    axes(handles.axFRt);
    [xdata, ~] = getpoints(handles.line1);
    addpoints(handles.line1, xdata(end) + 1, fr.wx); 
    addpoints(handles.line2, xdata(end) + 1, fr.wy); 
end

axes(handles.ROIx)
plot(sum(crop,1));
set(gca,'YTickLabel',[]);

axes(handles.ROIy)
plot(sum(crop,2)');
set(gca,'XTickLabel',[]);
% Refresh the display.
drawnow
