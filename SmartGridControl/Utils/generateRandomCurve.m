function [ result ] = generateRandomCurve( pPower, pSize )
    %GENERATERANDOMCURVE Summary of this function goes here
    %   Detailed explanation goes here
    

    %tempPowerMatrix = Consumer.Model.powerConsumed(2,:);
    %r_range = [min(r) max(r)]; 
     r = randi( pPower, 1, pSize);
    
     result = r;
end

