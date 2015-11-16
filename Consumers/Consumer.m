classdef Consumer < eNode  
   
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
      function Consumer = Consumer( XML, pSheduleXML, pCurrentTime, pOptimParams, pMeasures)

            % Read configuration from XML
            if isstruct(XML)
               def.eNode = XML;
            else
               def = xml2struct(XML);
            end
                                    
            Consumer.id = def.eNode.GeneralInformation.XMS_ID.Text;
            Consumer.currentTime = pCurrentTime;
            % Model
            Consumer.Model.maxWantedPower = str2num(def.eNode.Model.maxWantedPower.Text);
            Consumer.Model.powerConsumed = str2num(def.eNode.Model.powerConsumed.Text);
            Consumer.Model.CurveY = str2num(def.eNode.Model.CurveY.Text)
            Consumer.Model.powerConsumed(2,:) = 1000.*Consumer.Model.CurveY;
            
            Consumer.Model.CurveZ = str2num(def.eNode.Model.CurveZ.Text)
             Consumer.Model.CurveZ = 10000.*Consumer.Model.CurveZ;
            %plot(Consumer.Model.CurveY);
            % Creating the random values for the array
            %Consumer.Model.powerConsumed(2,:) = generateRandomCurve( Consumer.Model.maxWantedPower, length(Consumer.Model.powerConsumed) );
            Consumer.Model.priceCutOff = def.eNode.Model.priceCutOff;
            
            %OptimParams
            Consumer.OptimParams.horizon = pOptimParams.horizon;
            Consumer.OptimParams.tSample = pOptimParams.tSample;
            
            %Measures
                %Not used
            
            %OptimProblem
            	
            
        end      % end methods
    end      % end constructor      
    

   
methods %(Access = protected)
    
    function [control] = getControl( SP )
       control = getRealPower(SP);
    end
    
    % This function launches the optimization algorithm 
    function [result] = getOptimResult( SP ) 
        
        result = 0;
    end
    
    function [result] = getPriceCutOff( SP ) 

        result = SP.Model.priceCutOff;
    end
    
    function [result] = getPowerWanted( SP ) 
        
        %result = SP.Model.powerConsumption;
        result = randi(100,1,1);
    end
    
    function [ result ] = shiftHorizon( SP, scheduleXML, currentTime, predictions, measures )
        SP=SP;
    end

    function [ SP ] = setIncitation( SP, incitation )
    %   This function initializes the values which are not given externaly
    %   Detailed explanation goes here

    end
    
end      % end methods
end % end classdef

