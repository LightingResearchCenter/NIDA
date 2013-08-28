function batchProcessPhasor
%BATCHPROCESSPHASOR Summary of this function goes here
%   Detailed explanation goes here

addpath('phasorAnalysis');
startDir = 'C:\Users\jonesg5\Desktop\NIDA';
actiDir = uigetdir(startDir,'Select Actiwatch folder.');
dimeDir = uigetdir(startDir,'Select Dimesimeter folder.');

actiListing = dir(fullfile(actiDir,'sub*.csv'));

% Preallocate output dataset
n = length(actiListing);
out = struct;
out.subject = cell(n,1);
out.trial = cell(n,1);
out.phasorMagnitude = cell(n,1);
out.phasorAngle = cell(n,1);
out.IS = cell(n,1);
out.IV = cell(n,1);
out.mCS = cell(n,1);
out.MagH = cell(n,1);
out.f24abs = cell(n,1);

for i1 = 1:n
    % import actiwatch file
    actiFile = fullfile(actiDir,actiListing(i1).name);
    [aTime,aActivity,out.subject{i1}] = importActiwatch(actiFile);
    
    fileBase = regexprep(actiListing(i1).name,'\.csv','','ignorecase');
    % import dimesimeter file
    dimeFile = fullfile(dimeDir,[fileBase,'.txt']);
    [~,dTime,~,~,dCS,dActivity] = importDimesimeter(dimeFile);
    % combine the data
    ts1 = timeseries(dCS,dTime);
    ts2 = resample(ts1,aTime);
    CS = ts2.Data;
    time = aTime;
    activity = aActivity.*(mean(dActivity)/mean(aActivity));
    % analyze the data
    [out.phasorMagnitude{i1},out.phasorAngle{i1},out.IS{i1},out.IV{i1},...
        out.mCS{i1},out.MagH{i1},out.f24abs{i1}] = ...
        phasorAnalysis(time, CS, activity);
    % determine trial
    if weekday(aTime(1)) == 2
        out.trial{i1} = 'week';
    elseif weekday(aTime(1)) == 6
        out.trial{i1} = 'weekend';
    else
        out.trial{i1} = 'error';
    end
    close all
    Title = {['Subject ',num2str(out.subject{i1}),' ',out.trial{i1}];...
        [datestr(time(1),'mm/dd/yyyy HH:MM'),' - ',datestr(time(end),'mm/dd/yyyy HH:MM')]};
    PhasorReport(time,CS,activity,Title);
    reportFile = fullfile('phasorReports',[fileBase,'.pdf']);
    saveas(gcf,reportFile);
end

save('phasorAnalysis.mat','out');
close all;

end

