%Minority class feature selection methode(filter)

function [FeatMat2]=FSMC_function(inclSDANN)
%%%%%%%%%% loading data
%     cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\')
% 
%     if exist(fullfile(cd, ['feature_Matrix.mat']), 'file') == 2 % ==> 0 or 2
%     load(fullfile(cd, ['feature_Matrix.mat']));
%     end
% 
%     if exist(fullfile(cd, ['AnnotMatrixfull.mat']), 'file') == 2 % ==> 0 or 2
%     load(fullfile(cd, ['AnnotMatrixfull.mat']));
%     end
%     
%     %%%%%% scaled    
%     if exist(fullfile(cd, ['feature_scaledMatrix.mat']), 'file') == 2 % ==> 0 or 2
%         load(fullfile(cd, ['feature_scaledMatrix.mat']))
%     end
%     
%     cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\')
% 
%     if exist(fullfile(cd, ['AnnotationMatrix.mat']), 'file') == 2 % ==> 0 or 2
%         load(fullfile(cd, ['AnnotationMatrix.mat'])) ;
%         AnnotationMatrix=AnnotationMatrix';
%     end  
% 
%     if exist(fullfile(cd, ['SW_feature_Matrix.mat']), 'file') == 2 % ==> 0 or 2
%         load(fullfile(cd, ['SW_feature_Matrix.mat']));
%     end
%Fnr
% 54 is with all 54 features including nnx and SDANN
% 51 is with nnx (10-30) without SDANN

% 36 is without nnx (10-30) and including SDANN
% 33 is without nnx (10-30) and without   SDANN

% 17 is only 5 min with nnx (10-30) without SDANN 
% 12 is only 5 min without nnx (10-30) including SDANN
% 11 is only 5 min without nnx (10-30) wihtout   SDANN

Fnr=17;

