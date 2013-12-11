function exportfile(filename,Time,Lux,CLA,CS,Activity,x,y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Format string for the header line:
%   column1: string (%s) Time
%	column2: string (%s) Lux
%   column3: string (%s) CLA
%	column4: string (%s) CS
%   column5: string (%s) Activity
%	column6: string (%s) x
%	column7: string (%s) y
% For more information, see the TEXTSCAN documentation.
formatSpecHeader = '%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n';

%% Format string for each line of data:
%   column1: string (%s) Time
%	column2: string (%f) Lux
%   column3: string (%f) CLA
%	column4: string (%f) CS
%   column5: string (%f) Activity
%	column6: string (%f) x
%	column7: string (%f) y
% For more information, see the TEXTSCAN documentation.
formatSpecData = '%s\t%f\t%f\t%f\t%f\t%f\t%f\r\n';

%% Open the text file.
fileID = fopen(filename,'w');

%% Write the header
fprintf(fileID,formatSpecHeader,'Time','Lux','CLA','CS','Activity','x','y');

%% Write the data
for i1 = 1:numel(Time)
    fprintf(fileID,formatSpecData,Time{i1},Lux(i1),CLA(i1),CS(i1),Activity(i1),x(i1),y(i1));
end

%% Close the text file.
fclose(fileID);

end

