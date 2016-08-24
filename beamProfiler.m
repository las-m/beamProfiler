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

% Last Modified by GUIDE v2.5 24-Aug-2016 17:51:11

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


% Access an image acquisition device.
vidobj = videoinput('pointgrey', 1, 'Mono8_1280x960');

% Convert the input images to grayscale.
vidobj.ReturnedColorSpace = 'grayscale';

% Retrieve the video resolution.
vidRes = vidobj.VideoResolution;

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

stoppreview(handles.vidobj);

delete(handles.vidobj)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in pbPrev.
function pbPrev_Callback(hObject, eventdata, handles)
% hObject    handle to pbPrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state
    % toggle button is pressed
    preview(handles.vidobj, handles.hImage);
else
    % toggle button is not pressed
    stoppreview(handles.vidobj);
end


% --- Executes on button press in pbSelROI.
function pbSelROI_Callback(hObject, eventdata, handles)
% hObject    handle to pbSelROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function setROI(hObject, eventdata, handles, ROIpos)
handles.ROIpos = ROIpos;
guidata(hObject, handles);
set(handles.txtInfo, 'String', ['ROI: ' mat2str(ROIpos,3)]);


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
