
clc
clear all
close all
%XML
XML='FWClass.xml';
%scheduleXML
     scheduleXML=0; %We do not need this variable
% %currentTime
     currentTime=0; %We do not need this variable
%OptimParams
     OptimParams.beta=[];
     OptimParams.PriceCutoff=[];
     OptimParams.Incentivemin=[];
     OptimParams.Incentivemax=[];
 
     OptimParams.horizon=24*60*60; 
     OptimParams.tSample = 0.25*60*60;
     OptimParams.updatePeriod=[];

%predictions
     t=10*[0:95]/95;   
     predictions.tariff=0.06*(sin(t)+ones(1,96));%Inventado ones(1,96);%0.5*ones(1,96);%
%measures
     measures=[]; %Not used
     MiFlyWheel= FlyWheel(XML, scheduleXML, currentTime, OptimParams, predictions, measures);
     MiFlyWheel = getOptimResult(MiFlyWheel);
%      figure
%      %subplot(2,1,1)
%      %Resultados=MyTurbine.getOptimResult(MyTurbine);
%      %subplot(2,1,1)
%      plot(predictions.tariff,'r')
%      hold on
%      xlabel('Time Slot')
%      ylabel('Tariff')
%      grid on
% 
%      %subplot(2,1,2)
%      figure
%      plot(MiFlyWheel.ProductionPUproposal)
%      grid on
%      xlabel('Time Slot')
%      ylabel('Production')
     
     