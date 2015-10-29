% StaticAO.m
%
% Example Category:
%    AO
% Matlab(2010 or 2010 above)
%
% Description:
%    This example demonstrates how to use Static AO  voltage function.
%
% Instructions for Running:
%    1. Set the 'deviceDescription' for opening the device. 
%    2. Set the 'channelStart' as the first channel for  analog data
%       Output. 
%    3. Set the 'channelCount' to decide how many sequential channels to
%       output analog data. 
%
% I/O Connections Overview:
%    Please refer to your hardware reference manual.

function StaticAO()
Handle2 = getappdata(0,'Handle2');

% Make Automation.BDaq assembly visible to MATLAB.
BDaq = NET.addAssembly('Automation.BDaq');

% Define how many data to makeup a waveform period.
%oneWavePointCount = int32(512);

% Configure the following three parameters before running the demo.
% The default device of project is demo device, users can set other devices 
% according to their needs. 
deviceDescription = 'USB-4704,BID#0';
channelStart = int32(0);
channelCount = int32(1);

% Declare the type of signal. If you want to specify the type of output 
% signal, please change 'style' parameter in the GenerateWaveform function.
% parent_id = H5T.copy('H5T_NATIVE_UINT');
% WaveStyle = H5T.enum_create(parent_id);
% H5T.enum_insert(WaveStyle, 'Sine', 0);
% H5T.enum_insert(WaveStyle, 'Sawtooth', 1);
% H5T.enum_insert(WaveStyle, 'Square', 2);
% H5T.close(parent_id);

errorCode = Automation.BDaq.ErrorCode.Success;

% Step 1: Create a 'InstantAoCtrl' for Instant AO function.
instantAoCtrl = Automation.BDaq.InstantAoCtrl();
setappdata(Handle2,'instantAoCtrl',instantAoCtrl);
try
    % Step 2: Select a device by device number or device description and 
    % specify the access mode. In this example we use 
    % AccessWriteWithReset(default) mode so that we can fully control the 
    % device, including configuring, sampling, etc.
    instantAoCtrl.SelectedDevice = Automation.BDaq.DeviceInformation(...
        deviceDescription);
    
    % Step 3: Output data. 
    % Generate waveform data.
    data = getappdata(Handle2,'data');
    FreqOut = data.FreqOut;
    SrateOut = data.SrateOut;
    oneWavePointCount = ceil(SrateOut/FreqOut)+1;
    scaledWaveForm = NET.createArray('System.Double', channelCount * ...
        oneWavePointCount);
    errorCode = GenerateWaveform(instantAoCtrl, channelStart, ...
        channelCount, scaledWaveForm, channelCount * oneWavePointCount,SrateOut,FreqOut);
    if BioFailed(errorCode)    
        throw Exception();
    end


    % Output data
    scaleData = NET.createArray('System.Double', int32(64));
    
    TimerPeriod = round(1000/SrateOut)/1000;
    t = timer('TimerFcn',{@TimerCallback, instantAoCtrl, ...
        oneWavePointCount, scaleData, scaledWaveForm, channelStart, ...
        channelCount}, 'period', TimerPeriod, 'executionmode', 'fixedrate', ...
        'StartDelay', 1);
    setappdata(Handle2,'t',t);
    
catch e
    % Something is wrong. 
    if BioFailed(errorCode)    
        errStr = 'Some error occurred. And the last error code is ' ... 
            + errorCode.ToString();
    else
        errStr = e.message;
    end
    setappdata(Handle2,'errStr',errStr);

end   


end

function errorcode = GenerateWaveform(instantAoCtrl, channelStart,...
    channelCount, waveBuffer, SamplesCount,SrateOut,FreqOut)

errorcode = Automation.BDaq.ErrorCode.Success;
chanCountMax = int32(instantAoCtrl.Features.ChannelCountMax);
oneWaveSamplesCount = int32(SamplesCount / channelCount);

description = System.Text.StringBuilder();
unit = Automation.BDaq.ValueUnit;
ranges = NET.createArray('Automation.BDaq.MathInterval', chanCountMax); 

