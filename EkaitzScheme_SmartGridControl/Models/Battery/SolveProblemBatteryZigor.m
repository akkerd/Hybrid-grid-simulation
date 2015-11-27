function [Results] = SolveProblemBatteryZigor( SP )
%SolveProblem Summary of this function goes here
%   Detailed explanation goes here

Nslot = SP.OptimParams.horizon/SP.OptimParams.tSample;
Price=SP.StoredData.tariff;
t0=0;
tfin=1*24*3600;
deltaT=SP.OptimParams.deltaT;
Time=[t0:deltaT:tfin];
     
%Model's initial values
SOC0=SP.Model.SOC0;
V0=0.8*SP.Model.NCellsPerStack*SP.Model.NStacks;
V0=interp1(SP.Model.OCVvsSOC_x,SP.Model.OCVvsSOC_y,SOC0,'linear','extrap');
Vmin=SP.Model.Vmin;
    
%Model's variables
PlossHidr=zeros(1,length(Time));
IlossHidr=zeros(1,length(Time));
Pelec=zeros(1,length(Time));
Psetpoint=zeros(1,length(Time));
PlossElec=zeros(1,length(Time));
Ibat=zeros(1,length(Time));
V=zeros(1,length(Time));
V(1)=V0;
SOC=zeros(1,length(Time));
Ired=zeros(1,length(Time));    
Q=zeros(1,length(Time));
R=zeros(1,length(Time));
PowLoss_Bat=zeros(1,length(Time));
PowElec_Bat=zeros(1,length(Time));
OCV=zeros(1,length(Time));

%Incentive Factor
f=1./(1+exp(-(Price-SP.OptimParams.PriceCutoff)/SP.OptimParams.beta));
IncentiveFactor=SP.OptimParams.Incentivemin+(SP.OptimParams.Incentivemax-SP.OptimParams.Incentivemin)*f;
IncentiveFactor(IncentiveFactor<0)=0;
IF=interp1((tfin-t0)*[0:(length(IncentiveFactor))-1]/length(IncentiveFactor),IncentiveFactor,Time,'linear','extrap');
Ithmean=mean(IncentiveFactor);

 for k=1:length(Time)
    %k
    if k==1
        [SOC(k),V(k),Ired(k),Ibat(k),R(k),OCV(k),Psetpoint(k),PowLoss_Bat(k),PowElec_Bat(k),Q(k)]=SimulateZigorBatteryModel_CMG(SP,IF(k),Ithmean,SOC0,V0,Vmin,deltaT);
    else
        [SOC(k),V(k),Ired(k),Ibat(k),R(k),OCV(k),Psetpoint(k),PowLoss_Bat(k),PowElec_Bat(k),Q(k)]=SimulateZigorBatteryModel_CMG(SP,IF(k),Ithmean,SOC(k-1),V(k-1),Vmin,deltaT);
    end
    Pelec(k)=PowElec_Bat(k);
    
 end

Energia1=(sum(PowElec_Bat)-sum(PowLoss_Bat))*deltaT;
Energia2=(SOC(length(Time))-SOC0)*SP.Model.WsMax;
%Energia1-Energia2

figure
%subplot(5,1,1)
plot(Time,SOC,'r')
xlabel('Time [sec]')
ylabel('State of Charge [%]')
grid on

figure
%subplot(5,1,2)
plot(Time,IF,'r')
xlabel('Time [sec]')
ylabel('IF [-]')
grid on

figure
%subplot(5,1,3)
plot(Time,Pelec,'r',Time,Psetpoint,'g')
xlabel('Time [sec]')
ylabel('Power Production [Watts]')
grid on
legend('Real Power','Power setpoint')

figure
%subplot(5,1,4)
plot(Time,Ired,'r')
xlabel('Time [sec]')
ylabel('Network current [Amp]')
grid on

figure
%subplot(5,1,5)
plot(Time,V,'r')
xlabel('Time [sec]')
ylabel('Voltage [V]')
grid on

figure
PriceVec=[-10:0.1:10];
f=1./(1+exp(-(PriceVec-SP.OptimParams.PriceCutoff)/SP.OptimParams.beta));
IncentiveFactor=SP.OptimParams.Incentivemin+(SP.OptimParams.Incentivemax-SP.OptimParams.Incentivemin)*f;
IncentiveFactor(IncentiveFactor<0)=0;
plot(PriceVec,IncentiveFactor,'r')
xlabel('Price')
ylabel('Incentive Factor [pu]')
grid on

Results.pow=interp1(Time,Pelec,(tfin-t0)*[0:Nslot-1]/Nslot);
Results.objval=sum(IF.*Pelec/SP.Model.nPW)/Nslot;
Results.ProductionPUproposal=interp1(Time,Pelec/SP.Model.nPW,(tfin-t0)*[0:Nslot-1]/Nslot);
end

