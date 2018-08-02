%Call machine learning functions
clc
clear
tic
%%%%%%%% Call variables
pat=[3,4,5,6,7,9,13,15]; % 3,4,5(16,17,18),6,7,9,10,13,15\
saving=1;
plotting=0;
inclSDANN=0; % should SDANN be included in the matrix 
win=[60 180 300];
counter=1; %how often was a function called
scaled=0; % if scaled =1 then the CFS uses the scaled feature matrix, if scaled=0 the unscaled BUT Pearson does -mean/stdv
% pat=[5];
%preallocation
Matrix=[];
Matrix2=[];
Matrixonlysleep=[];
FeatureMatrix=struct;
AnnotMatrix=[];
AnnotationMatrix_onlysleep=[];
folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\MachineLearning';

[featurenames54,featurenames51,featurenames36,featurenames33,featurenames17,featurenames12,featurenames11,featurenames51_names_only]=fname;
%%%%%%%% Matrix creation
% % % 
% 
for i=1:length(pat)
        if i==length(pat)
            counter=10000;
        end
Neonate=pat(1,i);
% % % 
% % cd(folder)
% % % % [Matrix]=pcaMatrix(Neonate,win,Matrix,saving,counter); %only AS QS %output: 
% % % % %  row: values, colums: features 
% % % % 
% cd(folder)
% [Matrix]=FeatureMatrixfunct(Neonate,win,Matrix,saving,counter,inclSDANN); % all classes
% 
% cd(folder)
% [Matrix2]=FeatureMatrixfunct_for_each_patients(Neonate,win,Matrix2,saving); % all classes needed for leave one out cross validation Bootstrap.

% % cd(folder)
% % [AnnotMatrix,AnnotationMatrix_onlysleep]=AnnotationMatrix_funct(Neonate,win,saving,counter,AnnotMatrix,AnnotationMatrix_onlysleep); %output: row: features, colums: values
% % % % % % 
% cd(folder)
% [AnnotMatrix,AnnotationMatrix_onlysleep]=AnnotationMatrix_onewindow(Neonate,win,saving,counter,AnnotMatrix,AnnotationMatrix_onlysleep); %output: row: features, colums: values
% % % % 
% cd(folder)
% AnnotationMatrix_for_each_patients(Neonate,win,saving); %output: row: features, colums: values
% % 
% cd(folder)
% feature_scaling_for_each_patient(saving,Neonate); %deleting Nans and scaling mean over std %FEATURE SCALING IS DONE IN PYTHON
% % cd(folder)
 counter=counter+1;
end
cd(folder)
for i=1:length(pat) %Creating 5min only Matrix for python wrapper
%         if i==length(pat)
%             counter=10000;
%         end
% 
% Neonate=pat(1,i);
% [Matrix_5,AnnotationMatrix]=create5minonlyMatrix(Neonate,saving);
% cd(folder)


end
% counter=1; %reset
% % 
% cd(folder)
% % % 
% [Matrix]=feature_scaling(saving);%output: row: features, colums: values 
% cd(folder)
% [AnnotMatrixfull,AnnotationMatrix_onlysleep_full]=fillAnnotMatrix(AnnotMatrix,AnnotationMatrix_onlysleep,saving);%output: row: values, colums: features
% 
% 
% %  cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\')
% %  if exist(fullfile(cd, ['AnnotMatrixfull.mat']), 'file') == 2 % ==> 0 or 2
% %     load(fullfile(cd, ['AnnotMatrixfull.mat']));
% %  end
%  AnnotMatrixfull=AnnotMatrixfull(~any(isnan(AnnotMatrixfull),2),:);

% AnnotMatrix=AnnotMatrix';

%%%%%%%% Principal component analysis
% cd(folder)
%  [coeff,score,latent,tsquared,explained,Matrix]=pcaAnalysis; %latent= variance
% cd(folder)
%  plot_pca(coeff,score,AnnotMatrixfull,explained)


%%%%%%%% Correlation based feature selection
cd(folder)
Fnr=17;
%-------------------------------------------------------------------
% %  54 is with all 54 features including nnx and SDANN
% %  51 is with nnx (10-30) without SDANN
% % 
% %  36 is without nnx (10-30) and including SDANN
% %  33 is without nnx (10-30) and without   SDANN
% % 
% %  17 is only 5 min with nnx (10-30) without SDANN 
% %  12 is only 5 min without nnx (10-30) including SDANN
% %  11 is only 5 min without nnx (10-30) wihtout   SDANN
%-------------------------------------------------------------------
% [Sorted,zuordnung,CFS_value]=CFS_function(scaled,saving,Fnr,inclSDANN); % call correlation based feature selection
% cd(folder)
% plot_CFS(CFS_value,featurenames17,zuordnung)

% %  view([0,90])
% 
% %%%%%%%%Minority Class feature Seletion
cd(folder)
[FeatMat]=FSMC_function(inclSDANN);



%%%%%%%%% plotting differnt feature combinations
% cd(folder)
%  plot_features_general



%%%%%%%% Tool boxes
%Spider fisher object
% cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\MachineLearning\Spider')
% callingFisher

% Weka
%create CSV file
% 
% csvwrite('Matrix',Matrix)
% csvwrite('annotations',annotations)
toc



