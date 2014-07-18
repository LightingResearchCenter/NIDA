function batchDaysimeterPhasor
%BATCHPROCESSPHASOR Summary of this function goes here
%   Detailed explanation goes here

[parentDir,~,~] = fileparts(pwd);
phasorToolkit = fullfile(parentDir,'PhasorAnalysis');
addpath(phasorToolkit);

projectDir = fullfile([filesep,filesep],'root','projects','NIDA','2011');
inputDir = fullfile(projectDir,'daysimeterDataLocalTime');
resultsDir = fullfile(projectDir,'results');
plotDir = fullfile(projectDir,'phasorPlots');

runtime = datestr(now,'yyyy-mm-dd_HHMM');


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

% Save results to Excel
phasorPath = fullfile(resultsDir,[runtime,'_Phasor.xlsx']);
cellPhasor = dataset2cell(Phasor);
varNameArray = cellPhasor(1,:);
prettyVarNameArray = lower(regexprep(varNameArray,'([^A-Z])([A-Z0-9])','$1 $2'));
cellPhasor(1,:) = prettyVarNameArray;
xlswrite([phasorPath,'.xlsx'],cellPhasor);

% Plot the phasors
%   Weekday phasors
magnitude = cell2mat(Phasor.wkDayMagnitude);
angle = cell2mat(Phasor.wkDayAngleHrs);
figure(1);
plotTitle = 'Weekdays';
plotphasorcompass(magnitude,angle,plotTitle)
plotPath = fullfile(plotDir,[runtime,'_phasorCompass_Weekday.jpg']);
saveas(1,plotPath);

%   Weekend phasors
magnitude = cell2mat(Phasor.wkEndMagnitude);
angle = cell2mat(Phasor.wkEndAngleHrs);
figure(2);
plotTitle = 'Weekends';
plotphasorcompass(magnitude,angle,plotTitle)
plotPath = fullfile(plotDir,[runtime,'_phasorCompass_Weekend.jpg']);
saveas(2,plotPath);

%   Combined phasors
magnitude = cell2mat(Phasor.combinedMagnitude);
angle = cell2mat(Phasor.combinedAngleHrs);
figure(3);
plotTitle = 'Combined';
plotphasorcompass(magnitude,angle,plotTitle)
plotPath = fullfile(plotDir,[runtime,'_phasorCompass_Combined.jpg']);
saveas(3,plotPath);

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