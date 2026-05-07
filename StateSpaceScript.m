%% Estimated Params
Jeq = 6.6e-7;
Tau = 9.4e-3;
Beq = 8e-7;

%% Real derivative filter

dev_wc = 2*pi*50;
dev_delta = 1/sqrt(2);
Ts = 1e-3;
N=10;

num_dev1 = [dev_wc^2 0];
den_dev1 = [1 2*dev_delta*dev_wc dev_wc^2 ];

%% State feedback

% original eigval params
Mp = 0.1;
ts5 = 0.15;
d = log(1/Mp)/sqrt(pi^2+(log(1/Mp))^2);
wn = 3/(d*ts5);

sigma = -d*wn;
wd = wn*sqrt(1-d^2);

% state space params
Req = mot.R + snes.curr.Rs;
km = kdrv*mot.Kt/(Req*Beq + mot.Kt*mot.Ke);
Tm=Req*Jeq/(Req*Beq+mot.Kt*mot.Ke);

%% State feedback
ssc.A = [[0 1];[0 -1/Tm]];
ssc.B = [0; km/(gbox.N*Tm)];
ssc.C = [1 0];
ssc.D = 0;

%% Pole placement state feedback
ssc.K = acker(ssc.A,ssc.B,[sigma+j*wd, sigma-j*wd]);
ssc.sol = [[ssc.A ssc.B];[ssc.C 0]]\[[0;0];1];
ssc.Nx = ssc.sol(1:2);
ssc.Nu = ssc.sol(3);

%% Agumented State feedback

ssc_aug.Ae = [[0 ssc.C];[[0;0], ssc.A]];
ssc_aug.Be = [0; ssc.B];
% Note that (Ae, Be) is reachable as reachability matrix has rank = 3
ssc_aug.Ce = [0 ssc.C];
%% Feedback Matrices for agumented state space

ssc_aug.K1e = acker(ssc_aug.Ae,ssc_aug.Be,[sigma+j*wd,sigma-j*wd,sigma]);
ssc_aug.Ki1 = ssc_aug.K1e(1);
ssc_aug.K1 = ssc_aug.K1e(2:3);

ssc_aug.K2e = acker(ssc_aug.Ae, ssc_aug.Be, [sigma ,sigma ,sigma]);
ssc_aug.Ki2 = ssc_aug.K2e(1);
ssc_aug.K2 = ssc_aug.K2e(2:3);

ssc_aug.K3e = acker(ssc_aug.Ae, ssc_aug.Be, [2*sigma+j*wd,2*sigma-j*wd ,2*sigma]);
ssc_aug.Ki3 = ssc_aug.K3e(1);
ssc_aug.K3 = ssc_aug.K3e(2:3);

ssc_aug.K4e = acker(ssc_aug.Ae, ssc_aug.Be, [2*sigma+j*wd,2*sigma-j*wd ,3*sigma]);
ssc_aug.Ki4 = ssc_aug.K4e(1);
ssc_aug.K4 = ssc_aug.K4e(2:3);

ssc_aug.Nx =ssc.Nx;
ssc_aug.Nu = ssc.Nu;

%% Error space approach

% Tr1 = 0.15;
% A1 = [[0 1];[-2*pi/Tr1 0]];
% Tr2 = 0.25;
% A2 = [[0 1];[-2*pi/Tr2 0]];
% Tr3 = 0.5;
% A3 = [[0 1];[-2*pi/Tr3 0]];
% Tr4 = 1;
% A4 = [[0 1];[-2*pi/Tr4 0]];

Tr = [0.15, 0.25, 0.5, 1];
wr = 2*pi*[1/0.15, 1/0.25, 1/0.5, 1];
Ar = cell(1, length(Tr));
for i = 1:length(Tr)
    Ar{i} = [[0 1 0]; [0 0 1];[0 -wr(i)^2 0]];
end
% Access matrices as A{1}, A{2}, A{3}, A{4}
err_ssc.Bz = [0;0;0;ssc.B];
eigvals = wn*[exp(j*(-pi+pi/4)), exp(j*(-pi-pi/4)), exp(j*(-pi+pi/6)), exp(j*(-pi-pi/6)),-1];


%% Error space approach for Az1, Az2, Az3, Az4

% Az1
err_ssc.Az1 = [Ar{1} [[0 0]; [0 0]; ssc.C]; [[[0 0 0]; [0 0 0]] ssc.A]];
err_ssc.K1z = acker(err_ssc.Az1, err_ssc.Bz, eigvals);
err_ssc.K1 = err_ssc.K1z(1:3);
err_ssc.K1_xi = err_ssc.K1z(4:5);
num_H1 = flip(err_ssc.K1);
den_H1 = [1 0 wr(1)^2 0];

% Az2
err_ssc.Az2 = [Ar{2} [[0 0]; [0 0]; ssc.C]; [[[0 0 0]; [0 0 0]] ssc.A]];
err_ssc.K2z = acker(err_ssc.Az2, err_ssc.Bz, eigvals);
err_ssc.K2 = err_ssc.K2z(1:3);
err_ssc.K2_xi = err_ssc.K2z(4:5);
num_H2 = flip(err_ssc.K2);
den_H2 = [1 0 wr(2)^2 0];

% Az3
err_ssc.Az3 = [Ar{3} [[0 0]; [0 0]; ssc.C]; [[[0 0 0]; [0 0 0]] ssc.A]];
err_ssc.K3z = acker(err_ssc.Az3, err_ssc.Bz, eigvals);
err_ssc.K3 = err_ssc.K3z(1:3);
err_ssc.K3_xi = err_ssc.K3z(4:5);
num_H3 = flip(err_ssc.K3);
den_H3 = [1 0 wr(3)^2 0];

% Az4
err_ssc.Az4 = [Ar{4} [[0 0]; [0 0]; ssc.C]; [[[0 0 0]; [0 0 0]] ssc.A]];
err_ssc.K4z = acker(err_ssc.Az4, err_ssc.Bz, eigvals);
err_ssc.K4 = err_ssc.K4z(1:3);
err_ssc.K4_xi = err_ssc.K4z(4:5);
num_H4 = flip(err_ssc.K4);
den_H4 = [1 0 wr(4)^2 0];

