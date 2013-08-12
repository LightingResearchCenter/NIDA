function batchProcess
%BATCHPROCESS Summary of this function goes here
%   Detailed explanation goes here
startDir = 'C:\Users\jonesg5\Desktop\NIDA';
actiDir = uigetdir(startDir,'Select Actiwatch folder.');
sleepDir = uigetdir(startDir,'Select sleep time folder.');

actiListing = dir(fullfile(actiDir,'sub*.txt'));

% Preallocate output dataset
n = length(actiListing);
out = struct([]);
out.subject = cell(n,1);
out.trial = cell(n,1);
out.sleep = cell(n,1);
out.sleepPercent = cell(n,1);
out.wake = cell(n,1);
out.wakePercent = cell(n,1);
out.sleepEfficiency = cell(n,1);
out.latency = cell(n,1);
out.sleepBouts = cell(n,1);
out.wakeBouts = cell(n,1);
out.meanSleepBout = cell(n,1);
out.meanWakeBout = cell(n,1);

for i1 = 1:n
    % import actiwatch file
    actiFile = fullfile(actiDir,actiListing(i1).name);
    [time,activity,out.subject{i1}] = importActiwatch(actiFile);
    % determine trial
    if weekday(time(1)) == 2
        out.trial{i1} = 'week';
    elseif weekday(time(1)) == 6
        out.trial{i1} = 'weekend';
    else
        out.trial{i1} = 'error';
    end
    % import sleep time file
    sleepFile = fullfile(sleepDir,[actiListing(i1).name(1:16),'.txt']);
    [out.bedTime{i1},out.getUpTime{i1}] = importSleepTimes(sleepFile);
    % analyze the data
    [out.sleep{i1},out.sleepPercent{i1},out.wake{i1},out.wakePercent{i1},...
        out.sleepEfficiency{i1},out.latency{i1},out.sleepBouts{i1},...
        out.wakeBouts{i1},out.meanSleepBout{i1},out.meanWakeBout{i1}]...
        = AnalyzeFile(time,activity,out.bedTime{i1},out.getUpTime{i1});
end

save('sleepAnalysis.mat','out');

end

