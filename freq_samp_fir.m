% ENEL420 Assignemnt
% Tim Hadler, Emily Tideswell 
% 04/08/2020
% Design FIR filter using freq sampling method

clc, clear, close all;

data = load("enel420_grp_23.txt");

fs = 1024;  % Sampling frq, HZ
n = length(data);
t = linspace(0, n/fs, n);

%--------------------------------------------------------------------------
% Find coefficents for fir filter using fir2
f1 = 44.56; %Interference frequencies
f2 = 78.99;

N = 398; %No of coefficients
df =4; %BW

% Filter 1
a1 = [0, (f1-df)*2/fs, f1*2/fs,f1*2/fs, (f1+df)*2/fs, 1];
b1 = [1, 1, 0, 0, 1, 1];
% Filter 2
a2 = [0, (f2-df)*2/fs, f2*2/fs, f2*2/fs, (f2+df)*2/fs, 1];
b2 = b1;

h1 = fir2(N, a1, b1);
h2 = fir2(N, a2, b2);

%--------------------------------------------------------------------------
% Plot filter output in time domain
Filt_out = filter(h2, 1, (filter(h1,1,data)));
figure(1)
plot(t(1:2000), Filt_out(1:2000))
xlabel("Time (s)")
ylabel("Voltage (uV)")
grid on

%--------------------------------------------------------------------------
% Find and plot spectrum of filtered signal
spct = abs(fft(Filt_out));
p2 = spct/n;
p1 = p2(1:n/2+1);
p1(2:end-1) = 2*p1(2:end-1);

% Convert freq to Hz
f = fs*(0:n/2)/n;

figure(2)
plot(f, p1)
xlim([0,200])
xlabel("Frequency (Hz)")
ylabel("|P(f)|")
grid on

%--------------------------------------------------------------------------
% Plot freq response of filters
figure(3)
freqz(conv(h1, h2), 1, 512, fs)
% figure(4)
% freqz(h2, 1, 512, fs)