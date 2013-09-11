function checkFiles(actiFile,dimeFile,bedTimes,wakeTimes)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
saveDir = 'C:\Users\jonesg5\Desktop\NIDA\checkFigs';
[aTime,aActivity,subject] = importActiwatch(actiFile);

% check if daysimeter file exists and import
if exist(dimeFile,'file') == 2
    [~,dTime,~,~,dCS,dActivity] = importDimesimeter(dimeFile);
else
    dTime = aTime;
    an = length(aTime);
    dCS = -1*ones(an,1);
    dActivity = -1*ones(an,1);
end

% determine trial
if weekday(aTime(1)) == 2
    trial = 'week';
elseif weekday(aTime(1)) == 6
    trial = 'weekend';
else
    trial = 'error';
end

% determine number of days (noon to noon)
tempStart = ceil(aTime(1));
if tempStart - aTime(1) > .5
    startTime = tempStart - .5;
else
    startTime = tempStart + .5;
end
tempStop = floor(aTime(end));
if aTime(end) - tempStop > .5
    stopTime = tempStop + .5;
else
    stopTime = tempStop - .5;
end

% days = ceil(stopTime - startTime) + 1;
days = 3;

% apply gaussian filter to data
aEpoch = ((aTime(2)-aTime(1))*(24*3600)); % sample epoch in seconds
aWin = floor(300/aEpoch); % number of samples in 5 minutes
dEpoch = ((dTime(2)-dTime(1))*(24*3600)); % sample epoch in seconds
dWin = floor(300/dEpoch); % number of samples in 5 minutes
aActivity = gaussian(aActivity, aWin);
dActivity = gaussian(dActivity, dWin);
dCS = gaussian(dCS, dWin);

% plot files
color1 = [245,135, 35]/255; % orange
color2 = [100,100,100]/255; % grey
color3 = [ 27, 50, 95]/255; % blue
color4 = [148,186,101]/255; % green
color5 = [232, 55, 62]/255; % red
lineWidth = 1.5;

yMin = -0.1;
yMax = 0.8;

for i1 = 1:days
    startDay = startTime + i1 - 1;
    stopDay = startTime + i1;
    aidx = aTime >= startDay & aTime <= stopDay;
    didx = dTime >= startDay & dTime <= stopDay;
    ati = (aTime(aidx) - floor(startDay))*24;
    dti = (dTime(didx) - floor(startDay))*24;
    a = axes('XTick',12:1:36,'XLim',[12 36],...
        'YTick',yMin:.1:yMax,'YLim',[yMin,yMax],...
        'XTickLabelMode','manual','XTickLabel',...
        {'12','13','14','15','16','17','18','19','20','21','22','23',...
        '00','01','02','03','04','05','06','07','08','09','10','11','12'});
    hold(a);
    
    plot(a,ati,aActivity(aidx)/max(aActivity),...
        'Color',color1,'LineWidth',lineWidth,...
        'DisplayName','Actiwatch AI (normalized)');
    
    plot(a,dti,dCS(didx),...
        'Color',color2,'LineWidth',lineWidth,...
        'DisplayName','CS');
    
    plot(a,dti,dActivity(didx),...
        'Color',color3,'LineWidth',lineWidth,...
        'DisplayName','Daysimeter AI');
    % plot bed times
    bidx = bedTimes >= startDay & bedTimes <= stopDay & ~isnan(bedTimes);
    dayBed = (bedTimes(bidx) - floor(startDay))*24;
    dayBed2 = bedTimes(bidx);
    bn = length(dayBed);
    if bn >= 1
        for i2 = 1:bn
            bedLine = plot(a,[dayBed(i2),dayBed(i2)],[yMin,yMax],...
                'Color',color4,'LineWidth',lineWidth);
            set(get(get(bedLine,'Annotation'),'LegendInformation'),...
                'IconDisplayStyle','off'); % Exclude line from legend
            text(dayBed(i2)+.01,-.05,datestr(dayBed2(i2),'HH:MM'));
        end
    end
    % plot wake times
    widx = wakeTimes >= startDay & wakeTimes <= stopDay & ~isnan(wakeTimes);
    dayWake = (wakeTimes(widx) - floor(startDay))*24;
    dayWake2 = wakeTimes(widx);
    wn = length(dayWake);
    if wn >= 1
        for i3 = 1:wn
            wakeLine = plot(a,[dayWake(i3),dayWake(i3)],[yMin,yMax],...
                'Color',color5,'LineWidth',lineWidth);
            set(get(get(wakeLine,'Annotation'),'LegendInformation'),...
                'IconDisplayStyle','off'); % Exclude line from legend
            text(dayWake(i3)+.01,-.05,datestr(dayWake2(i3),'HH:MM'));
        end
    end

    title(a,{['Subject ',num2str(subject),' ',trial];...
        [datestr(min(dTime(didx)),'mm/dd/yyyy'),' - ',datestr(max(dTime(didx)),'mm/dd/yyyy')]})
    legend(a,'show','Location','NorthOutside','Orientation','horizontal');
    fileName = ['sub',num2str(subject,'%02.0f'),...
        '_',datestr(startDay,'yyyy-mm-dd'),...
        '_',datestr(stopDay,'yyyy-mm-dd')];
    saveas(gcf,fullfile(saveDir,[fileName,'.fig']));
    saveas(gcf,fullfile(saveDir,[fileName,'.pdf']));
    clf;
end

end

