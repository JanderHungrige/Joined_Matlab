  function plot_pca(coeff,score,AnnotMatrixfull,explained)

    %plotting PCA
    
%figure; bip=biplot(coeff(:,1:3),'scores',score(:,1:3));


AS=find(AnnotMatrixfull(:,1)==1);
QS=find(AnnotMatrixfull(:,1)==2);

%%%%%%% Scatter plot of the first 3 principal components with different colours for AS and QS

figure;scatter3(score(AS,1),score(AS,2),score(AS,3),'r.')
set(gcf,'color','w');
hold on
scatter3(score(QS,1),score(QS,2),score(QS,3),'gx')
legend('AS','QS','Location','Northeast');
title('Principal components of HRV features')
xlabel('Component 1'); ylabel('Component 2'); zlabel('Component 3')
% xlim([-5 30]);ylim([-10 30]);zlim([-15 10]);
hold off
% 
% figure;scatter3(score(AS,1),score(AS,2),score(AS,3),'r.')
% set(gcf,'color','w');
% hold on
% scatter3(score(QS,1),score(QS,2),score(QS,3),'g.')
% legend('AS','QS','Location','Northeast');
% title('Principal components of HRV features')
% xlabel('Component 1'); ylabel('Component 2'); zlabel('Component 3')
% % xlim([-30 30]);ylim([-30 30]);zlim([-30 30]);


%%%%%%%%%% Plot 1D distribution of points per principal component
figure;
set(gcf,'color','w');


hAxes = axes('NextPlot','add',...           %# Add subsequent plots to the axes,
             'DataAspectRatio',[1 1 1],...  %#   match the scaling of each axis,
             'XLim',[-30 30],...            %#   set the x axis limit,
             'YLim',[0 eps],...             %#   set the y axis limit (tiny!),
             'Color','none'...             %#   and don't use a background color
                );    
            
            
       
plot(score(AS,6),0,'*b','MarkerSize',10);  %# Plot data set 1
hold on
plot(score(QS,6),0,'*b','MarkerSize',10);  %# Plot data set 1

%%%%%%%%% Plot variance and cumultatve variance over the principal
%%%%%%%%% components
figure
set(gcf,'color','w');
hAxes = axes('YLim',[0 110],...            %#   set the x axis limit,
             'Color','none'...             %#   and don't use a background color
                );  
            x=(1:1:length(explained));
            red=find(cumsum(explained)>94.9999);
            yp=(0:0.01:110);
[ax,var,cumvar]=plotyy(x,explained,x,cumsum(explained)','plot','area');
set(ax(1),'ylim',[0 34], 'ytick', [10 20 32],'xlim',[0 30]);
set(ax(2),'ylim',[0 110], 'ytick',[50 100] );
uistack(ax(1)); % get plot in the front
set(ax(1), 'Color', 'none');% set background of plot none otherwise it blocks area
ylabel(ax(1),'Variance in % ')
ylabel(ax(2),'Cumultative variance in % ')
xlabel('Principal components')
var.LineWidth = 3;
var.Color = [0,0.7,0.7];
cumvar.FaceColor= [216,213,213]./255;
hold on 
tickle=[];
r=plot([red(1,1),red(1,1)], [0 110],'r')
legend([r],'95%tile at pc 9','Location','Southeast');

end