%%%%%%%%% loading data
    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\')

    if exist(fullfile(cd, ['AnnotationMatrix.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['AnnotationMatrix.mat'])) ;
        AnnotationMatrix=AnnotationMatrix';
    end  

    if exist(fullfile(cd, ['SW_feature_Matrix.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['SW_feature_Matrix.mat']));
    end

%%% Delete SDANN %%%
if inclSDANN ==0
    Matrix(:,[9,27,45])=[];
end

if Fnr==54 || Fnr==51  %decided before if SDANN is included or not
    %%%%%%%%%% Delete NaN in Feature AND annotation Matrix all 54 features%%%%%%%%
    [r,c]=find(isnan(Matrix));
    Matrix(r,:)=[]; AnnotationMatrix(r,:)=[]; clearvars r c
    Matrix(Matrix==1337)=0; % Before 0 was converted to 1337 to avoid deletion

elseif Fnr==36 || Fnr==33
    %%%%%%%%%% Delete NaN in Feature AND annotation Matrix without NN and pnn%%%%%%%%
    [r,c]=find(isnan(Matrix));
    Matrix(r,:)=[]; AnnotationMatrix(r,:)=[]; clearvars r c
    [r,c]=find(any(Matrix==1337));Matrix(:,c)=[];clearvars r c %as NN10-30 are zero, delete all NN and pnn features except nn50 pnn50
%     Matrix(Matrix==1337)=0; % Before 0 was converted to 1337 to avoid deletion


elseif Fnr==17
    %%%%%%%%%% Delete NaN in Feature AND annotation Matrix without NN and pnn%%%%%%%%
    [r,c]=find(isnan(Matrix));
    Matrix(r,:)=[]; AnnotationMatrix(r,:)=[]; clearvars r c
    [r,c]=find(any(Matrix==1337));Matrix(r,c)=0;clearvars r c %include nnx. 1337 was placeholder for 0. Nan/1337 already deleted. Rest 1337 return to 0
%     Matrix(Matrix==1337)=0; % Before 0 was converted to 1337 to avoid deletion
    Matrix=Matrix(:,end-16:end); % take only the last 17 which are the 5 min values (16 as including the end-17th )
    
elseif Fnr==12
    %%%%%%%%%% Delete NaN in Feature AND annotation Matrix without NN and pnn%%%%%%%%
    [r,c]=find(isnan(Matrix));
    Matrix(r,:)=[]; AnnotationMatrix(r,:)=[]; clearvars r c
    [r,c]=find(any(Matrix==1337));Matrix(:,c)=[];clearvars r c %as NN10-30 are zero, delete all NN and pnn features except nn50 pnn50
%     Matrix(Matrix==1337)=0; % Before 0 was converted to 1337 to avoid deletion
    Matrix=Matrix(:,end-11:end); % take only the last 12 which are the 5 min values
    
elseif Fnr==11
    %%%%%%%%%% Delete NaN in Feature AND annotation Matrix without NN and pnn%%%%%%%%
    [r,c]=find(isnan(Matrix));
    Matrix(r,:)=[]; AnnotationMatrix(r,:)=[]; clearvars r c
    [r,c]=find(any(Matrix==1337));Matrix(:,c)=[];clearvars r c %as NN10-30 are zero, delete all NN and pnn features except nn50 pnn50
    Matrix(Matrix==1337)=0; % Before 0 was converted to 1337 to avoid deletion
    Matrix=Matrix(:,end-10:end); % take only the last 11 which are the 5 min values
end

%%%%%%%%%% SCALING around 0
    scaledMatrix=zeros(size(Matrix));
    Mittelw=mean(Matrix,1);
    stderiv=std(Matrix,0,1);
    scaledMatrix=bsxfun(@minus,Matrix,Mittelw);
    scaledMatrix=bsxfun(@rdivide,scaledMatrix,stderiv);
%   scaledMatrix(any(isnan(scaledMatrix),2),:)=[];
    scaledMatrix(isnan(scaledMatrix))=0;
%     
% %%%%%%%%%% Delete NaN in Feature AND annotation Matrix%%%%%%%%
%     Matrix(any(isnan(Matrix),2),:)=[]; %kill nans
%     Matrix(Matrix==1337)=0; % Before 0 was converted to 1337 to avoid deletion
%     AnnotationMatrix(any(isnan(AnnotationMatrix),2),:)=[];
    L=size(Matrix); L=L(1,2); % nubers of features
% 
% %%%%%%%%%% SCALING
% for i=1:L
%     Fmean(:,i)=mean(Matrix(:,i)); Fstd(:,i)=(Matrix(:,i));
%     scaledMatrix(:,i)=(Matrix(:,i)-Fmean(1,i))./Fstd(:,i);
% end   
%%%%%%%%%% FEATURE SELECTION
for k=1:L   
    meanmaj(1,k)=mean(Matrix((AnnotationMatrix(:,1)==1),k)); % Mean of Majority class (AS) for each feature (k)
    meanmin(1,k)=mean(Matrix((AnnotationMatrix(:,1)==2),k));% Mean of Minority class (QS) for each feature (k)
    
    w=0; sigmaj(1,k)=std(Matrix(AnnotationMatrix(:,1)==1,k),w); % Standard derivation of Majority class (AS) for each feature (k),  When w = 0 (default), S is normalized by N-1. When w = 1, S is normalized by the number of observations, N
%     sigmin(1,k)=std(Matrix(AnnotMatrixfull(:,k)==1),k); % Standard derivation of Minority class (QS) for each feature (k)

    if meanmin(1,k)>(meanmaj(1,k)+2*sigmaj(1,k)) || meanmin(1,k)<(meanmaj(1,k)-2*sigmaj(1,k))
        FeatMat2(1,k)=1;
    else
        FeatMat2(1,k)=0;
    end

    if meanmin(1,k)>(meanmaj(1,k)+3*sigmaj(1,k)) || meanmin(1,k)<(meanmaj(1,k)-3*sigmaj(1,k))
        FeatMat3(1,k)=1;
    else
        FeatMat3(1,k)=0;
    end
        
end
%%%%%%%%%% ZUORDNUNG
folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\MachineLearning';
cd(folder)
[featurenames54,featurenames51,featurenames36,featurenames33,featurenames17,featurenames12,featurenames11,featurenames51_names_only]=fname;

disp('Features selected by FSMC are for') 
disp(['Sigma=1: ' num2str(find(FeatMat2==1))])
disp(['Sigma=2: ' featurenames17{find(FeatMat2==1)}])
disp(['Sigma=3: ' num2str(find(FeatMat3==1))])

    
end