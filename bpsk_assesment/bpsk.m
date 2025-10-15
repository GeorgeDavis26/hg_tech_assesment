%{
George Davis
Made for the Higher Ground Technical Assesment
Binary Phase Shift Keying Modulation and Demodulation

Referenced: https://www.youtube.com/watch?v=Pq-TGHRBMsw
%}

clear
clc
clf

%%% TRANSMITTER %%%

% System Parameters
f_c = 10^4; % 10 kHz Carrier Frequency (Hz) 
f_s = 10^5; % 100 kHz Sampling Frequency (Hz) - (abides by Nyquist)

R_b = 10^3;  % 1kBits per second
T_b = 1/R_b; % Seconds per bit

% Message to be Transmit
message_bits = [0 1 0 0 0 1 1 1]; % G in binary via ASCII

% Time vector
duration = length(message_bits) * T_b;
time = 0 : 1/f_s : duration;

% Carrier and Baseband
w = 2*pi*f_c; % Angular frequency 
carrier = cos(w*time);

baseband = ones(1, length(time));
NRZ = 2*message_bits - 1;

samples_per_bit = T_b * f_s;

for i = 1:length(NRZ)
    start = 1 + samples_per_bit * (i - 1);
    stop = samples_per_bit * (i);
    baseband(start:stop) = NRZ(i);
end

tx = baseband .* carrier;

%%% RECIEVER %%%

% Synchronous Detector (Multiplier)
rx = tx .* carrier;

% LPF
normw_c = 2*R_b/f_s;
rx_filtered = lowpass(rx, normw_c);

% Threshold Device
measure_point = round(samples_per_bit/2:samples_per_bit:length(message_bits)*samples_per_bit);
output_data = zeros(1,length(message_bits));

for i = 1:length(message_bits)
    output_data(i) = (rx_filtered(measure_point(i)) > 0);
end

check = isequal(output_data, message_bits)

figure(1)
subplot(4,1,1)
plot(time, carrier);
title("Carrier Signal")
xlabel("time [miliseconds]")

subplot(4,1,2)
plot(time, tx);
title("BFSK TX Signal")
xlabel("time [miliseconds]")

subplot(4,1,3)
plot(time, rx);
title("Demodulated RX Signal")
xlabel("time [miliseconds]")

subplot(4,1,4)
plot(time, rx_filtered);
title("Filtered Demodulated Signal")
xlabel("time [miliseconds]")