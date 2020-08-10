%IIR filters

clear all; close all; clc;

data = load("enel420_grp_23.txt");

f1 = 44.56; %Interference frequencies
f2 = 78.99;
fs = 1024;
BW = 5;
n = length(data);
t = linspace(0, n/fs, n);

%--------------------------------------------------------------------------
% Notch filter for 44.56 Hz
thetaz1 = (2*pi*f1)/fs;
r = 1 - (BW/fs)*pi;

B1 = [1, -2*cos(thetaz1), 1];
A1 = [1, -2*r*cos(thetaz1), r^2];

figure(1)
freqz(B1, A1, 512, fs)

%--------------------------------------------------------------------------
% Notch filter for 78.99 Hz
thetaz2 = (2*pi*f2)/fs;

B2 = [1, -2*cos(thetaz2), 1];
A2 = [1, -2*r*cos(thetaz2), r^2];

figure(2)
freqz(B2, A2, 512, fs)

%--------------------------------------------------------------------------
% Plot filter output in time domain
Filt_out = filter(B2,A2,filter(B1,A1,data));
figure(3)
plot(t(1:2000), Filt_out(1:2000))
ylabel('Voltage (uV)')
xlabel('Time (s)')

%--------------------------------------------------------------------------
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
xlabel('Frequency (Hz)')
ylabel('|P(f)|')

figure(5)
freqz(conv(B1, B2), conv(A1, A2), 512, fs)
ax = findall(gcf, 'Type', 'axes');
set(ax, 'XLim', [0, 250])