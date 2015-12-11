clc
clear all
close all
% GLOBAL VARIABLES
gPrice = 0.03; % Euros per KWh
gPossibleSolution = false;
gCount = 1;
gapProposal = 0;
tSample = 0.25;
gStableFreq = 50.00;

%% Create MiCentral
    % XML
        XML='CentraleNode.xml';
    % scheduleXML
         scheduleXML = [];
    % currentTime
         currentTime=0; %We do not need this variable
    % OptimProblem
         OptimProblem.Price = gPrice; % It's in euros per Kwh
         OptimProblem.possibleSolution = gPossibleSolution;
    % OptimParams
         OptimParams.horizon = 24; % I suppose that this time goes in hours.
         OptimParams.tSample = tSample; % I suppose that this time goes in hours.
         OptimParams.updatePeriod=[];
         OptimParams.stableFreq = gStableFreq;
    % predictions 
        predictions=[];
        %Inventado 
    % measures
         measures=[]; %Not used         
         cd  ../Models;
     %% Create The Central eNode
         MiCentral = CentraleNode(XML, scheduleXML, currentTime, OptimParams, OptimProblem, predictions, measures);
         
     %% Out of the loop WindTurbines
        fnWT = fieldnames(MiCentral.Generators.WTNodes); % Field names for every WindTurbines
        numWT = length(fnWT); % number of WTnodes
    %% Out of the loop PhotoVoltaic
        fnPV = fieldnames(MiCentral.Generators.PVNodes); % Field names for every PhotoVoltaic
        numPV = length(fnPV); % number of PVnodes
    %% Out of the loop Diesels
        fnDiesel = fieldnames(MiCentral.StabilityControllers.DieselNodes); % Field names for every Diesel
        numDiesel = length(fnDiesel); % number of Diesels
    %% Out of the loop Hydrolics
        fnHydro = fieldnames(MiCentral.StabilityControllers.HydroNodes); % Field names for every Diesel
        numHydro = length(fnHydro); % number of Diesels
     %% Out of the loop Consumers
        fnC = fieldnames(MiCentral.Consumers.ConsumerNodes); % fnC = field name consumers
        numCon = length(fnC);
        gPowerGap = 0;
          cd ../Models;
        for i=1:numCon
            itself = MiCentral.Consumers.ConsumerNodes.(fnC{i});
            gPowerGap = gPowerGap + itself.getPowerWanted( );
        end
        gPowerGap %= 5000

 %% Loop
