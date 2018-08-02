% this function will create the input feature matrix for principal
% component analysis
%Thereby, the n by m matrix will have the fearture values as collums (x)and
%the features as rows (y)

%Feature List

%%%%%short term frequency domain features (1,3,5min)
% 5min total power (<0.4 Hz)
% VLF power in very low frequency range (adult 0.003-0.04 Hz)
% LF  power in low frequency range (adult 0.04-0.15 Hz)
% LFnorm  LF power in normalized units LF/(total power-vlf)x100 or LF/(LF+HF)*100
% HF power in high frequency range (adult 0.15-0.4 Hz)
% HFnorm HF power in normalized units HF/(total power-vlf)x100 or HF/(LF+HF)*100
% LF/HF Ratio LF/HF

%%%%%short term time domain features (1,3,5min)
% SDNN;
% SDANN
% RMSSD
% NNx (50,30,20,10)
% pNNx (50,30,20,10)

%Attention HF norm was divided by 0, therefore,the result became inf. We
%solved this by exchanging the devision of HF/norm by HF/1 when norm ==0.
%Please check if that leads to wrong results



function [AnnotationMatrix,AnnotationMatrix_onlysleep]=AnnotationMatrix(Neonate,win,saving,counter,AnnotationMatrix,AnnotationMatrix_onlysleep)
      
      cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\')

    if exist(fullfile(cd,['SW_feature_Matrix.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd,['SW_feature_Matrix.mat']))
    end
    
    if counter~=10000
        Matrix=Matrix';% turning the feature matrix, when counter 1000 the matrix is already turned in featureMatrix.m
%         AnnotationMatrix=AnnotationMatrix'; %
%         AnnotationMatrix_onlysleep=AnnotationMatrix_onlysleep' ;
    end
%      AnnotationMatrix=nan(size(Matrix));  
     
    for j=1:length(win)

%%%%% checking if file exist / loading
    %%% !! VLFWake does not exist for patient 6&7. There where no 2 consentual annotations. Therefore preallocation of empty variables 
        VLF_AS{1}=[];VLF_QS{1}=[];VLF_Aalertness{1}=[];VLF_Qalertness{1}=[];VLF_transition{1}=[];VLF_position{1}=[];VLF_Not_reliable{1}=[]; %%%%% creating empty variables for error dissmissal
        cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\HRV features\')
        filenames={'VLF_','VLFWake_','VLFtransition_','VLFposition_','VLFNot_reliable_'};    
        %loading the files         
        for p=1:length(filenames)
           if exist(fullfile(cd, [filenames{p} num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
            load(fullfile(cd, [filenames{p} num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
          end
        end
        
        %some features are saved in cell elements.
        VLF_AS= cell2mat(VLF_AS); VLF_QS=cell2mat(VLF_QS);
        VLF_Aalertness=cell2mat(VLF_Aalertness);VLF_Qalertness=cell2mat(VLF_Qalertness);
        VLF_transition=cell2mat(VLF_transition);VLF_position=cell2mat(VLF_position);
        VLF_Not_reliable=cell2mat(VLF_Not_reliable);


%%%%% Matrix combining AS, QS ... values for each feature (differnt win [j] is new feature) for all patients

        if counter==1 %create the matrix new only for the first time (when Matrix=[], therefore L=0) All the other times just add the new data at the end
            if j==1 
                %create Matrix only for AS QS () used with pcaMartix.m
%                AnnotationMatrix_onlysleep(j,~isnan(VLF_AS))=1;          %creating Annotation Matrix with AS annotations
%                tmp(j,~isnan(VLF_QS))=2;                       % getting QS annotations...
%                    AnnotationMatrix_onlysleep=[AnnotationMatrix_onlysleep,tmp];       %... and mergin AS + QS into first row of the matrix
%                clear tmp                
                
                %create Matrix
               AnnotationMatrix(j,~isnan(VLF_AS))=1;          %creating Annotation Matrix with AS annotations
               tmp(j,~isnan(VLF_QS))=2;                       % getting QS annotations...
               AnnotationMatrix=[AnnotationMatrix,tmp];       %... and mergin AS + QS into first row of the matrix
               clear tmp
               tmp(j,~isnan(VLF_Aalertness))=3;               
               AnnotationMatrix=[AnnotationMatrix,tmp];       %... and mergin AS + QS + Wake into first row of the matrix
               clear tmp
               tmp(j,~isnan(VLF_Qalertness))=4;
               AnnotationMatrix=[AnnotationMatrix,tmp];       %... and mergin AS + QS + Wake into first row of the matrix
               clear tmp      
               tmp(j,~isnan(VLF_transition))=5;
               AnnotationMatrix=[AnnotationMatrix,tmp];       %... and mergin AS + QS + Wake + transition into first row of the matrix
               clear tmp  
               tmp(j,~isnan(VLF_position))=6;
               AnnotationMatrix=[AnnotationMatrix,tmp];       %... and mergin AS + QS + Wake + transition + position into first row of the matrix
               clear tmp     
               tmp(j,~isnan(VLF_Not_reliable))=7;
               AnnotationMatrix=[AnnotationMatrix,tmp];       %... and mergin AS + QS + Wake + transition + position + Not reliable into first row of the matrix
               clear tmp                   
            else
                
%%%%%%%%%%%%%Add new "win" features to the matrix per win loop (j~=1)%%%%%%
%%%%%%%%%%% only AS QS                
%                AnnotationMatrix_sleeponly_2(1,~isnan(VLF_AS))=1;       % creating array for AS annotations for next window size
%                tmp(1,~isnan(VLF_QS))=2;                      % creating array for QS annotations for next window size
%                AnnotationMatrix_sleeponly_2=[AnnotationMatrix_sleeponly_2,tmp];  % mergin new win values (AS+QS) in AS array...
%                AnnotationMatrix_onlysleep(j,:)=AnnotationMatrix_sleeponly_2;     %...and joining them into the Annotation Matrix in row j 
%                clear tmp AnnotationMatrix_sleeponly_2                
                
%%%%%%%%%%% AS QS     We use one feature e.g. VLF as the annotations are the same over the complete data for each feature           
               AnnotationMatrix_2(1,~isnan(VLF_AS))=1;       % creating array for AS annotations for next window size
               tmp(1,~isnan(VLF_QS))=2;                      % creating array for QS annotations for next window size
               AnnotationMatrix_2=[AnnotationMatrix_2,tmp];  % mergin new win values (AS+QS) in AS array...
               AnnotationMatrix_tmp=AnnotationMatrix_2;     %...and joining them into the Annotation Matrix in row j 
               clear tmp AnnotationMatrix_2
%%%%%%%%%%% WAKE               
               AnnotationMatrix_2(1,~isnan(VLF_Aalertness))=3;       % creating array for Aalertness annotations for next window size
               tmp(1,~isnan(VLF_Qalertness))=4;                      % creating array for Qalertness annotations for next window size
               AnnotationMatrix_2=[AnnotationMatrix_2,tmp];          % mergin new win values (Aalertness+Qalertness) in Aalertness array...
               AnnotationMatrix_tmp=[AnnotationMatrix_tmp,AnnotationMatrix_2];             %...and joining them into the Annotation Matrix in row j                
               clear tmp AnnotationMatrix_2
%%%%%%%%%%% TRANSITION - POSITION - NOT RELIABLE             
               AnnotationMatrix_2(1,~isnan(VLF_transition))=5;       % creating array for transition annotations for next window size
               tmp(1,~isnan(VLF_position))=6;                        % creating array for position annotations for next window size
               tmp2(1,~isnan(VLF_Not_reliable))=7;                   % creating array for Not reliable annotations for next window size               
               AnnotationMatrix_2=[AnnotationMatrix_2,tmp];  % mergin new win values (transition+position) in transition array...
               AnnotationMatrix_2=[AnnotationMatrix_2,tmp2];  % mergin new win values (transition+position+not reliable) in transition array...                              
               AnnotationMatrix_tmp=[AnnotationMatrix_tmp,AnnotationMatrix_2];             %...and joining them into the Annotation Matrix in row j                
               clear tmp tmp2 AnnotationMatrix_2
               
               AnnotationMatrix(j,:)=AnnotationMatrix_tmp;
            end
            
%%%%%%%%%%%%Add values of other patients to Matrix%%%%%%%%%%
        else % for the next patients           
               if j==1 
                    %create Matrix
%%%%%%%%%%% only AS QS                    
%                    AnnotationMatrix_onlysleep_temp(j,~isnan(VLF_AS))=1;
%                    temp(j,~isnan(VLF_QS))=2;
%                    AnnotationMatrix_onlysleep_temp=[AnnotationMatrix_onlysleep_temp,temp];
%                    clear temp   
%                    
%%%%%%%%%%% AS QS  %%%%                  
                   AnnotationMatrixtemp_1(j,~isnan(VLF_AS))=1;
                   temp(j,~isnan(VLF_QS))=2;
                   AnnotationMatrixtemp=[AnnotationMatrixtemp_1,temp];
                   clear temp AnnotationMatrixtemp_1
%%%%%%%%%%% WAKE                   
                   AnnotationMatrixtemp_1(j,~isnan(VLF_Aalertness))=3;
                   temp(j,~isnan(VLF_Qalertness))=4;
                   AnnotationMatrixtemp_1=[AnnotationMatrixtemp_1,temp];
                   AnnotationMatrixtemp=[AnnotationMatrixtemp,AnnotationMatrixtemp_1];
                   clear temp AnnotationMatrixtemp_1
%%%%%%%%%%% TRANSITION POSITION NOT RELIABLE                   
                   AnnotationMatrixtemp_1(j,~isnan(VLF_transition))=5;
                   temp(j,~isnan(VLF_position))=6;
                   temp2(j,~isnan(VLF_Not_reliable))=7;                   
                   AnnotationMatrixtemp_1=[AnnotationMatrixtemp_1,temp];
                   AnnotationMatrixtemp_1=[AnnotationMatrixtemp_1,temp2];
                   AnnotationMatrixtemp=[AnnotationMatrixtemp,AnnotationMatrixtemp_1];                   
                   clear temp temp2 AnnotationMatrixtemp_1                    
               else                    
%%%%%%%% Add new "win" features to the matrix per win loop (j~=1) %%%%%%%%%
%%%%%%%%%%%% only AS QS                                           
%                    AnnotationMatrix_onlysleep_temp(1,~isnan(VLF_AS))=1;               % creating array for AS annotations for next window size for new patient 
%                    temp(1,~isnan(VLF_QS))=2;                                 % creating array for QS annotations for next window size for new patient
%                    AnnotationMatrix_onlysleep_temp=[AnnotationMatrix_onlysleep_temp,temp];     % mergin new win values (AS+QS) of new patient in AS array...
%                    AnnotationMatrix_onlysleep_temp(j,:)=AnnotationMatrix_onlysleep_temp;         %...and joining them into the temporary Annotation Matrix at row j
%                    clear temp AnnotationMatrixtemp_onlysleep   
                   
%%%%%%%%%%%% AS QS %%%%                                          
                   AnnotationMatrixtemp_2(1,~isnan(VLF_AS))=1;               % creating array for AS annotations for next window size for new patient 
                   temp(1,~isnan(VLF_QS))=2;                                 % creating array for QS annotations for next window size for new patient
                   AnnotationMatrixtemp_2=[AnnotationMatrixtemp_2,temp];     % mergin new win values (AS+QS) of new patient in AS array...
                   AnnotationMatrixtemp_3=[AnnotationMatrixtemp_2];           %...and joining them into the temporary Annotation Matrix at row j
                   clear temp AnnotationMatrixtemp_2                   
%%%%%%%%%%%% WAKE                                  
                   AnnotationMatrixtemp_2(1,~isnan(VLF_Aalertness))=3;               % creating array for Aalertness annotations for next window size for new patient 
                   temp(1,~isnan(VLF_Qalertness))=4;                                 % creating array for Qalertness annotations for next window size for new patient
                   AnnotationMatrixtemp_2=[AnnotationMatrixtemp_2,temp];     % mergin new win values (Aalertness+Qalertness) of new patient in AS array...
                   AnnotationMatrixtemp_3=[AnnotationMatrixtemp_3,AnnotationMatrixtemp_2];         %...and joining them into the temporary Annotation Matrix at row j
                   clear temp AnnotationMatrixtemp_2
%%%%%%%%%%%% TRANSITION POSITION NOT RELIABLE                            
                   AnnotationMatrixtemp_2(1,~isnan(VLF_transition))=5;               % creating array for transition annotations for next window size for new patient 
                   temp(1,~isnan(VLF_position))=6;                                 % creating array for position annotations for next window size for new patient
                   temp2(1,~isnan(VLF_Not_reliable))=7;                                 % creating array for not reliable annotations for next window size for new patient                   
                   AnnotationMatrixtemp_2=[AnnotationMatrixtemp_2,temp];     % mergin new win values (trasnition+posiion) of new patient in transition array...
                   AnnotationMatrixtemp_2=[AnnotationMatrixtemp_2,temp2];     % mergin new win values (trasnition+posiion+not relibale) of new patient in transition array...                   
                   AnnotationMatrixtemp_3=[AnnotationMatrixtemp_3,AnnotationMatrixtemp_2];         %...and joining them into the temporary Annotation Matrix at row j                  
                   clear temp temp2 AnnotationMatrixtemp_2                   

                   AnnotationMatrixtemp(j,:)=AnnotationMatrixtemp_3;         %...and joining them all togehter into the Annotation Matrix at row j                  
                   clear  AnnotationMatrixtemp_3                                    
                   
               end
        

            if j==length(win) %when all windows loops through the win are finished...
                AnnotationMatrix=[AnnotationMatrix,AnnotationMatrixtemp];%...combine the temporary matrix with the Matrix
%                 AnnotationMatrix_onlysleep=[AnnotationMatrix_onlysleep,AnnotationMatrix_onlysleep_temp];%...combine the temporary matrix with the Matrix nlyfor sleep used with e.g the pcaMAtrix                
            end
        end %counter

         clearvars VLF_AS VLF_QS VLF_Aalertness VLF_Qalertness VLF_transition VLF_position VLF_Not_reliable
    end %win
    
     AnnotationMatrix(AnnotationMatrix==0)=nan; % to only have two step annotation (1 and 2) instead of three (0,1, and 2)
%      AnnotationMatrix_onlysleep_temp(AnnotationMatrix==0)=nan; % to only have two step annotation (1 and 2) instead of three (0,1, and 2)
     
  
%%%%%%%%%%%%Saving
                if saving
                    %all annotations
                    folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\';
                    if exist('AnnotationMatrix','var')==1
                     save([folder 'AnnotationMatrix'],'AnnotationMatrix');
                    end
                    %only for AS QS sleep
                    if exist('AnnotationMatrix_onlysleep','var')==1
                     save([folder 'AnnotationMatrix_onlysleep'],'AnnotationMatrix_onlysleep');
                    end
                                          
                end
          
end