function varargout = Proj3(varargin)
% PROJ3 MATLAB code for Proj3.fig
%      PROJ3, by itself, creates a new PROJ3 or raises the existing
%      singleton*.
%
%      H = PROJ3 returns the handle to a new PROJ3 or the handle to
%      the existing singleton*.
%
%      PROJ3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJ3.M with the given input arguments.
%
%      PROJ3('Property','Value',...) creates a new PROJ3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Proj3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Proj3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Proj3

% Last Modified by GUIDE v2.5 22-Oct-2015 10:13:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Proj3_OpeningFcn, ...
                   'gui_OutputFcn',  @Proj3_OutputFcn, ...
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


% --- Executes just before Proj3 is made visible.
function Proj3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Proj3 (see VARARGIN)

% Choose default command line output for Proj3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes Proj3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Proj3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle3 = gcf;
setappdata(0,'Handle3',Handle3);
% Get default command line output from handles structure
varargout{1} = handles.output;
setappdata(Handle3,'GUIhandle',handles);
data.ControlMode = '';
data.Freq = 20;
data.Duration = -1;
data.Flag = 0;
setappdata(Handle3,'data',data);
set(handles.figure1, 'DeleteFcn', {@DeleteFcn});
set(handles.FreqConfirm,'Enable','off');
set(handles.FreqReset,'Enable','off');
set(handles.FreqValue,'Enable','off');
set(handles.DurationConfirm,'Enable','off');
set(handles.DurationReset,'Enable','off');
set(handles.DurationValue,'Enable','off');
set(handles.OutputStart,'Enable','off');
set(handles.OutputRestart,'Enable','off');
set(handles.OutputStop,'Enable','off');
set(handles.OutputContinuous,'Enable','off');
set(handles.OutputGiven,'Enable','off');


% --- Executes on button press in GUIControl.
function GUIControl_Callback(hObject, eventdata, handles)
% hObject    handle to GUIControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle3 = getappdata(0,'Handle3');
OutputTimer = getappdata(Handle3,'OutputTimer');
if (isa(OutputTimer,'timer')&&isvalid(OutputTimer))
    if (strcmp(OutputTimer.Running,'on'))
        stop(OutputTimer);
    end
    delete(OutputTimer);

end
set(handles.GUIControl,'Enable','off');
set(handles.HardControl,'Enable','on');
set(handles.FreqConfirm,'Enable','on');
set(handles.FreqValue,'Enable','on');
set(handles.OutputContinuous,'Enable','on');
set(handles.OutputGiven,'Enable','on');
set(handles.DurationConfirm,'Enable','on');
set(handles.DurationValue,'Enable','on');
set(handles.OutputStart,'Enable','on');
data = getappdata(Handle3,'data');
data.ControlMode = 'GUI';
data.Flag = 0;
setappdata(Handle3,'data',data);

% --- Executes on button press in HardControl.
function HardControl_Callback(hObject, eventdata, handles)
% hObject    handle to HardControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle3 = getappdata(0,'Handle3');
set(handles.GUIControl,'Enable','on');
set(handles.HardControl,'Enable','off');
set(handles.FreqConfirm,'Enable','off');
set(handles.FreqReset,'Enable','off');
set(handles.FreqValue,'Enable','off');
set(handles.OutputContinuous,'Enable','off');
set(handles.OutputGiven,'Enable','off');
set(handles.DurationConfirm,'Enable','off');
set(handles.DurationReset,'Enable','off');
set(handles.DurationValue,'Enable','off');
set(handles.OutputStart,'Enable','off');
set(handles.OutputRestart,'Enable','off');
set(handles.OutputStop,'Enable','off');
data = getappdata(Handle3,'data');
data.ControlMode = 'Hard';
data.Duration = -1;
setappdata(Handle3,'data',data);
OutputTimer = getappdata(Handle3,'OutputTimer');
if (isa(OutputTimer,'timer')&&isvalid(OutputTimer))
    if (strcmp(OutputTimer.Running,'on'))
        stop(OutputTimer);
    end
    delete(OutputTimer);
