var N K C I Y z NX Nstar Kstar Cstar Istar Ystar zstar NXstar;

varexo ez ezstar;

parameters a astar B g gstar d dstar eta rho1 rho1star phi1 phi1star chi chistar sigmasq sigmastarsq G Gstar Zbar Zbarstar psi corr_ez_ezstar;

a = 0.6261774;
astar = 0.610943; 
B = 0.952;
g = 1.285278;
gstar = 1;
d = 0.0489669;
dstar = 0.0468721;
eta = 4; 
rho1 = 1.001897;
rho1star = -.0412054; 
phi1 = 0.1561653;
phi1star = 0.768823;
chi = 0.0189394;
chistar = 0.0110148; 
sigmasq = 0.00023;
sigmastarsq = 0.00032;
G = 1.83367;
Gstar = 0.82566;
Zbar = 1.140758039274864; 
Zbarstar = 1;
psi = 0.5;
corr_ez_ezstar = 0.3846;

model;
I = K - ( 1 - d )*K(-1);
Istar = Kstar - ( 1 - dstar )*Kstar(-1);
Y = Zbar*z*N^a*K(-1)^(1-a);
Ystar = Zbarstar*zstar*Nstar^astar*Kstar(-1)^(1-astar);
N = ( ( a/g )*( Y/C ) )^( eta/( 1 + eta ) );
Nstar = ( ( astar/gstar )*( Ystar/Cstar ) )^( eta/( 1 + eta ) );
1 = B*( C/C(+1) )*( ( 1 - a )*Y(+1)/K + ( 1 - d ) );
1 = B*( Cstar/Cstar(+1) )*( ( 1 - astar )*Ystar(+1)/Kstar + ( 1 - dstar ) );
C = ( psi/( 1 - psi ) )*Cstar;
Y = C + I + G + Cstar + Istar + Gstar - Ystar;
log(z) = chi + rho1*log(z(-1)) + rho1star*log(zstar(-1)) + ez;
log(zstar) = chistar + phi1*log(z(-1)) + phi1star*log(zstar(-1)) + ezstar;
NX = Y - C - I - G;
NXstar = Ystar - Cstar - Istar - Gstar;
end;

initval;
C = 3.66011;
Cstar = 3.66011;
I = 1.60597;
Istar = 0.66107;
Y = 8.71963;
Ystar = 3.52695;
N = 1.12658;
Nstar = 0.65452;
K = 32.7970;
Kstar = 14.1039;
z = 1.92415;
zstar = 1.63193;
NX = 1.61989;
NXstar = -1.61989;
end;

shocks;
var ez = sigmasq;
var ezstar = sigmastarsq;
corr ez, ezstar = corr_ez_ezstar;
end;

resid;
steady;
check;
model_diagnostics;
set_dynare_seed(2026);

// Retain original shock variances pending reconciliation with empirical results.
stoch_simul(order=1,irf=20,periods=1053);
