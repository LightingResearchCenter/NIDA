function batchDaysimeterPhasor
%BATCHPROCESSPHASOR Summary of this function goes here
%   Detailed explanation goes here

[parentDir,~,~] = fileparts(pwd);
phasorToolkit = fullfile(parentDir,'PhasorAnalysis');
addpath(phasorToolkit);

projectDir = fullfile([filesep,filesep],'root','projects','NIDA','2011');
inputDir = fullfile(projectDir,'daysimeterDataLocalTime');
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
emptyCell = cell(nSubjects,1);
Phasor = dataset;
Phasor.subject = unqSubjectArray;
Phasor.wkDayMagnitude = emptyCell;
Phasor.wkDayAngleHrs = emptyCell;
Phasor.wkEndMagnitude = emptyCell;
Phasor.wkEndAngleHrs = emptyCell;
Phasor.combinedMagnitude = emptyCell;
Phasor.combinedAngleHrs = emptyCell;

for i1 = 1:nSubjects
    % Find files that match the subject number
    idxSubject = fileSubjectArray == unqSubjectArray(i1);
    dimeFile = fullfile(inputDir,fileNameArray(idxSubject));
    
    subjectStartArray = fileStartArray(idxSubject);
    subjectEndArray = fileEndArray(idxSubject);
    
    % Preallocate variables
    nFiles = numel(dimeFile);
    timeArray = cell(nFiles,1);
    csArray = cell(nFiles,1);
    activityArray = cell(nFiles,1);
    
    for i2 = 1:nFiles
    % import dimesimeter file
        [~,timeArray{i2,1},~,~,csArray{i2,1},activityArray{i2,1}] = importDimesimeter(dimeFile{i2});

        % Trim the data
        idx1 = timeArray{i2,1} >= subjectStartArray(i2) & timeArray{i2,1} < subjectEndArray(i2) + 1;
        timeArray{i2,1} = timeArray{i2,1}(idx1);
        activityArray{i2,1} = activityArray{i2,1}(idx1);
        csArray{i2,1} = csArray{i2,1}(idx1);
        % analyze the data
        TempPhasor = phasoranalysis(timeArray{i2,1},csArray{i2,1},activityArray{i2,1});
        
        % Determine if weekend or weekday trial
        trialName = trial(timeArray{i2,1});
        
        % Reassign output
        switch trialName
            case 'weekday'
                Phasor.wkDayMagnitude{i1} = TempPhasor.magnitude;
                Phasor.wkDayAngleHrs{i1} = TempPhasor.angleHrs;
            case 'weekend'
                Phasor.wkEndMagnitude{i1} = TempPhasor.magnitude;
                Phasor.wkEndAngleHrs{i1} = TempPhasor.angleHrs;
            otherwise
                error('Unknown trial session');
        end % end of switch
    end % end of i2
    
    % Combine weekday and weekend
    if nFiles == 2
        % Combine data
        timeArray = cat(1,timeArray{:,:});
        csArray = cat(1,csArray{:,:});
        activityArray = cat(1,activityArray{:,:});
        % Sort data by time
        [timeArray,srtIdx] = sort(timeArray);
        csArray = csArray(srtIdx);
        activityArray = activityArray(srtIdx);
        % Analyze data
        TempPhasor = phasoranalysis(timeArray,csArray,activityArray);
        % Reassign output
        Phasor.combinedMagnitude{i1} = TempPhasor.magnitude;
        Phasor.combinedAngleHrs{i1} = TempPhasor.angleHrs;
    end % end of if
    

end % end of i1

% Average the results
MeanPhasor = dataset;
MeanPhasor.wkDayMagnitude = mean(cell2mat(Phasor.wkDayMagnitude));
MeanPhasor.wkDayAngleHrs = mean(cell2mat(Phasor.wkDayAngleHrs));
MeanPhasor.wkEndMagnitude = mean(cell2mat(Phasor.wkEndMagnitude));
MeanPhasor.wkEndAngleHrs = mean(cell2mat(Phasor.wkDayAngleHrs));
MeanPhasor.combinedMagnitude = mean(cell2mat(Phasor.combinedMagnitude));
MeanPhasor.combinedAngleHrs = mean(cell2mat(Phasor.combinedAngleHrs));

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