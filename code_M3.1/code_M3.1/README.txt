# This is a high-order simulation model for synthetic gas production, here we include waste-to-energy plant, CO2 electrolyzer, water electrolyzer, etc.

#we have two separate model for CO2 electrolyzer, water electrolyzer: CO2_Electrolyzer.slx PEMElectrolysisSystem.slx

#we have three parameter setting profiles: params_wte.m, PEMElectrolysisSystemParameters.m, params_co2el.m. The parameters require further tuning.

#we have several plotting code: PEMElectrolysisSystemPlot1IV.m, PEMElectrolysisSystemPlot2Power.m, PEMElectrolysisSystemPlot3Hydrogen.m

#The overall Simulink model: Synthgas.slx