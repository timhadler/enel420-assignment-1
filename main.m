% ENEL420 Assignemnt
% Tim Hadler, Emily Tideswell 
% 30/07/2020

clc, clear, close all;

data = load("enel420_grp_23.txt");

fs = 1024;  % Sampling frq, HZ
n = length(data);
t = linspace(0, n/fs, n);

% Plot raw data
figure(1)
plot(t(1:2000), data(1:2000));
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
p1 = p2(1:n/2+1);
p1(2:end-1) = 2*p1(2:end-1);

% Convert freq to Hz
f = fs*(0:n/2)/n;

figure(3)
plot(f, p1)
xlim([0,200])

% Coefficents for fir filter
df = 4;
f1 = 44.56;
f2 = 78.99;
a = fir1(399,[(f1-df)*2/fs (f1+df)*2/fs], 'stop');
b = fir1(399,[(f2-df)*2/fs (f2+df)*2/fs], 'stop');

figure(4)
freqz(a,1,128)

figure(5)
freqz(b,1,128)

% Plot filter output
Filt_out = filter(b,1,filter(a,1,data));
figure(6)
plot(t(1:2000), Filt_out(1:2000))

% Find and plot spectrum
spct = abs(fft(Filt_out));
p2 = spct/n;
p1 = p2(1:n/2+1);
p1(2:end-1) = 2*p1(2:end-1);

% Convert freq to Hz
f = fs*(0:n/2)/n;

figure(7)
plot(f, p1)
xlim([0,200])