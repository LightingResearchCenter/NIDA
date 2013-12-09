function exportfile(filename,Seconds,Time,Lux,CLA,CS,Activity)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Format string for the header line:
%   column1: string (%s) Seconds
%	column2: string (%s) Time
%   column3: string (%s) Lux
%	column4: string (%s) CLA
%   column5: string (%s) CS
%	column6: string (%s) Activity
% For more information, see the TEXTSCAN documentation.
formatSpecHeader = '%s\t%s\t%s\t%s\t%s\t%s\r\n';

%% Format string for each line of data:
%   column1: double (%f) Seconds
%	column2: double (%f) Time
%   column3: double (%f) Lux
%	column4: double (%f) CLA
%   column5: double (%f) CS
%	column6: double (%f) Activity
% For more information, see the TEXTSCAN documentation.
formatSpecData = '%f\t%f\t%f\t%f\t%f\t%f\r\n';

%% Open the text file.
fileID = fopen(filename,'w');

%% Write the header
fprintf(fileID,formatSpecHeader,'Seconds','Time','Lux','CLA','CS','Activity');

%% Write the data
fprintf(fileID,formatSpecData,[Seconds(:)';Time(:)';Lux(:)';CLA(:)';CS(:)';Activity(:)']);

%% Close the text file.
fclose(fileID);

end

