
classdef Battery< eNode  
   
   properties (SetAccess = protected)
      id                
      mode              % 'autonomous', 'DSP', 'theWorld'
      strategyType      % 'tariffdrivenLP', 'tariffdrivenLP',
      IDandNetworkInfo  % information such as GPS data, contact details, the Automation Server connection details,...  
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
      function Battery = Battery(XML, scheduleXML, currentTime, OptimParams, predictions, measures)
%          %          set Current Time
%          if nargin >= 2
%             SolarPanel.SetCurrentTime(currentTime);
%          else
%             SolarPanel.SetCurrentTime(0);
%          end
            % Read configuration from XML
%             if isstruct(XML)
%                def.eNode = XML;
%             else
%                def = util.xml2struct(XML);
%                %def = xml2struct(XML);
%             end
            def=xml2struct(XML);
            
            Battery.id = def.eNode.GeneralInformation.XMS_ID.Text;
          
            Battery.IDandNetworkInfo.VirtualDataPoints = [];
            Battery.IDandNetworkInfo.XMS_ID = [];
            Battery.IDandNetworkInfo.XMS_info = [];
            
            Battery.Model.Params.type = 'Battery';
%           Here we read the model parameters of our Battery model
            Battery.Model.nPW=str2num(def.eNode.Model.nPW.Text);  
            Battery.Model.Ploss_off=str2num(def.eNode.Model.Ploss_off.Text);          
            Battery.Model.Ploss_on=str2num(def.eNode.Model.Ploss_on.Text); 
            Battery.Model.Eff_hl=str2num(def.eNode.Model.Eff_hl.Text); 
            Battery.Model.Eff_fl=str2num(def.eNode.Model.Eff_fl.Text);         
            Battery.Model.Nliters=str2num(def.eNode.Model.Nliters.Text);
            Battery.Model.WhPerLiter=str2num(def.eNode.Model.WhPerLiter.Text);
            Battery.Model.WsIni=str2num(def.eNode.Model.WsIni.Text); 
            Battery.Model.WsMax=str2num(def.eNode.Model.WsMax.Text);              
            Battery.Model.ImaxPerCell=str2num(def.eNode.Model.ImaxPerCell.Text);        
            Battery.Model.IminPerCell=str2num(def.eNode.Model.IminPerCell.Text);
            Battery.Model.RPerCellvsSOC_x=str2num(def.eNode.Model.RPerCellvsSOC_x.Text);
            Battery.Model.RPerCellvsSOC_y=str2num(def.eNode.Model.RPerCellvsSOC_y.Text);
            Battery.Model.NCellsPerStack=str2num(def.eNode.Model.NCellsPerStack.Text);
            Battery.Model.NStacks=str2num(def.eNode.Model.NStacks.Text);
            Battery.Model.Imax=str2num(def.eNode.Model.Imax.Text);   
            Battery.Model.Imin=str2num(def.eNode.Model.Imin.Text);
            Battery.Model.OCVvsSOC_x=str2num(def.eNode.Model.OCVvsSOC_x.Text);
            Battery.Model.OCVvsSOC_y=str2num(def.eNode.Model.OCVvsSOC_y.Text);
            Battery.Model.RvsSOC_x=str2num(def.eNode.Model.RvsSOC_y.Text);
            Battery.Model.RvsSOC_y=str2num(def.eNode.Model.RvsSOC_y.Text);
            Battery.Model.PvsQ_x=str2num(def.eNode.Model.PvsQ_x.Text);
            Battery.Model.PvsQ_y=str2num(def.eNode.Model.PvsQ_y.Text);
            Battery.Model.nuPump=str2num(def.eNode.Model.nuPump.Text);
            Battery.Model.QvsI_x=str2num(def.eNode.Model.QvsI_x.Text);          
            Battery.Model.QvsI_y= str2num(def.eNode.Model.QvsI_y.Text);
            Battery.Model.SOC0=str2num(def.eNode.Model.SOC0.Text);
            Battery.Model.Vmin=str2num(def.eNode.Model.Vmin.Text);
            

            Battery.OptimParams.beta=str2num(def.eNode.OptimizationParameters.beta.Text);
            Battery.OptimParams.PriceCutoff=str2num(def.eNode.OptimizationParameters.PriceCutoff.Text);
            Battery.OptimParams.Incentivemin=str2num(def.eNode.OptimizationParameters.Incentivemin.Text);
            Battery.OptimParams.Incentivemax=str2num(def.eNode.OptimizationParameters.Incentivemax.Text);
            Battery.OptimParams.lambda=str2num(def.eNode.OptimizationParameters.lambda.Text);
            Battery.OptimParams.SOCmin=str2num(def.eNode.OptimizationParameters.SOCmin.Text);
            Battery.OptimParams.SOCmax=str2num(def.eNode.OptimizationParameters.SOCmax.Text);            
            Battery.OptimParams.deltaT=str2num(def.eNode.OptimizationParameters.deltaT.Text);
            
            Battery.Model.Interface.inputs = {};
            Battery.Model.Interface.outputs = {'GeneratedPower'};
            
            Battery.OptimParams.horizon = OptimParams.horizon;
            Battery.OptimParams.tSample = OptimParams.tSample;
            Battery.OptimParams.updatePeriod = OptimParams.updatePeriod;

 
            Battery.StoredData.tariff = predictions.tariff;
        
            Battery.OptimProblem.currentSolution.pow = zeros(round(Battery.OptimParams.horizon/Battery.OptimParams.tSample), 1);
            Battery.OptimProblem.currentSolution.objval = 0;
            Battery.OptimProblem.currentSolution.gradient = [];
            Battery.OptimProblem.currentSolution.feasibility = 1;       % flag to indicate whether solver was successful
      end      % end constructor
    function  [Results] = getOptimResult( SP )
    %   This function launches the optimization algorithm
       Results=SolveProblemBatteryZigor(SP);
       SP.OptimProblem.currentSolution.pow=Results.pow;
       SP.OptimProblem.currentSolution.objval=Results.objval;
       SP.OptimProblem.currentSolution.ProductionPUproposal=Results.ProductionPUproposal;
%        result.pow = SP.OptimProblem.currentSolution.pow;
%        result.objval = SP.OptimProblem.currentSolution.objval;
%        result.ProductionPUproposal=SP.OptimProblem.currentSolution.ProductionPUproposal;

    end
    function [ SP ] = setIncitation( SP, incitation )
        if isfield(incitation, 'virtualTariff')
            SP.StoredData.virtualTariff = incitation.virtualTariff;
            SP.StoredData.tariff = SP.StoredData.gridTariff  + SP.StoredData.virtualTariff ;
        end
    end
    function [ SP ] = shiftHorizon( SP, scheduleXML, currentTime, predictions, measures )
        SP.StoredData.WindSpeed = predictions.WindSpeed;
        SP.StoredData.gridTariff = predictions.tariff;
        SP.StoredData.tariff = SP.StoredData.gridTariff
    end
    function [ control ] = getControl( SP )
    %GetControl Summary of this function goes here
    %   Detailed explanation goes here
      control.pow=SP.OptimProblem.currentSolution.ProductionPUproposal(1);
    end
      
   end      % end methods
   

end      % end classdef

