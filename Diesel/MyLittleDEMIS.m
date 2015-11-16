clc
clear all
close all

%--------------------- Create the Diesel ----------------------------------
%XML
XML='Diesel.xml';
% Read configuration from XML
if isstruct(XML)
   def.eNode = XML;
else
   def = xml2struct(XML);
end

%scheduleXML
     scheduleXML=0; %We do not need this variable
% %currentTime
     currentTime=0; %We do not need this variable
%OptimParams
     OptimParams.beta=[];
     OptimParams.PriceCutoff=[];
     OptimParams.Incentivemin=[];
     OptimParams.Incentivemax=[];
 
     OptimParams.horizon=24; %I suppose that this time goes in hours.
     OptimParams.tSample = 0.25; %I suppose that this time goes in hours.
     OptimParams.updatePeriod=[];
     OptimParams.powerCurve = str2num(def.eNode.OptimParams.stableNetCurve.Text);
     OptimParams.powerCurve2 = str2num(def.eNode.OptimParams.stableNetCurve2.Text);
%measures
     measures=[]; %Not used
         
     MiDiesel = Diesel(XML, scheduleXML, currentTime, OptimParams, measures);
%--------------------------------------------------------------------------

% MiTurbina & MiDiesel are created
%   Infinite loop
  finish = false;
  set(gcf,'CurrentCharacter','@'); % set to a dummy character
    while ~finish
        %fprintf('Está funcionando\n');
        newFreq = input('Introduce manually the frequency that of the net: ');
        %newFreq = 4;
        
        r = setMeasuredFreq(MiDiesel, newFreq);
        powerNeeded = getOptimResult(MiDiesel);
        fprintf('The power we need to produce in this time slot is: %f \n', powerNeeded);
        

          % check for keys
          keyPressed = get(gcf,'CurrentCharacter');
          if keyPressed~='@' % has it changed from the dummy character?
            set(gcf,'CurrentCharacter','@'); % reset the character
            % now process the key as required
            if keyPressed == 27
                finish=true; 
                close all;
            end
          end
          pause(2);
    end
    %disp(str2numb(powerNeeded));
