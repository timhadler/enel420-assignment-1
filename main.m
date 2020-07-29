% ENEL420 Assignemnt
% Tim Hadler, Emily Tideswell 
% 30/07/2020

clc, clear

data = load("enel420_grp_23.txt");

fs = 1024;  % Sampling frq, HZ
n = length(data);
t = linspace(0, n/fs, n);

plot(t, data);
title("Raw Data")
xlabel("Time (s)");
ylabel("Amplitude (uV)");