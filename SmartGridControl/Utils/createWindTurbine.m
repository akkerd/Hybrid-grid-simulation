function [ outWindTurbine ] = createWindTurbine( pXML )
%CREATEWINDTURBINE Summary of this function goes here
%   Detailed explanation goes here
% XML
%scheduleXML
     scheduleXML=0; %We do not need this variable
% %currentTime
     currentTime=0; %We do not need this variable
%OptimParams
     OptimParams.beta=[];
     OptimParams.PriceCutoff=[];
     OptimParams.Incentivemin=[];
     OptimParams.Incentivemax=[];
 
     OptimParams.horizon=24; %I suppose that this time goes in hours.
     OptimParams.tSample = 0.25; %I suppose that this time goes in hours.
     OptimParams.updatePeriod=[];

%predictions
     cd ../Models/WindTurbine;
     load('GRC_ANDRAVIDA_166820_iw2_Forecast_WindSp.mat')
     Wind = windSpeed_forecast(:,1);
     TimeWind=[0:OptimParams.tSample:OptimParams.horizon];
     predictions.WindSpeed=interp1([0:OptimParams.horizon],Wind,TimeWind,'linear');
     predictions.tariff=ones(1,96);%Inventado
%measures
     measures=[]; %Not used
     
     cd ../;
     outWindTurbine = WindTurbine(pXML, scheduleXML, currentTime, OptimParams, predictions, measures)
end

