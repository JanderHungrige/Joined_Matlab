function plot_CFS(CFS_value,featurenames,zuordnung)

%%%%%% cumultative sum of CSF
sumCFS=cumsum(CFS_value/sum(CFS_value)*100); %cumsum in %

%%%%%%%%%% plotting
figure
        x=[1:1:length(CFS_value)];
        h = bar(x,CFS_value);
%         [ax,h1,h2]=plotyy(x,CFS_value,x,sumCFS','bar','plot');
        set(gcf,'color','w');% background white

        % Reduce the size of the axis so that all the labels fit in the figure.
        pos = get(gca,'Position');
        set(gca,'Position',[pos(1), .2, pos(3) .65])

        title('CFS values for each feature')
        h1.FaceColor = [0,0.7,0.7];
        h2.Color= [216,213,213]./255;
        h2.LineWidth = 3;
        % Set X-tick positions
        Xt = x;
        set(gca,'XTick',Xt);
        % % ensure that each string is of the same length, using leading spaces
        % algos = ['       CELF'; 'DegDiscount'; '    GroupPR';
        %     '     Linear'; '     OutDeg'; '   PageRank'; ' buildGraph'];

        axen = axis; % Current axis limits
        axis(axis); % Set the axis limit modes (e.g. XLimMode) to manual
        Yl = axen(3:4); % Y-axis limits
        % Xl= [1 50]
        % Remove the default labels
        set(gca,'XTickLabel','')

        % Place the text labels
        t = text(Xt,Yl(1)*ones(1,length(Xt)),featurenames(zuordnung'));%1:length(CFS_value),:));
        set(t,'HorizontalAlignment','right','VerticalAlignment','top', ...
        'Rotation',45, 'Fontsize', 13);
%         ylabel(ax(1),'CFS value', 'Fontsize', 13)
%         ylabel(ax(2),'cumultative CFS value', 'Fontsize', 13)
        ylabel('CFS value')
        % Get the Extent of each text object. This
        % loop is unavoidable.
        for i = 1:length(t)
        ext(i,:) = get(t(i),'Extent');
        end

        % % Determine the lowest point. The X-label will be
        % % placed so that the top is aligned with this point.
        % LowYPoint = min(ext(:,2));
        % 
        % % Place the axis label at this point
        % XMidPoint = Xl+abs(diff(Xl))/2;
        % tl = text(XMidPoint,LowYPoint,'X-Axis Label', ...
        % 'VerticalAlignment','top', ...
        % 'HorizontalAlignment','center');
        
%%%%%%%%%% #D plot as in Halls paper (z: max CFS; x: number of features (k); y: mean rff)

end