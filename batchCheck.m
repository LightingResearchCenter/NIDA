function batchCheck
%BATCHPROCESS Summary of this function goes here
%   Detailed explanation goes here
startDir = 'C:\Users\jonesg5\Desktop\NIDA';
% actiDir = uigetdir(startDir,'Select Actiwatch folder.');
actiDir = fullfile(startDir,'actiwatchData');
% dimeDir = uigetdir(startDir,'Select Dimesimeter folder.');
dimeDir = fullfile(startDir,'dimesimeterDataLocalTime');
% [sleepFile,sleepDir,~] = uigetfile([startDir,filesep,'.xlsx'],'Select Sleep Log');
sleepDir = startDir;
sleepFile = 'sleepLog.xlsx';

[logSubject,bedTime,wakeTime] = importSleepLog(fullfile(sleepDir,sleepFile));

actiListing = dir(fullfile(actiDir,'sub*.csv'));

% Preallocate
n = length(actiListing);

figure;
for i1 = 1:n
    % select actiwatch file
    actiFile = fullfile(actiDir,actiListing(i1).name);
    
    % select dimesimeter file
    fileBase = regexprep(actiListing(i1).name,'\.csv','','ignorecase');
    dimeFile = fullfile(dimeDir,[fileBase,'.txt']);
    
    % extract subject from filename
    [~,name,~] = fileparts(actiFile);
    pattern    = 'sub(\d*)_(\d*)-(\d*)-(\d*)_(\d*)-(\d*)-(\d*)';
    tokens     = regexpi(name,pattern,'tokens');
    numTokens  = str2double(tokens{1});
    subject    = numTokens(1);
    
    % select sleep times
    idx = logSubject == subject;
    
    % check files
    checkFiles(actiFile,dimeFile,bedTime(idx),wakeTime(idx));
    
end
close('all');

end

