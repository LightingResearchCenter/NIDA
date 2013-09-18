function [subject,trial,day] = importExcludes(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE Import data from a spreadsheet
%   [subject,trial,day] = IMPORTFILE(FILE) reads data from the first
%   worksheet in the Microsoft Excel spreadsheet file named FILE and
%   returns the data as column vectors.
%
%   [subject,trial,day] = IMPORTFILE(FILE,SHEET) reads from the specified
%   worksheet.
%
%   [subject,trial,day] = IMPORTFILE(FILE,SHEET,STARTROW,ENDROW) reads from
%   the specified worksheet for the specified row interval(s). Specify
%   STARTROW and ENDROW as a pair of scalars or vectors of matching size
%   for dis-contiguous row intervals. To read to the end of the file
%   specify an ENDROW of inf.%
% Example:
%   [subject,trial,day] =
%   importfile('excludedSleepAnalysis.xlsx','Sheet1',2,22);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2013/09/18 16:01:45

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 2;
    endRow = 22;
end

%% Import the data
[~, ~, raw] = xlsread(workbookFile, sheetName, sprintf('A%d:C%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    [~, ~, tmpRawBlock] = xlsread(workbookFile, sheetName, sprintf('A%d:C%d',startRow(block),endRow(block)));
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
end
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,2);
raw = raw(:,[1,3]);

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
subject = data(:,1);
trial = cellVectors(:,1);
day = data(:,2);

