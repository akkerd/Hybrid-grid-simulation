function Office_Building_sfun_vect(block)

setup(block);


%% Setup 
function setup(block)
    
    block.NumDialogPrms  = 1;       % Input parameter to specify the zone model
%     Zd = block.DialogPrm(1).Data;   % Read the Zone info of the chosen Zone (e.g. Model_Zone1)
    Zd = feval(block.DialogPrm(1).Data);
    
    NbrDat=  length(Zd.AllInputs) + length(Zd.Outputs) ; 
    
    % Extract index of outputs
    IdxOut = length(Zd.AllInputs)+1:NbrDat;
    
    % Extract index of controlled inputs
    IdxInp= zeros(1,length(Zd.Inputs)); 
    for k=1:length(Zd.Inputs), 
        IdxInp(k) = find(strcmp(Zd.AllInputs,Zd.Inputs{k})); 
    end
    
    % Extract index of estimated disturbances
    IdxDisEst = zeros(1, length(Zd.EstDisturb));
    for k=1:length(Zd.EstDisturb), 
        IdxDisEst(k) = find(strcmp(Zd.AllInputs,Zd.EstDisturb{k})); 
    end
    
    % Extract index of measurable distrubances
    IdxDis = setdiff(1:length(Zd.AllInputs),IdxInp);        % All Disturbances from AllInputs
    IdxDis = setdiff(IdxDis,IdxDisEst);                     % Measurable distrubances from all disturbances
    
    %Extract index of WT_ disturbance
    IdxWT = strmatch('WT_', Zd.AllInputs);
    
    %Extract index of Uh_ disturbance
    IdxUh = strmatch('Uh_', Zd.AllInputs);
    
    % Extract index of Top_{*} variables
    IdxTop = strmatch('Top', Zd.AllInputs); 
     
    % Extract index of Irr_... variables
    IdxIrr = strmatch('Irr', Zd.AllInputs);

    
    block.NumInputPorts  =1;  % Create Input ports ( +2 for IrrDir and IrrDif inputs)
    block.NumOutputPorts =1;              % Create Output ports (T_air is no output; Power is added instead)
  
    % Check whether the model is with FCU
    if sum(strcmp('Tw', Zd.AllInputs))
    
        IdxPhi = strmatch('Phi', Zd.AllInputs);
        IdxInp = setdiff(IdxInp, IdxPhi);
        
        block.InputPort(1).DatatypeID = 0;
        block.InputPort(1).Complexity = 'Real';
        block.InputPort(1).Dimensions = length(IdxInp) + length(IdxDis) - length(IdxTop) - length(IdxIrr) + length(IdxWT) + 2 ;
        block.InputPort(1).SamplingMode = 0;    
    
        block.OutputPort(1).DatatypeID = 0;   % double
        block.OutputPort(1).Complexity = 'Real';
        block.OutputPort(1).Dimensions = length(IdxOut) + 2; 
        block.OutputPort(1).SamplingMode = 0;
    
    else
        block.InputPort(1).DatatypeID = 0;
        block.InputPort(1).Complexity = 'Real';
        block.InputPort(1).Dimensions = length(IdxInp) + length(IdxDis) - length(IdxTop) - length(IdxIrr) + length(IdxWT) + 2;
        block.InputPort(1).SamplingMode = 0;    
    
        block.OutputPort(1).DatatypeID = 0;   % double
        block.OutputPort(1).Complexity = 'Real';
        block.OutputPort(1).Dimensions = length(IdxOut)+ 1; 
        block.OutputPort(1).SamplingMode = 0;
    end
    
    block.SampleTimes = [60 0];
   
    % Register methods
    block.RegBlockMethod('Outputs',@Output);
    block.RegBlockMethod('PostPropagationSetup',@DoPostPropSetup);
    block.RegBlockMethod('Start',@Start);
    
