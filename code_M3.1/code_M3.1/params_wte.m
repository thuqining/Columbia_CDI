%% ====== WtE parameters (10 MW-class example) ======
% Units:
%   mw: kg/s (waste mass flow rate)
%   r : -   (combustion rate, 0~1)
%   Q : MWth (effective thermal power)
%   P : MW (electric power)

% --- Time constants (sub-minute dynamics) ---
tauQ = 20;          % s, furnace/boiler-to-heat effective time constant
tauP = 5;           % s, turbine-generator/power conversion time constant

% --- Conversion efficiencies ---
eta_th = 0.90;      % -, effective fraction of fuel chemical energy to usable heat
eta_e  = 0.25;      % -, heat-to-electric efficiency (steam cycle)

% --- Fuel property ---
LHV = 1.0e7;        % J/kg, lower heating value (10 MJ/kg)

% --- CO2 yield parameters (mass-based) ---
wC = 0.4;          % -, carbon mass fraction in waste (wet-basis if mw is wet)
eta_burn = 0.98;    % -, burnout efficiency (fraction of carbon fully oxidized)

% --- Derived gains ---
% kQ maps the effective fuel input (mw*r) to Q-dot in the heat state equation:
%   tauQ * dQ/dt = -Q + (eta_th*LHV/1e6) * (mw*r)
% => dQ/dt = -(1/tauQ) Q + kQ * (mw*r)
kQ = eta_th*LHV/(1e6*tauQ);   % (MW)/(kg/s) / s = MW/(kg) ??? -> used in B matrix below

% alpha maps waste mass flow to CO2 mass flow:
%   mCO2 = alpha * mw
alpha = wC * eta_burn * (44/12);  % -, (kg_CO2/s)/(kg_waste/s)

%% ====== State-space matrices ======
% States: x = [Q; P]
% Input:  u = mw*r   (kg/s)
% Output: y = [P] or [P; ...] depending on your C/D (see options below)

A = [ -1/tauQ,        0;
       eta_e/tauP, -1/tauP ];

B = [ (eta_th*LHV)/(1e6*tauQ);
      0 ];

C = [0, 1];
D = 0;

% Simulation time settings
%% -------------------------
dt = 1;            % [s] time step used to build input profiles (must match your intended sampling)
T_end = 3600;      % [s] total simulation duration
t = (0:dt:T_end)'; % [s] time vector (column)

%% -------------------------
% Input profile: combustion rate r(t)
%% -------------------------
% r(t) is a dimensionless utilization/combustion rate (e.g., 0~1).
% Provide r_values with the SAME length as t.
%r_values = 0.8 * ones(size(t));  % Example: constant 0.8 over the whole horizon

% Alternatively, define a time-varying profile, e.g. piecewise steps:
r_values(t >= 0    & t < 1200) = 0.6;
r_values(t >= 1200 & t < 2400) = 1;
r_values(t >= 2400            ) = 0.8;

% Build a timeseries for Simulink "From Workspace"
r_ts = timeseries(r_values, t);
% Use zero-order hold so r behaves like a sampled/stepwise signal
r_ts.DataInfo.Interpolation = 'zoh';


t_waste = (0:10:3600)';          % time [s]
mw_waste = 5 + 0.5*sin(2*pi*t_waste/3600);  % kg/s, example variation

mw_ts = timeseries(mw_waste, t_waste);


% ---- Option 2 (NOT recommended for your current structure):
% Output both P and CO2 from the State-Space block.
% This would require a 2-input model (mw and mw*r) or other arrangement.
% Keep Option 1 for simplicity and correctness.

%% ====== Initial conditions (optional) ======
% If you want to start at steady state for given mw0 and r0, set these.
% Otherwise keep x0 = [0;0].
% mw0 = 5.0;      % kg/s, nominal waste feed for initialization (edit as needed)
% r0  = 1.0;      % -, nominal combustion rate for initialization (edit as needed)
% 
% Q0 = (eta_th*LHV/1e6) * (mw0*r0);   % MWth, steady-state Q at (mw0,r0)
% P0 = eta_e * Q0;                    % MW, steady-state P
% x0 = [Q0; P0];                      % initial state vector for State-Space block
