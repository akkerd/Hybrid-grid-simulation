function [Results] = SolveProblemFWZigor( SP )
%SolveProblem Summary of this function goes here
%   Detailed explanation goes here
Nslot = SP.OptimParams.horizon/SP.OptimParams.tSample;
Price=SP.StoredData.tariff;
t0=0;
tfin=1*24*3600;
deltaT=SP.OptimParams.deltaT;
Time=[t0:deltaT:tfin];
beta=SP.OptimParams.beta;
Incentivemax=SP.OptimParams.Incentivemax;
Incentivemin=SP.OptimParams.Incentivemin;
PriceCutoff=SP.OptimParams.PriceCutoff;
lambda=SP.OptimParams.lambda;
if lambda==0 
    lambda=1;
end

%Incentive Factor
f=1./(1+exp(-(Price-SP.OptimParams.PriceCutoff)/SP.OptimParams.beta));
IncentiveFactor=SP.OptimParams.Incentivemin+(SP.OptimParams.Incentivemax-SP.OptimParams.Incentivemin)*f;
IncentiveFactor(IncentiveFactor<0)=0;
Nslot = SP.OptimParams.horizon/SP.OptimParams.tSample;
IF=interp1((tfin-t0)*[0:Nslot-1]/Nslot,IncentiveFactor,Time,'linear','extrap');
Ithmean=mean(IncentiveFactor);

%Model's initial values
w0=SP.Model.Wini;
Wmin=SP.Model.Wmin;
    
%Model's variables
Psetpoint=zeros(1,length(Time));
Pelec=zeros(1,length(Time));
w=zeros(1,length(Time));
w(1)=SP.Model.Wini;
SOC=zeros(1,length(Time));
Plosses=zeros(1,length(Time));

[w(1),SOC(1),Psetpoint(1),Pelec(1),Plosses(1)]=SimulateZigorFWModel_CMG(SP,IF(1),Ithmean,w0,Wmin,deltaT); 
 for k=2:length(Time)
    100*k/length(Time)
    [w(k),SOC(k),Psetpoint(k),Pelec(k),Plosses(k)]=SimulateZigorFWModel_CMG(SP,IF(k),Ithmean,w(k-1),Wmin,deltaT);
 end
 
Energia1=(sum(Pelec)-sum(Plosses))*deltaT
Energia2=(SOC(length(Time))-(SP.Model.Wini/SP.Model.Wmax)^2)*(0.5*SP.Model.J*(SP.Model.Wmax^2));
Energia1-Energia2
 
 
% %subplot(3,1,1)
% figure
% plot(Time,SOC,'r')
% xlabel('Time [secs]')
% ylabel('State of Charge [%]')
% grid on
% 
% %subplot(3,1,2)
% figure
% plot(Time,IF,'r')
% xlabel('Time [secs]')
% ylabel('IF [-]')
% grid on
% 
% %subplot(3,1,3)
% figure
% plot(Time,Pelec,'r')
% xlabel('Time [secs]')
% ylabel('Power Production [Watts]')
% grid on
% 
% figure
% PriceVec=[0:0.01:1];
% f=1./(1+exp(-(PriceVec-SP.OptimParams.PriceCutoff)/SP.OptimParams.beta));
% IncentiveFactor=SP.OptimParams.Incentivemin+(SP.OptimParams.Incentivemax-SP.OptimParams.Incentivemin)*f;
% IncentiveFactor(IncentiveFactor<0)=0;
% plot(PriceVec,IncentiveFactor,'r')
% xlabel('Virtual tariff [-]')
% ylabel('Incentive factor [-]')
% grid on
% 
% figure
% TimePrice=tfin*[0:length(Price)-1]/(length(Price));
% plot(TimePrice,Price,'r')
% grid on
% xlabel('Time [secs]')
% ylabel('Virtual tariff')
% pause

Results.pow=interp1(Time,Pelec,(tfin-t0)*[0:Nslot-1]/Nslot);
Results.objval=sum(IF.*Pelec/SP.Model.nPW)/Nslot;
Results.ProductionPUproposal=interp1(Time,Pelec/SP.Model.nPW,(tfin-t0)*[0:Nslot-1]/Nslot);

end