%% DoPostPropSetup block
    function DoPostPropSetup(block)
    block.NumDworks = 14;
    
    Zd = feval(block.DialogPrm(1).Data);   % Read the Zone info of the chosen Zone (e.g. Model_Zone1)
    NbrDat=  length(Zd.AllInputs) + length(Zd.Outputs) ;    % Calculate number of inputs + disturbances + outputs
    
    % Extract index of outputs
    IdxOut=    length(Zd.AllInputs)+1:NbrDat;
    
    % Extract index of controlled inputs
    IdxInp= zeros(1,length(Zd.Inputs)); 
    for k=1:length(Zd.Inputs), 
        IdxInp(k) = find(strcmp(Zd.AllInputs,Zd.Inputs{k})); 
    end
    
    % Extract index of estimated disturbances
    IdxDisEst = zeros(1, length(Zd.EstDisturb));
    for k=1:length(Zd.EstDisturb), 
        IdxDisEst(k) = find(strcmp(Zd.AllInputs,Zd.EstDisturb{k})); 
    end
    
    % Extract index of measurable distrubances
    IdxDis = setdiff(1:length(Zd.AllInputs),IdxInp);        % All Disturbances from AllInputs
    IdxDis = setdiff(IdxDis,IdxDisEst);                     % take away estimated disturbances
    
    %Extract index of WT_ disturbance
    IdxWT = strmatch('WT_', Zd.AllInputs);
    
    %Extract index of Uh_ disturbance
    IdxUh = strmatch('Uh_', Zd.AllInputs);
    
    % Extract index of Top_{*} variables
    IdxTop = strmatch('Top', Zd.AllInputs); 
     
    % Extract index of Irr_... variables
    IdxIrr = strmatch('Irr', Zd.AllInputs);
    
    IdxDis = setdiff(IdxDis,IdxTop);                     % take away Top_ variables
    IdxDis = setdiff(IdxDis,IdxIrr);                     % take away Irr_ variables
    
    if sum(strcmp('Tw', Zd.AllInputs))
        IdxPhi = strmatch('Phi', Zd.AllInputs);
        IdxInp = setdiff(IdxInp, IdxPhi);
    end
       
    block.Dwork(1).Name            = 'D';
    block.Dwork(1).Dimensions      = NbrDat;
    block.Dwork(1).DatatypeID      = 0;      % double
    block.Dwork(1).Complexity      = 'Real'; % real
    block.Dwork(1).UsedAsDiscState = true;
    
    block.Dwork(2).Name            = 'x';
    block.Dwork(2).Dimensions      = length(Zd.InitialState);
    block.Dwork(2).DatatypeID      = 0;      % double
    block.Dwork(2).Complexity      = 'Real'; % real
    block.Dwork(2).UsedAsDiscState = true;
    
    block.Dwork(3).Name            = 'Pow';
    block.Dwork(3).Dimensions      = length(Zd.Powers);
    block.Dwork(3).DatatypeID      = 0;      % double
    block.Dwork(3).Complexity      = 'Real'; % real
    block.Dwork(3).UsedAsDiscState = true;
    
    block.Dwork(4).Name            = 'IdxInp';
    block.Dwork(4).Dimensions      = length(IdxInp);
    block.Dwork(4).DatatypeID      = 0;      % double
    block.Dwork(4).Complexity      = 'Real'; % real
    block.Dwork(4).UsedAsDiscState = true;
    
    block.Dwork(5).Name            = 'IdxOut';
    block.Dwork(5).Dimensions      = length(Zd.Outputs);
    block.Dwork(5).DatatypeID      = 0;      % double
    block.Dwork(5).Complexity      = 'Real'; % real
    block.Dwork(5).UsedAsDiscState = true;
    
    block.Dwork(6).Name            = 'IdxDis';
    block.Dwork(6).Dimensions      = length(IdxDis);
    block.Dwork(6).DatatypeID      = 0;      % double
    block.Dwork(6).Complexity      = 'Real'; % real
    block.Dwork(6).UsedAsDiscState = true;
    
    block.Dwork(7).Name            = 'IdxDisEst';
    block.Dwork(7).Dimensions      = length(IdxDisEst);
    block.Dwork(7).DatatypeID      = 0;      % double
    block.Dwork(7).Complexity      = 'Real'; % real
    block.Dwork(7).UsedAsDiscState = true;
    
    block.Dwork(8).Name            = 'IdxIrr';
    block.Dwork(8).Dimensions      = length(IdxIrr);
    block.Dwork(8).DatatypeID      = 0;      % double
    block.Dwork(8).Complexity      = 'Real'; % real
    block.Dwork(8).UsedAsDiscState = true;
    
    block.Dwork(9).Name            = 'IdxTop';
    block.Dwork(9).Dimensions      = length(IdxTop);
    block.Dwork(9).DatatypeID      = 0;      % double
    block.Dwork(9).Complexity      = 'Real'; % real
    block.Dwork(9).UsedAsDiscState = true;
    
    block.Dwork(10).Name            = 'IdxDir';
    block.Dwork(10).Dimensions      = 6;
    block.Dwork(10).DatatypeID      = 0;      % double
    block.Dwork(10).Complexity      = 'Real'; % real
    block.Dwork(10).UsedAsDiscState = true;
    
    block.Dwork(11).Name            = 'IdxPhi';
    block.Dwork(11).Dimensions      = 1;
    block.Dwork(11).DatatypeID      = 0;      % double
    block.Dwork(11).Complexity      = 'Real'; % real
    block.Dwork(11).UsedAsDiscState = true;
    
    block.Dwork(12).Name            = 'IdxHpow';
    block.Dwork(12).Dimensions      = 1;
    block.Dwork(12).DatatypeID      = 0;      % double
    block.Dwork(12).Complexity      = 'Real'; % real
    block.Dwork(12).UsedAsDiscState = true;
    
    block.Dwork(13).Name            = 'IdxWT';
    block.Dwork(13).Dimensions      = 1;
    block.Dwork(13).DatatypeID      = 0;      % double
    block.Dwork(13).Complexity      = 'Real'; % real
    block.Dwork(13).UsedAsDiscState = true;
    
    block.Dwork(14).Name            = 'IdxUh';
    block.Dwork(14).Dimensions      = 1;
    block.Dwork(14).DatatypeID      = 0;      % double
    block.Dwork(14).Complexity      = 'Real'; % real
    block.Dwork(14).UsedAsDiscState = true;
    
    
    
    
    
    
