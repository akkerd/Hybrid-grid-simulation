clc
clear all
close all
%XML
XML='WindTurbine.xml';
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
     load('GRC_ANDRAVIDA_166820_iw2_Forecast_WindSp.mat')
     Wind=windSpeed_forecast(:,1);
     TimeWind=[0:OptimParams.tSample:OptimParams.horizon];
     predictions.WindSpeed=interp1([0:OptimParams.horizon],Wind,TimeWind,'linear');
     predictions.tariff=ones(1,96);%Inventado
%measures
     measures=[]; %Not used
     MiTurbina = WindTurbine(XML, scheduleXML, currentTime, OptimParams, predictions, measures);
     MiTurbina = getOptimResult(MiTurbina)
     subplot(2,1,1)
     %Resultados=MyTurbine.getOptimResult(MyTurbine);
     plot(MiTurbina.OptimProblem.currentSolution.pow)
     hold on
     grid on
     xlabel('Time Slot')
     ylabel('Production')
     subplot(2,1,2)
     plot(Wind,'r')
     hold on
     xlabel('Time Slot')
     ylabel('Wind Speed')
     grid on