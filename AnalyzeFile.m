function [ActualSleep,ActualSleepPercent,ActualWake,...
    ActualWakePercent,SleepEfficiency,Latency,SleepBouts,WakeBouts,...
    MeanSleepBout,MeanWakeBout] = AnalyzeFile(time,activity,BedTime,GetUpTime,Subject,Trial,exSubject,exTrial,exDay)
Days = length(BedTime);

% Preallocate AnalysisStart and AnalysisEnd
AnalysisStart = zeros(Days,1);
AnalysisEnd = zeros(Days,1);

% Set AnalysisStart and AnalysisEnd for each day
for i = 1:Days
    AnalysisStart(i) = addtodate(BedTime(i),0,'minute');
    AnalysisEnd(i) = addtodate(GetUpTime(i),0,'minute');
end

% Preallocate sleep parameters
SleepStart = zeros(Days,1);
SleepEnd = zeros(Days,1);
ActualSleep = zeros(Days,1);
ActualSleepPercent = zeros(Days,1);
ActualWake = zeros(Days,1);
ActualWakePercent = zeros(Days,1);
SleepEfficiency = zeros(Days,1);
Latency = zeros(Days,1);
SleepBouts = zeros(Days,1);
WakeBouts = zeros(Days,1);
MeanSleepBout = zeros(Days,1);
MeanWakeBout = zeros(Days,1);
% Call function to calculate sleep parameters for each day
for i = 1:Days
    isExcluded = max(exSubject == Subject &...
        strcmpi(Trial,exTrial) & exDay == i);
    if isExcluded
        continue;
    end
[SleepStart(i),SleepEnd(i),ActualSleep(i),ActualSleepPercent(i),...
    ActualWake(i),ActualWakePercent(i),SleepEfficiency(i),Latency(i),...
    SleepBouts(i),WakeBouts(i),MeanSleepBout(i),MeanWakeBout(i)] = ...
    CalcSleepParams(activity,time,AnalysisStart(i),AnalysisEnd(i),...
    BedTime(i),GetUpTime(i),Subject);
end

end