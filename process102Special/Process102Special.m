function Process102Special

inputPath = 'C:\Users\jonesg5\Desktop\Daysimeter_0102_2013-11-21-10-10-19.log';
outputPath = 'C:\Users\jonesg5\Desktop\Daysimeter_0102_2013-11-21-10-10-19processed.txt';

% read the file
fid = fopen(inputPath);
scan = textscan(fid, '%f');
raw = scan{1};
fclose(fid);
header = raw(1:16);
data = raw(17:end);

%organize data in to rgba
IDnum = header(2);
year = 2000 + header(3);
month = header(4);
day = header(5);
hour = header(6);
minute = header(7);
logInterval = header(8);
startTime = datenum(year,month,day,hour,minute,0);

% preallocate data
n = floor(numel(data)/8);
A = ones(n,1)*65535;
R = ones(n,1)*65535;
G = ones(n,1)*65535;
B = ones(n,1)*65535;

j = 1;
for i = 1:8:numel(data)
    R(j) = 256*data(i) + data(i + 1);
    G(j) = 256*data(i + 2) + data(i + 3);
    B(j) = 256*data(i + 4) + data(i + 5);
    A(j) = 256*data(i + 6) + data(i + 7);
    flag1(j) = data(i + 6);
    flag2(j) = data(i + 7);
    j = j + 1;
end
flag1 = mod(flag1,2);
flag2 = mod(flag2,2);
% remove unwritten (value = 65535)
unwritten = R == 65535;
R(unwritten) = [];
G(unwritten) = [];
B(unwritten) = [];
A(unwritten) = [];

% consolidate resets and remove extra (value = 65278)
resets0 = R == 65278;
resets = circshift(resets0(:),-1);
R(resets0) = [];
G(resets0) = [];
B(resets0) = [];
A(resets0) = [];
resets(resets0) = [];

% Range Flag adjustment
q = (mod(A,2)==1);
R(q) = R(q)*10;
G(q) = G(q)*10;
B(q) = B(q)*10;
% A(q) = A(q) - 1;

% create an Excel format time array
time = (0:numel(R)-1)*(logInterval/(60*60*24))+startTime - 693960;

% read R,G,B calibration constants
g = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\Day12 RGB Values.txt');
%find line corresponding to id number
for i = 1:IDnum
    fgetl(g);
end

%pull in RGB calibration constants
fscanf(g, '%d', 1);
cal = zeros(1,3);
for i = 1:3
    cal(i) = fscanf(g, '%f', 1);
end


% convert activity to rms g
% raw activity is a mean squared value, 1 count = .0039 g's, and the 4 comes
% from four right shifts in the source code
activity = (sqrt(A))*.0039*4;

% calibrate to illuminant A
red = R*cal(1);
green = G*cal(2);
blue = B*cal(3);

% calculate lux and CLA
[lux, CLA] = Day12luxCLA(red, green, blue, IDnum);
CLA(CLA < 0) = 0;

% filter CLA and activity
CLA = filter5min(CLA,logInterval);
activity = filter5min(activity,logInterval);

% calculate CS
CS = CSCalc(CLA);

end

