function [ outPanel ] = createPhotoVoltaic( pXML )
%CREATEPHOTOVOLTAIC Summary of this function goes here
%   Detailed explanation goes here
    
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
    cd ../Models/PV;
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
    
    predictions.tariff=ones(1,96);%Inventado
%measures
     measures=[]; %Not used
     cd ../;
     outPanel = SolarPanel(pXML, scheduleXML, currentTime, OptimParams, predictions, measures)

end

