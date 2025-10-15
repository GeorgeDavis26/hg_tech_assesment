% ==============================================================
% BPSK Transmitter and Receiver Simulation
% ==============================================================

clear; clc; close all;

%% --- Parameters ---
fs = 100e3;        % Sampling frequency (Hz)
fc = 10e3;         % Carrier frequency (Hz)
Rb = 1e3;          % Bit rate (bits per second)
Tb = 1 / Rb;       % Bit period
numBits = 10;      % Number of bits to transmit

%% --- Transmitter ---
bits = randi([0 1], 1, numBits);   % Random bitstream
t = 0:1/fs:(numBits*Tb - 1/fs);    % Time vector
samplesPerBit = fs / Rb;

% NRZ encoding: 0 -> -1, 1 -> +1
baseband = repelem(2*bits - 1, samplesPerBit);

% Carrier
carrier = cos(2*pi*fc*t);

% BPSK Modulation
bpsk_signal = baseband .* carrier;

rx_signal = bpsk_signal

%% --- Receiver (Coherent Detection) ---
% Multiply by local carrier (synchronized)
demod = rx_signal .* carrier;

% Low-pass filter to remove 2*fc components
[b, a] = butter(5, (2*Rb)/fs);       % 5th order LPF
baseband_rec = filtfilt(b, a, demod);

% Sample once per bit to decide
samplePoints = round((samplesPerBit/2):samplesPerBit:length(baseband_rec));
samples = baseband_rec(samplePoints);
bits_rec = samples > 0;

%% --- Results ---
fprintf('Sent bits:      '); disp(bits);
fprintf('Recovered bits: '); disp(bits_rec);

%% --- Plots ---
figure('Position', [100, 100, 800, 600]);

subplot(4,1,1);
plot(t(1:1000), baseband(1:1000), 'LineWidth', 1.2);
title('Baseband Signal (NRZ)');
xlabel('Time [s]'); ylabel('Amplitude');

subplot(4,1,2);
plot(t(1:1000), bpsk_signal(1:1000), 'LineWidth', 1.2);
title('BPSK Modulated Signal');
xlabel('Time [s]'); ylabel('Amplitude');

subplot(4,1,3);
plot(t(1:1000), rx_signal(1:1000), 'LineWidth', 1.2);
title('Received Signal (with noise)');
xlabel('Time [s]'); ylabel('Amplitude');

subplot(4,1,4);
plot(t(1:1000), baseband_rec(1:1000), 'LineWidth', 1.2);
title('Demodulated Baseband Signal');
xlabel('Time [s]'); ylabel('Amplitude');

sgtitle('BPSK Transmission and Reception Simulation');

