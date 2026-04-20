% Code to plot simulation results from PEMElectrolysisSystem
%% Plot Description:
%
% This plot shows the current-voltage (i-v) curve and the power consumed by
% a cell in the stack. As the current ramps up, an initial rise in voltage
% occurs due to electrode activation losses, followed by a gradual increase
% in voltage due to Ohmic resistances. The cell voltage is about 1.71 V at
% a current density of 2 A/cm^2.

% Copyright 2021 The MathWorks, Inc.

% Generate simulation results if they don't exist or are outdated
if ~exist('simlog_PEMElectrolysisSystem', 'var') || ...
        (get_param('PEMElectrolysisSystem', 'RTWModifiedTimeStamp') ~= ...
        simscape.logging.timestamp(simlog_PEMElectrolysisSystem))
    sim('PEMElectrolysisSystem')
end

% Reuse figure if it exists, else create new figure
if ~exist('h1_PEMElectrolysisSystem', 'var') || ...
        ~isgraphics(h1_PEMElectrolysisSystem, 'figure')
    h1_PEMElectrolysisSystem = figure('Name', 'PEMElectrolysisSystem');
end
figure(h1_PEMElectrolysisSystem)
clf(h1_PEMElectrolysisSystem)

plotIV(simlog_PEMElectrolysisSystem)



% Plot electrolyzer i-v curve
function plotIV(simlog)

% Get simulation results
i_cell = simlog.Membrane_Electrode_Assembly.i_cell.series.values('A/cm^2');
v_cell = simlog.Membrane_Electrode_Assembly.v_cell.series.values('V');


% Plot results
yyaxis left
plot(i_cell, v_cell, 'LineWidth', 1)
grid on
title('Fuel Cell I-V Curve')
ylabel('Cell Voltage (V)')
yyaxis right
plot(i_cell, i_cell.*v_cell, 'LineWidth', 1)
ylabel('Power Density (W/cm^2)')
xlabel('Current Density (A/cm^2)')
set(gca, 'LineWidth', 1)

end

fig = gcf;   % get current figure

set(fig,'Units','centimeters','Position',[2 2 8 6]);  % 屏幕显示尺寸

% 同步导出尺寸（非常重要）
set(fig,'PaperUnits','centimeters');
set(fig,'PaperPosition',[0 0 8 6]);
set(fig,'PaperSize',[8 6]);