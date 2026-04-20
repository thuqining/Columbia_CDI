%% params_co2el.m  (Power-driven CO2 electrolyzer, lookup-based)
% Put this file in the same folder as your .slx, then run:
%   params_co2el

%% ===== Constants =====
F = 96485.33212;          % Faraday constant [C/mol]

%% ===== Stack / geometry (YOU edit) =====
A_cm2  = 200;              % Active electrode area per cell [cm^2]
N_cell = 200;              % Number of cells in series (stack), assume

%% ===== Molecular weights (optional for mass-flow outputs) =====
MW_CO  = 28.0101e-3;      % [kg/mol]
MW_H2  = 2.01588e-3;      % [kg/mol]
MW_CO2 = 44.0095e-3;      % [kg/mol]

%% ===== Lookup Table data (must be strictly increasing in breakpoints) =====
% Breakpoints: power density p = V_cell * j_tot
% Unit: mW/cm^2  (IMPORTANT: not W, not W/cm^2)

p_bp = [0
1.064483639
1.449787266
2.278993824
3.433222398
5.105558444
7.126880214
9.284710359
12.33435309
16.08899633
20.31014613
26.02537054
31.10302379
37.03290299
44.23049581
53.92954754
63.20265742
74.14767423
87.3834099
100.415962
111.7852827
123.1898513
134.1262401];

V_tab = [0
0.198058471
0.219794909
0.245491615
0.281066474
0.316647766
0.347294004
0.387810351
0.435246713
0.480712591
0.526178469
0.569681908
0.606262114
0.636924438
0.670556159
0.712101983
0.747715446
0.786298307
0.833774882
0.878282061
0.918824144
0.962322757
1.001867535];

j_tab_mAcm2 = [0
5.374592834
6.596091205
9.283387622
12.21498371
16.1237785
20.52117264
23.94136808
28.33876221
33.46905537
38.59934853
45.68403909
51.3029316
58.14332248
65.96091205
75.73289902
84.5276873
94.29967427
104.8045603
114.3322476
121.6612378
128.0130293
133.8762215];

%% ===== Convenience limits for Saturation blocks =====
p_min = p_bp(1);
p_max = p_bp(end);

% If you want to limit stack power based on table range:
% P_stack_max_W = (p_max [mW/cm^2]) * (N_cell*A_cm2) / 1000
P_stack_max_W = p_max * (N_cell*A_cm2) / 1000;

%% ===== Unit conversions helpers (optional) =====
mA_to_A = 1e-3;

% If later you compute I from j:
% I_stack_A = j[mA/cm^2] * A_cm2 * 1e-3
