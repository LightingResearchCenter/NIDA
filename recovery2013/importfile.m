function [Seconds,Lux,CLA,Activity] = importfile(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [TIME1,LUX1,CLA1,ACTIVITY1,TEMPERATURE1,X1,Y1] = IMPORTFILE(FILENAME)
%   Reads data from text file FILENAME for the default selection.
%
%   [TIME1,LUX1,CLA1,ACTIVITY1,TEMPERATURE1,X1,Y1] = IMPORTFILE(FILENAME,
%   STARTROW, ENDROW) Reads data from rows STARTROW through ENDROW of text
%   file FILENAME.
%
% Example:
%   [time1,lux1,CLA1,activity1,temperature1,x1,y1] =
%   importfile('Daysimeter_0001_2013-12-09-11-14-11_Cal.txt',2, 3532);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2013/12/09 12:26:04

%% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
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
Seconds = dataArray{:, 1};
Lux = dataArray{:, 2};
CLA = dataArray{:, 3};
Activity = dataArray{:, 4};
% temperature = dataArray{:, 5};
% x = dataArray{:, 6};
% y = dataArray{:, 7};

end


