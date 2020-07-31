% ENEL420 Assignemnt
% Tim Hadler, Emily Tideswell 
% 30/07/2020

clc, clear

data = load("enel420_grp_23.txt");

fs = 1024;  % Sampling frq, HZ
n = length(data);
t = linspace(0, n/fs, n);

% Plot raw data
figure(1)
plot(t, data);
title("Raw Data")
xlabel("Time (s)");
ylabel("Amplitude (uV)");

% Find and plot spectrum
spct = abs(fft(data));
f = [0:n-1];   %?

figure(2)
plot(f, spct);

% Find p2 (the two sided spectrum) and use this to find the one sided
% spectrum p1.
p2 = spct/n;
p1 = p2(1:n/2+1)
p1(2:end-1) = 2*p1(2:end-1)

% Convert freq to Hz
f = fs*(0:n/2)/n;

figure(3)
plot(f, p1)
xlim([0,200])