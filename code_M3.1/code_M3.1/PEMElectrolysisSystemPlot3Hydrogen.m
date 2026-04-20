% Code to plot simulation results from PEMElectrolysisSystem
%% Plot Description:
%
% This plot shows the rate of hydrogen produced, the rate of water consumed
% at the anode, as well as the rate of water transported to the cathode due
% to diffusion, electro-osmosis drag, and hydraulic pressure difference. As
% a result, a dehumidification step is necessary to produce hydrogen at the
% desired purity.
%
% This plot also shows the total mass of hydrogen produced and the
% equivalent energy based on its higher heating value. This provides an
% indication of the amount of energy available if the hydrogen is used to
% generate power in a fuel cell.

% Copyright 2021 The MathWorks, Inc.

% Generate simulation results if they don't exist or are outdated
if ~exist('simlog_PEMElectrolysisSystem', 'var') || ...
        (get_param('PEMElectrolysisSystem', 'RTWModifiedTimeStamp') ~= ...
        simscape.logging.timestamp(simlog_PEMElectrolysisSystem))
    sim('PEMElectrolysisSystem')
end

% Reuse figure if it exists, else create new figure
if ~exist('h3_PEMElectrolysisSystem', 'var') || ...
        ~isgraphics(h3_PEMElectrolysisSystem, 'figure')
    h3_PEMElectrolysisSystem = figure('Name', 'PEMElectrolysisSystem');
end
figure(h3_PEMElectrolysisSystem)
clf(h3_PEMElectrolysisSystem)

plotHydrogen(simlog_PEMElectrolysisSystem)



% Plot hydrogen production
function plotHydrogen(simlog)

% Get simulation results
t = simlog.Membrane_Electrode_Assembly.H2_produced.series.time;
H2_produced = simlog.Membrane_Electrode_Assembly.H2_produced.series.values('g/s');
H2O_consumed = simlog.Membrane_Electrode_Assembly.H2O_consumed.series.values('g/s');
H2O_transport = simlog.Membrane_Electrode_Assembly.H2O_transport.series.values('g/s');
power_elec = simlog.Membrane_Electrode_Assembly.power_elec.series.values('kW');
power_dissipated = simlog.Membrane_Electrode_Assembly.power_dissipated.series.values('kW');

M_H2 = cumtrapz(t, H2_produced) * 1e-3;
E_H2 = cumtrapz(t, power_elec - power_dissipated) / 3600;

% Plot results
handles(1) = subplot(2, 1, 1);
plot(t, H2_produced, 'LineWidth', 1)
hold on
plot(t, H2O_consumed, 'LineWidth', 1)
plot(t, H2O_transport, 'LineWidth', 1)
grid on
legend('H2 Produced', 'H2O Consumed', 'H2O Transported', 'Location', 'best')
title('Hydrogen and Water in MEA')
ylabel('Mass Flow Rate (g/s)')
handles(2) = subplot(2, 1, 2);
yyaxis left
plot(t, M_H2, 'LineWidth', 1)
grid on
title('Hydrogen Produced')
ylabel('Mass (kg)')
yyaxis right
plot(t, E_H2, 'LineWidth', 1)
ylim(max(ylim, 0))
ylabel('Energy (kWh)')
xlabel('Time (s)')
set(gca, 'LineWidth', 1)

linkaxes(handles, 'x')

end

fig = gcf;   % get current figure

set(fig,'Units','centimeters','Position',[2 2 8 6]);  % 屏幕显示尺寸

% 同步导出尺寸（非常重要）
set(fig,'PaperUnits','centimeters');
set(fig,'PaperPosition',[0 0 8 6]);
set(fig,'PaperSize',[8 6]);