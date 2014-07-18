function batchlightandhealthreport
%BATCHPROCESSPHASOR Summary of this function goes here
%   Detailed explanation goes here

[parentDir,~,~] = fileparts(pwd);
phasorToolkit = fullfile(parentDir,'PhasorAnalysis');
LHIToolkit = fullfile(parentDir,'LHIReport');
addpath(phasorToolkit,LHIToolkit);

projectDir = fullfile([filesep,filesep],'root','projects','NIDA','2011');
inputDir = fullfile(projectDir,'daysimeterDataLocalTime');
plotDir = fullfile(projectDir,'lightAndHealthReports');

FileListing = dir(fullfile(inputDir,'sub*.txt'));

% Extract information from filename
%   Prepare listing of file names for decomposition
cellFileListing = struct2cell(FileListing);
fileNameArray = cellFileListing(1,:)';
%   Decompose file names
pattern = 'sub(\d*)_(\d*)-(\d*)-(\d*)_(\d*)-(\d*)-(\d*).txt';
tokens = regexpi(fileNameArray,pattern,'tokens');
%	Flatten nested parts of file names and convert from strings to numbers
tempTokens1 = cat(1,tokens{:,:});
tempTokens2 = cat(1,tempTokens1{:,:});
numTokens = str2double(tempTokens2);
%   Find subjects
fileSubjectArray = numTokens(:,1);
unqSubjectArray = unique(fileSubjectArray);
%   Find date ranges and convert to datenum
fileStartArray = datenum(numTokens(:,2),numTokens(:,3),numTokens(:,4));
fileEndArray = datenum(numTokens(:,5),numTokens(:,6),numTokens(:,7));

% Preallocate output datasets
nSubjects = numel(unqSubjectArray);
[hFigure,width,height,units] = initializefigure('on');

for i1 = 1:nSubjects
    % Find files that match the subject number
    idxSubject = fileSubjectArray == unqSubjectArray(i1);
    dimeFile = fullfile(inputDir,fileNameArray(idxSubject));
    
    subjectStartArray = fileStartArray(idxSubject);
    subjectEndArray = fileEndArray(idxSubject);
    
    % Preallocate variables
    nFiles = numel(dimeFile);
    
    for i2 = 1:nFiles
    % import dimesimeter file
        [~,timeArray,illuminanceArray,~,csArray,activityArray] = importDimesimeter(dimeFile{i2});

        % Trim the data
        idx1 = timeArray >= subjectStartArray(i2) & timeArray < subjectEndArray(i2) + 1;
        timeArray = timeArray(idx1);
        illuminanceArray = illuminanceArray(idx1);
        activityArray = activityArray(idx1);
        csArray = csArray(idx1);
        
        % Determine if weekend or weekday trial
        trialName = trial(timeArray);
        
        fileID = [num2str(unqSubjectArray(i1)),' ',trialName];
        generatereport(plotDir,timeArray,csArray,activityArray,illuminanceArray,fileID,hFigure,units,'Light and Health Report: NIDA 2011');
        clf(hFigure);
    end % end of i2
    
end % end of i1

close(hFigure);

end

% determine trial
function trialName = trial(timeArray)
dayOfWeek = weekday(timeArray(1));
switch dayOfWeek
    case 2
        trialName = 'weekday';
    case 6
        trialName = 'weekend';
    otherwise
        trialName = 'error';
end
end