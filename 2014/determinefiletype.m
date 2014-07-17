function fileType = determinefiletype(filePath)
%DETERMINEFILETYPE Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(filePath);
content = fread(fid);
fclose(fid);

end