%% Initialization
function Start(block)   
    Zd = feval(block.DialogPrm(1).Data);   % Read the Zone info of the chosen Zone (e.g. Model_Zone1)
    
    NbrDat=  length(Zd.AllInputs) + length(Zd.Outputs) ;    % Calculate number of inputs + disturbances + outputs
    
    % Extract index of outputs
    IdxOut=    length(Zd.AllInputs)+1:NbrDat;
    
    % Extract index of controlled inputs
    IdxInp= zeros(1,length(Zd.Inputs)); 
    for k=1:length(Zd.Inputs), 
        IdxInp(k) = find(strcmp(Zd.AllInputs,Zd.Inputs{k})); 
    end
    
    % Extract index of estimated disturbances
    IdxDisEst = zeros(1, length(Zd.EstDisturb));
    for k=1:length(Zd.EstDisturb), 
        IdxDisEst(k) = find(strcmp(Zd.AllInputs,Zd.EstDisturb{k})); 
    end
    
    % Extract index of measurable distrubances
    IdxDis = setdiff(1:length(Zd.AllInputs),IdxInp);        % All Disturbances from AllInputs
    IdxDis = setdiff(IdxDis,IdxDisEst);                     % Measurable distrubances from all disturbances
    
    %Extract index of WT_ disturbance
    IdxWT = strmatch('WT_', Zd.AllInputs);
    
    %Extract index of Uh_ disturbance
    IdxUh = strmatch('Uh_', Zd.AllInputs);
    
    % Extract index of Top_{*} variables
    IdxTop = strmatch('Top', Zd.AllInputs); 
     
    % Extract index of Irr_... variables
    IdxIrr = strmatch('Irr', Zd.AllInputs);
    
    % Extract index of Phi^{fcu} disturbance
    IdxPhi = 0;
    IdxHPow = 0;
    if  strmatch('Phi', Zd.AllInputs)
        IdxPhi = strmatch('Phi', Zd.AllInputs);
        IdxHPow = strmatch('H', Zd.PowSrc);
        IdxInp = setdiff(IdxInp,IdxPhi);                     % take away Phi_ input variable
    end
    
    IdxDis = setdiff(IdxDis,IdxTop);                     % take away Top_ variables
    IdxDis = setdiff(IdxDis,IdxIrr);                     % take away Irr_ variables
    
    IdxDir = zeros(6, 1);        % vector to store in which directions the zone has outside walls (1 == NORTH, 2 == SOUTH, 3 == EST, 4 == WEST, 5 = HORIZ_UP, 6 = HORIZ_DOWN) )
                                 % The values indicate: 0 == no wall in this direction, 1 == the first element of IdxIrr has a wall in this direction, ...       
                                                                                  
    for k = 1:length(IdxIrr)
       if strmatch('Irr_NORTH', Zd.AllInputs(IdxIrr(k)))
           IdxDir(1) = k;
       end
       if strmatch('Irr_SOUTH', Zd.AllInputs(IdxIrr(k)))
           IdxDir(2) = k;
       end
       if strmatch('Irr_EST', Zd.AllInputs(IdxIrr(k)))
           IdxDir(3) = k;
       end
       if strmatch('Irr_WEST', Zd.AllInputs(IdxIrr(k)))
           IdxDir(4) = k;
       end 
       if strmatch('Irr_Horiz_UP', Zd.AllInputs(IdxIrr(k)))
           IdxDir(5) = k;
       end 
       if strmatch('Irr_Horiz_DOWN', Zd.AllInputs(IdxIrr(k)))
           IdxDir(6) = k;
       end 
    end
    
    block.Dwork(1).Data = zeros(1,NbrDat);      % Create Data vector (contains the inputs and outputs after each simulation step
    block.Dwork(2).Data = Zd.InitialState;      % Take predefined initial state contained in the Model
    block.Dwork(3).Data = Zd.Powers;            % Power parameters for controlled inputs
    block.Dwork(4).Data = IdxInp;               % Indexes of the inputs
    block.Dwork(5).Data = IdxOut;               % Indexes of the outputs
    block.Dwork(6).Data = IdxDis;               % Indexes of measurable disturbances
    block.Dwork(7).Data = IdxDisEst;            % Indexes of estimated disturbances
    block.Dwork(8).Data = IdxIrr;               % Indexes of Irratdiation inputs of the zone
    block.Dwork(9).Data = IdxTop;               % Indexes of neighbouring zone inputs 
    block.Dwork(10).Data = IdxDir;              % Indexes of directions of outside walls 
    block.Dwork(11).Data = IdxPhi;              % Index of input disturbance Phi ( only in FCU model)
    block.Dwork(12).Data = IdxHPow;             % Index of the Heat power multiplier
    block.Dwork(13).Data = IdxWT;               % Index of the disturbance containing OUEs (other usage of energy)
    block.Dwork(14).Data = IdxUh;               % Index of the disturbance containing OUEs (other usage of energy)
    
    
%% Define Output function
function Output(block)
    
    Pow =       block.Dwork(3).Data;
    IdxInp =    block.Dwork(4).Data;
    IdxOut =    block.Dwork(5).Data;
    IdxDis =    block.Dwork(6).Data;
    IdxDisEst = block.Dwork(7).Data;
    IdxIrr =    block.Dwork(8).Data;
    IdxTop =    block.Dwork(9).Data;
    IdxDir =    block.Dwork(10).Data;
    IdxPhi =    block.Dwork(11).Data;         
    IdxHPow =   block.Dwork(12).Data;        
    IdxWT =     block.Dwork(13).Data;   
    IdxUh =     block.Dwork(14).Data;
    
    PowerAmplifier = 15;        % Factor to multiply the output power with
    
    %% No FCU
    if IdxPhi == 0
        
        % Compute the irradiance
        h = (mod(block.CurrentTime, 86400) / 3600);      % 24*60*60 = 86400      Get the current hour
        d = floor(block.CurrentTime / 86400) + 1;             % Get the current day;
    
        Di =  block.InputPort(1).Data;    % Data received from inputs
        D = zeros(length(IdxInp) + length(IdxOut) + length(IdxDis) + length(IdxDisEst) + length(IdxIrr) + length(IdxTop), 1); 
    
        % Read controlled inputs 
        D(IdxInp) = Di( 1:length(IdxInp));
    
        % Read Disturbances (Tex, Occ)
        D(IdxDis) =Di((1: ( length(IdxDis)))  + length(IdxInp)) ;
   
        % Set neighbouring rooms to Tex temperature
        D(IdxTop) = Di(IdxDis(1));
    
        % Read OUE input disturbance
        D(IdxWT) = Di(end);
        
        Dir_Irr =Di( length(IdxInp) + length(IdxDis) + 1 );
        Dif_Irr = Di( length(IdxInp) + length(IdxDis) + 2 );
    
%       Orientations = [180 90;0 90;270 90;90 90;0 0;0 180];
%       OrNames    = {'NORTH' 'SOUTH' 'EST' 'WEST' 'Horiz_UP' 'Horiz_DOWN' };  
%       Latitude=48.7775;
%       longitude = 2.0025 
%       IrrGlobal=Global_Irr_Per_Direction( Dir_Irr ,Dif_Irr , Orientations  , longitude , Latitude ,0, d, h);     
        IrrGlobal = Global_Irr_Per_Direction( Dir_Irr, Dif_Irr, [180 90;0 90;270 90;90 90;0 0;0 180], 2.0025, 48.7775 , 0, d, h); 
     
        % Set Irradiation to the existing outside walls
        for j = 1:6     % For all outside directions
            for k = 1: (length(IdxIrr))     % For all walls
                if IdxDir(j) == k;          % Check if current wall points to direction j   (  j    = {'NORTH' 'SOUTH' 'EST' 'WEST' 'Horiz_UP' 'Horiz_DOWN' } )
                    D(IdxIrr(k)) = IrrGlobal(j);            % If yes, Set the Irradiation input for this wall to the corresponding value in IrrGlobal
                end        
            end
        end
    
%        [D, ~, X] =  feval( ['C',block.DialogPrm(1).Data] , D', block.Dwork(2).Data );      
        [D, ~, X] =  feval(block.DialogPrm(1).Data, D', block.Dwork(2).Data );      
    
        block.Dwork(2).Data = X(2,:);       % Save initial state for next execution
    
        % consumed power [kW]      
        pEl = PowerAmplifier * Pow' * D(IdxInp)';       % Compute output power
        pOUE = PowerAmplifier * Pow(IdxUh) * D(IdxWT)';     % Is treated just like U_h to compute power
        block.OutputPort(1).Data =[D(IdxOut(2:end))';pEl; pOUE];   
         
    
        
    %% With FCU    
    else        
        % Compute the irradiance
        h = (mod(block.CurrentTime, 86400) / 3600);      % 24*60*60 = 86400      Get the current hour
        d = floor(block.CurrentTime / 86400) + 1;             % Get the current day;
    
        Di =  [block.InputPort(1).Data];    % Data received from inputs
        D = zeros(length(IdxInp) + length(IdxOut) + length(IdxDis) + length(IdxDisEst) + length(IdxIrr) + length(IdxTop) + length(IdxPhi), 1); 
    
        % Read controlled inputs 
        D(IdxInp) = Di( 1:length(IdxInp));
    
        % Read Disturbances (Tex, Occ)
        D(IdxDis) =Di((1: ( length(IdxDis)))  + length(IdxInp)) ;
   
        % Set neighbouring rooms to Tex temperature
        D(IdxTop) = Di(IdxDis(1));
    
        % Read OUE input disturbance
        D(IdxWT) = Di(end);
        
        Dir_Irr =Di( length(IdxInp) + length(IdxDis) + 1 );
        Dif_Irr = Di( length(IdxInp) + length(IdxDis) + 2 );
    
%     Orientations = [180 90;0 90;270 90;90 90;0 0;0 180];
%     OrNames    = {'NORTH' 'SOUTH' 'EST' 'WEST' 'Horiz_UP' 'Horiz_DOWN' };  
%     Latitude=48.7775;
%     longitude = 2.0025 
%     IrrGlobal=Global_Irr_Per_Direction( Dir_Irr ,Dif_Irr , Orientations  , longitude , Latitude ,0, d, h);     
        IrrGlobal = Global_Irr_Per_Direction( Dir_Irr, Dif_Irr, [180 90;0 90;270 90;90 90;0 0;0 180], 2.0025, 48.7775 , 0, d, h); 
    
    
        % Set Irradiation to the existing outside walls
        for j = 1:6     % For all outside directions
            for k = 1: (length(IdxIrr))     % For all walls
                if IdxDir(j) == k;          % Check if current wall points to direction j   (  j    = {'NORTH' 'SOUTH' 'EST' 'WEST' 'Horiz_UP' 'Horiz_DOWN' } )
                    D(IdxIrr(k)) = IrrGlobal(j);            % If yes, Set the Irradiation input for this wall to the corresponding value in IrrGlobal
                end        
            end
        end
    
        [D, ~, X] =  feval(block.DialogPrm(1).Data, D', block.Dwork(2).Data );      
%        [D, ~, X] =  feval(block.DialogPrm(1).Data, D', block.Dwork(2).Data );      
    
        block.Dwork(2).Data = X(2,:);       % Save initial state for next execution
    
        % consumed power [kW]   
        PowElec = Pow;
        PowElec(IdxHPow) = [];
        
        pEl = PowerAmplifier * PowElec' * D(IdxInp)';       % Compute output power
        pW =  PowerAmplifier * D(IdxPhi) * (D(7) - D(20)) * Pow(IdxHPow);       % Compute power from/to HVAC system
        pOUE = PowerAmplifier * Pow(IdxUh) * D(IdxWT)';     % Compute power consumed from other energy use
        block.OutputPort(1).Data =[D(IdxOut(2:end))'; pEl; pW; pOUE];       
    end
    
    