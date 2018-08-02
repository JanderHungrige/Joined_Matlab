function [Matrix_5,AnnotationMatrix]=create5minonlyMatrix(Neonate,saving)

    cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\')
%%%%%%%%%% LOADING FEATURES AND ANNOTATIONS
    if exist([cd '\AnnotationMatrix_' num2str(Neonate) '.mat'], 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['AnnotationMatrix_' num2str(Neonate) '.mat'])) ;
    end  

    if exist([cd '\SW_feature_Matrix_patient_' num2str(Neonate) '.mat'],'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['SW_feature_Matrix_patient_' num2str(Neonate)]))
    end
%%%%%%%%%% DELETING NANS IN MATIRX AND ANNOTATIONS SYMULTANIOUSLY  
    Matrix=Matrix'; % Why auch ever, to find all NaNs te matrix has to be this way.
    AnnotationMatrix=AnnotationMatrix';
    [r,c]=find(isnan(Matrix));
    Matrix(r,:)=[]; AnnotationMatrix(r,:)=[]; clearvars r c
    Matrix=Matrix'; % Why auch ever, to find all NaNs te matrix has to be this way.
    AnnotationMatrix=AnnotationMatrix';    
%%%%%%%%%% DELETE SDANN 
    Matrix([9,27,45],:)=[];
    
%%%%%%%%%% REDUCE MATRIX TO ONLY 5 MIN FEATURES
    Matrix=Matrix(end-16:end,:);
    
%%%%%%%%%% RENAMING MATRIX FOR PYTHON    
    Matrix_5=Matrix; % InPython we call matrix, not MAtrix_5. Avoiding errors.

%%%%%%%%%%%% SAVING
           if saving
             folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\';
             if exist('Matrix','var')==1
              save([folder 'SW_5min_feature_Matrix_patient_' num2str(Neonate)],'Matrix');
              save([folder 'SW_5min_annotation_Matrix_patient_' num2str(Neonate)],'AnnotationMatrix');
             end
           end
%%%%%%%%%%%% Going back to matlab folder           
    folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\MachineLearning';
    cd(folder)
end