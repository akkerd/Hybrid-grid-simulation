function [ result ] = getOptimResult( SP )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
   Results=SolveProblem(SP);
   SP.OptimProblem.currentSolution.pow;
   SP.OptimProblem.currentSolution.objval=result.objval;  
   SP.OptimProblem.currentSolution=Results.ProductionPUproposal;
   disp('Hello!')
end

