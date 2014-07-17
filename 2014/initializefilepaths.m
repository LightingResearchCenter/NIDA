function [Directories,LogPaths] = initializefilepaths
%INITIALIZEFILEPATHS Prepare and return necessary file paths
%   Detailed explanation goes here

% Initialize output structs
Directories = struct;
LogPaths    = struct;

% Directories
Directories.project      = fullfile([filesep,filesep],'ROOT','projects','NIDA','2014Data');
Directories.originalData = fullfile(Directories.project,'originalData');
Directories.results      = fullfile(Directories.project,'results');
Directories.daysigram    = fullfile(Directories.project,'daysigrams');
Directories.plots        = fullfile(Directories.project,'plots');

% Log file paths
LogPaths.bed = fullfile(Directories.project,'bedLog.xlsx');
LogPaths.use = fullfile(Directories.project,'useLog.xlsx');

end

