addpath('C:\Users\jonesg5\Documents\GitHub\HANDLS\archive')
addpath('C:\Users\jonesg5\Documents\GitHub\NIDA\recovery2013')

% select raw data and header files
StartPath = 'C:\Users\jonesg5\desktop'; % directory to start in
[InfoName,InfoPath] = uigetfile('*.txt','Select log_info.txt',StartPath);
[DataName,DataPath] = uigetfile('*.txt','Select data_log.txt',InfoPath);
% save the full paths for the source files
InfoName = fullfile(InfoPath,InfoName);
DataName = fullfile(DataPath,DataName);

ProcessedData = ReadRaw(InfoName,DataName);
time = ProcessedData.time;
time = datestr(time,'HH:MM:SS mm/dd/yy');
time = mat2cell(time,ones(size(time,1),1));

red = ProcessedData.red(:);
green = ProcessedData.green(:);
blue = ProcessedData.blue(:);
lux = ProcessedData.lux(:);
CLA = ProcessedData.CLA(:);
CS = ProcessedData.CS(:);
activity = ProcessedData.activity(:);

%%
h = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\Other Calibration Values_Ithaca.txt');
%pull in chromaticity conversion constants
while(fscanf(h, '%c', 1) ~= '#')
end
chrom = sscanf(fgetl(h), '%f %f %f')';
while(fscanf(h, '%c', 1) ~= '#')
end
chrom = vertcat(chrom, sscanf(fgetl(h), '%f %f %f')');
while(fscanf(h, '%c', 1) ~= '#')
end
%chrom is lines 3 - 5 (3x3 matrix)
chrom = vertcat(chrom, sscanf(fgetl(h), '%f %f %f')');
%find chromaticity coordinates
tristim = [red green blue] * chrom;
for i = 1:length(red)
    if((red(i) > 5) && (green(i) > 5) && (blue(i) > 4))
        Chrom(i,:) = tristim(i,:)/sum(tristim(i,:));
    else
        Chrom(i,:) = [0 0 0];
    end
end
x = Chrom(:,1);
y = Chrom(:,2);

%%
filename = [DataName(1:end-4) '_Processed.txt']; % name of text file

exportfile(filename,time,lux,CLA,CS,activity,x,y)