function callingFisher
tic
% A=FISHER(H) returns a fisher object initialized with hyperparameters H. 
%
% Calculates a Fisher/Correlation score for each feature to implement
%  feature selection.
% Hyperparameters, and their defaults
%  feat=[]              -- number of features
%  output_rank=1        -- set to 1 if only the feature ranking matters
%                          (does not perform any classification on the data)
%                          otherwise performs classification using
%                          weights given by individual correlation scores
%  method=2             -- useful only for multi-class. Set the how to combine
%                          the score of different one-vs-rest fisher's score. 
%                          (2 = take the sum, 1 = take the max)
% Model
%  w                    -- the weights
%  b0                   -- the threshold (when using all features)
%  rank                 -- the ranking of the features
%  d                    -- training set
%
% Methods:
%  train, test, get_w 
%
% Example:
 a=fisher;
tic
cd('C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\')

if exist(fullfile(cd, ['PCA_Matrix.mat']), 'file') == 2 % ==> 0 or 2
load(fullfile(cd, ['PCA_Matrix.mat']))
end

if exist(fullfile(cd, ['AnnotationMatrix.mat']), 'file') == 2 % ==> 0 or 2
load(fullfile(cd, ['AnnotationMatrix.mat']))
end

%%%%%%%%%%%% preparing the annotationMatrix to fit Corrcoef
n=17; %numbers of features per window
annotations(1:n,:)= repmat(AnnotationMatrix(1,:),[n 1]);
annotations(n+1:2*n,:)= repmat(AnnotationMatrix(2,:),[n 1]);
annotations(2*n+1:3*n,:)= repmat(AnnotationMatrix(3,:),[n 1]);

d=data(Matrix,annotations) ;

a.feat=51; a.output_rank=1;[r,a]=train(a,d);
a.rank ; % - lists the chosen features in  order of importance
%


cd('search-ms:displayname=Search%20Results%20in%20spider&crumb=location:C%3A%5CUsers%5C310122653%5CDocuments%5CMATLAB%5Cspider%5Cspider\@fisher')
A=FISHER(a);
toc

end