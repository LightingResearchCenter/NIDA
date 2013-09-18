function organizeExcelSleep
%ORGANIZEEXCEL Organize input data and save to Excel
%   Format for Mariana
[inputName, inputPath] = uigetfile('*.mat');
inputFile = fullfile(inputPath,inputName);
load(inputFile);
saveFile = regexprep(inputFile,'\.mat','\.xlsx');
inputData = out;
clear outputData;

%% Determine size of input and variable names
varNames = fieldnames(inputData);
% Remove subject, and trial from varNames
varNameIdx = strcmpi(varNames,'subject') | strcmpi(varNames,'trial');
varNames(varNameIdx) = [];
nVars = length(varNames);

%% Create header labels
header = [{'subject'},{'WeekD1'},{'WeekD2'},{'WeekD3'},...
    {'WeekendD1'},{'WeekendD2'},{'WeekendD3'}];

%% Organize data
% Seperate subject and trial from rest of the data
subject = cell2mat(inputData.subject);
trial = inputData.trial;
inputData = rmfield(inputData,{'subject','trial'});
% Convert data to cells
data = struct2cell(inputData);

unqSubjects = unique(subject);
nSubjects = length(unqSubjects);

idxWK = strcmpi('week',trial);
idxWE = strcmpi('weekend',trial);

for i1 = 1:nVars
    output = cell(nSubjects,6);
    for i2 = 1:nSubjects
        output{i2,1} = unqSubjects(i2);
        idxSub = subject == unqSubjects(i2);
        try
            subjectDataWK = data{i1,1}{idxSub & idxWK};
        catch
            subjectDataWK = ['error';'error';'error'];
        end
        try
            subjectDataWE = data{i1,1}{idxSub & idxWE};
        catch
            subjectDataWE = ['error';'error';'error'];
        end
        nWKnight = length(subjectDataWK);
        nWEnight = length(subjectDataWE);
        for i3 = 1:3
            if i3 <= nWKnight
                output{i2,i3+1} = subjectDataWK(i3,:);
            end
        end
        for i3 = 1:3
            if i3 <= nWEnight
                output{i2,i3+4} = subjectDataWE(i3,:);
            end
        end
    end
    
    % Create Excel file and write output to appropriate sheet
    sheetName = varNames{i1}; % Set sheet names
    sheetTitle = [varNames(i1),{[]},{[]},{[]},{[]},{[]},{[]}]; % Create title
    xlswrite(saveFile,[sheetTitle;header;output],sheetName); % Write to file
end

end

