classdef SolarPanel < eNode  
   
   properties (SetAccess = protected)
      id                
      mode              % 'autonomous', 'DSP', 'theWorld'
      strategyType      % 'tarifftimeSlot',
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
      avStrategyTypes = {'tariffTimeSlot'};
      predictionTypes = {'Energy_purchase_cost'};
      measureTypes = {'SOC_Bat'};
        
   end
      
   methods      
      % Constructor
      function SolarPanel = SolarPanel(XML, scheduleXML, currentTime, OptimParams, predictions, measures)
         
            %% Read configuration from XML
            def=xml2struct(XML);
            SolarPanel.id = def.eNode.GeneralInformation.XMS_ID.Text;          
            SolarPanel.IDandNetworkInfo.VirtualDataPoints = [];
            SolarPanel.IDandNetworkInfo.XMS_ID = [];
            SolarPanel.IDandNetworkInfo.XMS_info = [];

            %% Solar Panel
            SolarPanel.Model.tilt=str2num(def.eNode.Model.tilt.Text)
            SolarPanel.Model.SO=str2num(def.eNode.Model.SO.Text);
            SolarPanel.Model.insPwPV =str2num(def.eNode.Model.insPwPV.Text);
            SolarPanel.Model.TempPcoeffPV =str2num(def.eNode.Model.TempPcoeffPV.Text);
            SolarPanel.Model.NOCT =str2num(def.eNode.Model.NOCT.Text);
            SolarPanel.Model.Kl =str2num(def.eNode.Model.Kl.Text);
            SolarPanel.Model.Albedo=str2num(def.eNode.Model.Albedo.Text);
            %% Inverter
            SolarPanel.Model.nPW =str2num(def.eNode.Model.nPW.Text);
            SolarPanel.Model.Ploss_off = str2num(def.eNode.Model.Ploss_off.Text);
            SolarPanel.Model.Ploss_on =str2num(def.eNode.Model.Ploss_on.Text);
            SolarPanel.Model.Eff_hl =str2num(def.eNode.Model.Eff_hl.Text);
            SolarPanel.Model.Eff_fl =str2num(def.eNode.Model.Eff_fl.Text);
            SolarPanel.Model.MinPVPW_On =str2num(def.eNode.Model.MinPVPW_On.Text);
            SolarPanel.Model.MinPVPW_av = str2num(def.eNode.Model.MinPVPW_av.Text);

            
            %% Optimizer Parameters
            SolarPanel.OptimParams.tSample=str2num(def.eNode.OptimizationParameters.SampleTime.Text);
            SolarPanel.OptimParams.horizon=str2num(def.eNode.OptimizationParameters.horizon.Text);
            SolarPanel.OptimParams.beta=str2num(def.eNode.OptimizationParameters.beta.Text);
            SolarPanel.OptimParams.PriceCutoff=str2num(def.eNode.OptimizationParameters.PriceCutoff.Text);
            SolarPanel.OptimParams.Incentivemin=str2num(def.eNode.OptimizationParameters.Incentivemin.Text);
            SolarPanel.OptimParams.Incentivemax=str2num(def.eNode.OptimizationParameters.Incentivemax.Text);
            
            SolarPanel.Model.Interface.inputs = {'irrDir', 'irrDif'};
            SolarPanel.Model.Interface.outputs = {'pow'};
            N = round(SolarPanel.OptimParams.horizon/SolarPanel.OptimParams.tSample);
     
            SolarPanel.StoredData.irrDif=predictions.irrDif;
            SolarPanel.StoredData.irrDir=predictions.irrDir; 
            SolarPanel.StoredData.TAirExt=predictions.TAirExt; 
            SolarPanel.StoredData.Elevation_Angle=predictions.Elevation_Angle;
            SolarPanel.StoredData.Azimut=predictions.Azimut_Angle;
            SolarPanel.StoredData.tariff=predictions.tariff;                     
            SolarPanel.OptimProblem.currentSolution.pow = zeros(round(SolarPanel.OptimParams.horizon/SolarPanel.OptimParams.tSample), 1);
            SolarPanel.OptimProblem.currentSolution.objval = 0;
            SolarPanel.OptimProblem.currentSolution.gradient = [];
            SolarPanel.OptimProblem.currentSolution.feasibility = 1;       % flag to indicate whether solver was successful               
            SolarPanel.optimResults = [];
      end      % end constructor
          function  [SP] = getOptimResult( SP )
    %   This function launches the optimization algorithm
           Results=SolveProblem(SP);
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

       %N = round(SP.OptimParams.horizon / SP.OptimParams.tSample);
       SP=SP
    end
    function [ SP ] = shiftHorizon( SP, scheduleXML, currentTime, predictions, measures )
     SP=SP;
    end
    function [ control ] = getControl( SP )
    %GetControl Summary of this function goes here
    %   Detailed explanation goes here
      control.pow=SP.OptimProblem.currentSolution.ProductionPUproposal;
    end    
   end      % end methods
   
   methods %(Access = protected)
      
     
   end
end      % end classdef

