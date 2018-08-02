function plot_features_general
%%%%%%%%%%%%%%%%% CFS
clear 
clc
   cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\')
    if exist(fullfile(cd, ['AnnotationMatrix.mat']), 'file') == 2 % ==> 0 or 2
    load(fullfile(cd, ['AnnotationMatrix.mat']));
    AnnotationMatrix=AnnotationMatrix';
    end
    
    if exist(fullfile(cd, ['SW_feature_Matrix.mat']), 'file') == 2 % ==> 0 or 2
    load(fullfile(cd, ['SW_feature_Matrix.mat']));
    end    
    
%%%%%%%%%% Delete NaN in Feature AND annotation Matrix%%%%%%%%
    [r,c]=find(isnan(Matrix));
    Matrix(r,:)=[]; AnnotationMatrix(r,:)=[]; clearvars r c
    Matrix(Matrix==1337)=0; % Before 0 was converted to 1337 to avoid deletion

%%%%% SCALING
for i=1:51
    Fmean(:,i)=mean(Matrix(:,i)); Fstd(:,i)=(Matrix(:,i));
    scaledMatrix(:,i)=(Matrix(:,i)-Fmean(1,i))./Fstd(:,i);
end

%%%%%%%%% FIND STATES

   AS=find(AnnotationMatrix(:,1)==1);
   QS=find(AnnotationMatrix(:,1)==2);
   Aalertness=find(AnnotationMatrix(:,1)==3);
   Qalertness=find(AnnotationMatrix(:,1)==4); 
   Transition=find(AnnotationMatrix(:,1)==5);
   Position=find(AnnotationMatrix(:,1)==6); 
   Not_reliable=find(AnnotationMatrix(:,1)==7);

%%%%% find single features
%When using the name DO NOT FORGET THE SPACE AT THE END OF THE NAME
folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\MachineLearning';
cd(folder)
[featurenames54,featurenames51,featurenames36,featurenames33,featurenames17,featurenames12,featurenames11,featurenames51_names_only]=fname;

  NN50_1min=scaledMatrix(:,find(ismember(featurenames51_names_only,'NN50_1min ')));
  NN50_5min=scaledMatrix(:,find(ismember(featurenames51_names_only,'NN50_5min ')));
  NN10_5min=scaledMatrix(:,find(ismember(featurenames51_names_only,'NN10_5min ')));
  pNN50_5min=scaledMatrix(:,find(ismember(featurenames51_names_only,'pNN50_5min ')));
  pNN10_5min=scaledMatrix(:,find(ismember(featurenames51_names_only,'pNN10_5min ')));
  pNN20_5min=scaledMatrix(:,find(ismember(featurenames51_names_only,'pNN20_5min ')));
  VLF_5min=scaledMatrix(:,find(ismember(featurenames51_names_only,'VLF_5min ')));
  RMSSD_5min=scaledMatrix(:,find(ismember(featurenames51_names_only,'RMSSD_5min ')));
  LFnorm_5min=scaledMatrix(:,find(ismember(featurenames51_names_only,'LFnorm_5min ')));
  HFnorm_5min=scaledMatrix(:,find(ismember(featurenames51_names_only,'HFnorm_5min ')));
   totpow_5min=scaledMatrix(:,find(ismember(featurenames51_names_only,'totpow_5min ')));
%    F1= F2= F3=
%%%%%%%  plot of the first 3 CFS components with different colours for AS and QS
%%%3D

%PLOT ALL CLASSES NOT SCALED
figure;scatter3(HFnorm_5min(AS,1),VLF_5min(AS,1),totpow_5min(AS,1),'rd')
set(gcf,'color','w');
hold on
scatter3(HFnorm_5min(QS,1),VLF_5min(QS,1),totpow_5min(QS,1),'bs', 'MarkerFaceColor', 'b')
% scatter3(HFnorm_1min(Aalertness,1),pnn50_5min(Aalertness,1),RMSSD_5min(Aalertness,1),'b^')
% scatter3(HFnorm_1min(Qalertness,1),pnn50_5min(Qalertness,1),RMSSD_5min(Qalertness,1),'c*')
% scatter3(HFnorm_1min(Transition,1),pnn50_5min(Transition,1),RMSSD_5min(Transition,1),'yO')
% scatter3(HFnorm_1min(Not_reliable,1),pnn50_5min(Not_reliable,1),RMSSD_5min(Not_reliable,1),'k+')
legend('AS','QS','Active wake','Quite wake','Transition',' Not reliable','Location','Northeast');
% title(' First three CFS features')
xlabel('HFnorm '); ylabel('VLF '); zlabel('totpow ')
xlim([-6 0.5]);ylim([-5 1.5]);zlim([-6 1]);
hold off

