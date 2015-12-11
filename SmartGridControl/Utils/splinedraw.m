function splinedraw(x)
%  SPLINEDRAW Draw piecewise cubic spline in figure, move points and retrieve
%  interpolation point coordinates (from command window). May be used to
%  draw a trend line manually over a plot.
%
%  SPLINEDRAW starts the draw mode in the active window. If there is no
%  figure, one will be created. If there are already interpolation points
%  in the current axis, editing is continued.
%  When draw mode is activated, clicking left on the plot will create a new
%  interpolation point. Clicking right on the point will delete it.
%  Clicking left on a point and holding while moving the mouse will move
%  the point. The coordinates of the interpolation points will be printed
%  in the command window whenever they are changed. Run SPLINEDRAW again or
%  doubleclick to deactivate draw mode again.
% 
%  EXAMPLE:
%  EZPLOT('sin(x)')
%  SPLINEDRAW
% 
%  Created by Henning Francke, GeoForschungsZentrum Potsdam, Germany, 2010
%  inspired by
%  http://www.mathworks.com/support/solutions/en/data/1-17UGZ/?solution=1-17UGZ

if nargin <1
    x = 'start';
end

switch x
    case {'dragstart','move','stop'} % a point has been clicked on
        points = findobj(gca,'tag','trendpoints');
        XData = get(points,'Xdata');
        YData = get(points,'Ydata');
        currPt=get(gca,'CurrentPoint');
        X = currPt(1,1);
        Y = currPt(1,2);
        if any(points)
            [dummy,whichpoint] = min( (( XData-X )/diff(xlim)).^2 +...
                ( ( YData-Y )/diff(ylim)).^2 ); %determine number of point that has been clicked on
        end
end

updateplot = false; %default

switch x

    case 'start'
        if ~strcmp(get(gca,'ButtonDownFcn') , 'splinedraw gcf_bdf')
            figure(gcf)
            hold on
            set(gca,'ButtonDownFcn','splinedraw gcf_bdf')  %clicking on axis will create a point
            set(get(gca,'Children'),'ButtonDownFcn','splinedraw gcf_bdf') %clicking on an object on the axis, e.g. a line will also create a point
            set(findobj(gca,'tag','trendpoints'),'Buttondownfcn','splinedraw dragstart','color','r'); %reactivate points, if present
            disp(['Draw mode started.' char(10)...
                'Click left in figure to set points.' char(10)...
                'Click right to delete points' char(10)...
                'Click and hold left on points to drag points' char(10)...
                'Doubleclick to end Draw Mode.'])
        else %already active --> deactivate draw mode
            set(gca,'ButtonDownFcn','')
            set(get(gca,'Children'),'ButtonDownFcn','') %clicking on an object on the axis, e.g. a line will also create a point
            set(findobj(gca,'Tag','trendpoints'),'color','k');
            disp('Draw mode stopped.')
        end
        
    case 'gcf_bdf'
        A = get(gca,'CurrentPoint'); %Where has been clicked?
        X = A(1,1);
        Y = A(1,2);

        get(gcbf,'SelectionType')
        if ~strcmp(get(gcbf,'SelectionType'),'normal') %cancel on right click
            return
        end
        disp(['New point [' num2str(X)  ' '  num2str(Y) ']']);
       
        line = findobj(gca,'Tag','trendspline');
        points = findobj(gca,'Tag','trendpoints');
        
        if isempty(points) %no points yet
            plot(X,Y,'ro','Tag','trendpoints','Buttondownfcn','splinedraw dragstart');
        else
            [XData,i] = sort([get(points,'Xdata') X]); %add new point
            YData = [get(points,'Ydata') Y]; %add new point
            XData %print coordinates
            YData = YData(i) %sort Y like X, print coordinates

            if length(XData)>1
                XX = linspace(min(XData),max(XData),length(XData)*10); %create pline plot data
                YY = spline(XData,YData,XX);
            else % if only one point defined, spline makes no sense, just draw point
                XX = XData;
                YY = YData;
            end
            if ~isempty(line)
%                 set(line,'Xdata',XX,'Ydata',YY); %Update spline plot
                updateplot = true;
            end
            
            if length(XData)==2 %replot points so that they are above spline and can be clicked to move
                delete(points) 
                line=plot(XX, YY);
                set(line,'Tag','trendspline','Buttondownfcn','splinedraw gcf_bdf ')
                plot(XData,YData,'ro','Tag','trendpoints','Buttondownfcn','splinedraw dragstart');
            else
%                 set(points,'Xdata',XData,'Ydata',YData) %Update points
                updateplot = true;
            end
        end
        
    case 'dragstart',
        switch get(gcbf,'SelectionType')
            case 'normal' %left button --> move
                set(gcbf,'WindowButtonMotionFcn','splinedraw move')
                set(gcbf,'WindowButtonUpFcn','splinedraw stop')
                axis manual %freeze axes while dragging
            case 'alt'  %right button --> delete
                XData(whichpoint(1)) = []
                YData(whichpoint(1)) = []                
                updateplot = true;
            case 'open'  %right button --> delete
                disp('Doubleclick!')
                splinedraw %stop draw mode
                return
        end
        
    case 'move'
        set(points,'Selected','on')

        XData(whichpoint(1)) = X;
        YData(whichpoint(1)) = Y;
        
        updateplot = true;
        
    case 'stop'
        set(gcbf,'WindowButtonMotionFcn','')
        set(gcbf,'WindowButtonUpFcn','')
        points = findobj(gca,'tag','trendpoints');
        set(points,'selected','off')
        axis auto

        XData = get(points,'Xdata') %print coordinates
        YData = get(points,'Ydata') %print coordinates
end

if updateplot

        line = findobj('tag','trendspline');
        if length(XData)>1
            [XData,index]=unique(XData); %delete points with same X-Value
            XX = linspace(min(XData),max(XData),length(XData)*10);
            YY = spline(XData,YData(index),XX);
            set(line,'Xdata',XX,'Ydata',YY); %Update plot data
        else
            set(line,'Xdata',XData,'Ydata',YData); %Just a dummy
        end
        set(points,'Xdata',XData,'Ydata',YData(index)) %Update plot data
end