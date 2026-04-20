% Code to plot simulation results from PEMElectrolysisSystem
%% Plot Description:
%
% This plot shows the electrical power consumed by the electrolyzer. The
% electrical power is greater than the power needed to produce hydrogen due
% to various losses. The difference is the heat dissipated.
%
% This plot also shows the thermal efficiency of the electrolyzer, which
% indicates the fraction of the electrical power used to generate hydrogen
% based on hydrogen's heating value. This electrolyzer is about 87%
% efficient at a current density of 2 A/cm^2.

% Copyright 2021 The MathWorks, Inc.

% Generate simulation results if they don't exist or are outdated
if ~exist('simlog_PEMElectrolysisSystem', 'var') || ...
        (get_param('PEMElectrolysisSystem', 'RTWModifiedTimeStamp') ~= ...
        simscape.logging.timestamp(simlog_PEMElectrolysisSystem))
    sim('PEMElectrolysisSystem')
end

% Reuse figure if it exists, else create new figure
if ~exist('h2_PEMElectrolysisSystem', 'var') || ...
        ~isgraphics(h2_PEMElectrolysisSystem, 'figure')
    h2_PEMElectrolysisSystem = figure('Name', 'PEMElectrolysisSystem');
end
figure(h2_PEMElectrolysisSystem)
clf(h2_PEMElectrolysisSystem)

plotPower(simlog_PEMElectrolysisSystem)



% Plot power and efficiency
function plotPower(simlog)

% Get simulation results
t = simlog.Membrane_Electrode_Assembly.power_elec.series.time;
power_elec = simlog.Membrane_Electrode_Assembly.power_elec.series.values('kW');
power_dissipated = simlog.Membrane_Electrode_Assembly.power_dissipated.series.values('kW');
eta_HHV = simlog.Membrane_Electrode_Assembly.efficiency_HHV.series.values('1');
eta_LHV = simlog.Membrane_Electrode_Assembly.efficiency_LHV.series.values('1');

% Plot results
handles(1) = subplot(2, 1, 1);
plot(t, power_elec, 'LineWidth', 1)
hold on
plot(t, power_dissipated, 'LineWidth', 1)
grid on
legend('Electrical Supply', 'Heat Dissipated', 'Location', 'best')
title('Power (kW)')
handles(2) = subplot(2, 1, 2);
plot(t, eta_HHV*100, 'LineWidth', 1)
hold on
plot(t, eta_LHV*100, 'LineWidth', 1)
grid on
legend('Based on HHV', 'Based on LHV', 'Location', 'best')
title('Thermal Efficiency (%)')
xlabel('Time (s)')

linkaxes(handles, 'x')

end

fig = gcf;   % get current figure

set(fig,'Units','centimeters','Position',[2 2 8 6]);  % 屏幕显示尺寸

% 同步导出尺寸（非常重要）
set(fig,'PaperUnits','centimeters');
set(fig,'PaperPosition',[0 0 8 6]);
set(fig,'PaperSize',[8 6]);