while ~gPossibleSolution 
    %% WindTurbines
    freqWT = 0;
        totalPowWT = 0;
        powWT = 0;
        sumFreqWT = 0;
        totalFreqWT = 0;

        % Loop for getting total frequency and power for all the WTNodes
        for cHydro = 1:numWT
            freqWT = MiCentral.Generators.WTNodes.( fnWT{numWT} ).getFreqFromEuro( gPrice ); % Freq of the WTNode number 'c'
            sumFreqWT = sumFreqWT + freqWT; % Sum of all frequencies
            powWT = MiCentral.Generators.WTNodes.( fnWT{numWT} ).getPowerFromFreq( freqWT ); 
            totalPowWT = totalPowWT + powWT   % Sum the power of the WTNode 'c' and sum it to the total
        end    
        
        % Results of the WT Grid sent to the Central eNode
        totalFreqWT = sumFreqWT / numWT % Result freq of WT Grid sent to Central eNode
        totalPowWT          % Result total power of WT Grid sent to Central eNode

    %     gPrice = 0.0648; % It's the starting price of the PV for now. Needs to change
    %% PhotoVoltaics
        freqPV = 0;
        totalPowPV = 0;
        powPV=0;
        sumFreqPV = 0;
        totalFreqPV = 0;

        % Loop for getting total frequency and power for all the PVNodes
        for cHydro = 1:numPV
            freqPV = MiCentral.Generators.PVNodes.( fnPV{numPV} ).getFreqFromEuro( gPrice ); % Freq of the PVNode number 'c'
            sumFreqPV = sumFreqPV + freqPV; % Sum of all frequencies
            % totalFreqPV = sumFreqPV / c;
            %freqPV = 47.512
           powPV = powPV + MiCentral.Generators.PVNodes.( fnPV{numPV} ).getPowerFromFreq( freqPV ) ; % Sum the power of the PVNode 'c' and sum it to the total
        end
        
        % Results of the PV Grid sent to the Central eNode
        totalFreqPV = sumFreqPV / numPV
        totalPowPV = powPV
        generatorsTotalFreq = str2num( sprintf('%.2f', (sumFreqPV + sumFreqWT) / (numPV + numWT) ))    % TOTAL FREQ WITHOUT Stab. Controllers
        generatorsTotalPow = totalPowWT + totalPowPV                                                   % TOTAL POWER WITHOUT Stab. Controllers
        
    %% Mange the Price for all the generators
        generatorsTotalEuro = generatorsTotalPow * tSample * (gPrice/(1000*tSample))
        
    %% Caculate the power needed for stability
        powForStability = MiCentral.getPowerForStability( generatorsTotalFreq, gPowerGap)
        
    %% Fix the stabilization problem
        gridFreq = generatorsTotalFreq; % The grid frequency is generators frequency because otherwise you have no stablility control
        
        
    % if( false) % This is for TRIALS only. Skip the stabilizers
        %stableCounter = 1;
    stableSolution = false;
    % while (stableCounter < 500)
    %while( powForStability <= 0 || ~stableSolution )
        %% Hydros
            totalPowHydro = 0;
            powHydro = 0;
            totalConsumptionH = 0;
            euroHydro = 0;
            totalEuroHydro = 0;
            cHydro = 1;
            
            % Loop for getting total frequency and power for all the Hydros
            while ( cHydro <= numHydro ) && ( powForStability >= 0 )
                
                
                powHydro = MiCentral.StabilityControllers.HydroNodes.(  fnHydro{cHydro} ).setRealPower( powForStability );
                powForStability = powForStability - powHydro;
                totalPowHydro = totalPowHydro + powHydro;
                
                consHydro = MiCentral.StabilityControllers.HydroNodes.(  fnHydro{cHydro} ).calcWaterConsumption( powHydro );
                totalConsumptionH = totalConsumptionH + consHydro;
                
                euroHydro = MiCentral.StabilityControllers.HydroNodes.(  fnHydro{cHydro} ).calcWaterEuro( cHydro );
                totalEuroHydro = totalEuroHydro + euroHydro;
                
                cHydro = cHydro + 1; % Increment the counter
            end

            if powForStability <= 0 % Stability problem already SOLVED
                break;
            else 
                
            end
            
        %% Diesels
            totalPowD = 0;
            powDiesel = 0;
            totalConsumptionD = 0; 
            euroDiesel = 0;
            totalEuroDiesel = 0;
            cDiesel = 1;
            
            % Loop for getting total frequency and power for all the DieselNodes
            while ( cDiesel <= numHydro ) && ( powForStability >= 0 )
                 
                powDiesel = MiCentral.StabilityControllers.DieselNodes.( fnDiesel{cDiesel} ).setRealPower( powForStability );
                powForStability = powForStability - powDiesel;
                totalPowD = totalPowD + powDiesel;
                
                consDiesel = MiCentral.StabilityControllers.DieselNodes.(  fnDiesel{cDiesel} ).calcFuelConsumption( powDiesel );
                totalConsumptionD = totalConsumptionD + consDiesel;
                
                euroDiesel = MiCentral.StabilityControllers.DieselNodes.(  fnDiesel{cDiesel} ).calcFuelEuro(consDiesel);
                totalEuroDiesel = totalEuroDiesel + euroDiesel;
                
                cDiesel = cDiesel + 1; % Increment the counter
                               
            end
            
            if powForStability <= 0 % Stability problem already SOLVED
                fprintf('Stable solution found');
                stableSolution = true;
            else 
                fprintf('No possible stable solution');
                stableSolution = false;
            end
            
            %stableCounter = stableCounter + 1;
    %end
    
    % Print the total values of the Hydro nodes we have used
    totalPowHydro 
    totalConsumptionH
    totalEuroHydro
    
    % Print the total values of the 
    totalPowD               % Total power in Watts produced by all the Diesels for this time slot
    totalConsumptionD    % Fuel consumption in litres per "tSample" of your parameters
    totalEuroDiesel         % Total price in Euros per each time slot 
    
    fprintf('Nº of Hydros = %d ; Nº of Diesels = %d', cHydro-1, cDiesel-1);
    
    % end
        %% Compare previous Gap
        prevGapProposal = gapProposal;
        newGapProposal = totalPowD + generatorsTotalPow;
        
        if prevGapProposal == newGapProposal
            fprintf('Is impossible to fix the GAP, raise the price');
        else
            
        %% Compare Gaps 
        %REMEMBER TO CHANGE GPOSSIBLESOLUTION HERE, ALREADY USED
            gapProposal = totalPowD + generatorsTotalPow
            billConsumers = generatorsTotalEuro + totalEuroDiesel + totalEuroHydro
            
            if gapProposal >= gPowerGap  
                gCount
                gPossibleSolution = true;
                fprintf('Yaaaaaaaaaaaaaaaaaaay \n\n');
                fprintf('The final price in the %ith loop is %f euros per time slot.\n', gCount, billConsumers);
            else
                if ~stableSolution % No stable solution
                    fprintf('There is no stable solution for this Proposal. Add more Stability Controllers to the grid. And then --> Yeah! Stability!');
                    break;
                else % Gap is not filled, loop again
                    gCount = gCount + 1
                    fprintf('Loop again');
                    %gPrice = gPrice +(0.0757 - 0.0648);
                %%High the price
                    prevPrice = gPrice;
                    clear gPrice;
                    gPrice = prevPrice + 0.01
                end
                
            end
        end
        %% Clean the scum
            clear euroDiesel freqPV freqWT generatorsTotalFreq generatorsTotalPow...
                powDiesel powPV powWT prevPrice sumFreqPV sumFreqWT totalEuroD totalFreqPV totalFreqWT...
                totalPowD totalPowPV totalPowWT;
end

%% 
% Wait 15 minutes before looping again
pause(900); 

% Remember to pass the time slot via parameter
cd ../MainProgram
eval('MainProgram' )