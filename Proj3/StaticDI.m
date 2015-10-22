% StaticDI.m
%
% Example Category:
%    DIO
% Matlab(2010 or 2010 above)
%
% Description:
%    This example demonstrates how to use Static DI function.
%
% Instructions for Running:
%    1. Set the 'deviceDescription' for opening the device. 
%    2. Set the 'startPort' as the first port for Di scanning.
%    3. Set the 'portCount' to decide how many sequential ports to 
%       operate Di scanning.
%
% I/O Connections Overview:
%    Please refer to your hardware reference manual.

function StaticDI()

% Make Automation.BDaq assembly visible to MATLAB.
BDaq = NET.addAssembly('Automation.BDaq');

% Configure the following three parameters before running the demo.
% The default device of project is demo device, users can choose other 
% devices according to their needs. 
deviceDescription = 'USB-4704,BID#0';
startPort = int32(0);
portCount = int32(1);
errorCode = Automation.BDaq.ErrorCode.Success;

% Step 1: Create a 'InstantDiCtrl' for DI function.
instantDiCtrl = Automation.BDaq.InstantDiCtrl();
setappdata(0,'instantDiCtrl',instantDiCtrl);
try
    % Step 2: Select a device by device number or device description and 
    % specify the access mode. In this example we use 
    % AccessWriteWithReset(default) mode so that we can fully control the 
    % device, including configuring, sampling, etc.
    instantDiCtrl.SelectedDevice = Automation.BDaq.DeviceInformation(...
        deviceDescription);
    
    % Step 3: read DI ports' status and show.
    buffer = NET.createArray('System.Byte', int32(64));
    InputTimer = timer('TimerFcn', {@TimerCallback, instantDiCtrl, startPort, ...
        portCount, buffer}, 'period', 0.1, 'executionmode', 'fixedrate');
    setappdata(0,'InputTimer',InputTimer);
%     start(InputTimer);
%     fprintf('Reading ports'' status is in progress...');
%     input('Press Enter key to quit!', 's');    
%     stop(InputTimer);
%     delete(InputTimer);
catch e
    % Something is wrong. 
    if BioFailed(errorCode)    
        errStr = 'Some error occurred. And the last error code is ' ... 
            + errorCode.ToString();
    else
        errStr = e.message;
    end
    disp(errStr);
end   

% Step 4: Close device and release any allocated resource.
% instantDiCtrl.Dispose();

end

function result = BioFailed(errorCode)

result =  errorCode < Automation.BDaq.ErrorCode.Success && ...
    errorCode >= Automation.BDaq.ErrorCode.ErrorHandleNotValid;

end

function TimerCallback(obj, event, instantDiCtrl, startPort, ...
    portCount, buffer)
data = getappdata(0,'data');
errorCode = instantDiCtrl.Read(startPort, portCount, buffer); 
if BioFailed(errorCode)
    throw Exception();
end
persistent flag;
if isempty(flag)
    flag = 0;
end

in = buffer.Get(0);
if (bitget(in,7))%1 for set, 0 for ready
    flag = flag+1;
    if (flag == 10)
        data.Freq = in - 64 - bitget(in,8)*128;
        setappdata(0,'data',data);
        flag = 0;
    else
        flag = flag + 1;
    end
else
   flag = 0;
   if (bitget(in,8))%1 for run
       InputTimer = getappdata(0,'InputTimer');
       instantDiCtrl = getappdata(0,'instantDiCtrl');
       if (isvalid(InputTimer))
           if (strcmp(InputTimer.Running,'on'))
               stop(InputTimer);
           end
           delete(InputTimer);
       end
       if (isvalid(instantDiCtrl))
           instantDiCtrl.Dispose();
       end
       setappdata(0,'InputTimer',InputTimer);
       setappdata(0,'instantDiCtrl',instantDiCtrl);
       StaticDO();
   end
end
end























