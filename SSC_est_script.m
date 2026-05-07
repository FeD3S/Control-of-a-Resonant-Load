%% State Space model
ssc_est.A = [
    0,                                  0,                         1,                                    0;
    0,                                  0,                         0,                                    1;
    0,             mld.k_est/(gbox.N^2 * Jeq),     -1/Jeq*(Beq + mot.Kt*mot.Ke/Req),                         0;
    0,-mld.k_est/mld.Jb-mld.k_est/(Jeq * gbox.N^2),  -mld.Bb_est/mld.Jb + 1/Jeq*(Beq + mot.Kt*mot.Ke/Req),  -mld.Bb_est/mld.Jb
];
ssc_est.B = [
    0;
    0;
    mot.Kt * kdrv / (gbox.N * Jeq * Req);
   -mot.Kt * kdrv / (gbox.N * Jeq * Req)
];

ssc_est.Bd = [
    0;
    0;
   -1 / (gbox.N^2 * Jeq);
    1 / (gbox.N^2 * Jeq)
];

ssc_est.C = [1 0 0 0];

sysG_est = ss(ssc_est.A,ssc_est.B,ssc_est.C,0);
sysGp_est = ss(-ssc_est.A,-ssc_est.B,ssc_est.C,0);

%% Eigenvalue Placement
Mp = 0.3;
ts5 = 0.5;
d = log(1/Mp)/sqrt(pi^2+(log(1/Mp))^2);
wn = 3/(d*ts5);
p = atan(sqrt(1-d^2)/d);
eigvals = wn * exp(1j * [-pi + p, -pi - p, -pi + p/2, -pi - p/2]);

ssc_est.K = acker(ssc_est.A,ssc_est.B,eigvals);
ssc_est.sol = [[ssc_est.A ssc_est.B];[ssc_est.C 0]]\[[0;0;0;0];1];
ssc_est.Nx = ssc_est.sol(1:4);
ssc_est.Nu = ssc_est.sol(5);

%% ROOT LOCUS

rlocus(sysG_est*sysGp_est)
grid on
hold on
xline(-3/ts5, 'r--', 'Min σ', 'LabelOrientation','horizontal');

s = axis;
r_est = abs(s(1));
line([-1 0]*r_est, [-1 0]*r_est*tan(p), 'Color','r','LineStyle','--');
line([-1 0]*r_est, [1 0]*r_est*tan(p), 'Color','r','LineStyle','--');

gain_est = 1.5e3;
r_est = 1/gain_est;
poles_r_est = rlocus(sysG_est*sysGp_est, gain_est);
plot(real(poles_r_est), imag(poles_r_est), 'mo', 'MarkerSize', 10, 'LineWidth', 2);
plot(real(eigvals), imag(eigvals), 'r^', 'MarkerSize', 10, 'LineWidth', 2);

%% LQR

theta_h_max = 0.3 * 50 * pi / 180;
theta_d_max = pi / 36;
u_max       = drv.outmax;

%SRL
ssc_LQR_SRL_est.R = r_est;
ssc_LQR_SRL_est.Q = 1;
ssc_LQR_SRL_est.K = lqry(sysG_est,1,ssc_LQR_SRL_est.R);

ssc_LQR_SRL_est.sol = [[ssc_est.A ssc_est.B];[ssc_est.C 0]]\[[0;0;0;0];1];
ssc_LQR_SRL_est.Nx = ssc_LQR_SRL_est.sol(1:4);
ssc_LQR_SRL_est.Nu = ssc_LQR_SRL_est.sol(5);

ssc_LQR_BRY_est.Q = diag([1/theta_h_max^2, 1/theta_d_max^2, 0, 0]);
ssc_LQR_BRY_est.R = 1 / u_max^2;
ssc_LQR_BRY_est.K = lqr(sysG_est,ssc_LQR_BRY_est.Q,ssc_LQR_BRY_est.R);

ssc_LQR_BRY_est.sol = [[ssc_est.A ssc_est.B];[ssc_est.C 0]]\[[0;0;0;0];1];
ssc_LQR_BRY_est.Nx = ssc_LQR_BRY_est.sol(1:4);
ssc_LQR_BRY_est.Nu = ssc_LQR_BRY_est.sol(5);

%% Agumented LQR

ssc_LQR_aug_est.Ae = [[0 ssc_est.C];[[0;0;0;0], ssc_est.A]];
ssc_LQR_aug_est.Be = [0; ssc_est.B];
ssc_LQR_aug_est.Ce = [ssc_est.C 0];

sysAug_est = ss(ssc_LQR_aug_est.Ae,ssc_LQR_aug_est.Be,ssc_LQR_aug_est.Ce,0);
sysAugp_est = ss(-ssc_LQR_aug_est.Ae,-ssc_LQR_aug_est.Be,ssc_LQR_aug_est.Ce,0);

%% ROOT LOCUS

rlocus(sysAug_est*sysAugp_est)
grid on
hold on
xline(-3/ts5, 'r--', 'Min σ', 'LabelOrientation','horizontal');

s = axis;
r_est = abs(s(1));
line([-1 0]*r_est, [-1 0]*r_est*tan(p), 'Color','r','LineStyle','--');
line([-1 0]*r_est, [1 0]*r_est*tan(p), 'Color','r','LineStyle','--');

gain_est = 3e6;
r_est = 1/gain_est;
poles_r_est = rlocus(sysAug_est*sysAugp_est, gain_est);
plot(real(poles_r_est), imag(poles_r_est), 'mo', 'MarkerSize', 10, 'LineWidth', 2);

%% Feedback Matrices for augmented state space

ssc_LQR_aug_est.R = r_est;
ssc_LQR_aug_est.Q = 1;
ssc_LQR_aug_est.Ke = lqry(sysAug_est,ssc_LQR_aug_est.Q,ssc_LQR_aug_est.R);
ssc_LQR_aug_est.Ki = ssc_LQR_aug_est.Ke(1);
ssc_LQR_aug_est.K = ssc_LQR_aug_est.Ke(2:5);