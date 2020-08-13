% ENEL420 Assignemnt
% Tim Hadler, Emily Tideswell 
% 30/07/2020
% Design FIR filter using window method

clc, clear, close all;

data = load("enel420_grp_23.txt");

fs = 1024;  % Sampling frq, HZ
n = length(data);
t = linspace(0, n/fs, n);

%--------------------------------------------------------------------------
% Use window method (fir1) to design FIR filter
N = 398; %No. coefficients
df = 4; %BW
f1 = 44.56; %Interference freqs
f2 = 78.99;

a = fir1(N,[(f1-df)*2/fs (f1+df)*2/fs], 'stop');
b = fir1(N,[(f2-df)*2/fs (f2+df)*2/fs], 'stop');

%--------------------------------------------------------------------------
% Plot filter output in time domain
Filt_out = filter(b,1,filter(a,1,data));
figure(1)
plot(t(1:2000), Filt_out(1:2000))

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
xlabel('Frequency (Hz)')
ylabel('|P(f)|')

%--------------------------------------------------------------------------
% Plot freq response of filters
figure(3)
freqz(conv(a, b), 1, 512, fs)