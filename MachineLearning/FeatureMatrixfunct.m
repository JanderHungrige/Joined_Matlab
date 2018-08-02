    % this function will create the input feature matrix for principal
% component analysis
%Thereby, the n by m matrix will have the fearture values as collums (x)and
%the features as rows (y)
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%THIS M FILE INCLUDES ALL CLASSES, AS QS WAKE IS ...
%WHILE pcaMatrix.m ONLY INCLUDES AS AND QS
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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



function [Matrix]=FeatureMatrixfunct(Neonate,win,Matrix,saving,counter,inclSDANN)


    for j=1:length(win)
        Neonate
        win(1,j) %marker
        
 %making the features known for the matrix, even when they do not exist to prevent error       
        totpowAS=[];totpowQS=[];totpowAalertness=[]; totpowQalertness=[]; totpowtransition=[]; totpowposition=[]; totpowNot_reliable=[];VLF_AS=[];
        VLF_QS{1}=[]; VLF_Aalertness{1}=[];VLF_Qalertness{1}=[];VLF_transition{1}=[];VLF_position{1}=[];VLF_Not_reliable{1}=[]; 
        LF_AS{1}=[];LF_QS{1}=[];LF_Aalertness{1}=[];LF_Qalertness{1}=[];LF_transition{1}=[];LF_position{1}=[];LF_Not_reliable{1}=[];
        LFnorm_AS=[];LFnorm_QS=[];LFnorm_Aalertness=[];LFnorm_Qalertness=[];LFnorm_transition=[];LFnorm_position=[];LFnorm_Not_reliable=[];
        HF_AS{1}=[];HF_QS{1}=[];HF_Aalertness{1}=[];HF_Qalertness{1}=[];HF_transition{1}=[];HF_position{1}=[];HF_Not_reliable{1}=[];
        HFnorm_AS=[];HFnorm_QS=[];HFnorm_Aalertness=[];HFnorm_Qalertness=[];HFnorm_transition=[];HFnorm_position=[];HFnorm_Not_reliable=[];
        ratioLFHF_AS=[];ratioLFHF_QS=[];ratioLFHF_Aalertness=[];ratioLFHF_Qalertness=[];ratioLFHF_transition=[];ratioLFHF_position=[];ratioLFHF_Not_reliable=[];
        SDNN_AS{1}=[];SDNN_QS{1}=[];SDNN_Aalertness{1}=[];SDNN_Qalertness{1}=[];SDNN_transition{1}=[];SDNN_position{1}=[];SDNN_Not_reliable{1}=[];
        SDANN_AS=[];SDANN_QS=[];SDANN_Aalertness=[];SDANN_Qalertness=[];SDANN_transition=[];SDANN_position=[];SDANN_Not_reliable=[];
        RMSSD_AS{1}=[];RMSSD_QS{1}=[];RMSSD_Aalertness{1}=[];RMSSD_Qalertness{1}=[];RMSSD_transition{1}=[];RMSSD_position{1}=[];RMSSD_Not_reliable{1}=[];
        NN10_AS=[];NN10_QS=[];NN10_Aalertness=[];NN10_Qalertness=[];NN10_transition=[];NN10_position=[];NN10_Not_reliable=[];
        NN20_AS=[];NN20_QS=[];NN20_Aalertness=[];NN20_Qalertness=[];NN20_transition=[];NN20_position=[];NN20_Not_reliable=[];
        NN30_AS=[];NN30_QS=[];NN30_Aalertness=[];NN30_Qalertness=[];NN30_transition=[];NN30_position=[];NN30_Not_reliable=[];
        NN50_AS=[];NN50_QS=[];NN50_Aalertness=[];NN50_Qalertness=[];NN50_transition=[];NN50_position=[];NN50_Not_reliable=[];
        pNN10_AS=[];pNN10_QS=[];pNN10_Aalertness=[];pNN10_Qalertness=[];pNN10_transition=[];pNN10_position=[];pNN10_Not_reliable=[];
        pNN20_AS=[];pNN20_QS=[];pNN20_Aalertness=[];pNN20_Qalertness=[];pNN20_transition=[];pNN20_position=[];pNN20_Not_reliable=[];
        pNN30_AS=[];pNN30_QS=[];pNN30_Aalertness=[];pNN30_Qalertness=[];pNN30_transition=[];pNN30_position=[];pNN30_Not_reliable=[];
        pNN50_AS=[];pNN50_QS=[];pNN50_Aalertness=[];pNN50_Qalertness=[];pNN50_transition=[];pNN50_position=[];pNN50_Not_reliable=[];
       
  %checking if file exist / loading
          cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\HRV features\')
          % all feature names for each class
      filenames={'totpower_','totpowerWake_','totpowertransition_','totpowposition_','totpowNot_reliable_',...
                 'VLF_','VLFWake_','VLFtransition_','VLFposition_', 'VLFNot_reliable_',...
                 'LF_','LFWake_','LFtransition_','LFposition_','LF_Not_reliable_',...
                 'LFnorm_','LFnormWake_','LFnormtransition_','LFnormposition_' ,'LFnormNot_reliable_',...
                 'HF_','HFWake_','HFtransition_','HFposition_','HFNot_reliable_',...
                 'HFnorm_','HFnormWake_','HFnormtransition_','HFnormposition_','HFnorm_Not_reliable_',...
                 'ratioLFHF_' ,'ratioLFHFWake_','ratioLFHFtransition_','ratioLFHFtransition_','ratioLFHF_position_','ratioLFHF_Not_reliable_',...
                 'SDNN_','SDNN_Wake_','SDNN_transition_','SDNN_position_','SDNN_Not_reliable_',...
                 'SDANN_','SDANN_Wake_','SDANN_transition_','SDANN_position_','SDANN_Not_reliable_',...
                 'RMSSD_','RMSSD_Wake_','RMSSD_transition_','RMSSD_position_','RMSSD_Not_reliable_',...
                 'NNx_','NNx_Wake_','NNx_transition_','NNx_position_','NNx_Not_reliable_',...
                 'pNNx_','pNNx_Wake_','pNNx_transition_','pNNx_position_','pNNx_Not_reliable_' ...
                };    
   % loading the files         
    for p=1:length(filenames)
       if exist(fullfile(cd, [filenames{p} num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, [filenames{p} num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end
    end

    % Cell to mat  
    VLF_AS= cell2mat(VLF_AS); VLF_QS=cell2mat(VLF_QS); VLF_Aalertness=cell2mat(VLF_Aalertness);VLF_Qalertness=cell2mat(VLF_Qalertness);VLF_transition=cell2mat(VLF_transition);VLF_position=cell2mat(VLF_position);VLF_Not_reliable=cell2mat(VLF_Not_reliable); 
    LF_AS=cell2mat(LF_AS); LF_QS=cell2mat(LF_QS);LF_Aalertness=cell2mat(LF_Aalertness);LF_Qalertness=cell2mat(LF_Qalertness);LF_transition=cell2mat(LF_transition);LF_position=cell2mat(LF_position);LF_Not_reliable=cell2mat(LF_Not_reliable);
    HF_AS=cell2mat(HF_AS); HF_QS=cell2mat(HF_QS); HF_Aalertness=cell2mat(HF_Aalertness);HF_Qalertness=cell2mat(HF_Qalertness);HF_transition=cell2mat(HF_transition);HF_position=cell2mat(HF_position);HF_Not_reliable=cell2mat(HF_Not_reliable);  
    SDNN_AS=cell2mat(SDNN_AS); SDNN_QS=cell2mat(SDNN_QS);SDNN_Aalertness=cell2mat(SDNN_Aalertness);SDNN_Qalertness=cell2mat(SDNN_Qalertness);SDNN_transition=cell2mat(SDNN_transition);SDNN_position=cell2mat(SDNN_position);SDNN_Not_reliable=cell2mat(SDNN_Not_reliable);
    RMSSD_AS=cell2mat(RMSSD_AS); RMSSD_QS=cell2mat(RMSSD_QS);RMSSD_Aalertness=cell2mat(RMSSD_Aalertness);RMSSD_Qalertness=cell2mat(RMSSD_Qalertness);RMSSD_transition=cell2mat(RMSSD_transition);RMSSD_position=cell2mat(RMSSD_position);RMSSD_Not_reliable=cell2mat(RMSSD_Not_reliable);

    
    featureValues=[totpowAS,totpowQS,totpowAalertness, totpowQalertness,totpowtransition,totpowposition, totpowNot_reliable;...
                            VLF_AS,VLF_QS, VLF_Aalertness,VLF_Qalertness,VLF_transition,VLF_position,VLF_Not_reliable; ...
                            LF_AS,LF_QS,LF_Aalertness,LF_Qalertness,LF_transition,LF_position,LF_Not_reliable;...
                            LFnorm_AS,LFnorm_QS,LFnorm_Aalertness,LFnorm_Qalertness,LFnorm_transition,LFnorm_position,LFnorm_Not_reliable;...
                            HF_AS,HF_QS,HF_Aalertness,HF_Qalertness,HF_transition,HF_position,HF_Not_reliable;...
                            HFnorm_AS,HFnorm_QS,HFnorm_Aalertness,HFnorm_Qalertness,HFnorm_transition,HFnorm_position,HFnorm_Not_reliable;...                            
                            ratioLFHF_AS,ratioLFHF_QS,ratioLFHF_Aalertness,ratioLFHF_Qalertness,ratioLFHF_transition,ratioLFHF_position,ratioLFHF_Not_reliable;...
                            SDNN_AS,SDNN_QS,SDNN_Aalertness,SDNN_Qalertness,SDNN_transition,SDNN_position,SDNN_Not_reliable;...
                            SDANN_AS,SDANN_QS,SDANN_Aalertness,SDANN_Qalertness,SDANN_transition,SDANN_position,SDANN_Not_reliable;...
                            RMSSD_AS,RMSSD_QS,RMSSD_Aalertness,RMSSD_Qalertness,RMSSD_transition,RMSSD_position,RMSSD_Not_reliable;...
                            NN10_AS,NN10_QS,NN10_Aalertness,NN10_Qalertness,NN10_transition,NN10_position,NN10_Not_reliable;...
                            NN20_AS,NN20_QS,NN20_Aalertness,NN20_Qalertness,NN20_transition,NN20_position,NN20_Not_reliable;...
                            NN30_AS,NN30_QS,NN30_Aalertness,NN30_Qalertness,NN30_transition,NN30_position,NN30_Not_reliable;...
                            NN50_AS,NN50_QS,NN50_Aalertness,NN50_Qalertness,NN50_transition,NN50_position,NN50_Not_reliable;...
                            pNN10_AS,pNN10_QS,pNN10_Aalertness,pNN10_Qalertness,pNN10_transition,pNN10_position,pNN10_Not_reliable;...
                            pNN20_AS,pNN20_QS,pNN20_Aalertness,pNN20_Qalertness,pNN20_transition,pNN20_position,pNN20_Not_reliable;...
                            pNN30_AS,pNN30_QS,pNN30_Aalertness,pNN30_Qalertness,pNN30_transition,pNN30_position,pNN30_Not_reliable;...
                            pNN50_AS,pNN50_QS,pNN50_Aalertness,pNN50_Qalertness,pNN50_transition,pNN50_position,pNN50_Not_reliable;...
                            ];

%                        totpow      %1 19 37
%                        VLF         %2 20 38
%                        LF          %3 21 39
%                        LFnorm      %4 22 40
%                        HF          %5 23 41
%                        HFnorm      %6 24 42
%                        ratioLFHF   %7 25 43
%                        SDNN        %8 26 44
%                        SDANN       %9 27 45
%                        RMSSD       %10 28 46
%                        NN10        %11 29 47
%                        NN20        %12 30 48
%                        NN30        %13 31 49
%                        NN50        %14 32 50
%                        pNN10       %15 33 51
%                        pNN20       %16 34 52
%                        pNN30       %17 35 53
%                        pNN50       %18 36 54
%%%%%% Matrix combining classes values for each feature (differnt win [j] is new feature) for all patients
        L=size(Matrix);
        L=L(1,1);
        if j==2 %in the first loop of win the amount of features is determined to add to L
            Lf=L;
        end
%%%%% first itteration, no Matrix created yet 
%%%% FIRST PATIENT
        if counter==1 %create the matrix new only for the first time (when Matrix=[], therefore L=0) All the other times just add the new data at the end
            if j==1 
                %create Matrix
                  Matrix= featureValues;
%%%%% Adding features of window 180, 300 to features of window 60                   
            else
                %Add new "win" features to the matrix per win loop (j~=1)
                Matrix(L+1:L+Lf,:)=featureValues;
            end
            
%%%%% NEW PATIENT            
                %Add values of other patients to Matrix (counter ~=1)
        else % for the next patients    
            if j>=2 % for win after j=1 calculate L; Matrixtemp is not know yet, therfore  in this if clause
            L=size(Matrixtemp);
            L=L(1,1);
            end
            
            if j==2 %in the first loop of win the amount of features is determined to add to L
                Lf=L; %fix Lf at the amount of features 
            end
%%%% first itteration            
            if j==1 
                %create Matrix
                Matrixtemp=featureValues;
%%%%% Adding features of window 180, 300 to features of window 60                     
            else
                %Add new "win" features to the matrix per win loop (j~=1)
                Matrixtemp(L+1:L+Lf,:)=featureValues;
            end
%%%%% Merging The Matrixes of patient 1 and 2, 3, ... to one
            if j==length(win) %when all windows loops through the win are finished...
                Matrix=[Matrix,Matrixtemp];%...combine the temporary matrix with the Matrix
            end
        end 

        %%%%%%halbwegs funktionierende struct

        % %           FeatureMatrix
        % %       if exist('totpowAS','var')  
        % %         eval([' (',num2str(Neonate) ',1 ).Patient_', num2str(Neonate) '.win_',num2str(win(1,j)) '.totpower_ASQS {1,1} ','= totpowAS'])
        % %       end
        % % %         if exist('totpowQS','var')  
        % % %           eval(['FeatureMatrix.Patient_', num2str(Neonate) '.win_',num2str(win(1,j)) '.totpower_ASQS {1,2} ','= totpowQS'])
        % % % 
        % % %         end
       clearvars -except Neonate win Matrix saving counter j L Lf Matrixtemp inclSDANN
    end %win
    clearvars   Matrixtemp 
%%%%%%%%Turning Matrix, that rows are values and collums are features
if counter==10000 %loop reached last round
Matrix=Matrix';
end
%%% Delete SDANN %%%
% if inclSDANN ==0
%     Matrix(:,[9,27,45])=[];
% end
    %%%%%%%%%%%%Saving
    if saving
        folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\';
        %saving R peaks positions in mat file
        if exist('Matrix','var')==1
         save([folder 'SW_feature_Matrix'],'Matrix');
        end
    end

end