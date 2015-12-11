clc
clear all
close all
%XML
XML='PVClass.xml';
%scheduleXML
 scheduleXML=0; %We do not need this variable
% %currentTime
currentTime=0; %We do not need this variable
%OptimParams
OptimParams.beta=[];
OptimParams.PriceCutoff=[];
OptimParams.Incentivemin=[];
OptimParams.Incentivemax=[];

OptimParams.horizon=24*60*60; %I suppose that this time goes in secs.
OptimParams.tSample = 15*60; %I suppose that this time goes in secs.

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

Time=[0:OptimParams.tSample:OptimParams.horizon];
predictions.Azimut_Angle=interp1(timeAzi,SunPosition(2,:),Time,'linear','extrap');
predictions.Elevation_Angle=interp1(timeEle,SunPosition(3,:),Time,'linear','extrap');
predictions.TAirExt=interp1(timeTAir,temperature_Forecast(:,1),Time,'linear','extrap'); 
predictions.irrDir=interp1(timeirrDir,irrDir_Forecast(:,1)',Time,'linear','extrap');
predictions.irrDif=interp1(timeirrDif,irrDif_Forecast(:,1),Time,'linear','extrap');

predictions.tariff=ones(1,96);%Inventado
%measures
measures=[]; %Not used

%% Read configuration from XML
def=xml2struct(XML);
SolarPanel.id = def.eNode.GeneralInformation.XMS_ID.Text;          
SolarPanel.IDandNetworkInfo.VirtualDataPoints = [];
SolarPanel.IDandNetworkInfo.XMS_ID = [];
SolarPanel.IDandNetworkInfo.XMS_info = [];

%% Solar Panel
SolarPanel.Model.Params.tilt=str2num(def.eNode.Model.tilt.Text)
SolarPanel.Model.SO=str2num(def.eNode.Model.SO.Text);
SolarPanel.Model.insPwPV =str2num(def.eNode.Model.insPwPV.Text);
SolarPanel.Model.TempPcoeffPV =str2num(def.eNode.Model.TempPcoeffPV.Text);
SolarPanel.Model.NOCT =str2num(def.eNode.Model.NOCT.Text);
SolarPanel.Model.Kl =str2num(def.eNode.Model.Kl.Text);
SolarPanel.Model.Albedo=str2num(def.eNode.Model.Albedo.Text);

%% Inverter
SolarPanel.Model.nPW =str2num(def.eNode.Model.nPW.Text);
SolarPanel.Model.Ploss_off = str2num(def.eNode.Model.Ploss_off.Text);
SolarPanel.Model.Ploss_on =str2num(def.eNode.Model.Ploss_on.Text);
SolarPanel.Model.Eff_hl =str2num(def.eNode.Model.Eff_hl.Text);
SolarPanel.Model.Eff_fl =str2num(def.eNode.Model.Eff_fl.Text);
SolarPanel.Model.MinPVPW_On =str2num(def.eNode.Model.MinPVPW_On.Text);
SolarPanel.Model.MinPVPW_av = str2num(def.eNode.Model.MinPVPW_av.Text);


%% Optimizer Parameters
SolarPanel.OptimParams.tSample=str2num(def.eNode.OptimizationParameters.SampleTime.Text);
SolarPanel.OptimParams.horizon=str2num(def.eNode.OptimizationParameters.horizon.Text);
SolarPanel.OptimParams.beta=str2num(def.eNode.OptimizationParameters.beta.Text);
SolarPanel.OptimParams.PriceCutoff=str2num(def.eNode.OptimizationParameters.PriceCutoff.Text);
SolarPanel.OptimParams.Incentivemin=str2num(def.eNode.OptimizationParameters.Incentivemin.Text);
SolarPanel.OptimParams.Incentivemax=str2num(def.eNode.OptimizationParameters.Incentivemax.Text);

SolarPanel.Model.Interface.inputs = {'irrDir', 'irrDif'};
SolarPanel.Model.Interface.outputs = {'pow'};
N = round(SolarPanel.OptimParams.horizon/SolarPanel.OptimParams.tSample);

SolarPanel.StoredData.irrDif=predictions.irrDif;
SolarPanel.StoredData.irrDir=predictions.irrDir; 
SolarPanel.StoredData.TAirExt=predictions.TAirExt; 
SolarPanel.StoredData.Elevation_Angle=predictions.Elevation_Angle;
SolarPanel.StoredData.Azimut=predictions.Azimut_Angle;
SolarPanel.StoredData.tariff=predictions.tariff;

SolarPanel.OptimProblem.currentSolution.pow = zeros(round(SolarPanel.OptimParams.horizon/SolarPanel.OptimParams.tSample), 1);
SolarPanel.OptimProblem.currentSolution.objval = 0;
SolarPanel.OptimProblem.currentSolution.gradient = [];
SolarPanel.OptimProblem.currentSolution.feasibility = 1;       % flag to indicate whether solver was successful               
SolarPanel.optimResults = [];


Param.Orientation.tilt =SolarPanel.Model.Params.tilt;
Param.Orientation.SO =SolarPanel.Model.SO;
Param.insPwPV =SolarPanel.Model.insPwPV;
Param.TempPcoeffPV = SolarPanel.Model.TempPcoeffPV;
Param.NOCT =SolarPanel.Model.NOCT;
Param.Kl = SolarPanel.Model.Kl;
Param.Albedo=SolarPanel.Model.Albedo;
PowerSolar=zeros(1,length(SolarPanel.StoredData.irrDir));
for k1=1:length(SolarPanel.StoredData.irrDir)
    IrrDirect = SolarPanel.StoredData.irrDir(k1);
    IrrDiffuse=SolarPanel.StoredData.irrDif(k1);
    Elevation =SolarPanel.StoredData.Elevation_Angle(k1);
    Azimuth =SolarPanel.StoredData.Azimut(k1);
    Tair = SolarPanel.StoredData.TAirExt(k1);
    P_Solar = PowSolar_PV(Param, IrrDirect,IrrDiffuse, Elevation, Azimuth, Tair);
    PowerSolar(k1)=P_Solar;
end
subplot(2,1,1)
plot(PowerSolar,'r')
hold on
subplot(2,1,2)
plot(SolarPanel.StoredData.irrDir,'r')