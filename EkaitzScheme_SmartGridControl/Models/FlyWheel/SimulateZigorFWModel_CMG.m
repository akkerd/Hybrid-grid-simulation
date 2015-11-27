function [w,SOC,Pcons_Bat,PowElec_Bat,Plosses]=SimulateZigorFWModel_CMG(SP,IF,Ithmean,w_Before,Wmin,deltaT)
        Param.nPW=SP.Model.nPW;
        Param.Eff.Ploss_off=SP.Model.Ploss_off;
        Param.Eff.Ploss_on=SP.Model.Ploss_on;
        Param.Eff.Eff_hl=SP.Model.Eff_hl;
        Param.Eff.Eff_fl=SP.Model.Eff_fl;
        Conv_Ctl=1; %The control is always  available
        Conv_Shaving_Ctl=1;


        %SOC Equation 7
        SOC=SP.Model.J*(w_Before^2)/2;
        SOC=SOC/(0.5*SP.Model.J*(SP.Model.Wmax^2));
        %Pcons Equation 2
            Pcons_red=-(SP.Model.nPW/SP.OptimParams.lambda)*(IF-Ithmean);
            if Pcons_red>SP.Model.nPW
                Pcons_red=SP.Model.nPW;
            else
                if Pcons_red<-SP.Model.nPW
                    Pcons_red=-SP.Model.nPW;
                end
            end
            if SOC<=SP.OptimParams.SOCmin && Pcons_red<0
                Pcons_red=Param.Eff.Ploss_on*(2-SP.Model.nuConv)+(SP.Model.Tloss_hyst+(SP.Model.Keddy*w_Before)+(SP.Model.Kaero*(w_Before^2)))*w_Before;
            else
                if SOC>=SP.OptimParams.SOCmax && Pcons_red>0
                    Pcons_red=Param.Eff.Ploss_on*(1.95-SP.Model.nuConv)+(SP.Model.Tloss_hyst+(SP.Model.Keddy*w_Before)+(SP.Model.Kaero*(w_Before^2)))*w_Before;
                end
            end 
        
        if SOC<1
%           Tmax=SP.Model.Tmax;
            Tmax=min(SP.Model.Tmax,SP.Model.J*(sqrt(SP.OptimParams.SOCmax)*SP.Model.Wmax-w_Before)/(deltaT));
        else
          Tmax=0;  
        end
        if SOC<0
            Tmin=0;
        else
%            Tmin=SP.Model.Tmin;
            Tmin=max(SP.Model.Tmin,SP.Model.J*(sqrt(SP.OptimParams.SOCmin)*SP.Model.Wmax-w_Before)/(deltaT));
        end
%{        
        if Tcons>Tmax
            Tcons=Tmax;
        end
        if Tcons<Tmin
            Tcons=Tmin;
        end
%}
        %Pmax & Pmin Equations 8 and 9
        Pmax=min(w_Before*Tmax,SP.Model.Pmax);
        Pmin=max(w_Before*Tmin,SP.Model.Pmin);
        
        Bat_Const.Pow_Max=Pmax;
        Bat_Const.Pow_Min=Pmin;
        
        [PowElec_Bat,PowLoss_Bat] = PowElec_Stg_Zigor(Param,Pcons_red,Conv_Ctl,Conv_Shaving_Ctl,Bat_Const);
        Pcons_Bat=PowElec_Bat-PowLoss_Bat;
        
        if abs(w_Before)>Wmin   
           Tred=Pcons_Bat/abs(w_Before);    
        else
           Tred=Pcons_Bat/SP.Model.Wmin; 
        end
        %Tred equation3
        %Tred=Tcons;
        
        %Telec_Loss equation4
        if Tred>0
            Telec_Loss=(1-SP.Model.nuConv)*Tred;
        else
            Telec_Loss=(-(1-SP.Model.nuConv)/SP.Model.nuConv)*Tred;
        end
        %Tloss equation 5
        Tloss=SP.Model.Tloss_hyst+(SP.Model.Keddy*w_Before)+(SP.Model.Kaero*(w_Before^2));
        if w_Before<0
            Tloss=0;
        end
        %w equation 6
        w=w_Before+(((Tred-Tloss-Telec_Loss)/SP.Model.J)*deltaT);
        if w<0
            w=0;
        end
        if w>SP.Model.Wmax
            w=SP.Model.Wmax;
        end
        %PLosses 
         Plosses=abs(Tloss*w)+abs(Telec_Loss*w)+PowLoss_Bat;
        
         
%        SOC=1/2*SP.Model.J*(w^2)/(0.5*SP.Model.J*(SP.Model.Wmax^2));
        SOC=(w/SP.Model.Wmax)^2;
              
        %PowRef_Stg=Pcons;
        
        %Pnet=PowElec_Bat-PowLoss_Bat-Plosses;

end