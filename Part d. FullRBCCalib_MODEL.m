function F = FullRBCCalib_MODEL(GUESS)

%MAKE PARAMETERS GLOBAL
global psi a eta astar gstar etastar B d dstar...
    Zbar Zbarstar chi chistar rho1 rho1star phi1 phi1star...
     g gy_ratio gystar_ratio target_N_ratio


%ASSIGN NAMES TO INITIAL GUESS VECTOR
C = GUESS(1);
Cstar = GUESS(2);
I = GUESS(3);
Istar = GUESS(4);
Y = GUESS(5);
Ystar = GUESS(6);
N = GUESS(7);
Nstar = GUESS(8);
K = GUESS(9);
Kstar = GUESS(10);
z = GUESS(11);
zstar = GUESS(12);
NX = GUESS(13);
NXstar = GUESS(14);
g = GUESS(15)

%MODEL EQUATIONS
ss1 = ( 1 - psi )*C - psi*Cstar; %First consumption equation
ss2 = C + I + (0.2102921*Y) + Cstar + Istar + (0.2341014*Ystar) - Y - Ystar; %Second consumption equation
ss3 = ( ( a/g )*( Y/C ) )^( eta/( 1 + eta ) ) - N; %Home labor equation
ss4 = ( ( astar/gstar )*( Ystar/Cstar ) )^( etastar/( 1 + etastar ) ) - Nstar; %Home labor equation
ss5 = B*( ( 1 - a )*Y/K + ( 1 - d ) ) - 1; %Home capital equation
ss6 = B*( ( 1 - astar )*Ystar/Kstar + ( 1 - dstar ) ) - 1; %Home capital equation
ss7 = d*K - I; %Home investment equation
ss8 = dstar*Kstar - Istar; %Foreign investment equation
ss9 = Zbar*z*( N^a )*( K^( 1 - a ) ) - Y; %Home output equation
ss10 = Zbarstar*zstar*( Nstar^astar )*( Kstar^( 1 - astar ) ) - Ystar; %Foreign output equation
ss11 = Y - C - I - (0.2102921*Y)- NX; %Home net exports equation
ss12 = Ystar - Cstar - Istar - (0.2341014*Ystar) - NXstar; %Foreign net exports equation
ss13 = chi + rho1*log(z) + rho1star*log(zstar) - log(z); %Home productivity equation
ss14 = chistar + phi1*log(z) + phi1star*log(zstar) - log(zstar); %Foreign productivity equation
ss15 = (N / Nstar) - target_N_ratio;

F = [ss1 ss2 ss3 ss4 ss5 ss6 ss7 ss8 ss9 ss10 ss11 ss12 ss13 ss14 ss15];
