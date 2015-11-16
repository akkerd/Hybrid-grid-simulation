clc
clear all
close all

%XML
XML='Consumer.xml';
%scheduleXML
scheduleXML = [];
% %currentTime
     currentTime=0; %We do not need this variable
%OptimParams
     OptimParams.beta=[];
     OptimParams.PriceCutoff=[];
 
     OptimParams.horizon=24; %I suppose that this time goes in hours.
     OptimParams.tSample = 0.25; %I suppose that this time goes in hours.
     OptimParams.updatePeriod=[];

%measures
     measures=[]; %Not used
     
     MiConsumidor = Consumer( XML, scheduleXML, currentTime, OptimParams, measures);
     
     %t=10.*[0:95]/9.5;  
     time = [0:length(MiConsumidor.Model.powerConsumed(1,:)) - 1] ;
     curve = MiConsumidor.Model.powerConsumed(2,:);
%      Ts = 0.001;
%      for i = 1 : length(curve)-1
%         curve2(i) =  tf( curve(i), [ Ts, 1]);
%      end
%      stepplot(curve2);
    hold on
     %plot( time, curve, 'r');
     plot( time,  MiConsumidor.Model.CurveZ, 'r');
     hold off
     set(gcf,'units','normalized','outerposition',[0 0 1 1])    
    %curveHeavi = heaviside(time);
    %h = stepplot(time,curve);
    %      sys = ar(time, 10);
    %      sys2 = ar(curve, 2);
    %     data = iddata( time, curve, 96);
    %      sys = impulse(data);
    %      t = (0:1:96);
    %      h = stepplot(sys, time , t);
    %      showConfidence(h, 3);
    %     sys = tf( 1, [3 2 1], .1);
    %     step(sys);
     xlabel('Time')
     ylabel('Power [Watts]')
     grid on
     ax = gca;
     set(ax,'XTick',(0:100));