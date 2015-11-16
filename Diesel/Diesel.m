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

            % Read configuration from XML
            if isstruct(XML)
               def.eNode = XML;
            else
               def = xml2struct(XML);
            end
            
            Diesel.id = def.eNode.GeneralInformation.XMS_ID.Text;
            
            % Model
            Diesel.Model.realPower = def.eNode.Model.realPower; 
            Diesel.Model.maxPower = def.eNode.Model.maxPower;
            Diesel.Model.fuelLvl = def.eNode.Model.fuelLvl;
            Diesel.Model.fuelConsumption = def.eNode.Model.fuelConsumption; % ¡IS IN GALLONS!
            Diesel.Model.fuelConsumptionNow = 0;
            
            %OptimParams
            Diesel.OptimParams.powerCurve = pOptimParams.powerCurve;
            Diesel.OptimParams.powerCurve2 = pOptimParams.powerCurve2;
            Diesel.OptimParams.horizon = pOptimParams.horizon;
            Diesel.OptimParams.tSample = pOptimParams.tSample;
            
            %OptimProblem
            Diesel.OptimProblem.measuredFreq = 0;
            
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
            %result = Diesel.OptimParams.powerCurve(measuredFreq);
            
            %controlPow = SP.OptimParams.powerCurve(measuredFreq);
            %controlPow = interp1(SP.OptimParams.powerCurve(1), SP.OptimParams.powerCurve(2), [floor(measuredFreq), ceil(measuredFreq)] );
            SP.OptimProblem.controlPowCurve = interp1( SP.OptimParams.powerCurve2, SP.OptimParams.powerCurve,'linear', 'extrap');
            
            result = SP.OptimProblem.controlPowCurve(measuredFreq);
        else
            result = 0;
        end
    end
    
    function [ result ] = shiftHorizon( SP, scheduleXML, currentTime, predictions, measures )
        SP=SP;
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
     
     function out = setRealPower( SP, power )
        %   Summary of setMeasuredFreq this function goes here
        %   Detailed explanation goes here
        SP.Model.realPower = power;
        % Remember to change the fuel consumption
        %
        out=0;
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
     
      function fuelConsumption = calcFuelConsumption( SP, power )
        %   Summary of setMeasuredFreq this function goes here
        %   Detailed explanation goes here
        MyRegime = power / SP.Model.maxPower;
        pos = ceil(MyRegime * 4) + 1;
        
        fuelConsumption = SP.Model.fuelConsumption(pos);
      end
end      % end methods
end % end classdef

