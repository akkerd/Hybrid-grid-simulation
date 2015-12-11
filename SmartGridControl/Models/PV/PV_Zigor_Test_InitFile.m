function [ DATA ] = PV_Zigor_Test_InitFile


% this function gives the model parameter; 

% Inputs
% combination ('paramName', paramValue)
% example: 
% [ DATA ] = Bat_CEA_Simplified_Integrator_LookupTable
% [ DATA ] = Bat_CEA_Simplified_Integrator_LookupTable('Capa_Max', 50)
% [ DATA ] = Bat_CEA_Simplified_Integrator_LookupTable('Capa_Max', 50, 'SOC_ini', 0.8)

%% Solar Panel
DATA.tilt = 30; % Angle of inclinaison of solar panels [°]
DATA.SO = -20; % South orientation of solar panel [°]
DATA.insPwPV = 16500; % Installed PV power (at 1000 W/m2 and 25 °C) [W]
DATA.TempPcoeffPV = -0.4; % Solar cells Power temperature coefficient [%/°C]
DATA.NOCT = 47; % NOCT (Nominal operating Cell Temperature) @ Tair = 28°C, G = 800 W/m2 [°C]
DATA.Kl = 0.95; % Factor for losses in the panel, shades and/or dust
DATA.Albedo=0.25; % Albedo (green grass surface example)


%% Inverter
DATA.nPW = 15000 ; % Nominal Power of the inverter [W]
DATA.Ploss_off = 0 ; % Power losses when PV inverter stopped [W]
DATA.Ploss_on = 15 ; % Power losses when PV inverter generating Ppv=0 [W]
DATA.Eff_hl = 97 ; % Efficiency at 50% load [%]
DATA.Eff_fl = 96 ; % Efficiency at 100% load [%]
DATA.MinPVPW_On = 150 ; % Minimum PV power for production [W]
DATA.MinPVPW_av = 100 ; % Minimum PV power to have the inverter available for communication purposes with BMS [W]

end