figure;scatter3(HFnorm_5min(AS,1),VLF_5min(AS,1),LFnorm_5min(AS,1),'r.')
set(gcf,'color','w');
hold on
scatter3(HFnorm_5min(QS,1),VLF_5min(QS,1),LFnorm_5min(QS,1),'bx')
% scatter3(HFnorm_1min(Aalertness,1),pnn50_5min(Aalertness,1),RMSSD_5min(Aalertness,1),'b^')
% scatter3(HFnorm_1min(Qalertness,1),pnn50_5min(Qalertness,1),RMSSD_5min(Qalertness,1),'c*')
% scatter3(HFnorm_1min(Transition,1),pnn50_5min(Transition,1),RMSSD_5min(Transition,1),'yO')
% scatter3(HFnorm_1min(Not_reliable,1),pnn50_5min(Not_reliable,1),RMSSD_5min(Not_reliable,1),'k+')
legend('AS','QS','Active wake','Quite wake','Transition',' Not reliable','Location','Northeast');
% title(' First three CFS features')
xlabel('nn10 '); ylabel('VLF '); zlabel('pNN50 ')
% xlim([-12 2]);ylim([-30 2]);zlim([-30 2]);
hold off
disp('Holla');

figure;scatter3(VLF_5min(AS,1),pNN50_5min(AS,1),RMSSD_5min(AS,1),'r.')
set(gcf,'color','w');
hold on
scatter3(VLF_5min(QS,1),pNN50_5min(QS,1),RMSSD_5min(QS,1),'bx')
% scatter3(HFnorm_1min(Transition,1),pnn10_5min(Transition,1)*100,SDANN_5min(Transition,1),'gx')
% scatter3(HFnorm_1min(QS,1),pnn50_5min(QS,1),SDANN_5min(QS,1),'bo')
% scatter3(HFnorm_1min(Aalertness,1),pnn50_5min(Aalertness,1),SDANN_5min(Aalertness,1),'ks')
% scatter3(HFnorm_1min(Qalertness,1),pnn50_5min(Qalertness,1),SDANN_5min(Qalertness,1),'k*')
% scatter3(HFnorm_1min(Not_reliable,1),pnn50_5min(Not_reliable,1),RMSSD_5min(Not_reliable,1),'k+')
title(' First three CFS features')
xlabel('VLF 5min '); ylabel('pnn50 5min'); zlabel('RMSSD 5min')
xlim([0 4000000]);ylim([0 0.025]);zlim([-10 200]);
% set(gca,'position',[0.05 0.04 0.92 0.9],'units','normalized')% 3d fitting without frame
    legend('AS',' QS', 'transition','Acitve wake',' Quite wake' , 'Location','Northeast');
hold off
view([0,90])
set(gca,'position',[0.05 0.04 0.95 0.9],'units','normalized')% 2d fitting without frame
view([90,0])

%PLOT TWO/THREE OF THE CLASSES !! SCALED !!
figure;scatter3(HFnorm_1min_scaled(AS_scaled,1),pnn50_5min_scaled(AS_scaled,1),RMSSD_5min_scaled(AS_scaled,1),'r.')
set(gcf,'color','w');
hold on
scatter3(HFnorm_1min_scaled(QS_scaled,1),pnn50_5min_scaled(QS_scaled,1),RMSSD_5min_scaled(QS_scaled,1),'bx')
% % scatter3(HFnorm_1min_scaled(Transition,1),pnn50_5min_scaled(Transition,1),RMSSD_5min_scaled(Transition,1),'bO')
legend('AS','QS','Transition','Location','Northeast');
title(' First three CFS features')
xlabel('HFnorm 1min'); ylabel('pnn50 5min'); zlabel('RMSSD 5min')
xlim([-1 7]);ylim([-0.5 3]);zlim([-1 1]);
% xlim([0 80]);ylim([0 0.025]);zlim([-1 300]);
set(gca,'position',[0.04 0.04 0.95 0.9],'units','normalized')

