function [Results] = SolveProblem( SP )
%SolveProblem Summary of this function goes here
%   Detailed explanation goes here
  N = SP.OptimParams.horizon/SP.OptimParams.tSample;
  Time=SP.OptimParams.horizon*[0:N-1]'/N;

  IrrExtDir_Nor=SP.StoredData.irrDir;% No estoy seguro
  IrrExtDir_Hor=SP.StoredData.irrDif;% No estoy seguro
  Elevation_Angle=SP.StoredData.Elevation_Angle;
  Azimut_Angle=SP.StoredData.Azimut;
  TAirExt=SP.StoredData.TAirExt;
  Price=SP.StoredData.tariff;
 
 %% Solar Panel
  DATA.tilt = SP.Model.tilt; % Angle of inclinaison of solar panels [°]
  DATA.SO = SP.Model.SO; % South orientation of solar panel [°]
  DATA.insPwPV = SP.Model.insPwPV; % Installed PV power (at 1000 W/m2 and 25 °C) [W]
  DATA.TempPcoeffPV = SP.Model.TempPcoeffPV; % Solar cells Power temperature coefficient [%/°C]
  DATA.NOCT = SP.Model.NOCT; % NOCT (Nominal operating Cell Temperature) @ Tair = 28°C, G = 800 W/m2 [°C]
  DATA.Kl = SP.Model.Kl; % Factor for losses in the panel, shades and/or dust
  DATA.Albedo=SP.Model.Albedo; % Albedo (green grass surface example)


  %% Inverter
  DATA.nPW = SP.Model.nPW; % Nominal Power of the inverter [W]
  DATA.Ploss_off = SP.Model.Ploss_off; % Power losses when PV inverter stopped [W]
  DATA.Ploss_on = SP.Model.Ploss_on; % Power losses when PV inverter generating Ppv=0 [W]
  DATA.Eff_hl = SP.Model.Eff_hl; % Efficiency at 50% load [%]
  DATA.Eff_fl = SP.Model.Eff_fl; % Efficiency at 100% load [%]
  DATA.MinPVPW_On = SP.Model.MinPVPW_On; % Minimum PV power for production [W]
  DATA.MinPVPW_av = SP.Model.MinPVPW_av; % Minimum PV power to have the inverter available for communication purposes with BMS [W]

  Param=DATA;
  Param.Orientation.tilt=DATA.tilt;
  Param.Orientation.SO=DATA.SO;
  Param.Eff.Ploss_off = DATA.Ploss_off;
  Param.Eff.Ploss_on = DATA.Ploss_on;
  Param.Eff.Eff_hl = DATA.Eff_hl;
  Param.Eff.Eff_fl = DATA.Eff_fl;
  
  Posible_Shaving_Ctl=[0:0.1:1];
  PV_ON_Ctl=ones(1,length(Time));
  PV_Power=zeros(length(Time),length(Posible_Shaving_Ctl));

  for k1=1:length(Time)
      for k2=1:length(Posible_Shaving_Ctl)  
        PV_Shaving_Ctl=Posible_Shaving_Ctl(k2);
        P_Solar= PowSolar_PV(Param, IrrExtDir_Nor(k1),IrrExtDir_Hor(k1),Elevation_Angle(k1), Azimut_Angle(k1), TAirExt(k1)); 
        if P_Solar<0
            P_Solar=0;
        end
        P_Elec = PowElec_PV(Param, real(P_Solar), PV_ON_Ctl(k1), PV_Shaving_Ctl);
        PV_Power(k1,k2)=P_Elec;
      end
  end
  beta=SP.OptimParams.beta;
  Incentivemax=SP.OptimParams.Incentivemax;
  Incentivemin=SP.OptimParams.Incentivemin;
  PriceCutoff=SP.OptimParams.PriceCutoff;
  f=1./(1+exp(-(Price-PriceCutoff)/beta));
  IncentiveFactor=Incentivemin+(Incentivemax-Incentivemin)*f;
  IncentiveFactor(IncentiveFactor<0)=0;
  Results.pow=zeros(1,length(Time));
  Results.objval=0;
  Results.ProductionPUproposal=zeros(1,length(Time));
  for k1=1:length(Time)
      [Results.pow(k1),Ref]=min(PV_Power(k1,:)); %La generacion de potencia tiene signo negativo
      %IncentiveFactor(k1)
      Shaving_Ctl_Incentived=IncentiveFactor(k1)*Posible_Shaving_Ctl(Ref);  
      Results.pow(k1)=interp1(Posible_Shaving_Ctl,PV_Power(k1,:),Shaving_Ctl_Incentived,'linear','extrap');
      Results.ProductionPUproposal(k1)=Shaving_Ctl_Incentived;
  end 
 
  Results.objval=-sum(Results.pow);
end

