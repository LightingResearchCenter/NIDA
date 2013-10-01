function [ hour, magnitude ] = centroidCS( time1, CS )
%CENTROIDCS Determine the centroid of CS
%   time1 is an array of either datenum values or in units of days.
%   CS is an array of circadian stimulus values equal in length to time.

%% Convert input to a polar coordinate system
% Assign CS to radial dimension
rho = CS;
% Adjust time for rollover
modTime = mod(time1,1); % Time of day in fractions of a day
% Convert time to radians and assign to angular dimension
theta = modTime*2*pi; % Time of day in radians

%% Calculate point mass centroid in Cartesian coordinates
C_x = sum(rho.^2 .* cos(theta)) / sum(rho); % x-axis centroid
C_y = sum(rho.^2 .* sin(theta)) / sum(rho); % y-axis centroid

%% Convert the centroid to polar coordinates
C_rho = sqrt(C_x^2 + C_y^2); % radial centroid
C_theta = atan2(C_y,C_x);   % angular centroid

%% Convert the centroid for output
hour = C_theta*12/pi; % Convert radians to hours
magnitude = C_rho; % Assign C_rho as central magnitude of CS

end

