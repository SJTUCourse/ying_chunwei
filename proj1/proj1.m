function varargout = proj1(varargin)
% PROJ1 MATLAB code for proj1.fig
%      PROJ1, by itself, creates a new PROJ1 or raises the existing
%      singleton*.
%
%      H = PROJ1 returns the handle to a new PROJ1 or the handle to
%      the existing singleton*.
%
%      PROJ1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJ1.M with the given input arguments.
%
%      PROJ1('Property','Value',...) creates a new PROJ1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before proj1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to proj1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help proj1

% Last Modified by GUIDE v2.5 12-Oct-2015 23:50:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @proj1_OpeningFcn, ...
                   'gui_OutputFcn',  @proj1_OutputFcn, ...
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


% --- Executes just before proj1 is made visible.
function proj1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to proj1 (see VARARGIN)

% Choose default command line output for proj1
handles.output = hObject;
Handle1 = gcf;
setappdata(0,'Handle1',Handle1);
%tappdata(0,'GUIhandles',handles);
% Update handles structure
guidata(hObject, handles);

setappdata(Handle1,'PlotArea',handles.axes1);
Srate = 100;
setappdata(Handle1,'Srate',Srate);
FileNum = 0;
setappdata(Handle1,'FileNum',FileNum);
SignalSave = [];
setappdata(Handle1,'SignalSave',SignalSave);
h = line;
set(h,'Marker','*','LineStyle','none');
h.Parent = handles.axes1;
setappdata(Handle1,'LineHandle',h);
z = 1;
setappdata(Handle1,'Zoom',z);
set(handles.figure1, 'DeleteFcn', {@DeleteFcn});


set(handles.Srate_Reset, 'Enable','off');
set(handles.Start_Rec, 'Enable','off');
set(handles.Stop_Rec, 'Enable','off');
set(handles.Plus, 'Enable','off');
set(handles.Minus, 'Enable','off');
% UIWAIT makes proj1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = proj1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Srate_Value_Callback(hObject, eventdata, handles)
% hObject    handle to Srate_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Srate_Value as text
%        str2double(get(hObject,'String')) returns contents of Srate_Value as a double


% --- Executes during object creation, after setting all properties.
function Srate_Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Srate_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Srate_Confirm.
function Srate_Confirm_Callback(hObject, eventdata, handles)
% hObject    handle to Srate_Confirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  Handle1 = getappdata(0,'Handle1');
  Srate = str2double(get(handles.Srate_Value, 'String'));
  setappdata(Handle1,'Srate',Srate);
  set(handles.Srate_Confirm, 'Enable','off');
  set(handles.Srate_Reset, 'Enable','on');
  set(handles.Srate_Value, 'Enable','off');
  set(handles.Start_Rec, 'Enable','on');
  

  




% --- Executes on button press in Srate_Reset.
function Srate_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Srate_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Srate_Confirm, 'Enable','on');
set(handles.Srate_Value, 'Enable','on');
set(handles.Srate_Reset, 'Enable','off');



% --- Executes on button press in Start_Rec.
function Start_Rec_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle1 = getappdata(0,'Handle1');
h = getappdata(Handle1,'LineHandle');
set(h,'XData',[],'YData',[]);
set(handles.Stop_Rec, 'Enable','on');
set(handles.Start_Rec, 'Enable','off');
PointCount = 0;
setappdata(Handle1,'PointCount',PointCount);
z = 1;
setappdata(Handle1,'Zoom',z);
InstantAI();
set(handles.Srate_Reset, 'Enable','off');
set(handles.Plus, 'Enable','on');
set(handles.Minus, 'Enable','on');


% --- Executes on button press in Stop_Rec.
function Stop_Rec_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_Rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle1 = getappdata(0,'Handle1');
SignalSave = getappdata(Handle1,'SignalSave');
FileNum = getappdata(Handle1,'FileNum');
save(['Signal',int2str(FileNum)],'SignalSave');
SignalSave = [];
FileNum = FileNum+1;
setappdata(Handle1,'SignalSave',SignalSave);
setappdata(Handle1,'FileNum',FileNum);

t = getappdata(Handle1,'TimerHandle');
stop(t);
delete(t);

instantAiCtrl = getappdata(Handle1,'instantAiCtrl');
instantAiCtrl.Dispose();
set(handles.Stop_Rec, 'Enable','off');
set(handles.Start_Rec, 'Enable','on');
set(handles.Srate_Reset, 'Enable','on');
set(handles.Plus, 'Enable','off');
set(handles.Minus, 'Enable','off');


% --- Executes on button press in Plus.
function Plus_Callback(hObject, eventdata, handles)
% hObject    handle to Plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% XDgree = getappdata(0,'XDgree');
% XDgree = XDgree+1;
% setappdata(Handle1,'XDgree',XDgree);
Handle1 = getappdata(0,'Handle1');
z = getappdata(Handle1,'Zoom');
z = z*0.5;
setappdata(Handle1,'Zoom',z);


% --- Executes on button press in Minus.
function Minus_Callback(hObject, eventdata, handles)
% hObject    handle to Minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle1 = getappdata(0,'Handle1');
z = getappdata(Handle1,'Zoom');
z = z*2;
setappdata(Handle1,'Zoom',z);


function DeleteFcn(hObject, eventdata)
Handle1 = getappdata(0,'Handle1');
t = getappdata(Handle1,'TimerHandle');
if (t ~= [])
    stop(t);
    delete(t);
end
instantAiCtrl = getappdata(Handle1,'instantAiCtrl');
if (instantAiCtrl ~= [])
    instantAiCtrl.Dispose();
end



