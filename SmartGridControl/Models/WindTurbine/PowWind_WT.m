%% Wind Turbine model
%{
 _________________________________________
/                                         \
¦ Wind Turbine model                      ¦
\_________________________________________/

by ZIGOR R&D

Release 2.1.0.0
(2014)

Generator:  Model of Generic Wind Turbine intended for use in energy
             generation low speed (several minutes) simulation only.

___________
Function
//2.0.1.0    PowWind_WT=PowWind_WT(Param,v)
//2.0.1.1    PowWind_WT=PowWind_WT(Param,SpdWind)
        PowWind_WT=PowWind_WT(Param_s,Param_m,SpdWind)
where
    Param_s is a structure defining the wind turbine parameters:
        Param_s.Vcuton   Cut on speed (m/s); below this wind speed the
                          turbine produce no power
        Param_s.Vcutoff  Cut off speed (m/s); above this wind speed the
                          turbine stops
    
    and Param_m is a structure defining the wind turbine parameters:
        Param_m.PowerCurve Turbine power curve in a two rows, n column matrix
                             [v0 v1 v2 ... vn
                              p0 p1 p2 ... pn]
                            where pi are the turbine output power (W) at vi
                            airspeeds (m/s)
                            v0 MUST be Vcuton and vn MUST be Vcutoff
                            usually pn is turbine maximum power
__________________
Inputs
//2.0.0.0        v
2.0.1.0 SpdWind         Wind speed (m/s) at turbine height    
___________________
Outputs
        PowWind_WT      Available turbine output power (W)
        
___________________________________________________________________________

  ####  
 #    #   oooooooooooo ooooo   .oooooo.      .oooooo.   ooooooooo.  
#  ##  # d'""""""d888' `888'  d8P'  `Y8b    d8P'  `Y8b  `888   `Y88.
# #  # #       .888P    888  888           888      888  888   .d88'
# #    #      d888'     888  888           888      888  888ooo88P'   
#  ### #    .888P       888  888     ooooo 888      888  888`88b.  
 #    #    d888'    .P  888  `88.    .88'  `88b    d88'  888  `88b. 
  ####   .8888888888P  o888o  `Y8bood8P'    `Y8bood8P'  o888o  o888o

      ooooooooo.     .oo.     oooooooooo.   
      `888   `Y88. .88' `8.   `888'   `Y8b  
       888   .d88' 88.  .8'    888      888 
       888ooo88P'  `88.8P      888      888 
       888`88b.     d888[.8'   888      888 
       888  `88b.  88' `88.    888     d88' 
      o888o  o888o `bodP'`88. o888bood8P' 
___________________________________________________________________________
%}

%% LOG of modifications:
%{
LOG of modifications:
2.0.0.0: - Initial Release
2.0.1.0: - interpolation function changed from "fit" (Toolbox required) to
            "spline" (MATLAB included)
         - the following input name has been changed according to District_
            Model_ver20140124.docx document:
                v --> SpdWind
2.0.1.1: - Added Simulink compatibility
         - Param input divided into two different Param inputs
2.0.1.2: - Added Simulink and matlab R2013b compatibility
2.1.0.0: - No additional changes
%}

%% Function definition
%2.0.1.0 function pwTurbine=PowWind_WT(Param,v)
%2.0.1.1 function pwTurbine=PowWind_WT(Param,SpdWind)
function pwTurbine=PowWind_WT(Param_s,Param_m,SpdWind)
    % Generator: Model of Generic Wind Turbine

%%2.0.1.1
    % The directive %#eml declares the function
    % to be Embedded MATLAB compliant
%    eml.allowpcode('plain');
%% 2.0.1.2
%    coder.allowpcode('plain');
    coder.extrinsic('spline');
    pwTurbine=coder.nullcopy(4.1);
%%        
%    [m n]=size(Param_m.PowerCurve);
%    if m~=2 || n<2 || Param_m.PowerCurve(1,1)~=Param_s.Vcuton || Param_m.PowerCurve(1,n)~=Param_s.Vcutoff
%        disp('Turbine Power Curve format is not correct')
%    end
           
%2.0.1.0    fPC=fit(Param.PowerCurve(1,:)',Param.PowerCurve(2,:)','pchipinterp');
 
    if SpdWind>Param_s.Vcuton && SpdWind<Param_s.Vcutoff
%2.0.1.0        pwTurbine=fPC(v);
        pwTurbine=spline(Param_m.PowerCurve(1,:),Param_m.PowerCurve(2,:),SpdWind);
    else
        pwTurbine=0;
    end
            
end