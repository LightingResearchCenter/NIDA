function [duration] = hoursPeakCS(time1,CS,threshold)
%HOURSPEAKCS Average hours per day that CS is above the threshold
%   time1 is an array of either datenum values or in units of days.
%   CS is an array of circadian stimulus values equal in length to time.
%   threshold is one value [0 to 0.7] where duration is calculated for CS
%   greater than or equal to the specified threshold.

%% Check and prepare inputs
% Make vectors vertical
time1 = time1(:);
CS = CS(:);
% Check that arrays are of equal length
if length(time1) ~= length(CS)
    error('time1 and CS vectors are not of equal length');
end
% Check that the time1 array is sorted in ascending order
if ~issorted(time1)
    warning('The time1 array is not in ascending order and will be sorted');
    % Sort time1 into ascending order
    [time1,idx1] = sort(time1);
    % Sort CS according to time1
    CS = CS(idx1);
end

%% Calculate intervals between time points
time2 = circshift(time1,1);
interval = time2 - time1;
% replace the first interval (a negative false value) with the average
interval(1) = mean(interval(2:end));

%% Calculate the total duration of CS at or above threshold
% Find CS greater than or equal to the threshold
idx2 = CS >= threshold;
totalDuration = sum(interval(idx2))*24; % in hours

%% Calculate the average duration per day
days = time1(end)-time1(1);
duration = totalDuration/days;

end

