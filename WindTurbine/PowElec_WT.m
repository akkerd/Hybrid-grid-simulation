%% Wind Inverter model
%{
 __________________________________________
/                                          \
¦ Wind Inverter model                      ¦
\__________________________________________/

by ZIGOR R&D

Release 2.0.1.2
(2014)

Generator: Model of Generic Small Wind Inverter intended for use in energy
            generation low speed (several minutes) simulation only
           Inverter efficiency independent of input and output voltage
           The MPPT algorithm implemented in the inverter is supposed  to
            be perfect and it gets every kW of the turbine
           The grid voltage is supposed to be OK.
___________
Function
    PowElec_WT=PowElec_WT(Param,PowWind_WT,WT_Ctl,WT_Shaving_Ctl)
where
    Param is a structure defining the mini wind inverter parameters: 
        Param.nPW             Nominal Power (W)
        Param.MaxPW           Max power generated (W)
        Param.Eff             Efficiency. Structure defining the efficiency
                               and power losses
                                Eff.Ploss_off  Power losses when inverter
                                                stopped (W)
                                Eff.Ploss_on   Power losses when inverter
                                                generating P=0 (W)
                                Eff.Eff_hl     Efficiency at 50% load (%)
                                Eff.Eff_fl     Efficiency at 100% load (%)
        Param.MinWindPW_On    Minimum Wind power for production (W)
        Param.MinWindPW_av    Minimun PV power to have the inverter available
                               for communication purposes (W)

__________________
Inputs
        PowWind_WT      Available Power at turbine (W)
        WT_Ctl          Photovoltaic system On/Off control (boolean) ????
        WT_Shaving_Ctl  Photovoltaic production shaving control (0÷1) ????
___________________
Outputs
        PowElec_WT      Produced power (W). <0: producing power
                                            >0: consuming power

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
2.0.1.0: - No changes
2.0.1.1: - Added Simulink compatibility
2.0.1.2: - Added Simulink and MATLAB R2013b compatibility

%}

%% Function definition
function pwE=PowElec_WT(Param,PowWind_WT,WT_Ctl,WT_Shaving_Ctl)
    % Generator: Model of Generic small Wind Inverter

% %% 2.0.1.1
    % The directive %#eml declares the function
    % to be Embedded MATLAB compliant
    eml.allowpcode('plain');
%% 2.0.1.2    
    coder.allowpcode('plain');
%%    
%     if PowWind_WT<Param.MinWindPW_av
%         pwE=0;                       %Igual quitar
%         return;                     %Unavailable
%else
%     switch WT_Ctl
%             case false
%                 State=2;            %Stopped
%             otherwise
%                 if PowWind_WT<Param.MinWindPW_On
%                     State=3;        %Waiting
%                 else
%                     State=4;        %Production
%                 end
%         end
%    % end
State=4;
    switch State
        case 4
            if WT_Shaving_Ctl~=0 
                pWnd=PowWind_WT/Param.nPW;
                p0=Param.Eff.Ploss_on/Param.nPW;
                a=(200*Param.Eff.Eff_fl-3*p0*Param.Eff.Eff_hl*Param.Eff.Eff_fl-100*Param.Eff.Eff_hl-Param.Eff.Eff_hl*Param.Eff.Eff_fl)/(Param.Eff.Eff_hl*Param.Eff.Eff_fl);
                b=(200*(Param.Eff.Eff_hl-Param.Eff.Eff_fl)+2*p0*Param.Eff.Eff_hl*Param.Eff.Eff_fl)/(Param.Eff.Eff_hl*Param.Eff.Eff_fl);
                rendInv=pWnd/(pWnd*(1+a)+p0+b*pWnd^2);

                pwE=PowWind_WT*(1-a)-PowWind_WT^2/Param.nPW*b-Param.Eff.Ploss_on;
                pwE=min(pwE,WT_Shaving_Ctl*Param.nPW);
                pwE=-min(pwE,Param.MaxPW);
            else
                pwE=Param.Eff.Ploss_off;
            end
        otherwise
            pwE=Param.Eff.Ploss_off;
    end

    
end
        