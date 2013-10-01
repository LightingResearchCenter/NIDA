function batchProcessPhasor
%BATCHPROCESSPHASOR Summary of this function goes here
%   Detailed explanation goes here

addpath('phasorAnalysis');
startDir = 'C:\Users\jonesg5\Desktop\NIDA';
actiDir = fullfile(startDir,'actiwatchData');
dimeDir = fullfile(startDir,'daysimeterDataLocalTime');

dimeListing = dir(fullfile(dimeDir,'sub*.txt'));

% Preallocate output dataset
n = length(dimeListing);
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
out.peakCSperDay = cell(n,1);

for i1 = 1:n
    % import dimesimeter file
    dimeFile = fullfile(dimeDir,dimeListing(i1).name);
    [~,dTime,~,~,dCS,dActivity] = importDimesimeter(dimeFile);
    fileBase = regexprep(dimeListing(i1).name,'\.txt','','ignorecase');
    % import actiwatch file
    actiFile = fullfile(actiDir,[fileBase,'.csv']);
    [aTime,aActivity,out.subject{i1}] = importActiwatch(actiFile);
    % combine the data
    ts1 = timeseries(dCS,dTime);
    ts2 = resample(ts1,aTime);
    CS = ts2.Data;
    time = aTime;
    activity = aActivity.*(mean(dActivity)/mean(aActivity));
    % remove NaN values
    idxNaN = isnan(CS) | isnan(activity);
    CS(idxNaN) = [];
    time(idxNaN) = [];
    activity(idxNaN) = [];
    % analyze the data
    [out.phasorMagnitude{i1},out.phasorAngle{i1},out.IS{i1},out.IV{i1},...
        out.mCS{i1},out.MagH{i1},out.f24abs{i1}] = ...
        phasorAnalysis(time, CS, activity);
    out.peakCSperDay{i1} = hoursPeakCS(time,CS,.67);
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

