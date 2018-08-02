%Correlation based feature selcetion
%CF  Pearsons correlation between target value and feature 
%FF Pearsons correlation between features and features

% loock at:
% http://www.ime.unicamp.br/~wanderson/Artigos/correlation_based_feature_selection.pdf

%differene of corr2 corr and corrcoef
%If you want a single correlation coefficient between two matrices, then neither, see corr2.
%For two matrices, corr() returns the pairwise correlation between the columns of the two matrices if that is what you want.
%If you input two matrices into corrcoef(), it converts the matrices to column vectors first and then just computes the correlation coefficient between those two vectors.      

function [Sorted,zuordnung,CFS_value]=CFS_function(scaled,saving,Fnr,inclSDANN)
%Fnr
% 54 is with all 54 features including nnx and SDANN
% 51 is with nnx (10-30) without SDANN

% 36 is without nnx (10-30) and including SDANN
% 33 is without nnx (10-30) and without   SDANN

% 17 is only 5 min with nnx (10-30) without SDANN 
% 12 is only 5 min without nnx (10-30) including SDANN
% 11 is only 5 min without nnx (10-30) wihtout   SDANN
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
%%%%%%%%% only choose Features for specific class
Class=[1;2];
label=['AS/QS'];  % change these if you change Class so it will be correctly saved
A=AnnotationMatrix(ismember(AnnotationMatrix(:,1),Class));
A=repmat(A,1,54);
F=     scaledMatrix(ismember(AnnotationMatrix(:,1),Class),:);
Matrix=scaledMatrix(ismember(AnnotationMatrix(:,1),Class),:);
Sorted=[];  %sorted feature Matrix
CFS_value=[];  

%%%%%%%%%% CFS - greedy forward search
% Pearsons product momentum (Corrcoef, or corr)
    rff=abs(corr(F));rff(isnan(rff))=0;                    % correlation feature-feature
    rcf=abs(corr(A,F));rcf(isnan(rcf))=0;rcf=rcf(1,:);     % correlation class - feature; rows are the result of the correlation between each feature and the annotation
