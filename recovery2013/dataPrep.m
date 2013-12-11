function dataPrep(inputPath,outputPath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[Seconds,Lux,CLA,Activity,x,y] = importfile(inputPath);
matTime = Seconds/3600/24; % convert to MATLAB time
strTime = datestr(matTime,'HH:MM:SS mm/dd/yy');
Time = mat2cell(strTime,ones(size(strTime,1),1));
CS = CSCalc_postBerlin_12Aug2011(CLA);
exportfile(outputPath,Time,Lux,CLA,CS,Activity,x,y);

end

