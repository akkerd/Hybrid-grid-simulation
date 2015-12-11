%%PV Solar Panel model
%{
 __________________________________________
/                                          \
¦ PV Solar Panel model                     ¦
\__________________________________________/

by ZIGOR R&D

Release 2.2.0.0
(2014)

Generator:  Model of Generic PV Solar Panel intended for use in energy
             generation low speed (several minutes) simulation only.
            No shade influence has been implemented
            The solar panel are supposed to be fixed. Not Solar Tracker
             modelled. If solar tracker is to be simulated, an external
             model of solar tracker should be implemented; it should update
             continuously the Orientation property.
            Diffuse irradiance is modeled using Reindl Sky Diffuse model.
            Temperature of the cells are simulated following incoming
             irradiation and air temperature. Wind cooling no simulated.
___________
Function
//2.0.1.0    PowSolar_PV=PowSolar_PV(Param,Irr,Tair,time,K1)
//2.1.0.0    PowSolar_PV=PowSolar_PV(Param,IrrExtDir_Nor,TairExt,time)
//2.2.0.0    PowSolar_PV=PowSolar_PV(Param,IrrExtDir_Nor,Elevation_Angle,Azimuth_Angle,TairExt)
    PowSolar_PV=PowSolar_PV(Param,IrrExtDir_Nor,IrrExtDif_Hor,Elevation_Angle,Azimuth_Angle,TairExt)
where
    Param is a structure defining the solar panel parameters: 
//2.1.0.0        Param.Location     Structure that specifies the geographic location of
//2.1.0.0                           the solar panel array
//2.1.0.0                               location.latitude:  latitude (in degrees,
//2.1.0.0                                                    north of equator is
//2.1.0.0                                                    positive)
//2.1.0.0                               location.longitude: longitude (in degrees,
//2.1.0.0                                                    positive for east of
//2.1.0.0                                                    Greenwich)
//2.1.0.0                               location.altitude:  altitude above mean sea
//2.1.0.0                                                    level (in meters)
        Param.Orientation  Structure that specifies the relative spatial
                            orientation of solar panels
                               Orientation.tilt:   Angle of inclination (º)
                                                     0 = horizontal
                                                    90 = vertical
                               Orientation.SO:     South orientation (º)
                                                     0 = panel facing South
                                                    90 = panel facing West
                                                   -90 = panel facing East
        Param.insPwPV      Installed PV power (W)
        Param.TempPcoeffPV Solar cells Power temperature coefficient (%/ºC)
                            Use -0.4%/ºC if unknown
        Param.NOCT         NOCT (Nominal Operating Cell Temperature)
//2.1.0.1                            Tair=25ºC, G=800W/m2 (ºC) Use 47ºC if unknown
                            Tair=20ºC, G=800W/m2 (ºC) Use 47ºC if unknown
2.0.1.0 Param.Kl           Factor for losses in the panel, shades and/or dust.
                            Use 0.95 if unknown
2.2.0.0 Param.Albedo       Albedo (reflection coeeficient) of surrounding
                            surfaces
__________________
Inputs
//2.0.0.0   Irr
2.0.1.0 IrrExtDir_Nor   Irradiance (W/m2). Normal direct irradiance (sun
                         direction)
2.2.0.0 IrrExtDif_Hor   Irradiance (W/m2). Diffuse horizontal irradiance
2.1.0.0     Elevation_Angle Sun elevation angle (from horizontal plane)(º)
2.1.0.0     Azimuth_Angle   Sun azimuth angle (-90 at East, 0 at South and 
                             +90 at West)(°)
//2.0.0.0   Tair
2.0.1.0 TairExt         Air Temperature surrounding solar panel surface (ºC)

//2.1.0.0        time            Structure that specify the time when the sun
//2.1.0.0                         position is calculated. 
//2.1.0.0                               time.year: year. Valid for [-2000, 6000]
//2.1.0.0                               time.month: month [1-12]
//2.1.0.0                               time.day: calendar day [1-31]
//2.1.0.0                               time.hour: local hour [0-23]
//2.1.0.0                               time.min: minute [0-59]
//2.1.0.0                               time.sec: second [0-59]
//2.1.0.0                               time.UTC: offset hour from UTC. Local time
//2.1.0.0                                = Greenwich time + time.UTC
//2.1.0.0                         This input can also be passed using the Matlab
//2.1.0.0                         time format ('dd-mmm-yyyy HH:MM:SS'). 
//2.1.0.0                         In that case, the time has to be specified as UTC
//2.1.0.0                         time (time.UTC = 0)

//2.0.0.0   Kl          Factor for losses in the panel, shades and/or dust.
                         Use 0.95 if unknown
___________________
Outputs
        PowSolar_PV     Available PV power (W)

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
2.0.1.0: - "degtorad" function from Mapping Toolbox included now as an
            internal function for better compatibility with R2013a
         - the following input name has been changed according to District_
            Model_ver20140124.docx document:
                Irr --> IrrExtDir_Nor
                Tair --> TairExt
         - Kl changes from being a input variable into a parameter
2.0.1.1: - Added Simulink compatibility
2.1.0.0: - Sun position calculated externally (weather module). Changes in
            the input and parameter definition:
                * Deleted Param.Location and time input
                * Added Elevation_Angle and Azimuth_Angle inputs
         - Added Simulink and Matlab R2013b compatibility
2.2.0.0: - Direct irradiation cos factor computation changed for trying
            faster simulation
         - Diffuse irradiation taken into account. Reindl Sky diffuse model
         - Reflected irradiance (albedo) taken into acocunt. One more
            parameter (albedo) added
%}