%initialize best feature Matrix F doing the CFS for all Features separately
    L=size(F); L=L(1,2); 
    for h=1:L % for all featues
        CFS(h,1)=rcf(1,h)/sqrt(1+2*(sum(rff(:,h))-1)); %CFS of each single feature  2:end o avoid rff_11 !!!!!diagonal 1 are still in (from forum http://stackoverflow.com/questions/29244189/which-of-these-implementation-if-any-of-the-correlation-based-feature-selectio)
%         CFS(h,1)=rcf(1,h);
    end
    
    
     [CFS_max, b] = max(abs(CFS));      % finding the maximum of CFS (When CFS is complex, the maximum is computed using the magnitude MAX(ABS(X)). In the case of equal magnitude elements, then the phase angle MAX(ANGLE(CFS)) is used.)
     CFS_value=[CFS_value; CFS_max];
     Sorted = [Sorted F(:,b)];          % fill sorted feature Matrix F with all values of 1# max feature    
     F(:,b) = [];                       % delete best feature from the inital matrix
     A(:,b) = [];                       % delete annotation of best feature from the inital annotation matrix
     round_one=1; % just a counter
    
     clearvars CFS a b

%now add all other features one by one and find the maximum from the new combination
%If new max is found. Delet feature form initial Matrix and move it to sorted
%repeate until the merrit is not increased any more
merrit_increase=1;
 
% while merrit_increase 
for u=1:Fnr-1 %if plot over all feaures use this for instead of while
    merrit_increase=0; % change to one if incease. Otherwise break one line before
    CFS_during_tryout_run=[]; 
    L=size(F); L=L(1,2);
    
    for j=1:L  
        tryoutMatrix=[Sorted,F(:,j)];
% calculate CFS max /merrit max
        rff=abs(corr(tryoutMatrix));                    % correlation feature-feature
        rcf=abs(corr(A,tryoutMatrix)); rcf=rcf(1,:);    % correlation class - feature; rows are the result of the correlation between each feature and the annotation
        rff_sum=sum(sum(triu(rff,1))); %Summation of the upper triagle of rff (no double correlations)
        rcf_sum=sum(rcf);
        
        k=size(tryoutMatrix); k=k(1,2);
               
        CFS=rcf_sum/sqrt(k+2*rff_sum); %CFS of each single feature  !!!!!diagonal 1 are still in (from forum http://stackoverflow.com/questions/29244189/which-of-these-implementation-if-any-of-the-correlation-based-feature-selectio)
        CFS_during_tryout_run=[CFS_during_tryout_run; CFS]; 
    
    end % for j
    %looking for new max merrit
       [CFS_max_tryout, b] = max(abs(CFS_during_tryout_run));  clearvars  CFS_during_tryout_run  % finding the maximum of CFS (When CFS is complex, the maximum is computed using the magnitude MAX(ABS(X)). In the case of equal magnitude elements, then the phase angle MAX(ANGLE(CFS)) is used.)
       if round_one; CFS_value_tryout=[];end;  round_one=0;% initializing variable not existing after first round         
       CFS_value_tryout=[CFS_value_tryout; CFS_max_tryout];
       
%        if CFS_max_tryout>CFS_max(end) % the last cfs max is the one to compare to
           merrit_increase=1; %continue adding new and see if the merrit increases
           CFS_max=[CFS_max,CFS_max_tryout]; % the new CFS is added to CFS max
           CFS_value=[CFS_value; CFS_max(end)];
           
           Sorted = [Sorted F(:,b)];           % fill sorted feature Matrix F with all values of 1# max feature    
            F(:,b) = [];                       % delete best feature from the inital matrix
            A(:,b) = [];                       % delete annotation of best feature from the inital annotation matrix
    
%        end
    SF=size(Sorted); SF=SF(1,2); 
 end % end while
disp(['Best subset found. Subset consist of ' num2str(SF) ' features'])
%--------------------------------------- ust adding best cfs one by one
%after best feature is found, find next 
      % here we have to correlate now not in the initial matrix but between the
      % "best" matrix and the initial matrix

%     for k=2:L %== -1 because we start from 2 and we have already one less itteration     
%         rff=abs(corr(Sorted,F));             % correlation best feature features - remaining feature
%         rcf=abs(corr(A,F));                  % correlation class - remaining features; rows are the result of the correlation between each feature and the annotation
% 
%         L=size(F); L=L(1,2);
%        for h=1:L  % for all remaining featues
%             CFS(h,1)=sum(rcf(1,:))/sqrt(k+2*(sum(rff(:,h)))); %CFS of each single feature (forum)
% 
%         end
%         [CFS_max, b] = max(abs(CFS));             % finding the maximum of CFS
%          CFS_value=[CFS_value; CFS_max];
%          Sorted = [Sorted F(:,b)];          % fill sorted feature Matrix F with all values of 1# max feature 
%          F(:,b) = [];                       % delete best feature from the inital matrix
%          A(:,b)=[];           % delete annotation of best feature from the inital annotation matrix
%          
%          clearvars CFS a b
%     end
%     
    
    %%%%%%% find which feature is where in sorted
    L=size(Sorted);L=L(1,2);
    l=size(Matrix);l=l(1,2);
    zuordnung=nan(1,L);
    for p=1:L % going through sorted features
        for i=1:l%going through Matrix
            finding=Matrix(:,i)~=Sorted(:,p);   
            if sum(finding)==0
                zuordnung(1,p)=i; % if Matrix and sorted are the same, put down the column number of Matrix
            end
        end
    end
    disp(['The features are Nr.: ', num2str(zuordnung)])
    
    %%%%%%%%%%%%Saving
%     if saving
%         folder='C:\Users\310122653\Documents\PhD\InnerSense Data\Matlab\saves\Matrizen\';
%         %saving R peaks positions in mat file
%         if (exist('zuordnung','var')==1 &&  exist('Sorted','var')==1)
%             save([folder 'CFS_sorted features_' label],'zuordnung','Sorted');
%         end
%         
%     end

end