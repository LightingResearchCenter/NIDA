function batchPrep
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

inputPath = {'\\ROOT\projects\NIDA\2013recoveredData\Daysimeter_0001_2013-12-09-11-14-11_Cal.txt';
    '\\ROOT\projects\NIDA\2013recoveredData\Daysimeter_0005_2013-12-09-11-24-51_Cal.txt';
    '\\ROOT\projects\NIDA\2013recoveredData\Daysimeter_0102_2013-12-09-11-28-57_Cal.txt'};

outputPath = {'\\ROOT\projects\NIDA\2013recoveredData\Daysimeter_0001_2013-12-09-11-14-11.txt';
    '\\ROOT\projects\NIDA\2013recoveredData\Daysimeter_0005_2013-12-09-11-24-51.txt';
    '\\ROOT\projects\NIDA\2013recoveredData\Daysimeter_0102_2013-12-09-11-28-57.txt'};


for i1 = 1:3
    dataPrep(inputPath{i1},outputPath{i1});
end

end

