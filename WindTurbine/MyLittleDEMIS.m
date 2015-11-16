clc
clear all
close all
     
%--------------------- Create the WindTurbine -----------------------------
%XML
XML='WindTurbine.xml';
% Read configuration from XML
if isstruct(XML)
   def.eNode = XML;
else
   def = xml2struct(XML);
end

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
     Wind = windSpeed_forecast(:,1);
     TimeWind=[0:OptimParams.tSample:OptimParams.horizon];
     predictions.WindSpeed=interp1([0:OptimParams.horizon],Wind,TimeWind,'linear');
     predictions.tariff=ones(1,96);%Inventado
%measures
     measures=[]; %Not used
     MiTurbina = WindTurbine(XML, scheduleXML, currentTime, OptimParams, predictions, measures);
     MiTurbina = getOptimResult(MiTurbina)
     %disp(MiTurbina.OptimProblem.currentSolution.pow );
%--------------------------------------------------------------------------

%   Infinite loop
    while ~finish
        
        wtPower = MiTurbina.OptimProblem.currentSolution.ProductionPUproposal;

        %fprintf('The power we produce in this time slot is: %f \n', powerNeeded);
        
          pause(2);
    end
    %disp(str2numb(powerNeeded));
