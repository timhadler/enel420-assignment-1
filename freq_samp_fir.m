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

N = 398;
df =4;

% Filter 1
a1 = [0, (f1-df)*2/fs, f1*2/fs,f1*2/fs, (f1+df)*2/fs, 1];
b1 = [1, 1, 0, 0, 1, 1];
% Filter 2
a2 = [0, (f2-df)*2/fs, f2*2/fs, f2*2/fs, (f2+df)*2/fs, 1];
b2 = b1;

h1 = fir2(N, a1, b1);
h2 = fir2(N, a2, b2);

% Plot filter output
Filt_out = filter(h2, 1, (filter(h1,1,data)));
figure(3)
plot(t(1:2000), Filt_out(1:2000))
xlabel("Time (s)")
ylabel("Voltage (uV)")
grid on

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
xlabel("Frequency (Hz)")
ylabel("|P(f)|")
grid on

figure(5)
freqz(conv(h1, h2), 1, 512, fs)
figure(6)
freqz(h2, 1, 512, fs)