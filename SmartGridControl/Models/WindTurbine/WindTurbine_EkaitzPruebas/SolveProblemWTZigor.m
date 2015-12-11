function [Results] = SolveProblemWTZigor( SP )
%SolveProblem Summary of this function goes here
%   Detailed explanation goes here

Nslot = SP.OptimParams.horizon/SP.OptimParams.tSample;
Wind=SP.StoredData.WindSpeed;
Price=SP.StoredData.tariff;
ProductionPUvector=[0:0.01:1]; %The productionPU possible values this variable is between 0 and 1
ProductionProposal=zeros(1,Nslot);
ProductionPUproposal=zeros(1,Nslot); 
ProductionVector=zeros(1,length(ProductionPUvector));

beta=SP.OptimParams.beta;
Incentivemax=SP.OptimParams.Incentivemax;
Incentivemin=SP.OptimParams.Incentivemax;
PriceCutoff=SP.OptimParams.PriceCutoff;
Benefit=zeros(1,Nslot);
for k1=1:Nslot    
    %k-th Time Slot optimization
    for k2=1:length(ProductionPUvector)
        [B,ProductionVector(k2)]=Zigor_WT_profit(ProductionPUvector(k2),Price(k1),Wind(k1),SP);
    end
    %The second alternative
    [ProductionProposal(k1),Ref]=min(ProductionVector); % The production has negative value, So to maximime production, we have to minime this value
    ProductionPUproposal(k1)=ProductionPUvector(Ref);
    f=1/(1+exp(-(Price(k1)-PriceCutoff)/beta));
    IncentiveFactor=Incentivemin+(Incentivemax-Incentivemin)*f;
    IncentiveFactor(IncentiveFactor<0)=0;
    ProductionPUproposal(k1)=IncentiveFactor*ProductionPUproposal(k1);
    [B,ProductionProposal(k1)]=Zigor_WT_profit(ProductionPUproposal(k1),Price(k1),Wind(k1),SP);
    Benefit(k1)=B;
end
% SP.OptimProblem.currentSolution.pow=ProductionProposal;
% SP.OptimProblem.currentSolution.objval=sum(Benefit);  
% SP.OptimProblem.currentSolution.ProductionPUproposal=ProductionPUproposal;
Results.pow=ProductionProposal;
Results.objval=sum(Benefit);
Results.ProductionPUproposal=ProductionPUproposal;
end

