% ENEL420 Assignemnt
% Tim Hadler, Emily Tideswell 
% 04/08/2020

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

% Find p2 (the two sided spectrum) and use this to find the one sided
% spectrum p1.
spct = abs(fft(data));
p2 = spct/n;
p1 = p2(1:n/2+1);
p1(2:end-1) = 2*p1(2:end-1);

% Convert freq to Hz
f = fs*(0:n/2)/n;

figure(2)
plot(f, p1)
xlim([0,200])

% Coefficents for fir filter
f1 = 44.56; %Interference frequencies
f2 = 78.99;
df = 2;
dfnotch = 0.5;
a1 = [0, (f1-df)/(fs/2), (f1-dfnotch)/(fs/2), (f1+dfnotch)/(fs/2), (f1+df)/(fs/2), 1];
b1 = [1 , 1, 0, 0, 1, 1];
a2 = [0, (f2-df)/(fs/2), (f2-dfnotch)/(fs/2), (f2+dfnotch)/(fs/2), (f2+df)/(fs/2), 1];
b2 = [1 , 1, 0, 0, 1, 1];

h1 = firpm(398, a1, b1);
h2 = firpm(400, a2, b2);

% Plot filter output
Filt_out = filter(h2, 1, (filter(h1,1,data)));
figure(3)
plot(t(1:2000), Filt_out(1:2000))

% Find and plot spectrum
spct = abs(fft(Filt_out));
p2 = spct/n;
p1 = p2(1:n/2+1);
p1(2:end-1) = 2*p1(2:end-1);

% Convert freq to Hz
f = fs*(0:n/2)/n;

figure(4)
plot(f, p1)
xlim([0,200])

figure(5)
freqz(h1, 1, 512)
figure(6)
freqz(h2, 1, 512)