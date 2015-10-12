% InstantAI.m
%
% Example Category:
%    AI
% Matlab(2010 or 2010 above)
%
% Description:
%    This example demonstrates how to use Instant AI function.
%
% Instructions for Running:
%    1. Set the 'deviceDescription' for opening the device. 
%    2. Set the 'startChannel' as the first channel for scan analog samples  
%    3. Set the 'channelCount' to decide how many sequential channels to 
%       scan analog samples.
%
% I/O Connections Overview:
%    Please refer to your hardware reference manual.

function InstantAI()

% Make Automation.BDaq assembly visible to MATLAB.
BDaq = NET.addAssembly('Automation.BDaq');

% Configure the following three parameters before running the demo.
% The default device of project is demo device, users can choose other 
% devices according to their needs. 
deviceDescription = 'USB-4704,BID#0'; 
startChannel = int32(0);
channelCount = int32(1);

% Step 1: Create a 'InstantAiCtrl' for Instant AI function.
instantAiCtrl = Automation.BDaq.InstantAiCtrl();

try
    % Step 2: Select a device by device number or device description and 
    % specify the access mode. In this example we use 
    % AccessWriteWithReset(default) mode so that we can fully control the 
    % device, including configuring, sampling, etc.
    instantAiCtrl.SelectedDevice = Automation.BDaq.DeviceInformation(...
        deviceDescription);
    setappdata(0,'instantAiCtrl',instantAiCtrl);
    data = NET.createArray('System.Double', channelCount);
    
    % Step 3: Read samples and do post-process, we show data here.
    errorCode = Automation.BDaq.ErrorCode();
    Srate = getappdata(0,'Srate');
    TimerPeriod = round(1000/Srate)/1000;
    t = timer('TimerFcn', {@TimerCallback, instantAiCtrl, startChannel, ...
        channelCount, data}, 'period', TimerPeriod, 'executionmode', 'fixedrate', ...
        'StartDelay', 1);
    start(t);
    setappdata(0,'TimerHandle',t);
  %  input('InstantAI is in progress...Press Enter key to quit!');
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

end

function result = BioFailed(errorCode)

result =  errorCode < Automation.BDaq.ErrorCode.Success && ...
    errorCode >= Automation.BDaq.ErrorCode.ErrorHandleNotValid;

end

function TimerCallback(obj, event, instantAiCtrl, startChannel, ...
    channelCount, data)
  DataNow = data.Get(0);
  instantAiCtrl.Read(startChannel, channelCount, data); 
  Srate = getappdata(0,'Srate');
  PointCount = getappdata(0,'PointCount');
  TimePoint = PointCount/ Srate;
  Y = [TimePoint;DataNow];
  SignalSave = getappdata(0,'SignalSave');
  SignalSave = [SignalSave,Y];
  FileNum = getappdata(0,'FileNum');
  PlotArea = getappdata(0,'PlotArea');
  h = getappdata(0,'LineHandle');
  z = getappdata(0,'Zoom');
  XTmp = get(h,'XData');
  YTmp = get(h,'YData');
  if (length(XTmp)==1024*1024)
      XTmp = XTmp(1024*512:1024*1024);
      YTmp = YTmp(1024*512:1024*1024);
  end
  if (length(SignalSave)<Srate*10)
      set(h,'XData',[XTmp,TimePoint],'YData',[YTmp,DataNow]);
      set(PlotArea,'Xlim',[TimePoint-5*z,TimePoint+0.2*z],'Ylim',[-1.5,1.5],'XTick',[round(TimePoint-5*z):z:round(TimePoint+0.2*z)]);
      setappdata(0,'SignalSave',SignalSave);
  else       
      save(['Signal',int2str(FileNum)],'SignalSave');
      SignalSave = [];
      FileNum = FileNum+1;
      setappdata(0,'SignalSave',SignalSave);
      setappdata(0,'FileNum',FileNum);
  end
  PointCount = PointCount + 1;
  setappdata(0,'PointCount',PointCount);
end