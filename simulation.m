%Beq = 2.0*10^-6; %[Nm/(rad/s)]
%tsf = 1.0*10^-2; %[Nm]
Req = mot.R+snes.curr.Rs;
J_eq = mot.J+mld.J/(gbox.N^2);
B_eq = mot.B+mld.B/(gbox.N^2);

Tdrv = (drv.R1*drv.R2*drv.C1)/(drv.R1+drv.R2);
kdrv = (1+drv.R3/drv.R4)*drv.R2/(drv.R1+drv.R2);


% electrical dynamics
numElect = [1];
denElect = [mot.L Req];

% mechanical dynamics
numMech = [1];
denMech = [J_eq B_eq];

% driver dynamics
numDriv = [kdrv] ;
denDriv = [Tdrv 1];

% gains
current2Torque = mot.Kt;
speed2Voltage = mot.Ke;

% Parameters of the simplified model
k_m = (drv.dcgain * mot.Kt) / (B_eq * Req + mot.Kt*mot.Ke);
T_m = (Req * J_eq) / (Req * B_eq + mot.Kt*mot.Ke);

% Funzione per calcolo frequenza attraversamento e margine di fase
function [omega_gc, phi_m] = computeWgcPhiM(ts5, Mp)
    % Calcola la frequenza di attraversamento del guadagno e il margine di fase
    % ts5: tempo di assestamento al 5% (in secondi)
    % Mp: overshoot (espresso come decimale, es. 0.2 per 20%)

    % Calcolo del fattore di smorzamento delta
    delta = log(1/Mp) / sqrt(pi^2 + (log(1/Mp))^2);

    % Calcolo della frequenza naturale omega_n
    omega_n = 3 / (delta * ts5);

    % Come abbiamo visto in classe per il sistema approssimato sono quasi
    % uguali
    omega_gc = omega_n;

    % Calcolo del margine di fase phi_m (in gradi)
    phi_m = atan((2 * delta) / sqrt(-2 * delta^2 + sqrt(1 + 4 * delta^4))) * (180/pi);

    % Output dei risultati
    %fprintf('Frequenza di attraversamento del guadagno: %.2f rad/s\n', omega_gc);
    %fprintf('Margine di fase desiderato: %.2f°\n', phi_m);
end

[omega_gc, phi_m] = computeWgcPhiM(0.15, 0.1);

% Funzione per calcolo PID
function [Kp, Ki, Kd, C] = designPID(Km, Tm, N, omega_gc, phi_m)
    s = tf('s');  % Definizione della variabile di Laplace

    % Funzione di trasferimento semplificata del motore   
    P = Km / ((Tm * s + 1) * (N * s));

    % Calcolo del gunadagno da imporre per il PID
    P_mag = abs(evalfr(P, 1j*omega_gc));  % Modulo di P(jωgc)
    delta_k = 1 / P_mag;

    P_phase = angle(evalfr(P, 1j*omega_gc)) * 180/pi;  % Fase di P in gradi ( sarebbe da sostituire con rad2deg ma non va)
    delta_phi = -180 + phi_m - P_phase;

    % Equazioni per i parametri PID  
    alpha = 4;
    Kp = delta_k * cosd(delta_phi);  
    Td = (tand(delta_phi) + sqrt(tand(delta_phi)^2 + 4/alpha)) / (2 * omega_gc);  
    Ti = alpha * Td;  % Imposto α = 4 per stabilità
    % 
    Kd = Kp * Td;
    Ki = Kp / Ti;

    % Controllore PID
    % - Kp: guadagno costante, risponde non appena ho un errore 
    % - Ki: permette di agire in caso l'errore rimanga costante nel tempo
    % - Kd: agisce nel transiente per smorzare derivazione errore e poi a
    %       regime non conta più nulla dato che non ce variazione

    C = Kp + Ki/s + Kd * s;

end

[pid.Kp, pid.Ki, pid.Kd, C] = designPID(k_m, T_m, gbox.N, omega_gc, phi_m);

Mp = 0.1;
ts5 = 0.15;
% Calcolo del fattore di smorzamento delta
delta = log(1/Mp) / sqrt(pi^2 + (log(1/Mp))^2);

% Calcolo della frequenza naturale omega_n
omega_n = 3 / (delta * ts5);

% Come abbiamo visto in classe per il sistema approssimato sono quasi
% uguali
omega_gc = omega_n;

pid.Tl = (1/omega_gc) *3;

%pid.Kp = 8.889;
%pid.Ki = 124.310;
%pid.Kd = 0.1589;
%pid.Tl = 0.0074;
pid.rdev_num = [1 0];
pid.rdev_den = [pid.Tl 1];

%% Plant

s = tf('s');  % Definizione della variabile di Laplace

% Funzione di trasferimento semplificata del motore   
P = k_m / ((T_m * s + 1) * (gbox.N * s));

% Calcolo del gunadagno da imporre per il PID
P_mag = abs(evalfr(P, 1j*omega_gc));  % Modulo di P(jωgc)

P_phase = angle(evalfr(P, 1j*omega_gc)) * 180/pi;  % Fase di P in gradi ( sarebbe da sostituire con rad2deg ma non va)
delta_phi = -180 + phi_m - P_phase;


%% Anti-windup 

T_w = ts5/5;
K_w = 1 / T_w;

%% Feedforward compensations 
N = gbox.N;

P_ud = Req / (kdrv*current2Torque*N); 

tau_sf = 0.0093;
Beq = 1.0742e-06;
Jeq = 4.7887e-07;

inertia_comp = (N*Req*Jeq) / (kdrv*mot.Kt);
friction_comp = Req / (kdrv*mot.Kt*N);
BEMF_comp = (N*mot.Ke) / kdrv;
tauf = N^2 * Beq;


HPF_omega_c = 2*pi*50;
HPF_delta = 1/sqrt(2);

s = tf('s');  % Definizione della variabile di Laplac

H1 = (HPF_omega_c^2*s) / (s^2 + 2*HPF_delta*HPF_omega_c*s + HPF_omega_c^2);


