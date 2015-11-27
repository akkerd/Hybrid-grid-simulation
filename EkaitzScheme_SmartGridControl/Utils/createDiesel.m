function [ outDiesel ] = createDiesel( pXML )
%CREATEDIESEL Summary of this function goes here
%   Detailed explanation goes here

% Read configuration from XML
%myXML = strcat('../Work/GridComponents',pXML);

if isstruct(pXML)
   def.eNode = pXML;
else
   def = xml2struct(pXML);
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
     OptimParams.powerCurve = str2num(def.eNode.OptimParams.stableNetCurve.Text);
     %OptimParams.powerCurve2 = str2num(def.eNode.OptimParams.stableNetCurve2.Text); 
%measures
     measures=[]; %Not used
     cd ../Models;
     outDiesel = Diesel(pXML, scheduleXML, currentTime, OptimParams, measures)    
end

