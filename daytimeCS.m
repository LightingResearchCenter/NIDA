function meanDaytimeCS = daytimeCS(timeD,CS,lat,lon,GMToff)
%DAYTIMECS Calculates mean CS during daylight that is nonzero
%   Inputs:
%       timeD	= time in datenum format
%       CS      = circadian stimulus
%       lat     = latitude, scalar
%       lon     = longitude, scalar
%       GMToff	= offset from GMT to timezone used

%% Calculate sunrise and sunset times
% Find the dates that are included in the data
Date = unique(floor(timeD));
Date = Date(:)'; % make sure Date is a vertical vector

% Caluclate approximate sunrise and sunset time
[sunrise,sunset] = simpleSunCycle(lat,lon,Date);

% Adjust sunrise and sunset times from GMT to desired timezone
sunrise = sunrise + GMToff/24 + isDST(Date)/24;
sunset = sunset + GMToff/24 + isDST(Date)/24;

%% Find times that occur during the day
% Preallocate the logical index
dayIdx = false(size(timeD));
% Add indexes for daytime of each day
for i1 = 1:numel(Date)
    dayIdx = dayIdx | (timeD >= sunrise(i1) & timeD <= sunset(i1));
end

%% Find the mean CS
% Find daytime CS
dayCS = CS(dayIdx);
% Find and remove daytime CS = 0
dayCS(dayCs == 0) = [];
% Take the average
meanDaytimeCS = mean(dayCS);

end