end
StaticDI();
InputTimer = getappdata(Handle3,'InputTimer');
start(InputTimer);
setappdata(Handle3,'InputTimer',InputTimer);

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


% --- Executes on button press in FreqConfirm.
function FreqConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to FreqConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle3 = getappdata(0,'Handle3');
FreqTmp = str2double(get(handles.FreqValue,'String'));
if ( isnan(FreqTmp) || FreqTmp < 0)
    errordlg('Please input positive numbers!');
else
    data = getappdata(Handle3,'data');
    data.Freq = FreqTmp;
    data.Flag = data.Flag+1 ;
    setappdata(Handle3,'data',data);
    set(handles.FreqConfirm,'Enable','off');
    set(handles.FreqReset,'Enable','on');
    set(handles.FreqValue,'Enable','off');
    set(handles.OutputStart,'Enable','on');
end



% --- Executes on button press in FreqReset.
function FreqReset_Callback(hObject, eventdata, handles)
% hObject    handle to FreqReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle3 = getappdata(0,'Handle3');
data = getappdata(Handle3,'data');
data.Flag = data.Flag - 1;
setappdata(Handle3,'data',data);
set(handles.FreqConfirm,'Enable','on');
set(handles.FreqReset,'Enable','off');
set(handles.FreqValue,'Enable','on');



% --- Executes on button press in OutputContinuous.
function OutputContinuous_Callback(hObject, eventdata, handles)
% hObject    handle to OutputContinuous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OutputContinuous
set(handles.OutputGiven,'value',0);
set(handles.DurationValue,'Enable','off');