hold off



view([0,90])


%%%2D 
%HFnorm-pnn50
figure;scatter(NN10_5min(AS,1),VLF_5min(AS,1),'r.')
set(gcf,'color','w');
hold on
scatter(NN10_5min(QS,1),VLF_5min(QS,1),'bx')
legend('AS','QS','Location','Northeast');
% title(' First two CFS features')
xlabel('pnn10'); ylabel('VLF')
xlim([0 0.025]);ylim([0 3000000]);

%pnn50-RMSSD
figure;scatter(SDANN_5min(AS,1),RMSSD_5min(AS,1),'r.')
set(gcf,'color','w');
hold on
scatter(SDANN_5min(QS,1),RMSSD_5min(QS,1),'gx')
legend('AS','QS','Location','Northeast');
title(' #2 and #3 CFS features')
xlabel('pnn50 5min'); ylabel('RMSSD 5min')
xlim([-0.005 0.025]);ylim([-1 300]);

figure;plot(HFnorm_1min(AS,1),' r.')
hold on 
plot(HFnorm_1min(QS,1),' gx');
hold off
xlabel('Instance')
ylabel('Values')
title('AS,QS of HFnorm 1min, Attention: unequal data')
legend('AS','QS','Location','Northeast');


%%%%%%%  plot of the first 3 FSMC components with different colours for AS and QS


%%%3D
%PNN50-PNN10
figure;scatter3(pNN50_5min(AS,1),pnn30_5min(AS,1),pnn20_5min(AS,1),'r.')
set(gcf,'color','w');
hold on
scatter3(pnn50_5min(QS,1),pnn30_5min(QS,1),pnn20_5min(QS,1),'g.')
legend('AS','QS','Location','Northeast');
title(' FSMC features')
xlabel('pnn50 5min'); ylabel('pnn30 5min'); zlabel('pnn20 5min')
% xlim([-10 90]);ylim([-0.005 0.025]);zlim([-1 300]);
hold off

figure;scatter3(pnn50_5min(AS,1),pnn10_5min(AS,1),pnn20_5min(AS,1),'r.')
set(gcf,'color','w');
hold on
scatter3(pnn50_5min(QS,1),pnn10_5min(QS,1),pnn20_5min(QS,1),'g.')
legend('AS','QS','Location','Northeast');
title(' FSMC features')
xlabel('pnn50 5min'); ylabel('pnn10 5min'); zlabel('pnn20 5min')
% xlim([-10 90]);ylim([-0.005 0.025]);zlim([-1 300]);
hold off

figure;scatter3(pnn50_1min(AS,1),pnn10_1min(AS,1),pnn20_1min(AS,1),'r.')
set(gcf,'color','w');
hold on
scatter3(pnn50_1min(QS,1),pnn10_1min(QS,1),pnn20_1min(QS,1),'g.')
legend('AS','QS','Location','Northeast');
title(' FSMC features')
xlabel('pnn50 1min'); ylabel('pnn10 1min'); zlabel('pnn20 1min')
% xlim([-10 90]);ylim([-0.005 0.025]);zlim([-1 300]);
hold off

figure;scatter3(pnn30_1min(AS,1),pnn10_1min(AS,1),pnn20_1min(AS,1),'r.')
set(gcf,'color','w');
hold on
scatter3(pnn30_1min(QS,1),pnn10_1min(QS,1),pnn20_1min(QS,1),'g.')
legend('AS','QS','Location','Northeast');
title(' FSMC features')
xlabel('pnn30 1min'); ylabel('pnn10 1min'); zlabel('pnn20 1min')
% xlim([-10 90]);ylim([-0.005 0.025]);zlim([-1 300]);
hold off

%%SDANN
figure;scatter3(SDANN_5min(AS,1),pnn50_5min(AS,1),pnn30_5min(AS,1),'r.')
set(gcf,'color','w');
hold on
scatter3(SDANN_5min(QS,1),pnn50_5min(QS,1),pnn30_5min(QS,1),'gx')
legend('AS','QS','Location','Northeast');
title(' FSMC features')
xlabel('SDANN 5min'); ylabel('pnn50 5min'); zlabel('pnn30 5min')
% xlim([-10 90]);ylim([-0.005 0.025]);zlim([-1 300]);
hold off

%%% only x y can be seen with view(0,0); view(0,90), view(0,180)...
end