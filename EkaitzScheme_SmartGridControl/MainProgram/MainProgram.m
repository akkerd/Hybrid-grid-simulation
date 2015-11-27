clc
clear all
close all
% GLOBAL VARIABLES
gPrice = 0.0648;

% XML
    XML='CentraleNode.xml';
% scheduleXML
     scheduleXML = [];
% currentTime
     currentTime=0; %We do not need this variable
% OptimProblem
     OptimProblem.Price = gPrice; % It's in euros per Kwh
% OptimParams
     OptimParams.horizon = 24; % I suppose that this time goes in hours.
     OptimParams.tSample = 0.25; % I suppose that this time goes in hours.
     OptimParams.updatePeriod=[];
% predictions 
    predictions=[];
    %Inventado 
% measures
     measures=[]; %Not used         
     cd  ../Models;
     MiCentral = CentraleNode(XML, scheduleXML, currentTime, OptimParams, OptimProblem, predictions, measures);
     %MiCentral = CentraleNode();
%      for x=1:( length(MiCentral.Consumers.ConsumerNodes) ) 
%         MiCentral.Consumers.ConsumerNodes
%      end
     %data = MiCentral.Consumers.ConsumerNodes;
     
    fnC = fieldnames(MiCentral.Consumers.ConsumerNodes); % fnC = field name consumers
    numCon = length(fnC);
    
    powerGap = 0;
    cd ../Models;
    for i=1:numCon
        itself = MiCentral.Consumers.ConsumerNodes.(fnC{i});
        powerGap = powerGap + itself.getPowerWanted(  );
    end
    powerGap

    fnWT = fieldnames(MiCentral.Generators.WTNodes); % Field names for every WindTurbines
    numWT = length(fnWT); % number of WTnodes
    fnPV = fieldnames(MiCentral.Generators.PVNodes); % Field names for every PhotoVoltaic
    numPV = length(fnPV); % number of PVnodes
    
    freqWT = 0;
    powWT = 0;
    sumFreqWT = 0;
    totalFreqWT = 0;
    
    % Loop for getting total frequency and power for all the WTNodes
    for c = 1:numWT
        freqWT = MiCentral.Generators.WTNodes.( fnWT{numWT} ).getFreqFromPrice( gPrice ); % Freq of the WTNode number 'c'
        sumFreqWT = sumFreqWT + freqWT; % Sum of all frequencies
        powWT = powWT + MiCentral.Generators.WTNodes.( fnWT{numWT} ).getPowerFromFreq( freqWT ); % Sum the power of the WTNode 'c' and sum it to the total
    end    
    % Results of the WT Grid sent to the Central eNode
    totalFreqWT = sumFreqWT / numWT; % Result freq of WT Grid sent to Central eNode
    totalPowWT = powWT             % Result total power of WT Grid sent to Central eNode

    gPrice = 0.0648; % It's the starting price of the PV for now. Needs to change
    
    freqPV = 0;
    totalPowPV = 0;
    powPV=0;
    sumFreqPV = 0;
    totalFreqPV = 0;
    
    % Loop for getting total frequency and power for all the PVNodes
    for c = 1:numPV
        freqPV = MiCentral.Generators.PVNodes.( fnPV{numPV} ).getFreqFromEuro( gPrice ); % Freq of the PVNode number 'c'
        sumFreqPV = sumFreqPV + freqPV; % Sum of all frequencies
        % totalFreqPV = sumFreqPV / c;
        %freqPV = 47.512
       powPV = powPV + MiCentral.Generators.PVNodes.( fnPV{numPV} ).getPowerFromFreq( freqPV ); % Sum the power of the PVNode 'c' and sum it to the total
    end   
    % Results of the PV Grid sent to the Central eNode
    totalFreqPV = sumFreqPV / numPV
    totalPowPV = powPV;
    
    generatorsTotalFreq = (sumFreqPV + sumFreqWT) / (numPV + numWT)
    generatorsTotalPow = totalPowWT + totalPowPV
        
        
