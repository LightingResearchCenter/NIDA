function organizeExcelPhasor
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
header = [{'subject'},{'Week'},{'Weekend'}];

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
    output = cell(nSubjects,3);
    for i2 = 1:nSubjects
        output{i2,1} = unqSubjects(i2);
        idxSub = subject == unqSubjects(i2);
        try
            subjectDataWK = data{i1,1}{idxSub & idxWK};
        catch
            subjectDataWK = data{i1,1}(idxSub & idxWK);
        end
        try
            subjectDataWE = data{i1,1}{idxSub & idxWE};
        catch
            subjectDataWE = data{i1,1}(idxSub & idxWE);
        end
        output{i2,2} = subjectDataWK;
        output{i2,3} = subjectDataWE;
    end
    % Replace empty cells with better empty cells
    idxEmpty = cellfun('isempty',output);
    output(idxEmpty) = {[]};
    
    % Create Excel file and write output to appropriate sheet
    sheetName = varNames{i1}; % Set sheet names
    sheetTitle = [varNames(i1),{[]},{[]}]; % Create title
    xlswrite(saveFile,[sheetTitle;header;output],sheetName); % Write to file
end

end

