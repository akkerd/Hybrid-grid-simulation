function [ control ] = getControl( SP )
%GetControl Summary of this function goes here
%   Detailed explanation goes here
      control.pow=SP.OptimProblem.currentSolution.ProductionPUproposal
end

