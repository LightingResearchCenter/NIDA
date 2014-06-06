function [Directories,LogPaths,DaysimeterArray,DimesimeterArray] = initializefilepaths
%INITIALIZEFILEPATHS Prepare and return necessary file paths
%   Detailed explanation goes here

% Initialize output structs
Directories = struct;
LogPaths    = struct;
DataPaths   = struct;

% Directories
Directories.project   = fullfile([filesep,filesep],'ROOT','projects','NIDA','2014Data');
Directories.results   = fullfile(Directories.project,'results');
Directories.daysigram = fullfile(Directories.project,'daysigrams');
Directories.plots     = fullfile(Directories.project,'plots');

% Log file paths
LogPaths.bed = fullfile(Directories.project,'bedLog.xlsx');
LogPaths.use = fullfile(Directories.project,'useLog.xlsx');

% Search for Swizzle Stick Daysimeter and Daysimeter 12 files
subjectDirPattern = '*checked*';
dayDirPattern     = '*daysimeter';
dimeDirPattern    = '*dimesimeter';
dayPattern        = 'Daysimeter*.log';
dimePattern       = '*header.txt';

DaysimeterArray  = searchsubdirectories(Directories.project,...
    subjectDirPattern,dayDirPattern,dayPattern);

DimesimeterArray = searchsubdirectories(Directories.project,...
    subjectDirPattern,dimeDirPattern,dimePattern);


end

