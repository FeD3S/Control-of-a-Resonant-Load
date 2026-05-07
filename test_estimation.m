clc
clear all
close all
%%
run("load_params_resonant_case.m")
run("compute_dynamics.m")
init_thb= 30;

T=0.13;
fs = 1000; 
t = 0:1/fs:1.2;

open_system("ASSIGNMENT_ESTIMATION.slx")

set_param("ASSIGNMENT_ESTIMATION", "SolverType", "Variable-step", "Solver", "ode45", ...
    "StopTime", "1.2");

out_est = sim("ASSIGNMENT_ESTIMATION");

% Example data: k = peak indices, y = log of absolute peak values
theta_d_noisy = out_est.abs_out.signals.values;


%% 2. Smooth the Signal
% Smooth with moving average (or use 'sgolay' or 'loess' methods)
smooth_window = 15;  % Must be odd
theta_d_smoothed = smooth(theta_d_noisy, smooth_window, 'moving');

%% 3. Automatic Peak Detection
% Use absolute value to detect both positive and negative peaks
abs_theta = abs(theta_d_smoothed);

% Estimate typical oscillation period (optional for robustness)
[pks_test, locs_test] = findpeaks(abs_theta, fs);  % Just to get rough spacing
if length(locs_test) >= 2
    est_period_samples = round(median(diff(locs_test)));
else
    est_period_samples = round(fs / omega_n);  % fallback estimate
end

% Find main peaks with automatic spacing estimate
[pks, locs] = findpeaks(abs_theta, 'MinPeakProminence', 1, ...
    'MinPeakDistance', est_period_samples);

tk = t(locs);       % Peak times
yk = pks;           % Peak amplitudes

%% 4. Estimate Logarithmic Decrement and Damping
y = log(yk(:));
k_index = (0:length(tk)-1)';
X = [-k_index, ones(size(k_index))];

%M =16; %NUMERO PEAKS dall'ABS

%k = (0:M-1)';                    % Column vector
%y = log(abs(theta_peaks(:)));   % Log of measured peaks, ensure column
%X = [-k, ones(size(k))];  % Regressor matrix
theta_hat = X \ y;     % Least squares solution
xi_hat = theta_hat(1);     % Slope
logA = theta_hat(2);   % Intercept
delta_hat = xi_hat / sqrt(pi^2 + xi_hat^2);
%% 5. Estimate Frequencies
T_k = diff(tk);                    % Peak-to-peak time differences
omega_k = pi ./ T_k;              % Estimate damped frequency
omega_hat = mean(omega_k);        % Average damped frequency
omega_n_hat = omega_hat / sqrt(1 - delta_hat^2);  % Natural frequency

%% 6. Display Results
fprintf('Estimated Logarithmic Decrement ξ = %.4f\n', xi_hat);
fprintf('Estimated Damping Ratio δ = %.4f\n', delta_hat);
fprintf('Estimated Damped Frequency ω = %.4f rad/s\n', omega_hat);
fprintf('Estimated Natural Frequency ω_n = %.4f rad/s\n', omega_n_hat);

%% plot estimated function
t = linspace(0, 1.2, 1000);  % 0 to 2 seconds
A = sqrt((init_thb)^2 + (delta_hat*omega_n_hat*init_thb/omega_hat)^2);
phi = atan(-delta_hat*omega_n_hat*init_thb/(omega_hat*init_thb));
theta_d =  A * exp(-delta_hat * omega_n_hat * t) .* cos(omega_hat * t + phi);
plot(t, theta_d, 'b', 'LineWidth', 1.5);
xlabel('Time [s]');
ylabel('\theta_d(t) [deg]');
title('Fitted Beam Oscillation');
grid on;