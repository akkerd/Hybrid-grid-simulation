classdef Diesel < eNode  
   
   properties (SetAccess = protected)
      id                
      mode              % 'autonomous', 'DSP', 'theWorld'
      strategyType      % 'tariffdrivenLP', 'tariffdrivenLP'
      % IDandNetworkInfo  % information such as GPS data, contact details, the Automation Server connection details,...  
      Model             % parameters to describe the model
      Schedule          % schedules, e.g. comfort bound definitions (sampled at 1h)
      StoredData        % proprietary time series class instances to store the prediction, schedule and historical data information relative to the current time instant
      OptimParams       % optimization parameters, such as sampling time, horizon length,...
      OptimProblem      % oprimization problem, which is constructed based on information from Model and OptimParams
      currentTime    
      optimResults
   end
   
   properties(Constant)
      avStrategyTypes = {'TimeSlotOptimization'};
   end
      
   methods      
      % Constructor
      function Diesel = Diesel( XML, pScheduleXML, pCurrentTime, pOptimParams,measures)

        %% Read configuration from XML
            % With the actual schema, change the driectory is needed
            cd ../Utils;
            if isstruct(XML)
               def.eNode = XML;
            else
               def = xml2struct(XML);
            end
            
            Diesel.id = def.eNode.GeneralInformation.XMS_ID.Text;
            
            % Model
            Diesel.Model.realPower = str2num( def.eNode.Model.realPower.Text ); 
            %Diesel.Model.Params.FreqPowerCurve = str2num(def.eNode.Model.FreqPowerCurve.Text);
            % Calculate the maxPower from the last value in FreqPowerCurve
            
            Diesel.Model.fuelLvl = str2num( def.eNode.Model.fuelLvl.Text );
            Diesel.Model.fuelConsumption = str2num( def.eNode.Model.fuelConsumption.Text ); % It's in litres per hour
            Diesel.Model.fuelConsumptionNow = 0;
            Diesel.Model.euroFuel = str2num( def.eNode.Model.euroFuel.Text );
            
            Diesel.Model.PowerCurve = str2num( def.eNode.Model.PowerCurve.Text );
            indexMP = length( Diesel.Model.PowerCurve( 1, :) );
            Diesel.Model.maxPower = Diesel.Model.PowerCurve( 1, indexMP);
            
            %OptimParams
            % stableNetCurve from XML
            % Diesel.OptimParams.powerCurve = pOptimParams.powerCurve; 
            % Diesel.OptimParams.powerCurve2 = pOptimParams.powerCurve2;
            Diesel.OptimParams.horizon = pOptimParams.horizon;
            Diesel.OptimParams.tSample = pOptimParams.tSample;
            
            %OptimProblem
            Diesel.OptimProblem.measuredFreq = 0;
            
        % interpolations
%             Diesel.OptimProblem.step4FreqPower = [52.5: -0.0005 : 47.5];    % needs to be the same amount of values as freqPrice
%             Diesel.OptimProblem.interpFreqPower = interp1(Diesel.Model.Params.FreqPowerCurve(1,:), ...
%                 Diesel.Model.Params.FreqPowerCurve(2,:), ...
%                 Diesel.OptimProblem.step4FreqPower, ...
%                 'linear', 'extrap');
%             Diesel.OptimProblem.aFreqPowerCombo = [ Diesel.OptimProblem.interpFreqPower; Diesel.OptimProblem.step4FreqPower];
            
   end      % end methods
      end      % end constructor      
    

   
methods %(Access = protected)
    
    function [control] = getControl( SP )
       control = getRealPower(SP);
    end
% This function launches the optimization algorithm 
    function [result] = getOptimResult( SP ) 
        measuredFreq = SP.OptimProblem.measuredFreq;
        
        if ( measuredFreq < 12  && measuredFreq > 0 )
            result = SP.OptimProblem.currentSolution;
        else
            result = 0;
        end
    end
    
    function [ result ] = shiftHorizon( SP, scheduleXML, currentTime, predictions, measures )
        SP=SP;
    end
    
    function [outPower] = getPowerFromFreq( SP, pFreq )
        
%         clear index;
%         index = find( SP.OptimProblem.aFreqPowerCombo(1,:) == pFreq);
%         outPower = SP.OptimProblem.aFreqPowerCombo( 2, index);
        i = length( SP.Model.Params.FreqPowerCurve( 1, :) );
        maxFreq = SP.Model.Params.FreqPowerCurve( 1, i);
        if pFreq <= maxFreq
        	outPower = interp1(SP.Model.Params.FreqPowerCurve(1,:), SP.Model.Params.FreqPowerCurve(2,:), pFreq, 'linear', 'extrap' );
        else
            % i2 = length( SP.Model.Params.FreqPowerCurve( 2, :) );
            maxPower = SP.Model.Params.FreqPowerCurve( 2, 1);
            outPower = maxPower;
        end
    end

    function [ SP ] = setIncitation( SP, incitation )
    %   This function initializes the values which are not given externaly
    %   Detailed explanation goes here

    end
    
     function out = setMeasuredFreq( SP, f )
        %   Summary of setMeasuredFreq this function goes here
        %   Detailed explanation goes here
        SP.OptimProblem.measuredFreq = f;
        
        out=0;
     end
     
     function outPower = setRealPower( SP, pPower )
        %   Summary of setMeasuredFreq this function goes here
        %   Detailed explanation goes here
        i = length( SP.Model.PowerCurve(1,:) );
        maxPower = SP.Model.PowerCurve(1,i);
        
        if pPower > maxPower
            fPower = maxPower;
        else
            fPower = pPower;
        end
        
        SP.Model.realPower = fPower;
        outPower = fPower;
        % Remember to change the fuel consumption
     end
     
     function power = getRealPower( SP )
        %   Summary of setMeasuredFreq this function goes here
        %   Detailed explanation goes here
       power =  SP.Model.realPower;
     end
     
     function out = setFuelLvl( SP, fuel )
        %   Summary of setMeasuredFreq this function goes here
        %   Detailed explanation goes here
        SP.Model.fuelLvl = fuel;
        
        out=0;
     end
     
      function outFuelConsumption = calcFuelConsumption( SP, pPower )
        %   This returns the fuelc consumption in litres per hour
        %   Detailed explanation goes here
        
        powerPercent = (pPower / SP.Model.maxPower); % Power per units
%         pos = (myRegime * 4) ;
%         
%         outFuelConsumption = ( SP.Model.fuelConsumption(pos) );
%         minPower = SP.Model.fuelConsumption(1);
%         
%         indexMax = length( SP.Model.fuelConsumption(:) );
%         maxPower = SP.Model.fuelConsumption(indexMax);
        
        outFuelConsumption = interp1(SP.Model.PowerCurve( 1, :), SP.Model.fuelConsumption( 1, :),...
            powerPercent, 'linear', 'extrap');
      end
      
      function outEuro = calcFuelEuro ( SP, pConsumption)
          
          outEuro = pConsumption * SP.Model.euroFuel;
      end
      
end      % end methods
end % end classdef

