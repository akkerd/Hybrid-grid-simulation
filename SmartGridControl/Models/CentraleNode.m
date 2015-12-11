classdef CentraleNode < eNode 
    %CentralENODE Summary of this class goes here
    %   Detailed explanation goes here
    
     properties (SetAccess = protected)
      id                
      mode              % 'stableGrid', 'massProduction'
      strategyType      % 'tariffdrivenLP', 'tariffdrivenLP',
      IDandNetworkInfo  % information such as GPS data, contact details, the Automation Server connection details,...  
      Model             % parameters to describe the model
      Schedule          % schedules, e.g. comfort bound definitions (sampled at 1h)
      StoredData        % proprietary time series class instances to store the prediction, schedule and historical data information relative to the current time instant
      OptimParams       % optimization parameters, such as sampling time, horizon length, price, ListGenerators, ListConsumers, ListStabControllers
      OptimProblem      % oprimization problem, which is constructed based on information from Model and OptimParams
      currentTime    
      optimResults
      Consumers
      StabilityControllers
      Generators
     end
     
  properties(Constant)
      avStrategyTypes = {'TimeSlotOptimization'};
  end
    
    methods
        % Constructor 
        function CentraleNode = CentraleNode( XML, scheduleXML, currentTime, pOptimParams,  pOptimProblem, predictions, measures )
            %% Initial data for for the CentraleNode
            cd ../Utils;
            XML = strcat('../Work/CentraleNode/',XML);
            def = xml2struct(XML);
            
            CentraleNode.id = def.eNode.GeneralInformation.XMS_ID.Text;
            CentraleNode.IDandNetworkInfo.VirtualDataPoints = [];
            CentraleNode.IDandNetworkInfo.XMS_ID = [];
            CentraleNode.IDandNetworkInfo.XMS_info = [];
            %CentraleNode.mode = 'stableGrid';
             %%  Optimization Problem
            %CentraleNode.OptimProblem.Price = pOptimProblem.Price;% It's in euros per Kwh
                CentraleNode.OptimProblem = pOptimProblem;
                
            %%  Optimization parameters 
                CentraleNode.OptimParams = pOptimParams;
                CentraleNode.OptimParams.FreqPowerCurve = str2num(def.eNode.OptimParams.FreqPowerCurve.Text);
                CentraleNode.OptimParams.FactorCurve = str2num(def.eNode.OptimParams.FactorCurve.Text);
%             CentraleNode.OptimParams.horizon = pOptimParams.horizon;
%             CentraleNode.OptimParams.tSample = pOptimParams.tSample;
%             CentraleNode.OptimParams.updatePeriod = pOptimParams.updatePeriod;
            
            CentraleNode.Model.ElementPath = def.eNode.Model.ElementPath.Text;
            
            cd(CentraleNode.Model.ElementPath); 
            
            resultdir = dir;
            Nfiles = length(resultdir);
            % This creates an array of Strings with the same size as the
            % number of elements in the Work folder
            cellVectorXML = cell(Nfiles,1);
            for i=1:Nfiles
                cellVectorXML{i} = '';
            end
            cellVectorXML = transpose(cellVectorXML); 
            
            c1 = 1;
            numXMLs = 0;
            for k=3:Nfiles
                resultsXML = strfind(resultdir(k).name,'.xml'); % resultsXML is storing the number
                if ( ~isempty(resultsXML) ) 
                    numXMLs = numXMLs + 1;
                    cellVectorXML{1,c1} = resultdir(k).name; % vectorXML is storing the 'name.xml' strings
                    c1 = c1 + 1;
                end
            end
            
            if (numXMLs ~= 0)  
                cd ../../Utils/;
                for j= 1:numXMLs  
                    % This if statement is for putting the XML into the
                    % structure called 'def2'
                    XML2 = strcat( '../Work/GridComponents/', cellVectorXML{1,j});
                    if isstruct( XML2 )
                       def2.eNode = XML2 ;
                    else
                       def2 = xml2struct( XML2 );
                    end
                    
                    nodeType = def2.eNode.eNodeType.Text; % Takes the node type from its xml
                    eNodeName = def2.eNode.GeneralInformation.XMS_ID.Text; % Get the ID of the eNode      
                    switch(nodeType)
                        case 'Diesel'   
                            % In this line we intrduce for the first time new structures and also new Diesels are introduces each itaration.
                            CentraleNode.StabilityControllers.DieselNodes.(eNodeName) = createDiesel( XML2 );
                        case 'Consumer'
                            CentraleNode.Consumers.ConsumerNodes.(eNodeName) = createConsumer( XML2 );
                        case 'WindTurbine'
                            CentraleNode.Generators.WTNodes.(eNodeName) = createWindTurbine( XML2 );
                        case 'Battery'
                            % Not implemented yet
                        case 'PhotoVoltaic'
                            CentraleNode.Generators.PVNodes.(eNodeName) = createPhotoVoltaic( XML2 );
                        case 'Hydro'
                            CentraleNode.StabilityControllers.HydroNodes.(eNodeName) = createHydro( XML2 ); 
                        otherwise
                            
                     end  
                end
            end
            
            %
        end
    %% Methods for the optimization
        
        function  [SP] = getOptimResult( SP )
        %   This function launches the optimization algorithm
        SP.optimResults.optimResult = LocalSearch( mFrequency, SP.OptimParams.Price,... % mFrequency IS NOT CREATED YET!!!
            SP.OptimParams.ListGenerators, SP.OptimParams.ListConsumers, SP.OptimParams.ListStabControllers ); % 
        
        end
        
        function [ SP ] = setIncitation( SP, incitation )
        %UNTITLED8 Summary of this function goes here
        %   Detailed explanation goes here
            SP=SP
        end

        function [ SP ] = shiftHorizon( SP, scheduleXML, currentTime, predictions, measures )
            SP=SP;
        end

        function [ control ] = getControl( SP )
        % GetControl Summary of this function goes here
        %   Detailed explanation goes here

        end
        
        function [outPower] = getPowerForStability( SP, pFreq, pPower)
            %% Get the size of the grid
            sizeFactor = interp1(SP.OptimParams.FactorCurve(1,:), SP.OptimParams.FactorCurve(2,:), pPower, 'linear', 'extrap' );
            %% Get the power
            
            outPower = sizeFactor * (interp1(SP.OptimParams.FreqPowerCurve(1,:), SP.OptimParams.FreqPowerCurve(2,:), pFreq, 'linear', 'extrap' ) );
        end
    %
    end  % end methods
    
end    % end classdef