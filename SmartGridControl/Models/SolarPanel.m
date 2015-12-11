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
            % With the actual schema, change the driectory is needed
            cd ../Utils;    
            def=xml2struct(XML);
            SolarPanel.id = def.eNode.GeneralInformation.XMS_ID.Text;          
            SolarPanel.IDandNetworkInfo.VirtualDataPoints = [];
            SolarPanel.IDandNetworkInfo.XMS_ID = [];
            SolarPanel.IDandNetworkInfo.XMS_info = [];

        %% Solar Panel
            SolarPanel.Model.tilt=str2num(def.eNode.Model.tilt.Text);
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
            
            %% Power curves
            SolarPanel.Model.Params.FreqPowerCurve = str2num(def.eNode.Model.FreqPowerCurve.Text); % Matrix for freq(1) and power() relationship
            SolarPanel.Model.Params.FreqEuroCurve = str2num(def.eNode.Model.FreqEuroCurve.Text); % Matrix for freq(1) and price() relationship

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
            if ~(exist ('predictions', 'var'))  %Nelly
                predictions.irrDif = zeros(N,1);
                predictions.irrDir = zeros(N,1);
                predictions.TAirExt= zeros(N,1);
                predictions.Elevation_Angle= zeros(N,1);
                predictions.Azimut_Angle= zeros(N,1);
                predictions.tariff = zeros(N,1);
            end
     
            SolarPanel.StoredData.irrDif=predictions.irrDif;
            SolarPanel.StoredData.irrDir=predictions.irrDir; 
            SolarPanel.StoredData.TAirExt=predictions.TAirExt; 
            SolarPanel.StoredData.Elevation_Angle=predictions.Elevation_Angle;
            SolarPanel.StoredData.Azimut=predictions.Azimut_Angle;
            SolarPanel.StoredData.tariff=predictions.tariff;    
            
            SolarPanel.StoredData.gridTariff = predictions.tariff* (SolarPanel.OptimParams.tSample/3600); %[€/kW]
            SolarPanel.StoredData.virtualTariff = zeros(N,1)';
            SolarPanel.StoredData.tariff = SolarPanel.StoredData.gridTariff+SolarPanel.StoredData.virtualTariff ;
            
            
            SolarPanel.OptimProblem.currentSolution.pow = zeros(round(SolarPanel.OptimParams.horizon/SolarPanel.OptimParams.tSample), 1);
            SolarPanel.OptimProblem.currentSolution.objval = 0;
            SolarPanel.OptimProblem.currentSolution.gradient = [];
            SolarPanel.OptimProblem.currentSolution.feasibility = 1;       % flag to indicate whether solver was successful               
            SolarPanel.optimResults = [];
            

            
            %% OptimProblem
            %interpFreq = interp1( SolarPanel.Model.Params.FreqEuroCurve(1,:), step, 'linear', 'extrap');
            %SolarPanel.OptimProblem.interpFreqPrice = interp1(  , SolarPanel.Model.Params.FreqEuroCurve(1,:),  SolarPanel.Model.Params.FreqEuroCurve(2,:), 'linear', 'extrap');
            
        %% Interpolations
%             SolarPanel.OptimProblem.step4FreqEuro = [0:0.0001:1]; % amount of values is 500
%             SolarPanel.OptimProblem.interpFreqEuro = interp1(SolarPanel.Model.Params.FreqEuroCurve(2,:),...
%                 SolarPanel.Model.Params.FreqEuroCurve(1,:),...
%                 SolarPanel.OptimProblem.step4FreqEuro,...
%                 'linear', 'extrap');
%              SolarPanel.OptimProblem.aFreqEuroCombo = [ SolarPanel.OptimProblem.interpFreqEuro; SolarPanel.OptimProblem.step4FreqEuro];
%                 
%             %plot(step,SolarPanel.OptimProblem.interpFreqPower,'r',SolarPanel.Model.Params.FreqPowerCurve(1,:),SolarPanel.Model.Params.FreqPowerCurve(2,:),'xb'); % Plot the freqPower curve
%             SolarPanel.OptimProblem.step4FreqPower = [0: 0.5 :5000];    % needs to be the same amount of values as freqPrice
%             SolarPanel.OptimProblem.interpFreqPower = interp1(SolarPanel.Model.Params.FreqPowerCurve(2,:), ...
%                 SolarPanel.Model.Params.FreqPowerCurve(1,:), ...
%                 SolarPanel.OptimProblem.step4FreqPower, ...
%                 'linear', 'extrap');
%             SolarPanel.OptimProblem.aFreqPowerCombo = [ SolarPanel.OptimProblem.interpFreqPower; SolarPanel.OptimProblem.step4FreqPower];
            
      end      % end constructor
          function  [Results] = getOptimResult( SP )
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
         if isfield(incitation, 'virtualTariff')
            SP.StoredData.virtualTariff = incitation.virtualTariff;
            SP.StoredData.tariff = SP.StoredData.gridTariff  + SP.StoredData.virtualTariff ;

        end
    end
    function [ SP ] = shiftHorizon( SP, scheduleXML, currentTime, predictions, measures )
        SP.StoredData.irrDif = predictions.irrDif;
        SP.StoredData.irrDir = predictions.irrDir;
        SP.StoredData.TAirExt = predictions.TAirExt;
        SP.StoredData.Elevation_Angle = predictions.Elevation_Angle;
        SP.StoredData.Azimut_Angle = predictions.Azimut_Angle;
        SP.StoredData.gridTariff = predictions.tariff;
        SP.StoredData.tariff = SP.StoredData.gridTariff;
    end
    function [ control ] = getControl( SP )
    %GetControl Summary of this function goes here
    %   Detailed explanation goes here
      control.pow=SP.OptimProblem.currentSolution.ProductionPUproposal(1);
    end    
    
    function [outFreq] = getFreqFromEuro( SP, pEuro)
      
        i1 = length( SP.Model.Params.FreqEuroCurve( 2, :) );
        maxEuro = SP.Model.Params.FreqEuroCurve( 2, i1);
        if pEuro <= maxEuro
            outFreq = interp1(SP.Model.Params.FreqEuroCurve(2,:), SP.Model.Params.FreqEuroCurve(1,:), pEuro, 'linear', 'extrap' );
        else
            i2 = length( SP.Model.Params.FreqEuroCurve( 1, :) );
            maxFreq = SP.Model.Params.FreqEuroCurve( 1, i2);
            fprintf('Impossible to get more power from the PV. Add more PVs or other producers to your Grid.');
            outFreq = maxFreq;
        end
    end
    
    function [outPower] = getPowerFromFreq( SP, pFreq )
        
        outPower = interp1(SP.Model.Params.FreqPowerCurve(1,:), SP.Model.Params.FreqPowerCurve(2,:), pFreq, 'linear', 'extrap' );
    end
    
   end      % end methods
   
   methods (Access = protected)
      
     
   end
end      % end classdef