%% Function definition
%2.0.1.0 function pwPV=PowSolar_PV(Param,Irr,Tair,time,Kl)
%2.1.0.0 function pwPV=PowSolar_PV(Param,IrrExtDir_Nor,TairExt,time)
%2.2.0.0 function pwPV=PowSolar_PV(Param,IrrExtDir_Nor,Elevation_Angle,Azimuth_Angle,TairExt)
function pwPV=PowSolar_PV(Param,IrrExtDir_Nor,IrrExtDif_Hor,Elevation_Angle,Azimuth_Angle,TairExt)
    % Generator: Model of Generic PV Solar Panel

%2.0.1.1
    % The directive %#eml declares the function
    % to be Embedded MATLAB compliant
    eml.allowpcode('plain');
%%2.1.0.0
    coder.allowpcode('plain');
    FA=1;
    
%%    
%{
2.2.0.0
    vect_panel=struct('x',0,'y',0,'z',0);
    [vect_panel.x,vect_panel.y,vect_panel.z]=sph2cart(degtorad(Param.Orientation.SO),degtorad(90-Param.Orientation.tilt),1);

%{
2.1.0.0
    sol=sun_position(time,Param.Location);
    FA=diffuse(vect_panel.x,vect_panel.y,vect_panel.z,[sol.azimuth-180 90-sol.zenith]);
%}
%    sol=sun_position(time,Param.Location);
    FA=diffuse(vect_panel.x,vect_panel.y,vect_panel.z,[Azimuth_Angle Elevation_Angle]);
%}
    FA=max(sin(degtorad(Elevation_Angle))*cos(degtorad(Param.Orientation.tilt))+...
        cos(degtorad(Elevation_Angle))*sin(degtorad(Param.Orientation.tilt))*...
        cos(degtorad(Azimuth_Angle-Param.Orientation.SO)),0);
%2.2.0.0
% diffuse irradiance model
    Ai=IrrExtDir_Nor/1367;
    FAd=max(Ai*FA+(1-Ai)*(1+cos(degtorad(Param.Orientation.tilt)))/2*...
        (1+sqrt(IrrExtDir_Nor*sin(degtorad(Elevation_Angle))/...
        (IrrExtDif_Hor+IrrExtDir_Nor*sin(degtorad(Elevation_Angle))))*...
        (sin(degtorad(Param.Orientation.tilt/2)))^3),0);

%Albedo or reflected irradiance model
    FAr=max(Param.Albedo*(1-cos(degtorad(Param.Orientation.tilt)))/2,0);
    

%2.0.1.0 Tcell=Tair+(Param.NOCT-25)/800*Irr;
%2.1.0.1    Tcell=TairExt+(Param.NOCT-25)/800*IrrExtDir_Nor;
    Tcell=TairExt+(Param.NOCT-20)/800*IrrExtDir_Nor;
%2.0.1.0 pwPV=Kl.*Irr/1000.*FA*Param.insPwPV.*(1+Param.TempPcoeffPV/100*(Tcell-25));
%2.1.0.0 pwPV=Param.Kl.*IrrExtDir_Nor/1000.*FA*Param.insPwPV.*(1+Param.TempPcoeffPV/100*(Tcell-25));
%2.2.0.0 pwPV=Param.Kl*IrrExtDir_Nor/1000*FA*Param.insPwPV*(1+Param.TempPcoeffPV/100*(Tcell-25));
    pwPV=Param.Kl*...
        (IrrExtDir_Nor*FA+...
        IrrExtDif_Hor*FAd+...
        (IrrExtDif_Hor+IrrExtDir_Nor*sin(degtorad(Elevation_Angle)))*FAr)...
        /1000*Param.insPwPV*(1+Param.TempPcoeffPV/100*(Tcell-25));
    
  
end


%% Additional Function
% 2.0.1.0: function added
function angleInRadians = degtorad(angleInDegrees)
% DEGTORAD Convert angles from degrees to radians
%
%   angleInRadians = DEGTORAD(angleInDegrees) converts angle units from
%   degrees to radians.
%
%   Example
%   -------
%   % Compute the tangent of a 45-degree angle
%   tan(degtorad(45))
%
%   See also: fromDegrees, fromRadians, toDegrees, toRadians, radtodeg.

% Copyright 2009 The MathWorks, Inc.
% $Revision: 1.1.6.3 $  $Date: 2009/04/15 23:34:49 $

angleInRadians = (pi/180) * angleInDegrees;
end