%% State Space model
ssc.A = [
    0,                                  0,                         1,                                    0;
    0,                                  0,                         0,                                    1;
    0,             kappa/(gbox.N^2 * Jeq),     -1/Jeq*(Beq + mot.Kt*mot.Ke/Req),                         0;
    0,-kappa/mld.Jb-kappa/(Jeq * gbox.N^2),  -mld.Bb/mld.Jb + 1/Jeq*(Beq + mot.Kt*mot.Ke/Req),  -mld.Bb/mld.Jb
];
ssc.B = [
    0;
    0;
    mot.Kt * kdrv / (gbox.N * Jeq * Req);
   -mot.Kt * kdrv / (gbox.N * Jeq * Req)
];

ssc.Bd = [
    0;
    0;
   -1 / (gbox.N^2 * Jeq);
    1 / (gbox.N^2 * Jeq)
];

ssc.C = [1 0 0 0];

sysG = ss(ssc.A,ssc.B,ssc.C,0);
sysGp = ss(-ssc.A,-ssc.B,ssc.C,0);

%% Eigenvalue Placement
Mp = 0.3;
ts5 = 0.5;
d = log(1/Mp)/sqrt(pi^2+(log(1/Mp))^2);
wn = 3/(d*ts5);
p = atan(sqrt(1-d^2)/d);
%eigvals =wn*exp(-j*pi)*[exp(j*p),exp(-j*p),exp(j*p/2),exp(-j*p/2)];
%eigvals =-wn*[exp(j*p),exp(-j*p),exp(j*p/2),exp(-j*p/2)];
eigvals = wn * exp(1j * [-pi + p, -pi - p, -pi + p/2, -pi - p/2]);
%eigvals = [-8.07+j*9.62,-8.07-j*9.62, -3.68+j*1.53,-3.68-j*1.53];

ssc.K = acker(ssc.A,ssc.B,eigvals);
ssc.sol = [[ssc.A ssc.B];[ssc.C 0]]\[[0;0;0;0];1];
ssc.Nx = ssc.sol(1:4);
ssc.Nu = ssc.sol(5);


%% ROOT LOCUS

ts5=0.55;
figure;
rlocus(sysG*sysGp)
grid on
hold on
xline(-3/ts5, 'r--', 'Min σ', 'LabelOrientation','horizontal');

s = axis;  % get current axis limits
r = abs(s(1));  % radius from origin to left
% Draw cone boundaries
line([-1 0]*r, [-1 0]*r*tan(p), 'Color','r','LineStyle','--');  % lower bound
line([-1 0]*r, [1 0]*r*tan(p), 'Color','r','LineStyle','--');   % upper bound

gain = 3.5e3;            
r = 1/gain;
poles_r = rlocus(sysG*sysGp, gain);  % poles at that gain
plot(real(poles_r), imag(poles_r), 'mo', 'MarkerSize', 10, 'LineWidth', 2);
plot(real(eigvals), imag(eigvals), 'r^', 'MarkerSize', 10, 'LineWidth', 2);

%% LQR

% Convert reference and tolerances to radians
theta_h_max = 0.3 * 50 * pi / 180;    % ≈ 0.2618 rad
theta_d_max = pi / 36;                % ≈ 0.0873 rad
%u_max       = drv.outmax;                     % 12 V
u_max = 10;

%SRL
ssc_LQR_SRL.R = r;
ssc_LQR_SRL.Q = 1;
ssc_LQR_SRL.K = lqry(sysG,1,ssc_LQR_SRL.R);

ssc_LQR_SRL.sol = [[ssc.A ssc.B];[ssc.C 0]]\[[0;0;0;0];1];
ssc_LQR_SRL.Nx = ssc_LQR_SRL.sol(1:4);
ssc_LQR_SRL.Nu = ssc_LQR_SRL.sol(5);

ssc_LQR_BRY.Q = diag([1/theta_h_max^2, 1/theta_d_max^2, 0, 0]);
ssc_LQR_BRY.R = 1 / u_max^2;
ssc_LQR_BRY.K = lqr(sysG,ssc_LQR_BRY.Q,ssc_LQR_BRY.R);
% check sysG !!

ssc_LQR_BRY.sol = [[ssc.A ssc.B];[ssc.C 0]]\[[0;0;0;0];1];
ssc_LQR_BRY.Nx = ssc_LQR_BRY.sol(1:4);
ssc_LQR_BRY.Nu = ssc_LQR_BRY.sol(5);

%% Agumented LQR

ssc_LQR_aug.Ae = [[0 ssc.C];[[0;0;0;0], ssc.A]];
ssc_LQR_aug.Be = [0; ssc.B];
% Note that (Ae, Be) is reachable as reachability matrix has rank = 3
ssc_LQR_aug.Ce = [ssc.C 0];

sysAug = ss(ssc_LQR_aug.Ae,ssc_LQR_aug.Be,ssc_LQR_aug.Ce,0);
sysAugp = ss(-ssc_LQR_aug.Ae,-ssc_LQR_aug.Be,ssc_LQR_aug.Ce,0);

%% ROOT LOCUS

figure;
rlocus(sysAug*sysAugp)
grid on
hold on
xline(-3/ts5, 'r--', 'Min σ', 'LabelOrientation','horizontal');

s = axis;  % get current axis limits
r = abs(s(1));  % radius from origin to left
% Draw cone boundaries
line([-1 0]*r, [-1 0]*r*tan(p), 'Color','r','LineStyle','--');  % lower bound
line([-1 0]*r, [1 0]*r*tan(p), 'Color','r','LineStyle','--');   % upper bound

gain_aug = 3e6;             
r_aug = 1/gain_aug;
poles_r = rlocus(sysAug*sysAugp, gain);  % poles at that gain
plot(real(poles_r), imag(poles_r), 'mo', 'MarkerSize', 10, 'LineWidth', 2);
%% Feedback Matrices for agumented state space

ssc_LQR_aug.R = r_aug;
ssc_LQR_aug.Q = 1;
ssc_LQR_aug.Ke = lqry(sysAug,ssc_LQR_aug.Q,ssc_LQR_aug.R);
%ssc_LQR_aug.Q = diag([1/theta_h_max^2, 1/theta_d_max^2, 0, 0,0]);
%ssc_LQR_aug.R= ssc_LQR.R;
%ssc_LQR_aug.Ke = lqr(sysAug, ssc_LQR_aug.Q,ssc_LQR_aug.R);
ssc_LQR_aug.Ki =ssc_LQR_aug.Ke(1);
ssc_LQR_aug.K =ssc_LQR_aug.Ke(2:5);
ssc_LQR_aug.Nx =ssc_LQR_SRL.Nx;
ssc_LQR_aug.Nu = ssc_LQR_SRL.Nu;