% This funtion creats a full annotation matrix from the 3 line annotation matrix 
% created in the function annotationMAtrix


function [AnnotMatrixfull,AnnotationMatrix_onlysleep_full]=fillAnnotMatrix(AnnotMatrix,AnnotationMatrix_onlysleep,saving)%output: row: values, colums: features
  
n=18; %numbers of features per window (SDNN SDANN RMSSD pnn(10-50 [4] nn(10-50 [4] totalpower VLF LF HF LF/HF LFratio HFratio)))
AnnotMatrixfull(1:n,:)= repmat(AnnotMatrix(1,:),[n 1]);
AnnotMatrixfull(n+1:2*n,:)= repmat(AnnotMatrix(2,:),[n 1]);
AnnotMatrixfull(2*n+1:3*n,:)= repmat(AnnotMatrix(3,:),[n 1]);

% n=18; %numbers of features per window
% AnnotationMatrix_onlysleep_full(1:n,:)= repmat(AnnotationMatrix_onlysleep(1,:),[n 1]);
% AnnotationMatrix_onlysleep_full(n+1:2*n,:)= repmat(AnnotationMatrix_onlysleep(2,:),[n 1]);
% AnnotationMatrix_onlysleep_full(2*n+1:3*n,:)= repmat(AnnotationMatrix_onlysleep(3,:),[n 1]);


%AnnotMatrixfull=AnnotMatrixfull(:,~any(isnan(AnnotMatrixfull)));% no NaN
    AnnotMatrixfull=AnnotMatrixfull'; % turn to fit it to the other matrizes
%     AnnotationMatrix_onlysleep_full=AnnotationMatrix_onlysleep_full'; % turn to fit it to the other matrizes
AnnotationMatrix_onlysleep_full=[]; %just place keeper until the only sleep is implemented

      if saving
        folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\';
        if exist('AnnotMatrix','var')==1
         save([folder 'AnnotMatrixfull'],'AnnotMatrixfull');
        end

        if exist('AnnotMatrix','var')==1
         save([folder 'AnnotationMatrix_onlysleep_full'],'AnnotationMatrix_onlysleep_full');
        end
      end
          
  
  end
