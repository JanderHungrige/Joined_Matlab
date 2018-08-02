% this function will create the input feature matrix for principal
% component analysis
%Thereby, the n by m matrix will have the fearture values as collums (x)and
%the features as rows (y)

%FeatureMatrix.m INCLUDES ALL CLASSES. tHIS M FILE ONLY INCLUDES AS QND QS
%AnnotationMatrix.m BELONGS TO THIS *.m FILE ONLY FOR AS QS

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



function [Matrix]=pcaMatrix(Neonate,win,Matrix,saving,counter)


    for j=1:length(win)
  %checking if file exist / loading
          cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\HRV features\')
          
      if exist(fullfile(cd, ['totpower_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['totpower_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end
      if exist(fullfile(cd, ['VLF_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['VLF_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end
      if exist(fullfile(cd, ['LF_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['LF_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end  
      if exist(fullfile(cd, ['LFnorm_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['LFnorm_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end 
      if exist(fullfile(cd, ['HF_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['HF_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end
      if exist(fullfile(cd, ['HFnorm_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['HFnorm_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end
      if exist(fullfile(cd, ['ratioLFHF_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['ratioLFHF_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end
      
      if exist(fullfile(cd, ['SDNN_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['SDNN_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end
      if exist(fullfile(cd, ['SDANN_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['SDANN_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end
      if exist(fullfile(cd, ['RMSSD_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['RMSSD_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end
      if exist(fullfile(cd, ['NNx_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['NNx_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end
      if exist(fullfile(cd, ['pNNx_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['pNNx_' num2str(Neonate) '_win_' num2str(win(1,j)) '.mat']));
      end
      
 % test if AS and QS exist. 
   if exist('VLF_QS','var') & exist('VLF_AS','var')     
       
    % Cell to mat  
    VLF_AS= cell2mat(VLF_AS); VLF_QS=cell2mat(VLF_QS);
    LF_AS= cell2mat(LF_AS); LF_QS=cell2mat(LF_QS);
    HF_AS= cell2mat(HF_AS); HF_QS=cell2mat(HF_QS);

    
    SDNN_AS= cell2mat(SDNN_AS); SDNN_QS=cell2mat(SDNN_QS);
    RMSSD_AS= cell2mat(RMSSD_AS); RMSSD_QS=cell2mat(RMSSD_QS);


%%%%%%Matrix combining AS and QS values for each feature (differnt win [j] is new feature) for all patients
        L=size(Matrix);
        L=L(1,1);
        if j==2 %in the first loop of win the amount of features is determined to add to L
            Lf=L;
        end
        if counter==1 %create the matrix new only for the first time (when Matrix=[], therefore L=0) All the other times just add the new data at the end
            if j==1 
                %create Matrix
                 Matrix=[totpowAS,totpowQS;...      %1 19 37
                      VLF_AS,VLF_QS;...             %2 20 38
                       LF_AS, LF_QS;...             %3 21 39
                       LFnorm_AS,LFnorm_QS;...      %4 22 40
                       HF_AS, HF_QS;...             %5 23 41
                       HFnorm_AS,HFnorm_QS;...      %6 24 42
                       ratioLFHF_AS,ratioLFHF_QS;...%7 25 43
                       SDNN_AS,SDNN_QS;...          %8 26 44
                       SDANN_AS,SDANN_QS;...        %9 27 45
                       RMSSD_AS,RMSSD_QS;...        %10 28 46
                       NN10_AS,NN10_QS;...          %11 29 47
                       NN20_AS,NN20_QS;...          %12 30 48
                       NN30_AS,NN30_QS;...          %13 31 49
                       NN50_AS,NN50_QS;...          %14 32 50
                       pNN50_AS,pNN50_QS;...        %15 33 51
                       pNN10_AS,pNN10_QS;...        %16 34 52
                       pNN20_AS,pNN20_QS;...        %17 35 53
                       pNN30_AS,pNN30_QS;...        %18 36 54
                   
                       
                      ];
            else
                %Add new "win" features to the matrix per win loop (j~=1)
                Matrix(L+1:L+Lf,:)=[totpowAS,totpowQS;...
                      VLF_AS,VLF_QS;...
                       LF_AS, LF_QS;...
                       LFnorm_AS, LFnorm_QS;...
                       HF_AS, HF_QS;...
                       HFnorm_AS,HFnorm_QS;...
                       ratioLFHF_AS,ratioLFHF_QS;...
                       SDNN_AS,SDNN_QS;...
                       SDANN_AS,SDANN_QS;...
                       RMSSD_AS,RMSSD_QS;...
                       NN10_AS,NN10_QS;...
                       NN20_AS,NN20_QS;...
                       NN30_AS,NN30_QS;...
                       NN50_AS, NN50_QS;...
                       pNN50_AS,pNN50_QS;...
                       pNN10_AS,pNN10_QS;...
                       pNN20_AS,pNN20_QS;...
                       pNN30_AS,pNN30_QS;...
                       
                      ];

            end
                %Add values of other patients to Matrix
        else % for the next patients
            
            if j>=2 % for win after j=1 calculate L; Matrixtemp is not know yet, therfore  in this if clause
            L=size(Matrixtemp);
            L=L(1,1);
            end
       
            if j==2 %in the first loop of win the amount of features is determined to add to L
                Lf=L; %fix Lf at the amount of features 
            end
            
             if j==1 
                    %create Matrix
                     Matrixtemp=[totpowAS,totpowQS;...
                      VLF_AS,VLF_QS;...
                       LF_AS, LF_QS;...
                       LFnorm_AS,LFnorm_QS;...
                       HF_AS, HF_QS;...
                       HFnorm_AS,HFnorm_QS;...
                       ratioLFHF_AS,ratioLFHF_QS;...
                       SDNN_AS,SDNN_QS;...
                       SDANN_AS,SDANN_QS;...
                       RMSSD_AS,RMSSD_QS;...
                       NN10_AS,NN10_QS;...
                       NN20_AS,NN20_QS;...
                       NN30_AS,NN30_QS;...
                       NN50_AS,NN50_QS;...
                       pNN50_AS,pNN50_QS;...
                       pNN10_AS,pNN10_QS;...
                       pNN20_AS,pNN20_QS;...
                       pNN30_AS,pNN30_QS;...
                       
                      ];
                else
                    %Add new "win" features to the matrix per win loop (j~=1)
                    Matrixtemp(L+1:L+Lf,:)=[totpowAS,totpowQS;...
                      VLF_AS,VLF_QS;...
                       LF_AS, LF_QS;...
                       LFnorm_AS,LFnorm_QS;...
                       HF_AS, HF_QS;...
                       HFnorm_AS,HFnorm_QS;...
                       ratioLFHF_AS,ratioLFHF_QS;...
                       SDNN_AS,SDNN_QS;...
                       SDANN_AS,SDANN_QS;...
                       RMSSD_AS,RMSSD_QS;...
                       NN10_AS,NN10_QS;...
                       NN20_AS,NN20_QS;...
                       NN30_AS,NN30_QS;...
                       NN50_AS,NN50_QS;...
                       pNN50_AS,pNN50_QS;...
                       pNN10_AS,pNN10_QS;...
                       pNN20_AS,pNN20_QS;...
                       pNN30_AS,pNN30_QS;...
                       
                      ];

                end

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




                  clearvars totpowAS totpowQS
    end%if exist AS QS

          
    end %win
    
%%%%%%%%Truning Matrix that rows are values and collums are features
if counter==10000 %loop reached last round
Matrix=Matrix';
end

    %%%%%%%%%%%%Saving
   
     

           if saving
                    folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\';
                    %saving R peaks positions in mat file
                    if exist('Matrix','var')==1
                     save([folder 'feature_Matrix'],'Matrix');
                     end
                end

end