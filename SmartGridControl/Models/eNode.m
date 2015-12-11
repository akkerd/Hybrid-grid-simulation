classdef eNode < handle
   % --------------------------------------
   % eNode : energy Node abtract class
   % Author : Peter Pflaum, Yacine Lamoudi, Ekaitz Zulueta (Zigor)
   % version : 0.0.3 
   % version history:
   %    v0.0.1: first proposition
   %    v0.0.2: predictions, measures are now passed to the eNodes as
   %            inputs after each horizon shift and at initialization; 
   %            The XML is read at every call of shiftHorizon to check
   %            whether something changed (schedulels!!!)
   %    v0.0.3: field OptimParams.mode in input to constructor has become
   %            an additional mandatory field
   %    v0.0.4: input "schedule_XML" added to Constructor and shiftHorizon
   %            function because decision was taken that schedules should
   %            be separted from the big initialization XML.
   %    v0.0.5: I have developed this enode for a Wind Turbine 
   % date : March 05, 2015
   % --------------------------------------
   
   properties (Abstract, SetAccess = protected)
      id                % identifier of the eNode (string)
      mode              % 'autonomous', 'DSP', 'theWorld'
      currentTime       % current Time (Universal time) (YYYY-MM-DDThh:mm:ssTZD)
      OptimParams       % structure containing optimization parameters
                        %    e.g.: OptimParams.horizon = 24*60*60;   (mandatory!)
                        %          OptimParams.samplingTime = 20*60; (mandatory!)
                        %          OptimParams.updatePeriod = 5*60;  (mandatory!)
                        %          OptimParams.additionalOptParam1 = 0.1; (possible additional parameters!)
