function [SOC,V,Ired,Ibat,R,OCV,Pcons_Bat,PowLoss_Bat,PowElec_Bat,Q]=SimulateZigorBatteryModel_CMG(SP,IF,Ithmean,SOC_Before,V_Before,Vmin,deltaT)
        
        Param.nPW=SP.Model.nPW;
        Param.Eff.Ploss_off=SP.Model.Ploss_off;
        Param.Eff.Ploss_on=SP.Model.Ploss_on;
        Param.Eff.Eff_hl=SP.Model.Eff_hl;
        Param.Eff.Eff_fl=SP.Model.Eff_fl;
        Conv_Ctl=1; %The control is always  available
        Conv_Shaving_Ctl=1;
        
        %Battery Management's Optimization, equation 1
        Pcons_red=-(SP.Model.nPW/SP.OptimParams.lambda)*(IF-Ithmean);
        if Pcons_red>SP.Model.nPW
            Pcons_red=SP.Model.nPW;
        else
            if Pcons_red<-SP.Model.nPW
                Pcons_red=-SP.Model.nPW;
            end
        end
        if SOC_Before<=SP.OptimParams.SOCmin && Pcons_red<0
            Pcons_red=Param.Eff.Ploss_on;
        else
            if SOC_Before>=SP.OptimParams.SOCmax && Pcons_red>0
                Pcons_red=Param.Eff.Ploss_on;
            end
        end
                     
        %Ired, equation 2
        if SOC_Before>=1
            Pmax=0;
        else
            Pmax=SP.Model.Imax*V_Before;
        end
        if SOC_Before<=0
            Pmin=0;
        else
            Pmin=SP.Model.Imin*V_Before;
        end
        
        Bat_Const.Pow_Max=Pmax;
        Bat_Const.Pow_Min=Pmin;
%{
        PconsPrima=Pcons;
        if Pcons>=Pmax
            PconsPrima=Pmax;
        else
            if Pcons<=Pmin
                PconsPrima=Pmin;
            end
        end
%}        
        [PowElec_Bat,PowLoss_Bat] = PowElec_Stg_Zigor(Param,Pcons_red,Conv_Ctl,Conv_Shaving_Ctl,Bat_Const);
%        PowElec_Bat=Pcons_red;
%        PowLoss_Bat=0;
        Pcons_Bat=PowElec_Bat-PowLoss_Bat;
        
        
                
        if V_Before>Vmin
            Ired=Pcons_Bat/V_Before;
        else
            Ired=Pcons_Bat/Vmin;
        end 
        
        %Q, equation 3
        Q=interp1(SP.Model.QvsI_x,SP.Model.QvsI_y,abs(Ired),'linear','extrap');  
        
        %Phidr, equation 6
        Phidr=interp1(SP.Model.PvsQ_x,SP.Model.PvsQ_y,Q,'linear','extrap'); %Hidraulic power losses   
        
        %PlossHidr, equation 5
        PlossHidr=(1/SP.Model.nuPump)*(Phidr*Q);
        
        %IlosidrsH, equation 6
        if V_Before>Vmin
            IlossHidr=(1/SP.Model.nuPump)*(Phidr*Q)/V_Before;
        else
            IlossHidr=(1/SP.Model.nuPump)*(Phidr*Q)/Vmin;
        end        
        
        %Ibat, equation 7
        Ibat=Ired-IlossHidr;
        
        %R, equation 8
        R=interp1(SP.Model.RvsSOC_x,SP.Model.RvsSOC_y,SOC_Before,'linear','extrap');
        
        %OCV, equation 9
        OCV=interp1(SP.Model.OCVvsSOC_x,SP.Model.OCVvsSOC_y,SOC_Before,'linear','extrap');
       
        %V(t), equation 10
        V=OCV+R*Ibat;
        PlossElec=R*(Ibat)^2;
        
        %SOC, equation 11
%         OCV
%         Ibat
%         deltaT
%         QQ=SP.Model.WsMax
        DeltaSOC=(OCV*Ibat)*deltaT/SP.Model.WsMax;
        SOC=SOC_Before+DeltaSOC;
        if SOC>=1
            SOC=1;
        else
            if SOC<=0
                SOC=0;
            end
        end  
        PowLoss_Bat=PowLoss_Bat+PlossHidr+PlossElec;
        %PowRef_Stg=Pcons;
        %[PowElec_Bat,PowLoss_Bat] = PowElec_Stg_Zigor(Param,PowRef_Stg,Conv_Ctl,Conv_Shaving_Ctl,Bat_Const);
        