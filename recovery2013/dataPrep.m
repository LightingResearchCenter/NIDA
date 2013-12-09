function dataPrep(inputPath,outputPath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[Seconds,Lux,CLA,Activity] = importfile(inputPath);
Time = Seconds/3600/24 - 693960; % convert to Excel time
CS = CSCalc_postBerlin_12Aug2011(CLA);
exportfile(outputPath,Seconds,Time,Lux,CLA,CS,Activity);

end

