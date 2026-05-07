%% State feedback (from StateSpaceScript.m)
ssc.A = [[0 1];[0 -1/Tm]];
ssc.B = [0; km/(gbox.N*Tm)];
ssc.C = [1 0];
ssc.D = 0;

%% Reduced order state Observer

obs_eigval = 5*sigma;

roso.L = -obs_eigval+ssc.A(2,2);
%roso.L = (ssc.A(2,2)-obs_eigval) / ssc.A(1,2); %observer gain
%roso.L = ssc.A(1,2)/(ssc.B(2)-ssc.A(2,2));
%roso.L = 200;
roso.T_basis = eye(2);

roso.A = (roso.T_basis)^-1*ssc.A*roso.T_basis;
roso.B = (roso.T_basis)^-1*ssc.B;
roso.C = ssc.C*roso.T_basis;
roso. D = 0;

roso.A0 = (roso.A(2,2)-roso.L);
roso.B0 = [roso.B(2), roso.A0*roso.L];
roso.C0 = [0;1];
roso.D0 = [[0,1];[0,roso.L]];

%% this list of params is useless
roso.H = roso.B(1)+roso.L*roso.B(2);
roso.F = roso.A(1,1)+roso.L*roso.A(2,1);
roso.G =roso.A(1,2)+roso.L*roso.A(2,2)-roso.A(1,1)*roso.L-roso.L*roso.A(2,1)*roso.L;

roso.L =acker(roso.A(2,2),roso.A(1,2),[obs_eigval]);
F = roso.A(2,2)-roso.L*(roso.C(1)*roso.A(1,2));
H = roso.B(2)-roso.L*roso.C(1)*roso.B(1);
G = roso.A(2,1)-roso.L*roso.A(1,1)+F*roso.L;

%% Discrete Time Observer(Forward Euler)
roso_fe.T = 1e-3;
roso_fe.phi = 1+roso.A0*roso_fe.T;
roso_fe.gamma = roso.B0*roso_fe.T;
roso_fe.H0 = roso.C0;
roso_fe.J0 = roso.D0;

%% Discrete Time Observer(Backward Euler)
roso_be.T = 1e-3;
roso_be.phi = (1-roso.A0*roso_be.T)^-1;
roso_be.gamma = roso_be.phi*roso.B0*roso_be.T;
roso_be.H0 = roso.C0*roso_be.phi;
roso_be.J0 = roso.D0+roso_be.H0*roso_be.T*roso.B0;

%% Discrete Time Observer(Tustin)
roso_tu.T = 1e-3;
roso_tu.phi = (1+(roso.A0*roso_tu.T)/2)*(1-(roso.A0*roso_tu.T)/2)^-1;
roso_tu.gamma = ((1-(roso.A0*roso_tu.T)/2)^-1)*roso.B0*sqrt(roso_tu.T);
roso_tu.H0 = sqrt(roso_tu.T)*roso.C0*(1-(roso.A0*roso_tu.T)/2)^-1;
roso_tu.J0 = roso.D0+roso.C0*((1-(roso.A0*roso_tu.T)/2)^-1)*roso.B0*roso_tu.T/2;

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
