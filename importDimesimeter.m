function [Seconds,Time,Lux,CLA,CS,Activity] = importDimesimeter(fileName)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   SOURCEDATA = IMPORTFILE(FILENAME) Reads
%   data from text file FILENAME for the default selection.
%
% Example:
%   sourceData =
%   importFile('Subject23_11Apr2013processed.txt');
%
%    See also TEXTSCAN.

%% Initialize variables.
delimiter = '\t';
startRow = 2;
endRow = inf;

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(fileName,'r');

%% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Create output variables
Seconds = cell2mat(dataArray(:, 1));
Time = 693960 + cell2mat(dataArray(:, 2)); % Convert Excel to Matlab format
Lux = cell2mat(dataArray(:, 3));
CLA = cell2mat(dataArray(:, 4));
CS = cell2mat(dataArray(:, 5));
Activity = cell2mat(dataArray(:, 6));

end