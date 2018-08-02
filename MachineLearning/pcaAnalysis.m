%coeff = pca(X) returns the principal component coefficients, 
%also known as loadings, for the n-by-p data matrix X. 
%Rows of X correspond to observations and columns correspond to variables.
%The coefficient matrix is p-by-p. Each column of coeff contains 
%coefficients for one principal component, and the columns are in 
%descending order of component variance. By default, pca centers the data 
%and uses the singular value decomposition (SVD) algorithm

function [coeff,score,latent,tsquared,explained,Matrix]=pcaAnalysis
    %checking if file exist / loading
      cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\')

%%%%%% unscaled      
    if exist(fullfile(cd, ['SW_feature_Matrix.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['SW_feature_Matrix.mat']))
    end
    
  
%     Matrix(Matrix==0)=nan; % PROBLEM 8 25 and 42 are 0 at some point???
%     Matrix=Matrix(:,~any(isnan(Matrix)));% pca allows no NaN
    Matrix=Matrix';
    Matrix=Matrix(~any(isnan(Matrix),2),:);% pca allows no NaN
    
%     [coeff,score,latent,tsquared,explained,mu] = pca(Matrix); %latent=variance

%%%%%% scaled    
    if exist(fullfile(cd, ['SW_feature_scaledMatrix.mat']), 'file') == 2 % ==> 0 or 2
        load(fullfile(cd, ['SW_feature_scaledMatrix.mat']))
    end
    
    scaledMatrix=scaledMatrix';
    scaledMatrix=scaledMatrix(~any(isnan(scaledMatrix),2),:);% pca allows no NaN
%     scaledMatrix(scaledMatrix==0)=nan; % PROBLEM 8 25 and 42 are 0 at some point???
%     scaledMatrix=scaledMatrix(:,~any(isnan(scaledMatrix)));
%     scaledMatrix=scaledMatrix';
    
    [coeff,score,latent,tsquared,explained,mu] = pca(scaledMatrix); %latent=variance


end