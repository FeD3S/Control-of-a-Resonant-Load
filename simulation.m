% Beq = 2.0*10^-6; % [Nm/(rad/s)]
% tsf = 1.0*10^-2; % [Nm]

% Calculation of the equivalent resistance (Motor + Sensor)
Req = mot.R+snes.curr.Rs;

% Calculation of the equivalent inertia reflected to the motor shaft
% Includes motor inertia and load inertia divided by the square of the gear ratio
J_eq = mot.J+mld.J/(gbox.N^2);

% Calculation of the equivalent viscous friction reflected to the motor shaft
B_eq = mot.B+mld.B/(gbox.N^2);

% Driver dynamics parameters based on RC circuit components
Tdrv = (drv.R1*drv.R2*drv.C1)/(drv.R1+drv.R2);
kdrv = (1+drv.R3/drv.R4)*drv.R2/(drv.R1+drv.R2);


% Electrical dynamics transfer function coefficients
numElect = [1];
denElect = [mot.L Req];

% Mechanical dynamics transfer function coefficients
numMech = [1];
denMech = [J_eq B_eq];

% Driver dynamics transfer function coefficients
numDriv = [kdrv] ;
denDriv = [Tdrv 1];

% Motor constants definition
current2Torque = mot.Kt;
speed2Voltage = mot.Ke;

% Parameters of the simplified 1st-order transfer function model 
% Km: DC gain of the simplified motor-load system
k_m = (drv.dcgain * mot.Kt) / (B_eq * Req + mot.Kt*mot.Ke);
% Tm: Time constant of the simplified motor-load system
T_m = (Req * J_eq) / (Req * B_eq + mot.Kt*mot.Ke);

% Function to calculate the gain crossover frequency and phase margin
function [omega_gc, phi_m] = computeWgcPhiM(ts5, Mp)
    % Calculates the gain crossover frequency and phase margin based on time-domain specs
    % ts5: 5% settling time (in seconds)
    % Mp: overshoot (expressed as a decimal, e.g., 0.2 for 20%)

    % Calculation of the damping factor delta using the overshoot formula
    delta = log(1/Mp) / sqrt(pi^2 + (log(1/Mp))^2);

    % Calculation of the natural frequency omega_n using the 5% settling time approximation
    omega_n = 3 / (delta * ts5);

    % As seen in class, for the approximated second-order system, the gain 
    % crossover frequency is almost equal to the natural frequency
    omega_gc = omega_n;

    % Calculation of the desired phase margin phi_m (in degrees) based on delta
    phi_m = atan((2 * delta) / sqrt(-2 * delta^2 + sqrt(1 + 4 * delta^4))) * (180/pi);

    % Output of the results (commented out)
    %fprintf('Gain crossover frequency: %.2f rad/s\n', omega_gc);
    %fprintf('Desired phase margin: %.2f°\n', phi_m);
end

% Compute target crossover frequency and phase margin for given specs (150ms settling, 10% overshoot)
[omega_gc, phi_m] = computeWgcPhiM(0.15, 0.1);

% Function for PID controller calculation using loop shaping
function [Kp, Ki, Kd, C] = designPID(Km, Tm, N, omega_gc, phi_m)
    s = tf('s');  % Definition of the Laplace variable

    % Simplified transfer function of the motor with gear ratio N   
    P = Km / ((Tm * s + 1) * (N * s));

    % Calculation of the magnitude required by the PID to set the crossover frequency
    P_mag = abs(evalfr(P, 1j*omega_gc));  % Magnitude of P(jωgc)
    delta_k = 1 / P_mag;

    % Calculation of the phase shift needed to reach the target phase margin
    P_phase = angle(evalfr(P, 1j*omega_gc)) * 180/pi;  % Phase of P in degrees (should be replaced with rad2deg but it doesn't work in older versions)
    delta_phi = -180 + phi_m - P_phase;

    % Equations for the PID parameters using the inversion formulas  
    alpha = 4;
    Kp = delta_k * cosd(delta_phi);  
    Td = (tand(delta_phi) + sqrt(tand(delta_phi)^2 + 4/alpha)) / (2 * omega_gc);  
    Ti = alpha * Td;  % Set α = 4 for optimal stability zero-pole placement
    
    % Calculation of standard PID gains
    Kd = Kp * Td;
    Ki = Kp / Ti;

    % PID Controller components explanation:
    % - Kp: proportional gain, responds as soon as there is an error 
    % - Ki: integral gain, allows action to eliminate steady-state error over time
    % - Kd: derivative gain, acts in the transient to damp the error derivative and 
    %       then at steady-state it no longer counts since there is no variation

    % Final PID transfer function formulation
    C = Kp + Ki/s + Kd * s;

end

% Design the PID controller with the calculated parameters
[pid.Kp, pid.Ki, pid.Kd, C] = designPID(k_m, T_m, gbox.N, omega_gc, phi_m);

% Re-definition of time domain specifications for filter time constant calculation
Mp = 0.1;
ts5 = 0.15;
% Calculation of the damping factor delta
delta = log(1/Mp) / sqrt(pi^2 + (log(1/Mp))^2);

% Calculation of the natural frequency omega_n
omega_n = 3 / (delta * ts5);

% As seen in class, for the approximated system they are almost equal
omega_gc = omega_n;

% Calculate the derivative filter time constant (Tl) to be outside the control bandwidth
pid.Tl = (1/omega_gc) * 3;

% Hardcoded PID values (currently commented out)
%pid.Kp = 8.889;
%pid.Ki = 124.310;
%pid.Kd = 0.1589;
%pid.Tl = 0.0074;

% Derivative filter transfer function coefficients
pid.rdev_num = [1 0];
pid.rdev_den = [pid.Tl 1];

%% Plant section

s = tf('s');  % Definition of the Laplace variable

% Simplified transfer function of the motor to verify plant behavior   
P = k_m / ((T_m * s + 1) * (gbox.N * s));

% Calculation of the gain to be imposed for the PID at crossover frequency
P_mag = abs(evalfr(P, 1j*omega_gc));  % Magnitude of P(jωgc)

% Phase of P in degrees
P_phase = angle(evalfr(P, 1j*omega_gc)) * 180/pi;  
delta_phi = -180 + phi_m - P_phase;


%% Anti-windup compensation

% Set the tracking time constant for the anti-windup mechanism
T_w = ts5/5;
K_w = 1 / T_w;

%% Feedforward compensations 
N = gbox.N;

% Disturbance decoupling term
P_ud = Req / (kdrv*current2Torque*N); 

% Mechanical constants for feedforward
tau_sf = 0.0093;
Beq = 1.0742e-06;
Jeq = 4.7887e-07;

% Calculate feedforward gains to compensate specific physical phenomena
inertia_comp = (N*Req*Jeq) / (kdrv*mot.Kt);
friction_comp = Req / (kdrv*mot.Kt*N);
BEMF_comp = (N*mot.Ke) / kdrv;
tauf = N^2 * Beq;

% High-Pass Filter parameters for velocity estimation or feedforward shaping
HPF_omega_c = 2*pi*50;
HPF_delta = 1/sqrt(2);

s = tf('s');  % Definition of the Laplace variable

% Second-order High-Pass Filter transfer function
H1 = (HPF_omega_c^2*s) / (s^2 + 2*HPF_delta*HPF_omega_c*s + HPF_omega_c^2);

