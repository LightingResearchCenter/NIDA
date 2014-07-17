function FileListing = searchsubdirectories(parentDir,validExt,ignoreStr)
%SEARCHSUBDIRECTORIES Summary of this function goes here
%   Detailed explanation goes here

Dir1Array = dir(parentDir);
nDir1 = numel(Dir1Array);

FileListing = struct;

ii = 1; % independent counter
for i1 = 1:nDir1
    
    if strcmp('.',Dir1Array(i1).name) || strcmp('..',Dir1Array(i1).name)
        continue;
    end
    
    currentSubject = regexprep(Dir1Array(i1).name,'(\d\d).*','$1');
    currentCompleter = ~strcmpi(regexprep(Dir1Array(i1).name,'.*(noncompleter).*','$1','ignorecase'),'noncompleter');
    
    currentDir1 = fullfile(parentDir,Dir1Array(i1).name);
    
    Dir2Array = dir(currentDir1);
    nDir2 = numel(Dir2Array);
    if isempty(Dir2Array)
        continue;
    end
    
    for i2 = 1:nDir2
        
        if strcmp('.',Dir2Array(i2).name) || strcmp('..',Dir2Array(i2).name)
            continue;
        end
        
        currentDevice = lower(regexprep(Dir2Array(i2).name,...
            '.*(daysimeter|dimesimeter).*','$1','ignorecase'));
        
        currentDir2 = fullfile(currentDir1,Dir2Array(i2).name);
        
        TempFileArray = dir(currentDir2);
        nFile = numel(TempFileArray);
        if isempty(TempFileArray)
            continue;
        end
        
        for i3 = 1:nFile
            
            if strcmp('.',TempFileArray(i3).name) || strcmp('..',TempFileArray(i3).name)
                continue;
            end
            
            [~,~,currentExt] = fileparts(TempFileArray(i3).name);
            
            if ~strcmp(currentExt,validExt)
                continue;
            end
            
            if strcmpi(regexprep(TempFileArray(i3).name,['.*(',ignoreStr,').*'],'$1','ignorecase'),ignoreStr)
                continue;
            end
            
            FileListing(ii,1).path      = fullfile(currentDir2,TempFileArray(i3).name);
            FileListing(ii,1).name      = TempFileArray(i3).name;
            FileListing(ii,1).ext       = currentExt;
            FileListing(ii,1).device    = currentDevice;
            FileListing(ii,1).subject   = str2double(currentSubject);
            FileListing(ii,1).completer = currentCompleter;
            
            ii = ii + 1;
        end
        
    end
    
end

FileListing = struct2dataset(FileListing);


end

