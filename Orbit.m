% Author: Akshata Patil [akshatap@stanford.edu]
% Date: April 28, 2023
clc
clear all 
close all
% Monitoring 24 hours at Ground Stations: 
startTime = datetime(2023, 04, 28, 0, 0, 0, 'TimeZone', 'UTC');
stopTime = startTime + hours(24);
sampleTime = 60;
sc = satelliteScenario(startTime, stopTime, sampleTime);
% Testing on Beidou:
% Add Satellite TLE as a txt file: 
sat = satellite(sc, "C58_April28_29_TLE.txt");
% Satellite Scenario
% show(sat);
for i = 1:length(sat)
    ele(i) = orbitalElements(sat(i));
end
% Adding Ground Station
name = ["NEW ORLEANS"];
lat = [30.58];
long = [-90.36];
gs = groundStation(sc, "Name", name, "Latitude", lat, "Longitude", long);
% Generating Elevation Angle Plot:
minutes = 1:(24*60);
time = startTime + minutes./1440;
elev = zeros(length(minutes), length(sat));
azim = zeros(length(minutes), length(sat)); % initialize azimuth matrix
satIdx = 1;
% Initialize one satellite at a time:
for idx = 1:length(minutes)
    [azim(idx, satIdx), elev(idx, satIdx), ~] = aer(gs, sat(satIdx), time(idx));
end
% Plotting:
plot(time, elev(:, satIdx), LineWidth=1.5);
title(['Elevation vs. time for satellite NORAD# 40749 ', 'GroundStation: ', name]);
ylabel('Elevation Angle [degrees]');
xlabel('Time [UTC]');
ylim([0, 90]);
grid on;
grid minor;
hold on