% get every channel's value range ,include external reference voltage
% value range which you should key it in manually.
channels = instantAoCtrl.Channels;
for i = 1:chanCountMax
    channel = channels.Get(i - 1);
    valRange = channel.ValueRange;
    if Automation.BDaq.ValueRange.V_ExternalRefBipolar == valRange ...
            || valRange == Automation.BDaq.ValueRange.V_ExternalRefUnipolar
        if instantAoCtrl.Features.ExternalRefAntiPolar
            if valRange == Automation.BDaq.ValueRange.V_ExternalRefBipolar
                referenceValue = double(...
                    instantAoCtrl.ExtRefValueForBipolar);
                if referenceValue >= 0
                    ranges(i).Max = referenceValue;
                    ranges(i).Min = 0 - referenceValue;
                else
                    ranges(i).Max = 0 - referenceValue;
                    ranges(i).Min = referenceValue;                    
                end
            else
               referenceValue = double(...
                   instantAoCtrl.ExtRefValueForUnipolar); 
               if referenceValue >= 0
                   ranges(i).Max = 0;
                   ranges(i).Min = 0 - referenceValue;
               else
                   ranges(i).Max = 0 - referenceValue;
                   ranges(i).Min = 0;
               end 
            end
        else
            if valRange == Automation.BDaq.ValueRange.V_ExternalRefBipolar
                referenceValue = double(...
                    instantAoCtrl.ExtRefValueForBipolar);
                if referenceValue >= 0
                    ranges(i).Max = referenceValue;
                    ranges(i).Min = 0 - referenceValue;
                else
                    ranges(i).Max = 0 - referenceValue;
                    ranges(i).Min = referenceValue;                    
                end
            else
                referenceValue = double(...
                    instantAoCtrl.ExtRefValueForUnipolar);
                if referenceValue >= 0
                    ranges(i).Max = referenceValue;
                    ranges(i).Min = 0;
                else
                    ranges(i).Max = 0;
                    ranges(i).Min = 0 - referenceValue;
                end
            end
        end
    else     
        [errorcode, ranges(i), unit] = ...
            Automation.BDaq.BDaqApi.AdxGetValueRangeInformation(...
            valRange, int32(0), description);
        if BioFailed(errorcode)
            return
        end
    end
end

% generate waveform data and put them into the buffer which the parameter
% 'waveBuffer' give in, the Amplitude these waveform

for i = 0:(oneWaveSamplesCount - 1)
    for j = channelStart:(channelStart + channelCount - 1)
        % pay attention to channel rollback(when startChannel+
        % channelCount>chanCountMax)
        channel = int32(rem(j, chanCountMax));
        amplitude = 1;
        offset = 1;        
%         amplitude = double((ranges.Get(channel).Max -...
%             ranges.Get(channel).Min) / 2);
%         offset = double((ranges.Get(channel).Max + ...
%             ranges.Get(channel).Min) / 2);
        waveBuffer.Set(i * channelCount + j - channelStart,...
                    amplitude * sin(double(i) * 2.0 * pi / ...
                    double(SrateOut) *FreqOut) + offset);
    end
end
           

end

function result = BioFailed(errorCode)

result =  errorCode < Automation.BDaq.ErrorCode.Success && ...
    errorCode >= Automation.BDaq.ErrorCode.ErrorHandleNotValid;

end

function TimerCallback(obj, event, instantAoCtrl, oneWavePointCount, ...
    scaleData, scaledWaveForm, channelStart, channelCount)

Handle2 = getappdata(0,'Handle2');

data = getappdata(Handle2,'data');
Duration = data.Duration;
SrateOut = data.SrateOut;
Step = 1/SrateOut;
time = getappdata(Handle2,'time');
if isempty(time)
    time = 0;
else
    time = time + Step;
end

i = getappdata(Handle2,'i');
if isempty(i)
    i = 0;
else
    i = i + 1;
end

  PlotArea = getappdata(Handle2,'PlotArea');
  h = getappdata(Handle2,'LineHandle');
  XTmp = get(h,'XData');
  YTmp = get(h,'YData');
  if (length(XTmp)==1024*1024)
      XTmp = XTmp(1024*512:1024*1024);
      YTmp = YTmp(1024*512:1024*1024);
  end
if i <= (oneWavePointCount - 1)
    Value = scaledWaveForm.Get(channelCount * i);
    scaleData.Set(0, Value);
    set(h,'XData',[XTmp,time],'YData',[YTmp,Value]);
    set(PlotArea,'Xlim',[time-5,time+0.2],'Ylim',[-1,3],'XTick',[round(time-5):1:round(time+0.2)]);

    errorCode = instantAoCtrl.Write(channelStart,...
        channelCount, scaleData);
    if BioFailed(errorCode)
        e = MException('DAQWarning:Notcompleted', ...
            'StaticAO is completed compulsorily!');
        throw (e);
    end
else
    i = 0;
end
t = getappdata(Handle2,'t');
if (Duration ~= -1 && time >= Duration)
    time = [];
    i = [];
    stop(t);
    delete(t);
    handles = getappdata(Handle2,'GUIhandle');
    set(handles.OutputStart,'Enable','on');
    set(handles.OutputStop,'Enable','off');
    set(handles.OutputRestart,'Enable','off');
    set(handles.SrateReset,'Enable','on');
    set(handles.FreqReset,'Enable','on');
    set(handles.OutputModeReset,'Enable','on');
end
setappdata(Handle2,'time',time);
setappdata(Handle2,'i',i);

end




















