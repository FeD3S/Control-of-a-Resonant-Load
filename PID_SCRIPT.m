%% PID CONTROLLER

%%% TRANSIENT SPECIFICATION
Mp = 0.3; % overshoot spec
ts5 = 0.85; % settling time

%%% DAMPING FACTOR, CROSS-OVER FREQUENCY AND DESIRED PHASE MARGIN
d = log(1/Mp) / (sqrt(pi^2 + (log(1/Mp))^2)); % damping factor
omega_gc = 3 / (d* ts5);  % cross-over frequency
phi_m = atan2((2 * d),(sqrt(sqrt(1 + 4 * d^4) - 2*d^2)));

%%% DEFINING THE SIMPLIFIED MODEL
km = (drv.dcgain * mot.Kt);
num = [km*mld.Jb km*mld.Bb km*mld.k];
den = [(Req*Jeq*mld.Jb) ((Req*(Jeq*mld.Bb+mld.Jb*Beq))+(mot.Kt*mot.Ke*mld.Jb)) (Req*(Beq*mld.Bb+mld.k*(Jeq+mld.Jb/gbox.N^2)) + (mot.Kt*mot.Ke*mld.Bb)) (Req*(mld.k*(Beq+mld.Bb/gbox.N^2)) + (mot.Kt*mot.Ke*mld.k))];


%%% SIMPLIFIED PLANT TF
P = tf(num,den) * tf(1,[gbox.N 0]);

%%% MODEL MARGIN AND PHASE
[P_mag,P_phase_deg] = bode(P,omega_gc);
P_phase = deg2rad*P_phase_deg;

%%% DELTA MARGIN AND PHASE
delta_K = abs(1/P_mag);
delta_Phi = -pi + phi_m - P_phase;

%%% PID PARAMETERS
alpha = 4;
Kp = delta_K*cos(delta_Phi);
Td = (tan(delta_Phi) + sqrt(tan(delta_Phi)^2 + (4/alpha))) / (2 * omega_gc);  
Ti = alpha * Td;  % Set α = 4 for stability

Kd = Kp * Td;
Ki = Kp / Ti;
Tl = 1/(10*omega_gc); % time constant of derivative filter
                      % From assignment (2.2.1) we put 10 instead of 3

%%% PID TRANSFER FUNCTION
C = pid(Kp, Ki, Kd, Tl);  % PID definition

%%% ANTI WINDUP
Tw = ts5/5;
Kw = 1/Tw;

%% For estimated params
num_est = [km*mld.Jb km*mld.Bb_est km*mld.k_est];
den_est = [(Req*Jeq*mld.Jb) ((Req*(Jeq*mld.Bb_est+mld.Jb*Beq))+(mot.Kt*mot.Ke*mld.Jb)) (Req*(Beq*mld.Bb_est+mld.k_est*(Jeq+mld.Jb/gbox.N^2)) + (mot.Kt*mot.Ke*mld.Bb_est)) (Req*(mld.k_est*(Beq+mld.Bb_est/gbox.N^2)) + (mot.Kt*mot.Ke*mld.k_est))];
P_est = tf(num_est,den_est) * tf(1,[gbox.N 0]);

%%% MODEL MARGIN AND PHASE
[P_est_mag, P_est_phase_deg] = bode(P_est, omega_gc);
P_est_phase = deg2rad * P_est_phase_deg;

%%% DELTA MARGIN AND PHASE
delta_K_est = abs(1 / P_est_mag);
delta_Phi_est = -pi + phi_m - P_est_phase;

%%% PID PARAMETERS
alpha = 4;
Kp_est = delta_K_est * cos(delta_Phi_est);
Td_est = (tan(delta_Phi_est) + sqrt(tan(delta_Phi_est)^2 + (4 / alpha))) / (2 * omega_gc);  
Ti_est = alpha * Td_est;

Kd_est = Kp_est * Td_est;
Ki_est = Kp_est / Ti_est;
Tl_est = 1 / (10 * omega_gc);  % time constant of derivative filter

%%% PID TRANSFER FUNCTION
C_est = pid(Kp_est, Ki_est, Kd_est, Tl_est);  % PID definition

%%% ANTI WINDUP
Tw_est = ts5 / 5;
Kw_est = 1 / Tw_est;