%       optimResults      % structure containing additional information on the optimization results. For instance
                        % the optimal temperature evolution in a building could be stored or whatever information could
                        % be interesting to access in an easy way.
                        %   e.g.: optimResult.pow = ...
                        %         optimResult.TAir = ...
                        %         optimResult.solverIterations = ...
                        %         optimResult.solverStatus = ...
   end
   
   properties (Constant, GetAccess = protected)          % list of possible available modes and units that can be found in district. (list is not at all complete!!!!!!!!)
      avModes = {'autonomous', 'DSP', 'realWorld'};      % available modes, 
      avUnits = {'degCelcius', 'kW', 'kWh', 'euro', 'noUnit'};     % available units      
      avMeasures = {'Tair', 'TAirExt', 'IrrExtDir_Nor', 'IrrExtDif_Hor', 'SpdWind', 'RHAirExt', 'SOC_Bat'};   % from excel fichier interfaces
      avPredictions = {'TAirExt_Forecast', 'IrrExtDir_Forecast', 'IrrExtDif_Forecast', 'SpdWind_Forecast'...
                       'Energy_purchase_cost',  'Energy_sale_cost'};
      
      version = {'v0.0.5, March 05, 2015'};               % version of the abstract eNode class definition
      
   end
   
   methods
      % ------------------------------------------------------------------- 
      % eNode instantiates and initializes the XMS/eNode object
      %     eNode = eNode(XML, schedule_XML, currentTime, OptimParams, predictions, measures )
      %           
      % API :   
      %     Inputs:   *XML: XML string containing all the properties (or
      %                    path to the XML), required to initialize the eNode.
      %    
      %               *schedule_XML: XML containing the schedules for the
      %                              eNode. Required at each horizon shift.
      %
      %               *currentTime: value in UT representing the initial
      %                            simulation/real time (YYYY-MM-DDThh:mm:ssTZD) 
      %              
      %               *OptimParams: stuct containing information about the
      %                            optimization timings and possibly
      %                            additional parameters that can specify
      %                            more detailed algorithmic characteristics
      %                             example:
      %                            OptimParams.mode = 'autonomous'   (mandatory!)                            
      %                            OptimParams.horizon = 24*60*60;   (mandatory!)
      %                            OptimParams.tSample = 20*60;      (mandatory!)
      %                            OptimParams.updatePeriod = 5*60;  (mandatory!)
      %                            OptimParams.additionalOptParam1 = 0.1; (optional!)
      %
      %               *predictions: structure containing the required
      %                             predictions for this eNode type.
      %                             example:
      %                             predictions.time =  [900; 1800; 2700;...;86400];
      %                             predictions.tariff = [1; 1; 2; 2;...;1]
      %                             predictions.tempForecast = [10; 11; 13; 13;...;7]
      %
      %               *measures:    structure containing the required
      %                             measures for this eNode type.
      %                              example:
      %                             measures.tempZone1 = 18;
      %                             measures.tempZone2 = 21;        
      %                             measures.tempWater = 65;
      %
      %     Outputs:  *eNode: handle to the instantiated eNode class instance
      %
      % Purpose:
      %     - Initialize properties of eNode
      %     - Get initial predictions, schedules and measures
      %     - Create the initial opimization problem
      % -------------------------------------------------------------------    
      function eNode = eNode(XML,schedule_XML, currentTime, OptimParams, predictions, measures)        
      end
   end
   
   methods(Abstract)
      %% -------------------------------------------------------------------
      % shiftHorizon shifts the prediction horizon 
      %              (usually by one update period) 
      %     eNode = ShiftHorizon(eNode, currentTime)
      %           
      % API :   
      %     Inputs:  *eNode: handle to eNode class instance
      %              *schedule_XML: XML containing the schedules for the
      %                             eNode. Required at each horizon shift.
      %                             If an update (for example of the occupancy
      %                             schedules occured), it is read from this XML.
      %              *currentTime: time in UT representing the current
      %                simulation/real time to be shifted to (YYYY-MM-DDThh:mm:ssTZD)
      %              *predictions: structure containing the required
      %                             predictions for this eNode type.
      %                              example:
      %                             predictions.time =  [900; 1800; 2700;...;86400];
      %                             predictions.tariff = [1; 1; 2; 2;...;1]
      %                             predictions.tempForecast = [10; 11; 13; 13;...;7]
      %
      %              *measures:    structure containing the required
      %                            measures for this eNode type.
      %                              example:
      %                             measures.tempZone1 = 18;
      %                             measures.tempZone2 = 21;        
      %                             measures.tempWater = 65;
      %
      %     Outputs: *eNode: handle to the modified eNode class instance
      %
      % Purpose:
      %     - Check whether something changed in the XML (in particular schedules or 
      %         other information that might be supplied by a building manager)
      %     - Create the new opimization problem for the shifted time
      % -------------------------------------------------------------------
      eNode = shiftHorizon(eNode, schedule_XML, currentTime, predictions, measures) 
      
      %% -------------------------------------------------------------------
      % setIncitation updates the incitation vector during iterations 
      %  
      %     eNode = SetIncitation(eNode, incitation)
      %           
      % API :   
      %     Inputs:  *eNode: handle to eNode class instance
      %              *incitation: structure containing the incitation vector. 
      %                           Its length is N = OptimParams.horizon/OptimParams.samplingTime 
      %                           e.g.: incitation.virtualTariff = 0.1*ones(OptimParams.horizon/OptimParams.samplingTime, 1);
      %     Outputs: *eNode: handle to the modified eNode class instance
      %
      % Purpose:
      %     - Update the optimization problem with the new incitation
      % -------------------------------------------------------------------
      eNode = setIncitation(eNode, incitation)
      
      %% -------------------------------------------------------------------
      % getOptimResult solves the optimization problem and returns the optimized
      %                power consumption vector and the objective value.
      %  
      %     result = GetOptimResult(eNode)
      %           
      % API :   
      %     Inputs:  *eNode: handle to eNode class instance
      %              
      %     Outputs: *result: structure containing the optimization result
      %                       to be returned to the Demis
      %                       mandatory fields are: 
      %                          result.pow (predicted optimal power profile)
      %                          result.objval (objective value)
      %                          (possibly additional fields containing 
      %                           information of interest are possible,
      %                           e.g. battery SOC curve,...)
      %
      % Purpose:
      %     - Solve the optimization problem and return the result to the
      %       Demis
      % -------------------------------------------------------------------
      result = getOptimResult(eNode)
      
      
      %% -------------------------------------------------------------------
      % getControl returns the control value to be applied by the local 
      %            controllers during the next update period.
      %            
      %  
      %     control = GetControl(eNode)
      %           
      % API :   
      %     Inputs:  *eNode: handle to eNode class instance
      %     Outputs: *control: structure containing the scalar control values
      %                       to be applied in the real system/DSP
      %                          e.g.: 
      %                             control.tempSetpointZone1 = 15; 
      %                             control.tempSetpointZone2 = 24;
      %
      % Purpose:
      %     - Get the control to be applied to the system after the
      %       iterations are terminated
      % -------------------------------------------------------------------
      control = getControl(eNode)
      
   
   end
   
   
   % Static methods : test method used to asses the eNode APIs
   % implementation i.e the APIs are complie with requirements. 
   methods(Static, Sealed = true)
      function [logFile] = test(eNode, time, incitation)
         %% Test APIs:
         % check whether field ID and mode are correct
         clc,
         if  nargout==1,
             logFile = [tempname,'.log'];
             diary(logFile);
             diary on
         end
         
         disp(datestr(now)) 
         disp('test of eNode consistency.');         
         
         % test whether ID is a string
         if isstr(eNode.id)
            disp('test 01 (id):..............................OK');
         else
            disp('test 01 (id):........ERROR: id should be a string');
         end
         
         % tes whether the mode exists
         if sum(ismember(eNode.avModes, eNode.mode))
            disp('test 02 (mode):............................OK');
         else
              disp(['test 02 (mode):............ERROR: The mode "', eNode.mode, '" is not an existing mode. Check spelling!\n']);
         end
         
         % check the different methods:
         try 
            eNode.shiftHorizon(time); 
            disp('test 03 (API ShiftHorizon):...........................OK');
         catch
            disp('test 03 (API ShiftHorizon):.............ERROR: shifting the horizon to the desired time failed!');
            rethrow(err);
         end
         
         try
            eNode.setIncitation(incitation); 
            disp('test 04 (API SetIncitation):...........................OK');
         catch err
            disp('test 04 (API SetIncitation):............ERROR: SetIncitation did not accept the supplied structure "incitation"!');
            rethrow(err);
         end

         result = eNode.getOptimResult;
         if (isfield(result, 'pow'))
            if length(result.pow) == (eNode.OptimParams.horizon/eNode.OptimParams.tSample)
                disp('test 05 (API GetOptimResult):...........................field "pow" OK');
            else
                disp(['test 05 (API GetOptimResult):..............ERROR: field "result.pow" should be a vector of length OptimParams.horizon/OptimParams.samplingTime = ', eNode.OptimParams.horizon/eNode.OptimParams.samplingTime]);
            end
         else
             disp('test 05 (API GetOptimResult):..............ERROR: missing field "result.pow" in output structure');
         end
         
         
         if (isfield(result, 'objval'))
            if length(result.objval) == 1
                disp('test 05 (API GetOptimResult):...........................field "objval" OK');
            else
                disp(['test 05 (API GetOptimResult):..............ERROR: field "result.pow" should be a vector of length OptimParams.horizon/OptimParams.samplingTime = ', OptimParams.horizon/OptimParams.samplingTime]);
            end
         else
             disp('test 05 (API GetOptimResult):..............ERROR: missing field "result.objval" in output structure');
         end
            
         control = eNode.getControl;
         disp('test 06 (API GetControl): The returned control structure is:')
         control
         disp('Verify whether the returned control values are scalars.')
         
         if  nargout==1, 
             diary off
         end         
      end
   end
end