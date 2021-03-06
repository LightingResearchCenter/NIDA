function [BedTime,GetUpTime] = importSleepTimes(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [BEDTIME,GETUPTIME] = IMPORTFILE(FILENAME) Reads data from text file
%   FILENAME for the default selection.
%
%   [BEDTIME,GETUPTIME] = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data
%   from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   [BedTime,GetUpTime] = importfile('sub01_trial2.txt',2, 3);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2013/08/12 10:14:48

%% Initialize variables.
delimiter = 'to';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: text (%s)
%	column2: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
BedTime = datenum(dataArray{:, 1},'mm/dd/yyyy HH:MM');
GetUpTime = datenum(dataArray{:, 2},'mm/dd/yyyy HH:MM');

end

