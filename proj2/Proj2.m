function varargout = Proj2(varargin)
% PROJ2 MATLAB code for Proj2.fig
%      PROJ2, by itself, creates a new PROJ2 or raises the existing
%      singleton*.
%
%      H = PROJ2 returns the handle to a new PROJ2 or the handle to
%      the existing singleton*.
%
%      PROJ2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJ2.M with the given input arguments.
%
%      PROJ2('Property','Value',...) creates a new PROJ2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Proj2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Proj2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Proj2

% Last Modified by GUIDE v2.5 19-Oct-2015 02:12:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Proj2_OpeningFcn, ...
                   'gui_OutputFcn',  @Proj2_OutputFcn, ...
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


% --- Executes just before Proj2 is made visible.
function Proj2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Proj2 (see VARARGIN)

% Choose default command line output for Proj2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

data.FreqOut = 1;
data.SrateOut = 50;
data.Duration = [];
data.Flag = 0;
setappdata(0,'data',data);
setappdata(0,'PlotArea',handles.axes1);
h = line;
set(h,'Marker','*','LineStyle','none');
h.Parent = handles.axes1;
setappdata(0,'LineHandle',h);
set(handles.figure1, 'DeleteFcn', {@DeleteFcn});
set(handles.FreqReset,'Enable','off');
set(handles.SrateReset,'Enable','off');
set(handles.OutputModeReset,'Enable','off');
set(handles.OutputStop,'Enable','off');
set(handles.OutputRestart,'Enable','off');
setappdata(0,'GUIhandle',handles);

% UIWAIT makes Proj2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Proj2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






function FreqValue_Callback(hObject, eventdata, handles)
% hObject    handle to FreqValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FreqValue as text
%        str2double(get(hObject,'String')) returns contents of FreqValue as a double


% --- Executes during object creation, after setting all properties.
function FreqValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FreqValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function SrateValue_Callback(hObject, eventdata, handles)
% hObject    handle to SrateValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SrateValue as text
%        str2double(get(hObject,'String')) returns contents of SrateValue as a double


% --- Executes during object creation, after setting all properties.
function SrateValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SrateValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in OutGiveTime.
function OutGiveTime_Callback(hObject, eventdata, handles)
% hObject    handle to OutGiveTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OutGiveTime
set(handles.ContinuousOut,'value',0);
set(handles.OutputTimeValue,'Enable','on');

% --- Executes on button press in ContinuousOut.
function ContinuousOut_Callback(hObject, eventdata, handles)
% hObject    handle to ContinuousOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ContinuousOut
set(handles.OutGiveTime,'value',0);
set(handles.OutputTimeValue,'Enable','off');


function OutputTimeValue_Callback(hObject, eventdata, handles)
% hObject    handle to OutputTimeValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputTimeValue as text
%        str2double(get(hObject,'String')) returns contents of OutputTimeValue as a double


% --- Executes during object creation, after setting all properties.
function OutputTimeValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputTimeValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OutputModeConfirm.
function OutputModeConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to OutputModeConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(0,'data');
if (get(handles.ContinuousOut,'value') == 1)
    data.Duration = -1;
    data.Flag = data.Flag + 1;
    set(handles.OutputModeReset,'Enable','on');
    set(handles.OutputModeConfirm,'Enable','off');
    set(handles.OutputTimeValue,'Enable','off');
    set(handles.ContinuousOut,'Enable','off');
    set(handles.OutGiveTime,'Enable','off');
else
    if (get(handles.OutGiveTime,'value') == 1)
        TimeTmp = str2double(get(handles.OutputTimeValue,'String'));
        if ( isnan(TimeTmp) || TimeTmp < 0)
            errordlg('Please input positive numbers!');
        else
            data.Duration = TimeTmp;
            data.Flag = data.Flag + 1;
            set(handles.OutputModeReset,'Enable','on');
            set(handles.OutputModeConfirm,'Enable','off');
            set(handles.OutputTimeValue,'Enable','off');
            set(handles.ContinuousOut,'Enable','off');
            set(handles.OutGiveTime,'Enable','off');
        end
    else
         errordlg('Please Choose an output mode');
    end
end
setappdata(0,'data',data);


% --- Executes on button press in OutputModeReset.
function OutputModeReset_Callback(hObject, eventdata, handles)
% hObject    handle to OutputModeReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(0,'data');
data.Flag = data.Flag - 1;
setappdata(0,'data',data);
set(handles.OutputModeReset,'Enable','off');
set(handles.OutputModeConfirm,'Enable','on');
set(handles.OutputTimeValue,'Enable','on');
set(handles.ContinuousOut,'Enable','on');
set(handles.OutGiveTime,'Enable','on');
set(handles.OutputStart,'Enable','on');
set(handles.OutputStop,'Enable','off');
set(handles.OutputRestart,'Enable','off');


