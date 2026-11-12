clear all 
clc 


%MAKE PARAMETERS GLOBAL
global psi a eta astar gstar etastar B d dstar...
    Zbar Zbarstar chi chistar rho1 rho1star phi1 phi1star...
    g gy_ratio gystar_ratio target_N_ratio

%DECLARE PARAMETER VALUES
psi = 0.5; %Value of pareto weight for Home
gy_ratio = 0.2102921; 
gystar_ratio = 0.2341014;
target_N_ratio = 1.7212276;
a = 0.6261774; %Home labor share
g = 1.2933; %Home labor disutility parameter
eta = 4; %Home Frisch labor-supply elasticity
astar = 0.610943; %Foreign labor share
gstar = 1; %Foreign labor disutility parameter
etastar = 4; %Foreign Frisch labor-supply elasticity
B = 0.952; %Household subjective discount factor
d = 0.0489669; %Home capital depreciation rate
dstar = 0.0468721; %Foreign capital depreciation rate
Zbar = 1.140758039274864; %Home production scaling parameter
Zbarstar = 1; %Foreign production scaling parameter
chi = 0.0189394; %Home VAR productivity constant
chistar = 0.0110148; %Foreign VAR productivity constant
rho1 = 1.001897; %Home VAR coefficient
rho1star = -.0412054; %Home VAR coefficient
phi1 = 0.1561653; %Foreign VAR coefficient
phi1star = 0.768823; %Foreign VAR coefficient

%DECLARE INITIAL GUESS VECTOR
GUESS = [3.69147075240786,3.69147075240786,1.57733571047753,0.652628675671557,8.75835406881109,3.52052411615265,1.11728809012613,0.649122806377340,33.6519104217121,14.2216081951643,1.92414711645680,1.63193232082740,1.64773493625187,-1.64773493625187,1.2]

%IMPLEMENT OPTIMIZATION ROUTINE
[RESULT,fval,exitflag] = fsolve('FullOERBCCalib_MODEL',GUESS,optimset('disp','iter','MaxFunEvals',...
    200000,'MaxIter',200000,'TolFun',1.0e-16));

%ASSIGN NAMES TO OUTPUT VECTOR
C = RESULT(1);
Cstar = RESULT(2);
I = RESULT(3);
Istar = RESULT(4);
Y = RESULT(5);
Ystar = RESULT(6);
N = RESULT(7);
Nstar = RESULT(8);
K = RESULT(9);
Kstar = RESULT(10);
z = RESULT(11);
zstar = RESULT(12);
NX = RESULT(13);
NXstar = RESULT(14);
g = RESULT(15)

%STEADY STATE TABLE
TABLE_SS = [C; Cstar; I; Istar; Y; Ystar; N; Nstar; K; Kstar; z; zstar; NX; NXstar]; 
labels2 = char('C__','Cstar__','I__','Istar__','Y__','Ystar__','N__','Nstar__','K__','Kstar__','z__','zstar__','NX__','NXstar__');
TABLE = [labels2 num2str(TABLE_SS)]

G_final = gy_ratio * Y;
Gstar_final = gystar_ratio * Ystar;
g_calibrated = RESULT(15); 

fprintf('Calibrated G: %f\n', G_final);
fprintf('Calibrated Gstar: %f\n', Gstar_final);
fprintf('Calibrated gamma (g): %f\n', g_calibrated);
