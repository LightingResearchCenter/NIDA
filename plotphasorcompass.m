function varargout = plotphasorcompass(phasorMagnitude,phasorAngle,plotTitle)
%PLOTPHASORCOMPASS Summary of this function goes here
%   Detailed explanation goes here

% Create axes to plot on
hAxes = axes;

% Average the phasors
meanMagnitude = mean(phasorMagnitude);
meanAngle = mean(phasorAngle);

phasorplot(phasorMagnitude,phasorAngle,.75,3,6,'top','left',.1);
hold on
phasorplot(meanMagnitude,meanAngle,.75,3,6,'top','left',.1,0,0,2,'r');

title(hAxes,{plotTitle;'Circadian Stimulus/Activity Phasor'});

% Eliminate excess white space
set(hAxes, 'Position', get(gca, 'OuterPosition') - ...
    get(hAxes, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);

% Return the axes handle if requested
if nargout == 1
    varargout = {hAxes};
end

end

