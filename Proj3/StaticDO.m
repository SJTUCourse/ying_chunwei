% StaticDO.m
%
% Example Category:
%    DIO
% Matlab(2010 or 2010 above)
%
% Description:
%    This example demonstrates how to use Static DO function.
%
% Instructions for Running:
%    1. Set the 'deviceDescription' for opening the device. 
%    2. Set the 'startPort' as the first port for Do.
%    3. Set the 'portCount' to decide how many sequential ports to 
%       operate Do.
%
% I/O Connections Overview:
%    Please refer to your hardware reference manual.

function StaticDO()
Handle3 = getappdata(0,'Handle3');
% Make Automation.BDaq assembly visible to MATLAB.
BDaq = NET.addAssembly('Automation.BDaq');

% Configure the following three parameters before running the demo.
% The default device of project is demo device, users can choose other 
% devices according to their needs. 
deviceDescription = 'USB-4704,BID#0'; 
startPort = int32(0);
portCount = int32(1);

errorCode = Automation.BDaq.ErrorCode.Success;

% Step 1: Create a 'InstantDoCtrl' for DO function.
instantDoCtrl = Automation.BDaq.InstantDoCtrl();
setappdata(Handle3,'instantDoCtrl',instantDoCtrl);
try
    % Step 2: Select a device by device number or device description and 
    % specify the access mode. In this example we use 
    % AccessWriteWithReset(default) mode so that we can fully control the 
    % device, including configuring, sampling, etc.
    instantDoCtrl.SelectedDevice = Automation.BDaq.DeviceInformation(...
        deviceDescription);
    
    % Step 3: Write DO ports
    bufferForWriting = NET.createArray('System.Byte', int32(64));
%     for i = 0:(portCount - 1)
%         fprintf('Input a hexadecimal number for DO port %d to output', ...
%             startPort + i);
%         strData = input('(for example, 0x11)\n', 's'); 
%         strData = System.String(strData);
%         if strData.Substring(0, 2) == '0x'
%             strData = strData.Remove(0, 2);
%         end
%         strData = hex2dec(char(strData));      
%         bufferForWriting.Set(i, strData); 
%     end
    data = getappdata(Handle3,'data');
    TimerPeriod = round(500/double(data.Freq))/1000;
    OutputTimer = timer('TimerFcn',{@TimerCallback,instantDoCtrl,bufferForWriting}, 'period', TimerPeriod, ...
        'executionmode', 'fixedrate');  
    if (strcmp(data.ControlMode,'Hard'))  
       start(OutputTimer);
       setappdata(Handle3,'OutputTimer',OutputTimer);
    else
        setappdata(Handle3,'OutputTimer',OutputTimer); 
    end
%     disp('DO output compl eted!');
%     % Read back the DO status.
%     % Note:
%     % For relay output, the read back must be deferred until 
%     % the relay is stable.
%     % The delay time is decided by the HW SPEC.
%     bufferForReading = NET.createArray('System.Byte', int32(64));
%     instantDoCtrl.Read(startPort, portCount, bufferForReading);
%     if BioFailed(errorCode)
%         throw  Exception();
%    end
%     % Show DO ports' status
%     for i = startPort:(portCount + startPort - 1)
%        fprintf('Now, DO port %d status is:  0x%X\n', i, ...
%             bufferForReading.Get(i - startPort));
%     end
catch e
    % Something is wrong. 
    if BioFailed(errorCode)    
        errStr = 'Some error occurred. And the last error code is ' ... 
            + errorCode.ToString();
    else
        errStr = e.message;
    end
    setappdata(Handle3,'errStr',errStr);
end   

% Step 4: Close device and release any allocated resource.
% instantDoCtrl.Dispose();

end

function result = BioFailed(errorCode)

result =  errorCode < Automation.BDaq.ErrorCode.Success && ...
    errorCode >= Automation.BDaq.ErrorCode.ErrorHandleNotValid;

end


function TimerCallback(obj, event,instantDoCtrl,bufferForWriting)
Handle3 = getappdata(0,'Handle3');
persistent i ;
if isempty(i)
    i = 0;
else
    i = ~i;
end
data = getappdata(Handle3,'data');
persistent time;
if isempty(time)
    time = 0.0;
else
    time = time+0.5/double(data.Freq);
end
bufferForWriting.Set(0,i);
errorCode = instantDoCtrl.Write(0,1,bufferForWriting);
if BioFailed(errorCode)
    throw  Exception();
end
if (data.Duration ~= -1 && time > data.Duration)
    time = 0;
    i = 0;
    handles = getappdata(Handle3,'GUIhandle');
    set(handles.OutputStart,'Enable','on');
    set(handles.OutputStop,'Enable','off');
    set(handles.OutputRestart,'Enable','off');
    set(handles.FreqReset,'Enable','off');
    set(handles.DurationReset,'Enable','off');
    OutputTimer = getappdata(Handle3,'OutputTimer');
    stop(OutputTimer);
    delete(OutputTimer);
    setappdata(Handle3,'OutputTimer',OutputTimer);
    return;
end






end
    






















