function [ outConsumer ] = createConsumer( pXML )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%myXML = strcat('../Work/GridComponents',pXML);
% Schedule is not used
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
     cd ../Models;
     outConsumer = Consumer( pXML, scheduleXML, currentTime, OptimParams, measures)
end