% --- Executes on button press in OutputGiven.
function OutputGiven_Callback(hObject, eventdata, handles)
% hObject    handle to OutputGiven (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OutputGiven
set(handles.OutputContinuous,'value',0);
set(handles.DurationValue,'Enable','on');



function DurationValue_Callback(hObject, eventdata, handles)
% hObject    handle to DurationValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DurationValue as text
%        str2double(get(hObject,'String')) returns contents of DurationValue as a double


% --- Executes during object creation, after setting all properties.
function DurationValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DurationValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DurationConfirm.
function DurationConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to DurationConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle3 = getappdata(0,'Handle3');
data = getappdata(Handle3,'data');
if (get(handles.OutputContinuous,'value') == 1)
    data.Duration = -1;
    data.Flag = data.Flag + 1;
    set(handles.DurationReset,'Enable','on');
    set(handles.OutputContinuous,'Enable','off');
    set(handles.OutputGiven,'Enable','off');
    set(handles.DurationConfirm,'Enable','off');
    set(handles.DurationValue,'Enable','off');
    set(handles.OutputContinuous,'Enable','off');
    set(handles.OutputGiven,'Enable','off');
else
    if (get(handles.OutputGiven,'value') == 1)
        DurationTmp = str2double(get(handles.DurationValue,'String'));
        if ( isnan(DurationTmp) || DurationTmp < 0)
            errordlg('Please input positive numbers!');
        else
            data.Duration = DurationTmp;
            data.Flag = data.Flag + 1;
            set(handles.DurationReset,'Enable','on');
            set(handles.DurationConfirm,'Enable','off');
            set(handles.DurationValue,'Enable','off');
            set(handles.OutputContinuous,'Enable','off');
            set(handles.OutputGiven,'Enable','off');
        end
    else
         errordlg('Please Choose an output mode');
    end
end
setappdata(Handle3,'data',data);


% --- Executes on button press in DurationReset.
function DurationReset_Callback(hObject, eventdata, handles)
% hObject    handle to DurationReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle3 = getappdata(0,'Handle3');
data = getappdata(Handle3,'data');
data.Flag = data.Flag - 1;
setappdata(Handle3,'data',data);
set(handles.DurationReset,'Enable','off');
set(handles.DurationConfirm,'Enable','on');
set(handles.DurationValue,'Enable','on');
set(handles.OutputContinuous,'Enable','on');
set(handles.OutputGiven,'Enable','on');
set(handles.OutputStart,'Enable','on');
set(handles.OutputStop,'Enable','off');
set(handles.OutputRestart,'Enable','off');


% --- Executes on button press in OutputStart.
function OutputStart_Callback(hObject, eventdata, handles)
% hObject    handle to OutputStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle3 = getappdata(0,'Handle3');
data = getappdata(Handle3,'data');
if (data.Flag == 2)
    OutputTimer = getappdata(Handle3,'OutputTimer');
    if (isa(OutputTimer,'timer')&&isvalid(OutputTimer))
        if (strcmp(OutputTimer.Running,'on'))
            stop(OutputTimer);
        end
        delete(OutputTimer);
        setappdata(Handle3,'OutputTimer',OutputTimer);
    end
    StaticDO();
    errStr = getappdata(Handle3,'errStr');
    if (isempty(errStr))
        OutputTimer = getappdata(Handle3,'OutputTimer');
        set(handles.OutputStart,'Enable','off');
        set(handles.OutputRestart,'Enable','on');
        set(handles.OutputStop,'Enable','on');
        set(handles.FreqReset,'Enable','off');
        set(handles.DurationReset,'Enable','off');
        start(OutputTimer);
        setappdata(Handle3,'OutputTimer',OutputTimer);
    else
        errordlg(errStr);
        setappdata(Handle3,'errStr',[]);
    end
else  
    errordlg('Make sure you confirm all your inputs');
end


% --- Executes on button press in OutputRestart.
function OutputRestart_Callback(hObject, eventdata, handles)
% hObject    handle to OutputRestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputTimer = getappdata(Handle3,'OutputTimer');
Handle3 = getappdata(0,'Handle3');
if (isa(OutputTimer,'timer'))
    if (strcmp(OutputTimer.Running,'on'))
        stop(OutputTimer);
       
    else
        start(OutputTimer);
       
    end
    setappdata(Handle3,'OutputTimer',OutputTimer);
end



% --- Executes on button press in OutputStop.
function OutputStop_Callback(hObject, eventdata, handles)
% hObject    handle to OutputStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Handle3 = getappdata(0,'Handle3');
OutputTimer = getappdata(Handle3,'OutputTimer');
if (isa(OutputTimer,'timer'))
    if (strcmp(OutputTimer.Running,'on'))
        stop(OutputTimer);
    end
    delete(OutputTimer);
    setappdata(Handle3,'OutputTimer',OutputTimer);
end


set(handles.OutputStart,'Enable','on');
set(handles.OutputStop,'Enable','off');
set(handles.OutputRestart,'Enable','off');
set(handles.FreqReset,'Enable','on');
set(handles.DurationReset,'Enable','on');



function DeleteFcn(hObject, eventdata)
Handle3 = getappdata(0,'Handle3');
OutputTimer = getappdata(Handle3,'OutputTimer');
if (isa(OutputTimer,'timer')&&isvalid(OutputTimer))
    if (strcmp(OutputTimer.Running,'on'))
        stop(OutputTimer);
    end
    delete(OutputTimer);
    setappdata(Handle3,'OutputTimer',OutputTimer);
end
InputTimer = getappdata(Handle3,'InputTimer');
if (isa(InputTimer,'timer')&&isvalid(InputTimer))
    if (strcmp(InputTimer.Running,'on'))
        stop(InputTimer);
    end
    delete(InputTimer);
    setappdata(Handle3,'InputTimer',InputTimer);
end
instantDoCtrl = getappdata(Handle3,'instantDoCtrl');
if (isa(instantDoCtrl,'Automation.BDaq.InstantDoCtrl'))
    instantDoCtrl.Dispose();
end
instantDiCtrl = getappdata(Handle3,'instantDiCtrl');
if (isa(instantDiCtrl,'Automation.BDaq.InstantDoCtrl'))
    instantDiCtrl.Dispose();
end
