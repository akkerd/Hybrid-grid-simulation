
classdef FlyWheel< eNode  
   
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
      function FlyWheel = FlyWheel(XML, scheduleXML, currentTime, OptimParams, predictions, measures)
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
            
            FlyWheel.id = def.eNode.GeneralInformation.XMS_ID.Text;
          
            FlyWheel.IDandNetworkInfo.VirtualDataPoints = [];
            FlyWheel.IDandNetworkInfo.XMS_ID = [];
            FlyWheel.IDandNetworkInfo.XMS_info = [];
            
            FlyWheel.Model.Params.type = 'FlyWheel';                         
            FlyWheel.Model.nPW=str2num(def.eNode.Model.nPW.Text);  % Nominal Power of the inverter [W]
            FlyWheel.Model.Ploss_off=str2num(def.eNode.Model.Ploss_off.Text); % Power losses when PV inverter stopped [W]       
            FlyWheel.Model.Ploss_on=str2num(def.eNode.Model.Ploss_on.Text); % Power losses when PV inverter generating Ppv=0 [W]
            FlyWheel.Model.Eff_hl=str2num(def.eNode.Model.Eff_hl.Text);  % Efficiency at 50% load [%]
            FlyWheel.Model.Eff_fl=str2num(def.eNode.Model.Eff_fl.Text);  % Efficiency at 100% load [%]       
            
            FlyWheel.Model.Pmax=str2num(def.eNode.Model.Pmax.Text);
            FlyWheel.Model.Pmin=str2num(def.eNode.Model.Pmin.Text);
            
            FlyWheel.Model.Tmax=str2num(def.eNode.Model.Tmax.Text); 
            FlyWheel.Model.Tmin=str2num(def.eNode.Model.Tmin.Text); 
            
            FlyWheel.Model.nuConv=str2num(def.eNode.Model.nuConv.Text);        
            FlyWheel.Model.Kaero=str2num(def.eNode.Model.Kaero.Text);
            FlyWheel.Model.Keddy=str2num(def.eNode.Model.Keddy.Text);
            FlyWheel.Model.Tloss_hyst=str2num(def.eNode.Model.Tloss_hyst.Text);
            
            FlyWheel.Model.Wmax=str2num(def.eNode.Model.Wmax.Text); %50Krpm
            FlyWheel.Model.J=str2num(def.eNode.Model.J.Text); %Kg*m2;
            FlyWheel.Model.Wini=str2num(def.eNode.Model.Wini.Text);
            FlyWheel.Model.Wmin=str2num(def.eNode.Model.Wmin.Text);

            FlyWheel.OptimParams.beta=str2num(def.eNode.OptimizationParameters.beta.Text);
            FlyWheel.OptimParams.PriceCutoff=str2num(def.eNode.OptimizationParameters.PriceCutoff.Text);
            FlyWheel.OptimParams.Incentivemin=str2num(def.eNode.OptimizationParameters.Incentivemin.Text);
            FlyWheel.OptimParams.Incentivemax=str2num(def.eNode.OptimizationParameters.Incentivemax.Text);
            FlyWheel.OptimParams.lambda=str2num(def.eNode.OptimizationParameters.lambda.Text);
            FlyWheel.OptimParams.SOCmin=str2num(def.eNode.OptimizationParameters.SOCmin.Text);
            FlyWheel.OptimParams.SOCmax=str2num(def.eNode.OptimizationParameters.SOCmax.Text);  
            FlyWheel.OptimParams.deltaT=str2num(def.eNode.OptimizationParameters.deltaT.Text);
            
            FlyWheel.Model.Interface.inputs = {};
            FlyWheel.Model.Interface.outputs = {'GeneratedPower'};
            
            FlyWheel.OptimParams.horizon = OptimParams.horizon;
            FlyWheel.OptimParams.tSample = OptimParams.tSample;
            FlyWheel.OptimParams.updatePeriod = OptimParams.updatePeriod;

 
            N = round(FlyWheel.OptimParams.horizon/FlyWheel.OptimParams.tSample); %Nelly
            if ~(exist ('predictions', 'var'))  %Nelly
                predictions.tariff = zeros(N,1);
            end
            FlyWheel.StoredData.gridTariff = predictions.tariff* (FlyWheel.OptimParams.tSample/3600); %[€/kW]
            FlyWheel.StoredData.virtualTariff = zeros(N,1)';
            FlyWheel.StoredData.tariff = FlyWheel.StoredData.gridTariff+FlyWheel.StoredData.virtualTariff ;
        
            FlyWheel.OptimProblem.currentSolution.pow = zeros(round(FlyWheel.OptimParams.horizon/FlyWheel.OptimParams.tSample), 1);
            FlyWheel.OptimProblem.currentSolution.objval = 0;
            FlyWheel.OptimProblem.currentSolution.gradient = [];
            FlyWheel.OptimProblem.currentSolution.feasibility = 1;       % flag to indicate whether solver was successful
      end      % end constructor
    function  [Results] = getOptimResult( SP )
    %   This function launches the optimization algorithm
       Results=SolveProblemFWZigor(SP);
       SP.OptimProblem.currentSolution.pow=Results.pow;
       SP.OptimProblem.currentSolution.objval=Results.objval;
       SP.OptimProblem.currentSolution.ProductionPUproposal=Results.ProductionPUproposal;
%        result.pow = SP.OptimProblem.currentSolution.pow;
%        result.objval = SP.OptimProblem.currentSolution.objval;
%        result.ProductionPUproposal=SP.OptimProblem.currentSolution.ProductionPUproposal;

    end
    function [ SP ] = setIncitation( SP, incitation )
    %UNTITLED8 Summary of this function goes here
    %   Detailed explanation goes here
        if isfield(incitation, 'virtualTariff')
            SP.StoredData.virtualTariff = incitation.virtualTariff;
            SP.StoredData.tariff = SP.StoredData.gridTariff  + SP.StoredData.virtualTariff ;
        end
    end
    function [ SP ] = shiftHorizon( SP, scheduleXML, currentTime, predictions, measures )
        SP.StoredData.gridTariff = predictions.tariff;
        SP.StoredData.tariff = SP.StoredData.gridTariff;
    end
    function [ control ] = getControl( SP )
    %GetControl Summary of this function goes here
    %   Detailed explanation goes here
      control.pow=SP.OptimProblem.currentSolution.ProductionPUproposal(1);
    end
      
   end      % end methods
   

end      % end classdef

