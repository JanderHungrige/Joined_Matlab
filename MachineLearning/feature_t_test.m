% T Test
% Testing if the Features have a significant difference between AS and QS.

clc
clear
tic
% [featurenames54,featurenames51,featurenames36,featurenames33,featurenames17,featurenames12,featurenames11,featurenames51_names_only]=fname;

%%%%% loading data
    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\')


    if exist(fullfile(cd, ['AnnotationMatrix.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['AnnotationMatrix.mat'])) ;
        AnnotationMatrix=AnnotationMatrix';
    end  

    if exist(fullfile(cd, ['SW_feature_Matrix.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['SW_feature_Matrix.mat']));
    end
    

%%%%% Delete NaN in Feature AND annotation Matrix%%%%%%%%
    [r,c]=find(isnan(Matrix));
    Matrix(r,:)=[]; AnnotationMatrix(r,:)=[]; clearvars r c

    %as NN10-30 are zero, delete all NN and pnn features except nn50 pnn50
    %r,c]=find(any(Matrix==1337));Matrix(:,c)=[];clearvars r c

%%%%% Delete SDANN %%%
    Matrix(:,[9,27,45])=[];
    
%%%%% Amount of features
    L=size(Matrix);L=L(2);

%%%%% Create feature Matrix with only AS and QS 
    FAS=Matrix(AnnotationMatrix(:,1)==1,:);
    FQS=Matrix(AnnotationMatrix(:,1)==2,:);
    
%%%%% Create only  LF HF SDNN   for meanstd to compare with adults
 Matrixmeanstd=Matrix(:,[38,40,42]);
 FASmeanstd=Matrixmeanstd(AnnotationMatrix(:,1)==1,:);
 FQSmeanstd=Matrixmeanstd(AnnotationMatrix(:,1)==2,:);
 clearvars Matrix AnnotationMatrix
 
 %%%%% Mean and std for LFnorm HFnorm and SDNN to compare with adults
 meanAS=mean(FASmeanstd); stdAS=std(FASmeanstd);
 meanQS=mean(FQSmeanstd); stdQS=std(FQSmeanstd);
 meanAS(2,:)=stdAS;meanQS(2,:)=stdQS;
 clearvars FASmeanstd FQSmeanstd stdAS stdQS
 
%%%%% Median and interquartile
    mediAS=median(FAS,1);mediAS_1=mediAS(1:17)';mediAS_3=mediAS(18:34)';mediAS_5=mediAS(35:51)';
    mediQS=median(FQS,1);mediQS_1=mediQS(1:17)';mediQS_3=mediQS(18:34)';mediQS_5=mediQS(35:51)';
    ASquartiles= quantile(FAS,[0.25 0.75]);ASquartiles_1=ASquartiles(:,1:17)';ASquartiles_3=ASquartiles(:,18:34)';ASquartiles_5=ASquartiles(:,35:51)';
    QSquartiles= quantile(FQS,[0.25 0.75]);QSquartiles_1=QSquartiles(:,1:17)';QSquartiles_3=QSquartiles(:,18:34)';QSquartiles_5=QSquartiles(:,35:51)';

%%%%% Is the data normal distributed?
    % can be checked with One-sample Kolmogorov-Smirnov test
    %h=0=standard normal distributed
    for i=1:L
        [norm_hAS(i),norm_pAS(i)] = kstest(FAS(:,i));
        [norm_hQS(i),norm_pQS(i)] = kstest(FQS(:,1));
    end
 
%%%% Wilcoxon rank sum test between AS and QS 
%     h=0==There is no difference between the groups. This lack of a difference is called the null hypothesis,
%     High P values: your data are likely with a true null.
%     Low P values: your data are unlikely with a true null.
%     The result h is 1 if the test rejects the null hypothesis at the 5% significance level, and 0 otherwise
    for i=1:L
        [p(i),AS_QS_h(i)] = ranksum(FAS(:,i),FQS(:,i));
    end
   AS_QS_p=p'*100;
    %create p values in percent for 1min 2.5min and five min windows
    ein=AS_QS_p(1:17);zwei=AS_QS_p(18:34);fuenf=AS_QS_p(35:51);AS_QS_p=[];
    AS_QS_p(:,1)=ein;AS_QS_p(:,3)=zwei;AS_QS_p(:,5)=fuenf;clearvars ein zwei fuenf
    AS_QS_p(:,2)=AS_QS_h(1:17);AS_QS_p(:,4)=AS_QS_h(18:34);AS_QS_p(:,6)=AS_QS_h(35:51);


%%%%% Wilcoxon rank sum test between Window size
    %ACHTUNG THE FREQUENCY DOMAIN IS OF COURS DEPENDENT ON THE WINDOW SIZE
    %ONLY CHECK 8-12 FOR TIME DOMAIN OR 4 AND 6 AS IT IS HFnorm and LFnorm
    AS1min=FAS(:,1:17);AS2min=FAS(:,18:34);AS5min=FAS(:,35:51);
    QS1min=FQS(:,1:17);QS2min=FQS(:,18:34);QS5min=FQS(:,35:51);
for i=1:(L/3)
    [win_p12(i),h12(i)] = ranksum(AS1min(:,i),AS2min(:,i));
    [win_p25(i),h25(i)] = ranksum(AS2min(:,i),AS5min(:,i));
    [win_p15(i),h15(i)] = ranksum(AS1min(:,i),AS5min(:,i));
    
    [win_Qp12(i),Qh12(i)] = ranksum(QS1min(:,i),QS2min(:,i));
    [win_Qp25(i),Qh25(i)] = ranksum(QS2min(:,i),QS5min(:,i));
    [win_Qp15(i),Qh15(i)] = ranksum(QS1min(:,i),QS5min(:,i));
end
win_p12(2,:)=h12;win_p25(2,:)=h25;win_p15(2,:)=h15;
win_Qp12(2,:)=Qh12;win_Qp25(2,:)=Qh25;win_Qp15(2,:)=Qh15;

    clearvars AS1min AS2min AS5min QS1min QS2min QS5min
    clearvars h p h12 h25 h15 Qh12 Qh25 Qh15 
    clearvars i L

    

toc