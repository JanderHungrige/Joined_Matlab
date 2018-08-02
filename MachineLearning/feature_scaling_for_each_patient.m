%Feature scaling
%Standardization

%In machine learning, we can handle various types of data, e.g. audio 
%signals and pixel values for image data, and this data can include 
%multiple dimensions. Feature standardization makes the values of each 
%feature in the data have zero-mean (when subtracting the mean in the 
%enumerator) and unit-variance. This method is widely used for 
%normalization in many machine learning algorithms 
%(e.g., support vector machines, logistic regression, and neural networks)
%This is typically done by calculating standard scores.[1] The general 
%method of calculation is to determine the distribution mean and standard
%deviation for each feature. Next we subtract the mean from each feature. 
%Then we divide the values (mean is already subtracted) of each feature by 
%its standard deviation.

function [Matrix2]=feature_scaling_for_each_patient(saving,Neonate)
    %checking if file exist / loading
      cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\')

%     %only sleep  
%     if exist(fullfile(cd, ['feature_Matrix.mat']), 'file') == 2 % ==> 0 or 2
%         load(fullfile(cd, ['feature_Matrix.mat']))
%     end
    
    %all classes
    if exist(fullfile(cd, ['SW_feature_Matrix_patient_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['SW_feature_Matrix_patient_' num2str(Neonate) '.mat']));
    end
    Matrix=Matrix';
    Matrix=Matrix(~any(isnan(Matrix),2),:); %get rid of nans

    scaledMatrix=nan(size(Matrix));
    
    Mittelw=nanmean(Matrix,2);
    stderiv=nanstd(Matrix,0,2);
        scaledMatrix=bsxfun(@minus,Matrix,Mittelw);
        scaledMatrix=bsxfun(@rdivide,scaledMatrix,stderiv);
        
     if exist(fullfile(cd, ['AnnotationMatrix_' num2str(Neonate) '.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['AnnotationMatrix_' num2str(Neonate) '.mat']));
     end 

     AnnotationMatrix=AnnotationMatrix';
     AnnotMatrix=AnnotationMatrix(:,1);
     AnnotMatrix=AnnotMatrix(~any(isnan(AnnotMatrix),2),:); %get rid of nans
    
%%%%%%%%%%%%Saving

    if saving
        folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\';

        if exist('scaledMatrix','var')==1
         save([folder 'SW_feature_scaledMatrix_noNaN_' num2str(Neonate) ],'scaledMatrix');
        end
        if exist('AnnotMatrix','var')==1
         save([folder 'AnnotationMatrix_noNaN_' num2str(Neonate) ],'AnnotMatrix');
        end
    end
end