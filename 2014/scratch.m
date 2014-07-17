clear
clc

[Directories,LogPaths] = initializefilepaths;

validExt = {'','.log','.txt'};
ignoreStr = 'note';
FileListing = searchsubdirectories(Directories.originalData,validExt,ignoreStr);