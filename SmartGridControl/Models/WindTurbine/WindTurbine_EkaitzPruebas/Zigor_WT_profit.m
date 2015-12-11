function [B,Production]=Zigor_WT_profit(ProductionPU,Price,Wind,SP)

%% Wind Turbine Parameter loading

Param_s.Vcuton=SP.Model.Params.Vcuton;
Param_s.Vcutoff=SP.Model.Params.Vcutoff;
Param_m.PowerCurve=SP.Model.Params.PowerCurve;
Param.nPW=SP.Model.Params.nPW;
Param.MaxPW=SP.Model.Params.MaxPW;
Param.Eff.Ploss_off=SP.Model.Params.Ploss_off;
Param.Eff.Ploss_on=SP.Model.Params.Ploss_on;
Param.Eff.Eff_hl=SP.Model.Params.Eff_hl;
Param.Eff.Eff_fl=SP.Model.Params.Eff_fl;
Param.MinWindPW_On=SP.Model.Params.MinWindPW_On;
Param.MinWindPW_av=SP.Model.Params.MinWindPW_av;

NtimeSlots = SP.OptimParams.horizon/SP.OptimParams.tSample;


%Control time series
WT_Shaving_Ctl=ProductionPU;%Algo progresivo de 0 a 1. Variable a manipular, a determinar por nuestro algoritmo
WT_Ctl=ones(NtimeSlots,1); %Disponibilidad 0 o 1

% Wind Turbine power resource
pwTurbine=PowWind_WT(Param_s,Param_m,Wind);
% Wind Turbine's power stage energy production
pwE=PowElec_WT(Param,pwTurbine,WT_Ctl,WT_Shaving_Ctl);
Production=pwE;
%%Profit calculation
B=-Production*Price;