% --- Executes on button press in FreqConfirm.
function FreqConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to FreqConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(0,'data');
FreqTmp = str2double(get(handles.FreqValue,'String'));
if ( isnan(FreqTmp) || FreqTmp < 0)
    errordlg('Please input positive numbers!');
else
    data.FreqOut = FreqTmp;
    data.Flag = data.Flag + 1;
    set(handles.FreqReset,'Enable','on');
    set(handles.FreqConfirm,'Enable','off');
    set(handles.FreqValue,'Enable','off');
end

setappdata(0,'data',data);


% --- Executes on button press in FreqReset.
function FreqReset_Callback(hObject, eventdata, handles)
% hObject    handle to FreqReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(0,'data');
data.Flag = data.Flag - 1;
setappdata(0,'data',data);
set(handles.FreqReset,'Enable','off');
set(handles.FreqConfirm,'Enable','on');
set(handles.FreqValue,'Enable','on');
set(handles.OutputStart,'Enable','on');
set(handles.OutputStop,'Enable','off');
set(handles.OutputRestart,'Enable','off');


% --- Executes on button press in SrateConfirm.
function SrateConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to SrateConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(0,'data');
SrateTmp = str2double(get(handles.SrateValue,'String'));
if ( isnan(SrateTmp) || SrateTmp < 0)
    errordlg('Please input positive numbers!');
else
    data.SrateOut = SrateTmp;
    data.Flag = data.Flag + 1;
    set(handles.SrateReset,'Enable','on');
    set(handles.SrateConfirm,'Enable','off');
    set(handles.SrateValue,'Enable','off');
end
setappdata(0,'data',data);


% --- Executes on button press in SrateReset.
function SrateReset_Callback(hObject, eventdata, handles)
% hObject    handle to SrateReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(0,'data');
data.Flag = data.Flag - 1;
setappdata(0,'data',data);
set(handles.SrateReset,'Enable','off');
set(handles.SrateConfirm,'Enable','on');
set(handles.SrateValue,'Enable','on');
set(handles.OutputStart,'Enable','on');
set(handles.OutputStop,'Enable','off');
set(handles.OutputRestart,'Enable','off');


% --- Executes on button press in OutputStart.
function OutputStart_Callback(hObject, eventdata, handles)
% hObject    handle to OutputStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 h = getappdata(0,'LineHandle');
set(h,'XData',[],'YData',[]);
data = getappdata(0,'data');

if (data.Flag == 3)
    setappdata(0,'time',[]);
    setappdata(0,'i',[]);
    StaticAO();
    errStr = getappdata(0,'errStr');
    if (isempty(errStr))
        t = getappdata(0,'t');
        start(t);
        setappdata(0,'t',t);
        set(handles.OutputStart,'Enable','off');
        set(handles.OutputStop,'Enable','on');
        set(handles.OutputRestart,'Enable','on');
        set(handles.SrateReset,'Enable','off');
        set(handles.FreqReset,'Enable','off');
        set(handles.OutputModeReset,'Enable','off');
    else
        errordlg(errStr);
        setappdata(0,'errStr',[]);
    end
else
    errordlg('Make sure you confirm all your inputs');
end


% --- Executes on button press in OutputStop.
function OutputStop_Callback(hObject, eventdata, handles)
% hObject    handle to OutputStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = getappdata(0,'t');
if isvalid(t)
    if (strcmp(t.Running,'on'))
        stop(t);
    end
    delete(t);
    set(handles.OutputStart,'Enable','on');
    set(handles.OutputStop,'Enable','off');
    set(handles.OutputRestart,'Enable','off');
    set(handles.SrateReset,'Enable','on');
    set(handles.FreqReset,'Enable','on');
    set(handles.OutputModeReset,'Enable','on');
    setappdata(0,'time',[]);
    setappdata(0,'i',[]);
end
 setappdata(0,'t',t);
 
 % --- Executes on button press in OutputRestart.
function OutputRestart_Callback(hObject, eventdata, handles)
% hObject    handle to OutputRestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = getappdata(0,'t');
if isvalid(t)
    if (strcmp(t.Running,'on'))
        stop(t);
        set(handles.SrateReset,'Enable','on');
        set(handles.FreqReset,'Enable','on');
        set(handles.OutputModeReset,'Enable','on');
    else
        start(t);
        set(handles.SrateReset,'Enable','off');
        set(handles.FreqReset,'Enable','off');
        set(handles.OutputModeReset,'Enable','off');
    end
end

setappdata(0,'t',t);




function DeleteFcn(hObject, eventdata)
t = getappdata(0,'t');
if (t ~= [])
    if (strcmp(t.Running,'on'))
        stop(t);
    end
    delete(t);
end

instantAoCtrl = getappdata(0,'instantAoCtrl');
if (instantAoCtrl ~= [])
    instantAoCtrl.Dispose();
end
