function batchMillerDot
%BATCHMILLERDOT Summary of this function goes here
%   Detailed explanation goes here

startDir = 'C:\Users\jonesg5\Desktop\NIDA';
actiDir = fullfile(startDir,'actiwatchData');
dimeDir = fullfile(startDir,'daysimeterDataLocalTime');

dimeListing = dir(fullfile(dimeDir,'sub*.txt'));

%% Create figure window
close all;
fig = figure;
paperPosition = [0 0 8.5 11];
set(fig,'PaperUnits','inches',...
    'PaperType','usletter',...
    'PaperOrientation','portrait',...
    'PaperPositionMode','manual',...
    'PaperPosition',paperPosition,...
    'Units','inches',...
    'Position',paperPosition);

%% Set spacing values
xMargin = 0.5/paperPosition(3);
xSpace = 0.125/paperPosition(3);
yMargin = 0.5/paperPosition(4);
ySpace = 0.125/paperPosition(4);

%% Calculate usable space for plots
workHeight = 1-2*ySpace-2*yMargin;
workWidth = 1-2*xMargin;

%% Position axes
w1 = workWidth-4*xSpace;
h1 = w1*paperPosition(4)/paperPosition(3);
y1 = yMargin + (workHeight - h1)/2;
x1 = xMargin;

%% Begin main loop
n = length(dimeListing);
for i1 = 1:n
    % Import dimesimeter file
    dimeFile = fullfile(dimeDir,dimeListing(i1).name);
    [~,dTime,~,~,dCS,dActivity] = importDimesimeter(dimeFile);
    fileBase = regexprep(dimeListing(i1).name,'\.txt','','ignorecase');
    % Import actiwatch file
    actiFile = fullfile(actiDir,[fileBase,'.csv']);
    [aTime,aActivity,subject] = importActiwatch(actiFile);
    % Combine the data
    ts1 = timeseries(dCS,dTime);
    ts2 = resample(ts1,aTime);
    CS = ts2.Data;
    time1 = aTime;
    activity = aActivity.*(mean(dActivity)/mean(aActivity));
    % Remove NaN values
    idxNaN = isnan(CS) | isnan(activity);
    CS(idxNaN) = [];
    time1(idxNaN) = [];
    activity(idxNaN) = [];
    % Determine trial
    if weekday(aTime(1)) == 2
        trial = 'week';
    elseif weekday(aTime(1)) == 6
        trial = 'weekend';
    else
        trial = 'error';
    end
    % Begin plotting
    titleStr = {['Subject ',num2str(subject),' ',trial];...
        [datestr(time1(1),'mm/dd/yyyy HH:MM'),' - ',datestr(time1(end),'mm/dd/yyyy HH:MM')]};
    plotTitle(fig,titleStr,yMargin);
    dateStamp(fig,xMargin,yMargin);
    % Create axes
    axes('Parent',fig,'OuterPosition',[x1 y1 w1 h1]);
    [C_time,C_magnitude] = millerDot(time1,CS,activity);
    % Plot annotation
    noteStr = {['Centroid time: ',datestr(C_time,'HH:MM')];...
        ['Centroid magnitude: ',num2str(C_magnitude,3)]};
    plotNotes(fig,noteStr);
    % Save plot to file
    reportFile = fullfile('millerDots',[fileBase(1:6),trial,'.pdf']);
    saveas(gcf,reportFile);
    clf(fig);
end

close all;

end

%% Subfunction to plot a centered title block
function plotTitle(fig,titleStr,yMargin)
% Create title
titleHandle = annotation(fig,'textbox',...
    [0.5,1-yMargin,0.1,0.1],...
    'String',titleStr,...
    'FitBoxToText','on',...
    'HorizontalAlignment','center',...
    'LineStyle','none',...
    'FontSize',14);
% Center the title and shift down
titlePosition = get(titleHandle,'Position');
titlePosition(1) = 0.5-titlePosition(3)/2;
titlePosition(2) = 1-yMargin-titlePosition(4);
set(titleHandle,'Position',titlePosition);
end

%% Subfunction to plot a date stamp in the top right corner
function dateStamp(fig,xMargin,yMargin)
% Create date stamp
dateStamp = ['Printed: ',datestr(now,'mmm. dd, yyyy HH:MM')];
datePosition = [0.8,1-yMargin,0.1,0.1];
dateHandle = annotation(fig,'textbox',datePosition,...
    'String',dateStamp,...
    'FitBoxToText','on',...
    'HorizontalAlignment','right',...
    'LineStyle','none');
% Shift left and down
datePosition = get(dateHandle,'Position');
datePosition(1) = 1-xMargin-datePosition(3);
datePosition(2) = 1-yMargin-datePosition(4); 
set(dateHandle,'Position',datePosition);
end

%% Subfunction to plot a centered annotation block
function plotNotes(fig,noteStr)
% Find position of axes
axesPosition = get(gca,'Position');
% Create title
noteHandle = annotation(fig,'textbox',...
    [0.5,axesPosition(2),0.1,0.1],...
    'String',noteStr,...
    'FitBoxToText','on',...
    'HorizontalAlignment','center',...
    'LineStyle','none',...
    'FontSize',14);
% Center the annotation and shift down
notePosition = get(noteHandle,'Position');
notePosition(1) = 0.5-notePosition(3)/2;
notePosition(2) = axesPosition(2)-notePosition(4);
set(noteHandle,'Position',notePosition);
end

