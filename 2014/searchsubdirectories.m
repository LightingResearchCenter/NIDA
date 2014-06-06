function DataFileListing = searchsubdirectories(parentDir,dirPattern1,dirPattern2,filePattern)
%SEARCHSUBDIRECTORIES Summary of this function goes here
%   Detailed explanation goes here

Dir1Array = dir(fullfile(parentDir,dirPattern1));
nDir1 = numel(Dir1Array);

DataFileListing = struct;

ii = 1; % independent counter
for i1 = 1:nDir1
    
    currentSubject = regexprep(Dir1Array(i1).name,'(\d\d)*.','$1');
    
    currentDir1 = fullfile(parentDir,Dir1Array(i1).name);
    
    Dir2Array = dir(fullfile(currentDir1,dirPattern2));
    nDir2 = numel(Dir2Array);
    if isempty(Dir2Array)
        continue;
    end
    
    for i2 = 1:nDir2
        
        currentDir2 = fullfile(currentDir1,Dir2Array(i2).name);
        
        TempFileArray = dir(fullfile(currentDir2,filePattern));
        nFile = numel(TempFileArray);
        if isempty(TempFileArray)
            continue;
        end
        
        for i3 = 1:nFile
            DataFileListing(ii,1).path    = fullfile(currentDir2,TempFileArray(i3).name);
            DataFileListing(ii,1).name    = TempFileArray(i3).name;
            DataFileListing(ii,1).subject = str2double(currentSubject);
            
            ii = ii + 1;
        end
        
    end
    
end



end

