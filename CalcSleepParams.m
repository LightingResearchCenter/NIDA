function [SleepStart,SleepEnd,ActualSleep,ActualSleepPercent,...
    ActualWake,ActualWakePercent,SleepEfficiency,Latency,SleepBouts,...
    WakeBouts,MeanSleepBout,MeanWakeBout] = ...
    CalcSleepParams(Activity,Time,AnalysisStart,AnalysisEnd,...
    BedTime,GetUpTime,Subject)
%CALCSLEEPPARAMS Calculate sleep parameters using Actiware method
%   Values and calculations are taken from Avtiware-Sleep
%   Version 3.4 documentation Appendix: A-1 Actiwatch Algorithm

%% Trim Activity and Time to times within the Start and End of the analysis
% period
i = find(Time > AnalysisStart,1);
if i >= length(Time);
    error(['index = ',num2str(i)]);
elseif i > 1
    Activity(1:i) = [];
    Time(1:i) = [];
end
i = find(Time < AnalysisEnd,1,'last');
if i == 1
    error(['index = ',num2str(i)]);
elseif i < length(Time)
    Activity(i+1:end) = [];
    Time(i+1:end) = [];
end
clear i

%% Find the sleep state
SleepState = FindSleepState(Activity);

Epoch = etime(datevec(Time(2)),datevec(Time(1))); % Find epoch length
n = ceil(300/Epoch); % Number of points in a 5 minute interval

%% Find Sleep Start
i = 1+n;
while i <= length(SleepState)-n
    if length(find(SleepState(i-n:i+n)==0)) == 1
        SleepStartIndex = i;
        SleepStart = Time(i);
        break
    else
        i = i+1;
    end
end

% Set Sleep Start to Bed Time if it was not found
if exist('SleepStart','var') == 0
    SleepStart = BedTime;
    SleepStartIndex = find(Time > SleepStart,1);
end
if SleepStart < Time(1)
    SleepStart = Time(1);
    SleepStartIndex = 1;
end

%% Find Sleep End
j = length(Time)-n;
while j > n+1
    if length(find(SleepState(j-n:j+n)==0)) == 1
        SleepEndIndex = j;
        SleepEnd = Time(j);
        break
    else
        j = j-1;
    end
end

if exist('SleepEnd','var') == 0
    SleepEnd = GetUpTime;
    SleepEndIndex = find(Time > SleepEnd,1);
end
if SleepEnd > Time(end)
    SleepEnd = Time(end);
    SleepEndIndex = length(Time);
end
%% Calculate the parameters
% Calculate Assumed Sleep in minutes
AssumedSleep = etime(datevec(Time(SleepEndIndex)),datevec(Time(SleepStartIndex)))/60;
% Calculate Actual Sleep Time in minutes
ActualSleep = sum(SleepState(SleepStartIndex:SleepEndIndex))*Epoch/60;
% Calculate Actual Sleep Time Percentage
ActualSleepPercent = ActualSleep/AssumedSleep;
% Calculate Actual Wake Time in minutes
ActualWake = length(find(SleepState(SleepStartIndex:SleepEndIndex)==0))*Epoch/60;
% Calculate Actual Wake Time Percentage
ActualWakePercent = ActualWake/AssumedSleep;
% Calculate Sleep Efficiency in minutes
TimeInBed = etime(datevec(GetUpTime),datevec(BedTime))/60;
SleepEfficiency = ActualSleep/TimeInBed;
% Calculate Sleep Latency in minutes
Latency = etime(datevec(SleepStart),datevec(BedTime))/60;
% Find Sleep Bouts and Wake Bouts
SleepBouts = 0;
WakeBouts = 0;
for i = 2:length(SleepState)
    if SleepState(i) == 1 && SleepState(i-1) == 0
        SleepBouts = SleepBouts+1;
    end
    if SleepState(i) == 0 && SleepState(i-1) == 1
        WakeBouts = WakeBouts+1;
    end
end
% Calculate Mean Sleep Bout Time in minutes
MeanSleepBout = ActualSleep/SleepBouts;
% Claculate Mean Wake Bout Time in minutes
MeanWakeBout = ActualWake/WakeBouts;

if ActualSleep < 10 || SleepEfficiency > 100
    close all;
    plot(Time,Activity);
    datetick;
    title({['Subject: ',num2str(Subject)];...
        [datestr(Time(1),'mm/dd/yyyy HH:MM'),' - ',...
        datestr(Time(end),'mm/dd/yyyy HH:MM')]});
    saveas(gcf,['sub',num2str(Subject),'_',datestr(Time(1),'yyyy-mm-dd'),'.pdf']);
end

end