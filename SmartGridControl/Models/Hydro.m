classdef Hydro < eNode  
   
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
      function Hydro = Hydro( XML, pScheduleXML, pCurrentTime, pOptimParams,measures)

        %% Read configuration from XML
            % With the actual schema, change the driectory is needed
            cd ../Utils;
            if isstruct(XML)
               def.eNode = XML;
            else
               def = xml2struct(XML);
            end
            
            Hydro.id = def.eNode.GeneralInformation.XMS_ID.Text;
            
            %% Model
            Hydro.Model.Params.PowerCurve = str2num(def.eNode.Model.PowerCurve.Text);
            
            Hydro.Model.waterLvl = str2num( def.eNode.Model.waterLvl.Text );
            Hydro.Model.waterConsumption = str2num( def.eNode.Model.waterConsumption.Text ); 
            Hydro.Model.waterConsumptionNow = 0;    % We are not using this
            Hydro.Model.Height = str2num( def.eNode.Model.Height.Text );
            Hydro.Model.Efficiency = str2num( def.eNode.Model.Efficiency.Text );
            Hydro.Model.realPower = str2num( def.eNode.Model.realPower.Text );
            Hydro.Model.euroWater = str2num( def.eNode.Model.euroWater.Text );
            Hydro.Model.PowerCurve = str2num( def.eNode.Model.PowerCurve.Text );
            
            %% OptimParams
            Hydro.OptimParams.horizon = pOptimParams.horizon;
            Hydro.OptimParams.tSample = pOptimParams.tSample;
            
            %% OptimProblem
            Hydro.OptimProblem.measuredFreq = 0;
            
        %% interpolations
%             Hydro.OptimProblem.step4FreqPower = [52.5: -0.0005 : 47.5];    % needs to be the same amount of values as freqPrice
%             Hydro.OptimProblem.interpFreqPower = interp1(Hydro.Model.Params.FreqPowerCurve(1,:), ...
%                 Hydro.Model.Params.FreqPowerCurve(2,:), ...
%                 Hydro.OptimProblem.step4FreqPower, ...
%                 'linear', 'extrap');
%             Hydro.OptimProblem.aFreqPowerCombo = [ Hydro.OptimProblem.interpFreqPower; Hydro.OptimProblem.step4FreqPower];
   end      % end methods
      end      % end constructor      
    

   
methods %(Access = protected)
    
    function [control] = getControl( SP )
       control = getRealPower(SP);
    end
% This function launches the optimization algorithm 
    function [result] = getOptimResult( SP ) 
        measuredFreq = SP.OptimProblem.measuredFreq;
        % If the given frequency is <50 the system process this info, if
        % not the power result is 0.
        if ( measuredFreq < 12  && measuredFreq > 0)
            
            result = SP.OptimProblem.currentSolution;
        else
            result = 0;
        end
    end
    
    function [ result ] = shiftHorizon( SP, scheduleXML, currentTime, predictions, measures )
        SP=SP;
    end
    
    function [outPower] = getPower( SP, pPower )
        outPower = 0;
    end
    
%     function [outPower , outFreq] = getPowerFromFreq( SP, pFreq, pPower )
%         
%        i = length( SP.Model.Params.FreqPowerCurve( 1, :) );
%        maxFreq = SP.Model.Params.FreqPowerCurve( 1, i);
%        minFreq = SP.Model.Params.FreqPowerCurve( 1, 1);
% 
%         %% New stuff for STB control
%         if pFreq > maxFreq % The frequency is TOO HIGH for being fixed only by this SC
%             i2 = length( SP.Model.Params.FreqPowerCurve( 2, :) );
%             maxPower = SP.Model.Params.FreqPowerCurve( 2, i2);
%             outPower = maxPower;
%             outFreq = maxFreq;
%         else
%             if pFreq < minFreq % The frequency is TOO LOW for being fixed only by this SC
%               
%                 minPower = SP.Model.Params.FreqPowerCurve( 2, 1);
%                 outPower = minPower;
%                 outFreq = minFreq;
%             else
%                 outPower = interp1(SP.Model.Params.FreqPowerCurve(1,:), SP.Model.Params.FreqPowerCurve(2,:), pFreq, 'linear', 'extrap' );
%                 outFreq = pFreq;
%             end
%         end
%     end
    
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
        % Remember to change the WATER CONSUMPTION
     end
     
     function power = getRealPower( SP )
        %   Summary of setMeasuredFreq this function goes here
        %   Detailed explanation goes here
        power = SP.Model.realPower;
        
     end
     
     function out = setWaterLvl( SP, water )
        %   Summary of setMeasuredFreq this function goes here
        %   Detailed explanation goes here
        SP.Model.waterLvl = water;
        out=0;
     end
     
      function outConsumption = calcWaterConsumption( SP, power )
        %   Summary of calcWaterConsumption: This function calculates the
            %   water consumption from the power produced, the height of
            %   the Hydro Station and the Efficiency of it.
            h = SP.Model.Height;
            ef = SP.Model.Efficiency;
        
            flow = power / (h * 9.81 * ef); % Litres per second
        
            outConsumption = flow*60*15; % Litres per 15 minutes
      end
      
      
      function outEuro = calcWaterEuro( SP, pConsumption)
          
          outEuro = pConsumption * SP.Model.euroWater;
      end
end      % end methods
end % end classdef


