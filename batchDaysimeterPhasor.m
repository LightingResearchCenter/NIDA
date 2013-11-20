function batchDaysimeterPhasor
%BATCHPROCESSPHASOR Summary of this function goes here
%   Detailed explanation goes here

addpath('phasorAnalysis');
startDir = '\\ROOT\projects\NIDA';
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
out.meanDaytimeCS = cell(n,1);
out.peakCSperDay = cell(n,1);
out.centroidHour = cell(n,1);

for i1 = 1:n
    % import dimesimeter file
    dimeFile = fullfile(dimeDir,dimeListing(i1).name);
    [~,time1,~,~,CS1,activity1] = importDimesimeter(dimeFile);
    % Extract information from filename
    [~,name,~] = fileparts(dimeListing(i1).name);
    pattern = 'sub(\d*)_(\d*)-(\d*)-(\d*)_(\d*)-(\d*)-(\d*)';
    tokens = regexpi(name,pattern,'tokens');
    numTokens = str2double(tokens{1});
    out.subject{i1} = numTokens(1);
    fileStart = datenum(numTokens(2),numTokens(3),numTokens(4));
    fileEnd = datenum(numTokens(5),numTokens(6),numTokens(7));
    % Trim the data
    idx1 = time1 >= fileStart & time1 < fileEnd + 1;
    time = time1(idx1);
    activity = activity1(idx1);
    CS = CS1(idx1);
    % analyze the data
    [out.phasorMagnitude{i1},out.phasorAngle{i1},out.IS{i1},out.IV{i1},...
        out.mCS{i1},out.MagH{i1},out.f24abs{i1}] = ...
        phasorAnalysis(time, CS, activity);
    out.meanDaytimeCS{i1} = daytimeCS(time,CS,39.2833,-76.6167,-5);
    out.peakCSperDay{i1} = hoursPeakCS(time,CS,.63);
    [out.centroidHour{i1}, ~] = centroidCS(time,CS);
    % determine trial
    if weekday(time(1)) == 2
        out.trial{i1} = 'week';
    elseif weekday(time(1)) == 6
        out.trial{i1} = 'weekend';
    else
        out.trial{i1} = 'error';
    end
end

save('daysimeterPhasorAnalysis.mat','out');
close all;

end

