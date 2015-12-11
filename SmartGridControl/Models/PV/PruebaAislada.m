clc
clear all
close all
DATA = PV_Zigor_Test_InitFile ;
Param=DATA;
Param.Orientation.tilt=DATA.tilt;
Param.Orientation.SO=DATA.SO;
Param.Eff.Ploss_off = DATA.Ploss_off;
Param.Eff.Ploss_on = DATA.Ploss_on;
Param.Eff.Eff_hl = DATA.Eff_hl;
Param.Eff.Eff_fl = DATA.Eff_fl;

%predictions
load('GRC_ANDRAVIDA_166820_iw2_Forecast_IrrDif.mat')
timeirrDif=[0:60*60:24*60*60];  %We take only the first day, each hour

load('GRC_ANDRAVIDA_166820_iw2_Forecast_IrrDir.mat')
timeirrDir=[0:60*60:24*60*60];  %We take only the first day, each hour

load('GRC_ANDRAVIDA_166820_iw2_Forecast_Text.mat')
timeTAir=[0:1*60*60:24*60*60];
load('GRC_ANDRAVIDA_166820_iw2_SunPosition.mat')
timeAzi=SunPosition(1,:);
timeEle=timeAzi;

Time=24*60*60*[0:95]/95;

predictions.Azimut_Angle=interp1(timeAzi,SunPosition(2,:),Time,'linear','extrap');
predictions.Elevation_Angle=interp1(timeEle,SunPosition(3,:),Time,'linear','extrap');
predictions.TAirExt=interp1(timeTAir,temperature_Forecast(:,1),Time,'linear','extrap'); 
predictions.irrDir=interp1(timeirrDir,irrDir_Forecast(:,1)',Time,'linear','extrap');
predictions.irrDif=interp1(timeirrDif,irrDif_Forecast(:,1),Time,'linear','extrap');

PV_Ctl=ones(1,96);
PV_Shaving_Ctl=ones(1,96);
P_Solar=zeros(1,96);
P_Elec=zeros(1,96);


for k=1:length(PV_Shaving_Ctl)
    P_Solar(k) = PowSolar_PV(Param, predictions.irrDir(k),predictions.irrDif(k),predictions.Elevation_Angle(k), predictions.Azimut_Angle(k), predictions.TAirExt(k)); 
    if P_Solar(k)<0
        P_Solar(k)=0;
    end
    P_Elec(k) = PowElec_PV(Param, real(P_Solar(k)), PV_Ctl(k), PV_Shaving_Ctl(k));
end
figure
subplot(3,1,1)
plot(real(P_Solar),'xb')
hold on
grid on


subplot(3,1,2)
plot(P_Elec,'xr')
hold on
grid on

subplot(3,1,3)
plot(predictions.irrDir,'xb')
hold on
grid on

figure
Price=[0:0.01:10];
beta=0.9;
Incentivemax=1;
Incentivemin=-0.1;
PriceCutoff=0.85;
f=1./(1+exp(-(Price-PriceCutoff)/beta));
IncentiveFactor=Incentivemin+(Incentivemax-Incentivemin)*f;
IncentiveFactor(IncentiveFactor<0)=0;
plot(Price,IncentiveFactor,'r')