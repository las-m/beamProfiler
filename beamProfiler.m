function varargout = beamProfiler(varargin)
% BEAMPROFILER MATLAB code for beamProfiler.fig
%      BEAMPROFILER, by itself, creates a new BEAMPROFILER or raises the existing
%      singleton*.
%
%      H = BEAMPROFILER returns the handle to a new BEAMPROFILER or the handle to
%      the existing singleton*.
%
%      BEAMPROFILER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEAMPROFILER.M with the given input arguments.
%
%      BEAMPROFILER('Property','Value',...) creates a new BEAMPROFILER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before beamProfiler_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to beamProfiler_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help beamProfiler

% Last Modified by GUIDE v2.5 26-Aug-2016 14:11:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @beamProfiler_OpeningFcn, ...
                   'gui_OutputFcn',  @beamProfiler_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before beamProfiler is made visible.
function beamProfiler_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to beamProfiler (see VARARGIN)


dev_inf = imaqhwinfo('pointgrey');
cam_names = {dev_inf.DeviceInfo.DeviceName};

for i = 1:numel(dev_inf.DeviceIDs)
    vidobj = videoinput('pointgrey', dev_inf.DeviceIDs{i}, 'Mono8_1280x960');
    src = getselectedsource(vidobj);
    serial_num{i} = src.SerialNumber;
end

cam_list = [dev_inf.DeviceIDs', cam_names', serial_num'];

set(handles.tabcamList, 'Data', cam_list);

evdata = struct('Indices',[1 1]);
tabcamList_CellSelectionCallback(handles.tabcamList,evdata,handles);

% Choose default command line output for beamProfiler
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes beamProfiler wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = beamProfiler_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'vidobj')
    stoppreview(handles.vidobj);
    delete(handles.vidobj)
end
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in pbPrev.
function pbPrev_Callback(hObject, eventdata, handles)
% hObject    handle to pbPrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');

if isfield(handles, 'vidobj')
    if button_state
        % toggle button is pressed
        preview(handles.vidobj, handles.hImage);
    else
        % toggle button is not pressed
        stoppreview(handles.vidobj);
    end
else
    set(hObject, 'Value', 0);
    warndlg('Select Camera first!');
end
    

function setROI(hObject, eventdata, handles, ROIpos)
stoppreview(handles.vidobj);
handles.ROIpos = ROIpos;
guidata(hObject, handles);
set(handles.txtInfo, 'String', ['ROI: ' mat2str(ROIpos,3)]);
preview(handles.vidobj, handles.hImage);


% --- Executes on button press in pbDF.
function pbDF_Callback(hObject, eventdata, handles)
% hObject    handle to pbDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton5


% --- Executes when selected cell(s) is changed in tabcamList.
function tabcamList_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tabcamList (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
row = eventdata.Indices;

% Access an image acquisition device.
vidobj = videoinput('pointgrey', hObject.Data{row(1), 1}, 'Mono8_1280x960');

% % Convert the input images to grayscale.
vidobj.ReturnedColorSpace = 'grayscale';

% Retrieve the video resolution.
vidRes = vidobj.VideoResolution;

handles.src = getselectedsource(vidobj);

% The Video Resolution property returns values as width by height, but
% MATLAB images are height by width, so flip the values.
imageRes = fliplr(vidRes);
axes(handles.image);
hImage = imagesc(zeros(imageRes));
axis image;
setappdata(hImage,'UpdatePreviewWindowFcn',@update_gaussian_fit);

handles.hImage = hImage;
handles.vidobj = vidobj;

handles.ROIpos = [500, 500, 200, 200];
h = imrect(handles.image, handles.ROIpos);
addNewPositionCallback(h,@(ROIpos) setROI(hObject, eventdata, handles, ROIpos));

guidata(hObject, handles);


% --- Executes on button press in cbShutterAuto.
function cbShutterAuto_Callback(hObject, eventdata, handles)
% hObject    handle to cbShutterAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbShutterAuto
if get(hObject,'Value')
    set(handles.src, 'ShutterMode', 'Auto');
else
    set(handles.src, 'ShutterMode', 'Manual');
    set(handles.src, 'Shutter', str2double(get(handles.edtShutterTime, 'String')));
end


function edtShutterTime_Callback(hObject, eventdata, handles)
% hObject    handle to edtShutterTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtShutterTime as text
%        str2double(get(hObject,'String')) returns contents of edtShutterTime as a double
set(handles.src, 'Shutter', str2double(get(handles.edtShutterTime, 'String')));

% --- Executes during object creation, after setting all properties.
function edtShutterTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtShutterTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbGainAuto.
function cbGainAuto_Callback(hObject, eventdata, handles)
% hObject    handle to cbGainAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbGainAuto
if get(hObject,'Value')
    set(handles.src, 'GainMode', 'Auto');
else
    set(handles.src, 'GainMode', 'Manual');
    set(handles.src, 'Gain', str2double(get(handles.edtShutterTime, 'String')));
end



function edtGain_Callback(hObject, eventdata, handles)
% hObject    handle to edtGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtGain as text
%        str2double(get(hObject,'String')) returns contents of edtGain as a double
set(handles.src, 'Gain', str2double(get(handles.edtShutterTime, 'String')));


% --- Executes during object creation, after setting all properties.
function edtGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
