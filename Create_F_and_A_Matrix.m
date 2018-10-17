%%
%THIS  M FILE CREATE FEATURE MATRICES WHERE EVERYTHING IS COMBINED
% FOR MATRICES WHERE ECG, HR, BREATHING ETC ARE SEPARATE MATRICES USE Create_single_F_and_A_Matrix_Session_and_perPatient_forDNN
%%
%This m file generates FEature and annotation Matrices. Per patient and per
%session
% Each Row is one Feature. Where each session of the same Feature


%      '	1=	ActiveSleep';...
%         '	2=	QuietSleep';...
%         '	3=	Wake';...
%         '	4=	CareTaking';...
%         '	5=	UnknownBedState'...
%           6=  Transition


%#1 How many sessions?
%     
%#2 Go through each session and load all Featrues and the annotation
%#3 Cut annotation and Feature to the same length
%#4 Save each combination as Session in multile matrices
%#5 Merge Feature Sessions together Safe them as one matrix

% Creating the data, the sliding window for the ECG produces (sometimes?
% pat5 Innerscense) differnt amount of cells. So if you chose win=30, there
% cen be a matirx mismatch. Why the window is differnt is a matter of the
% sliding window function... to tired of that sh** right now.

clear
clc
tic
dataset='InnerSense'; % ECG or cECG or MMC or InnerSense.
saving=1;
saving_for_mix=1;
win=300; % window of annotations. 30 precicse, 300 smoothed
systeminuse='c3po';

if strcmp('ECG',dataset) || strcmp('cECG',dataset)
    Pat=[4,5,6,7,9,10,11,12,13];
    datapath='cECG_study\C_Processed_Data\';
    MixNr_all=[9,10,11,12,13,14,15,16,17];
    MixNr_cECGMMC=[1,2,3,4,5,6,7,8,9];
    MixNr_cECGInSe=[9,10,11,12,13,14,15,16,17];
    if strcmp('ECG',dataset)
        if strcmp(systeminuse,'c3po')
            datapath='D:\PhD\Article_3_(cECG)\';
            safepathmix='D:\PhD\Matrix_sets\Single_Matrices\cECG' ;
        elseif strcmp(systeminuse,'Philips')
            datapath='C:\Users\310122653\Documents\PhD\Article_3_(cECG)\';
        end                    
        datapathload=[ datapath 'Processed data\'];
        datapath=[datapath 'Processed data\HRV_features\']; 
        loadfolderAnnotation= [datapathload 'Annotations\'];
%     elseif strcmp('cECG',dataset)
%         datapath='E:\cECG_study\C_Processed_Data\cHRV_features\';    
%         datapathload=datapath;
%         loadfolderAnnotation= [datapathload 'Annotations\'];
    end
    
elseif strcmp('MMC',dataset) 
    PatientID=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22]; % core. Show all patients in the folder
    Pat=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
    MixNr_all=[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39];
    MixNr_cECGMMC=[10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32];
    MixNr_InSeMMC=[9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
    
    if strcmp(systeminuse,'c3po')
        datapath='D:\PhD\Article_4_(MMC)\';
        safepathmix='D:\PhD\Matrix_sets\Single_Matrices\MMC' ;        
    elseif strcmp(systeminuse,'Philips')
        datapath='C:\Users\310122653\Documents\PhD\Article_4_(MMC)\';
    end
    datapathload=[ datapath 'Processed data\'];
    datapath=[datapath 'Processed data\HRV_features\'];
    loadfolderAnnotation= [datapathload 'Annotations\'];

elseif strcmp('InnerSense',dataset) 
    Pat=[3,4,5,6,7,9,13,15];
    MixNr_all=[1,2,3,4,5,6,7,8];
    MixNr_InSeMMC=[1,2,3,4,5,6,7,8];
    MixNr_cECGInSe=[1,2,3,4,5,6,7,8];    
    if strcmp(systeminuse,'c3po')
        datapath='D:\PhD\Article_2_(EHV)\';
        safepathmix='D:\PhD\Matrix_sets\Single_Matrices\InnerSense' ;
    elseif strcmp(systeminuse,'Philips')
        datapath='C:\Users\310122653\Documents\PhD\Article_2_(EHV)';
        safepathmix='???' ;
    end        
    datapathload=[ datapath 'Processed data\'];
    datapath=[datapath 'Processed data\HRV_features\'];
    loadfolderAnnotation= [datapathload 'Annotations\'];
end 

if  strcmp('ECG',dataset) || strcmp('MMC',dataset) || strcmp('InnerSense',dataset)
    savefolder= ([datapathload '\Matrices\']);
    savefolderSession=([datapathload '\Matrices\Sessions\']);    
    savefolderMix= ([safepathmix '\']);
    savefolderSessionMix=([safepathmix '\Sessions\']);   
elseif strcmp('cECG',dataset)==1
    savefolder= ([ datapathload '\DNN-Matrices\cMatrices'  '\']);
    savefolderSession=([ datapathload 'DNN-Matrices\cMatrices'  '\Sessions\']);    
end

TFeature_path=[datapath 'timedomain\'];
FFeature_path=[datapath 'freqdomain\'];
NLFeature_path=[datapath 'nonlinear\'];  
AWFeature_path=[datapath 'weigthAge\'];


if (exist(savefolder))==0;  mkdir([savefolder]);end
if (exist(savefolderSession))==0;  mkdir([savefolderSession]);end
if (exist(savefolderMix))==0;  mkdir([savefolderMix]);end
if (exist(savefolderSessionMix))==0;  mkdir([savefolderSessionMix]);end

   Featurenames_time={...
        'BpE';...
        'LL';...
        'aLL';...
        'NN10'; 'NN20';'NN30';'NN50';...
        'pNN10'; 'pNN20';'pNN30';'pNN50';...
        'RMSSD';...
        'SDaLL';...
        'SDANN';...
        'SDLL';...
        'SDNN';... 
        'pDEC';...
        'SDDEC';...               
        };

    Featurenames_frequency={...
        'HF';...
        'HFnorm';...
        'LF';...
        'LFnorm';...
        'ratioLFHF';...
        'sHF';...
        'sHFnorm';...
        'totpow';...
        'uHF';...
        'uHFnorm';...
        'VLF';...
        'HFR';...
        'HFnormR';...
        'LFnormR';...
        'MFR';...
        'MFnormR';...
        'ratioLFHFR';...
        'ratioMFHFR';...
        'totpowR';...   
        };

    Featurenames_nonlinear={...
        'SampEn';...
        'QSE';...
        'SEAUC';...
        'LZNN';...
        'LZECG';... 
        'LZEDR';...
%         'QSE_EDR';...
%         'SampEn_EDR';...
%         'SEAUC_EDR';...
        };
    
    Featurenames_AgeWeight={...
        'Age_diff';...
        'Birthweight';...
        'CA';...
        'GA';...
        };
    
for N=1:length(Pat)
    disp(['Working on patient ' num2str(Pat(N))])
    disp('-------------------------------')
    Neonate=Pat(N);
%     N_I=find(PatientID==Neonate); % IF we do not start with 1 we have to choose the correct index
    Annottmp=[];FeatureMatrix_tmp=[]; % renew for each session. For MMC data we stack all sessions as we mostly only have 1
   
    FeatureMatrix={};tmp={};tmp2={};tmp3={};tmp4={}; tmp5={};
    
    
    if strcmp('ECG',dataset) || strcmp('cECG',dataset)
        namefill=['_Session_*_win_' num2str(win) '_*_'  num2str(Neonate) '.mat'];
        namefillT=['_win_' num2str(win) '_*_' num2str(Neonate) '.mat'];
        namefillF=['_win_' num2str(win) '_*_' num2str(Neonate) '.mat'];
        namefillNL=['_win_' num2str(win) '_*_' num2str(Neonate) '.mat'];
        namefillAW=['_win_' num2str(win) '_*_' num2str(Neonate) '.mat'];
%         namefillAnnot1=['_win_' num2str(win) '_Intellivue_*_' num2str(Neonate) '.mat'];
        namefillAnnot1=['_pat_' num2str(Neonate) '.mat'];
        
    elseif strcmp('MMC',dataset) || strcmp('InnerSense',dataset)  
%         searchdiretory=['_Session_*_win_' num2str(win) '_'  num2str(Neonate) '.mat'];
        namefill  = ['_win_' num2str(win) '_' num2str(Neonate) '.mat'];
        namefillT = ['_win_' num2str(win) '_' num2str(Neonate) '.mat'];
        namefillF = ['_win_' num2str(win) '_' num2str(Neonate) '.mat'];
        namefillNL=['_win_' num2str(win) '_' num2str(Neonate) '.mat'];
        namefillAW=['_win_' num2str(win) '_' num2str(Neonate) '.mat']; 
        namefillAnnot2=[loadfolderAnnotation 'Annotations_win_' num2str(win) '_' num2str(Neonate) '.mat'];    
    end

%--------------- Per Patient ---------------     
%#1 How many sessions?
%#2 Go through each session and load all Featrues and the annotation
%#3 Cut annotation and Feature to the same length
%#4 Merge Feature Sessions together or safe them as session


    Sessionnames=dir([TFeature_path Featurenames_time{1,1} namefill]); 
    Sessionlength=length(cellfun('isempty',{Sessionnames.name}));
    
    if isempty(Sessionnames)
        error('Sessionlength is empty. Probably false name defenition')
    end

    for i=1:Sessionlength  
        disp(['Session ' num2str(i) '/' num2str(Sessionlength)])
        if strcmp('ECG',dataset) || strcmp('cECG',dataset)
            dateiname=dir([loadfolderAnnotation 'Annotations_Session_' num2str(i) namefillAnnot1]);
        elseif strcmp('MMC',dataset) || strcmp('InnerSense',dataset) 
            dateiname=dir(namefillAnnot2);
        end
        load([loadfolderAnnotation dateiname.name]);
        
        if (strcmp('ECG',dataset) || strcmp('cECG',dataset)) && length(Annotations)<10 % skipping one Session if it is shorter than 5min
            continue
        end
               
% all from one patient TIME DOMAIN
        for j=1:length(Featurenames_time) 
            if strcmp('ECG',dataset) || strcmp('cECG',dataset)
                dateiname=dir([TFeature_path Featurenames_time{j,1} '_Session_' num2str(i) namefillT]);
            elseif strcmp('MMC',dataset) || strcmp('InnerSense',dataset)
                dateiname=dir([TFeature_path Featurenames_time{j,1}  namefillT]);
            end
            
            load([TFeature_path dateiname.name])
            [tmp,Annotations]=Matrix_fill(Feature,dataset,Neonate,Annotations,tmp) ;
             
        end
        tmp2=[tmp2,tmp]; % Adding the long single line of Feature into the Feature Matrix, where each row is one Feature        
        tmp={};

% all from on patient FREQUENCY DOMAIN
        for j=1:length(Featurenames_frequency)
            if strcmp('ECG',dataset) || strcmp('cECG',dataset)
                dateiname=dir([FFeature_path Featurenames_frequency{j,1} '_Session_' num2str(i) namefillF]);
            elseif strcmp('MMC',dataset) || strcmp('InnerSense',dataset)
                dateiname=dir([FFeature_path Featurenames_frequency{j,1}  namefillF]);
            end            
            
            load([FFeature_path dateiname.name]);
            [tmp,Annotations]=Matrix_fill(Feature,dataset,Neonate,Annotations,tmp) ;
        end
        tmp3=[tmp3 ,tmp]; % Adding the long single line of Feature into the Feature Matrix, where each row is one Feature
        tmp={};


% all from on patient NONELINEAR    
        for j=1:length(Featurenames_nonlinear) 
            if strcmp('ECG',dataset) || strcmp('cECG',dataset)
                dateiname=dir([NLFeature_path Featurenames_nonlinear{j,1} '_Session_' num2str(i) namefillNL]);
            elseif strcmp('MMC',dataset) || strcmp('InnerSense',dataset)
                dateiname=dir([NLFeature_path Featurenames_nonlinear{j,1}  namefillNL]);
            end              
        
            load([NLFeature_path dateiname.name])
            [tmp,Annotations]=Matrix_fill(Feature,dataset,Neonate,Annotations,tmp) ;
                   
        end
        tmp4=[tmp4 ,tmp]; % Adding the long single line of Feature into the Feature Matrix, where each row is one Feature
        tmp={};
        
% all from on patient AGE domain    
        for j=1:length(Featurenames_AgeWeight) 
            if strcmp('ECG',dataset) || strcmp('cECG',dataset)
                dateiname=dir([AWFeature_path Featurenames_AgeWeight{j,1} '_Session_' num2str(i) namefillAW]);
            elseif strcmp('MMC',dataset) || strcmp('InnerSense',dataset)
                dateiname=dir([AWFeature_path Featurenames_AgeWeight{j,1}  namefillAW]);
            end              
        
            load([AWFeature_path dateiname.name])            
            [tmp,Annotations]=Matrix_fill(Feature,dataset,Neonate,Annotations,tmp);
            tmp=cellfun(@(x) x/10,tmp,'un',0); % We need to have vlaues between 0 and 1 else the z score destroys the values. So we use 0.1 - 0.4 instead of 1-4 for the age features
             
        end
        tmp5=[tmp5 ,tmp]; % Adding the long single line of Feature into the Feature Matrix, where each row is one Feature
        tmp={};       
%---------------------------------------------------------------------------

        FeatureMatrix=[tmp2; tmp3 ;tmp4; tmp5]; % Adding the long single line of Feature into the Feature Matrix, where each row is one Feature
        tmp2={};tmp3={};tmp4={}; tmp5={}; % Resetting 

        % remove total epoch if all values are nan, also in annotations to
        % not lose synch
        idxNan=cellfun(@(FeatureMatrix) all(isnan(FeatureMatrix)),FeatureMatrix);
%         [r,c]=find(isnan(cell2mat(FeatureMatrix)));
        c=any(idxNan);% find index where one cell element(any) is all nan (row before)
        FeatureMatrix(:,c)=[];
        Annotations(:,c)=[];
        clearvars c

        idxInf=cellfun(@(FeatureMatrix) all(isinf(FeatureMatrix)),FeatureMatrix);
        c=any(idxInf);% find index where one cell element(any) is all inf (row before)
        FeatureMatrix(:,c)=[];
        Annotations(:,c)=[];        
        clearvars c
        % remove all nans from each cell, as there are mostly less nans than 30s, it just
        % reduces the first epoch. Deleting nans as the standard scaler of Python cannot handle nans
%         for fm = 1:numel(FeatureMatrix)
%             FeatureMatrix{fm} = FeatureMatrix{fm}(~isnan(FeatureMatrix{fm}),:) ;            
%         end
        FMtmp=cell2mat(FeatureMatrix);
        
        
        
        %STANDARD SCALE WITH Z-SCORE
        for zs=1:size(FMtmp,1)
            FMtmp(zs,:) = zscore(FMtmp(zs,:));
        end

        %interpolate to gain same length per Feature
%         FMtmp = cell(size(FeatureMatrix));
        
%         for k = 1:numel(FeatureMatrix)
%            if numel(FeatureMatrix{k})~=1 % interpolation needs at least two values
%                N = numel(FeatureMatrix{k});
%                xo = 1:N;
%                xi = linspace(1,N,win*500);
%                FMtmp{k} = interp1(xo,FeatureMatrix{k},xi);
%            else % if only one value (e.g. detected R peak ) due to noise, just create cell with this one value in the specific length 
%                FMtmp{k}=kron(FeatureMatrix{k}, ones(1,win*500));
%            end     
%         end


            %standart scale with (x-mean)/std 
%         for F=1:size(FMtmp,1)
%             flattenedM=cell2mat(FMtmp(F,:));
%             MeanStd(F,1)=mean(flattenedM);
%             MeanStd(F,2)=std(flattenedM);            
%         end
        % Cell to 3D array ---lets do that in Keras
        % IN THE FOLLOWING LINE YOU CAN DETERMINE THE ORDER OF THE DATA.
        % KERAS NEEDS [SAMPLES, TIMESTEPS, FEATURES]
%         FMtmp=permute(reshape(FMtmp.',numel(FMtmp(1,:)),size(FMtmp,1),[]),[3,1,2]);
%         FMtmp=permute(reshape(cell2mat(FMtmp).',numel(FMtmp{1}),size(FMtmp,2),[]),[1,3,2]);

FeatureMatrix=FMtmp; 
        if saving
            Saving_Session_F(FeatureMatrix,savefolderSession, Neonate,i)
            Saving_Session_A(Annotations,savefolderSession, Neonate,i)   
            Saving_Session_F(FeatureMatrix,savefolderSessionMix, Neonate,i)
            Saving_Session_A(Annotations,savefolderSessionMix, Neonate,i)             
        end
        
        if saving_for_mix % Same Matrices but differnt numbers to have continuopuse numbers when datasets are merged
            if strcmp('MMC',dataset) || strcmp('InnerSense',dataset)
            MixNr=MixNr_InSeMMC(N);Mixpath='D:\PhD\Matrix_sets\Inner_Sence_MMC\';MixpathS='D:\PhD\Matrix_sets\Inner_Sence_MMC\Sessions\';
                Saving_Session_F(FeatureMatrix,MixpathS, MixNr,i)
                Saving_Session_A(Annotations,MixpathS, MixNr,i)
            end
            if strcmp('cECG',dataset) || strcmp('InnerSense',dataset)    
            MixNr=MixNr_cECGInSe(N);Mixpath='D:\PhD\Matrix_sets\Inner_Sense_cECG\';MixpathS='D:\PhD\Matrix_sets\Inner_Sense_cECG\Sessions\';
                Saving_Session_F(FeatureMatrix,MixpathS, MixNr,i)
                Saving_Session_A(Annotations,MixpathS, MixNr,i)
            end
            if strcmp('MMC',dataset) || strcmp('InnerSense',dataset) || strcmp('ECG',dataset)    
            MixNr=MixNr_all(N);Mixpath='D:\PhD\Matrix_sets\All\';MixpathS='D:\PhD\Matrix_sets\All\Sessions\';
                Saving_Session_F(FeatureMatrix,MixpathS, MixNr,i)
                Saving_Session_A(Annotations,MixpathS, MixNr,i)
            end
            if strcmp('MMC',dataset) || strcmp('ECG',dataset)     
            MixNr=MixNr_cECGMMC(N);Mixpath='D:\PhD\Matrix_sets\cECG_MMc\';MixpathS='D:\PhD\Matrix_sets\cECG_MMc\Sessions\';
                Saving_Session_F(FeatureMatrix,MixpathS, MixNr,i)
                Saving_Session_A(Annotations,MixpathS, MixNr,i) 
            end
        end
        
       
%         if strcmp('MMC',dataset) 
%             longestAnnotation=623;
%         end
%         
% % here zeros padd to create 1 3D tensor % NOOO DO ZERO PADDING IN PYTHON
% AS WE STILL HAVE TO BE VARIABLE HOW TO STACK AND SEPARATE THE DATA
%         if F<longestAnnotation % 623 is the longest data for the MMC data. F is the length of the Feature after removing nans
%             FeatureMatrix = padarray(FeatureMatrix,[0 623-F 0],'post') ;
%             Annotations = padarray(cell2mat(Annotations),[0 623-F],'post') ;
%         end
% 
            
            FeatureMatrix_tmp=[FeatureMatrix_tmp FeatureMatrix];
            Annottmp=[Annottmp Annotations]; % 
% 


    end % Session  
    
    Annotations=Annottmp;
    FeatureMatrix=FeatureMatrix_tmp;

    if saving
        Saving_F(FeatureMatrix,savefolder, Neonate,win)
        Saving_A(Annotations,savefolder, Neonate,win)
        Saving_F(FeatureMatrix,savefolderMix, Neonate,win)
        Saving_A(Annotations,savefolderMix, Neonate,win)        
    end
    
    if saving_for_mix % Same Matrices but differnt numbers to have continuopuse numbers when datasets are merged
        if strcmp('MMC',dataset) || strcmp('InnerSense',dataset)
        MixNr=MixNr_InSeMMC(N);Mixpath='D:\PhD\Matrix_sets\Inner_Sence_MMC\';MixpathS='D:\PhD\Matrix_sets\Inner_Sence_MMC\Sessions\';
            Saving_F(FeatureMatrix,Mixpath, MixNr,win)
            Saving_A(Annotations,Mixpath, MixNr,win)
        end
        if strcmp('ECG',dataset) || strcmp('InnerSense',dataset)    
        MixNr=MixNr_cECGInSe(N);Mixpath='D:\PhD\Matrix_sets\Inner_Sense_cECG\';MixpathS='D:\PhD\Matrix_sets\Inner_Sense_cECG\Sessions\';
            Saving_F(FeatureMatrix,Mixpath, MixNr,win)
            Saving_A(Annotations,Mixpath, MixNr,win)
        end
        if strcmp('MMC',dataset) || strcmp('InnerSense',dataset) || strcmp('ECG',dataset)    
        MixNr=MixNr_all(N);Mixpath='D:\PhD\Matrix_sets\All\';MixpathS='D:\PhD\Matrix_sets\All\Sessions\';
            Saving_F(FeatureMatrix,Mixpath, MixNr,win)
            Saving_A(Annotations,Mixpath, MixNr,win)
        end
        if strcmp('MMC',dataset) || strcmp('ECG',dataset)     
        MixNr=MixNr_cECGMMC(N);Mixpath='D:\PhD\Matrix_sets\cECG_MMc\';MixpathS='D:\PhD\Matrix_sets\cECG_MMc\Sessions\';
            Saving_F(FeatureMatrix,Mixpath, MixNr,win)
            Saving_A(Annotations,Mixpath, MixNr,win) 
        end
    end 
    
    FeatureMatrix=[];
    Annotations=[];
end
disp('* * * * * * * * * * ')
toc
%% Nested Matrixen

function [tmp,Annotations]=Matrix_fill(Feature,dataset,Neonate,Annotations,tmp)
    if iscolumn(Feature) % Need to be a row vector
        Feature=Feature';
    end
    if strcmp('MMC',dataset) && Neonate==17
        Feature=Feature(1,2:end); % as in pat 17 of the MMC data the annotations start exactly 30s after the ECG, we first cut the first cell of the feature to have the same start
    end                
    if length(Feature)>length(Annotations)
        Feature=Feature(1:length(Annotations)); % Cut the Feature to the length of the annotation. We asume that the annotations always start at the beginning but end earlier
    elseif length(Annotations)>length(Feature)
        Annotations=Annotations(1:length(Feature));
    end

    for f=1:length(Feature) 
        if iscell(Feature)==1 && isrow(Feature{1,f})
            Feature{1,f}=Feature{1,f}';
        end
    end

    if iscell(Feature)==1 % Some features are saved in cell some as double
%               tmp= {tmp; cell2mat(Feature)}; % adding each session of one feature to one single line of Feature 
        tmp= [tmp; Feature]; % adding each session of one feature to one single line of Feature 
    else
        tmp= [tmp; num2cell(Feature)]; % adding each session of one feature to one single line of Feature 
    end      
end


%% Nested saving
    function Saving_F(FeatureMatrix,savefolder, Neonate,win)
        if exist('FeatureMatrix','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_' num2str(Neonate)],'FeatureMatrix')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end
    
    function Saving_Session_F(FeatureMatrix,savefolder, Neonate,Session,win)
        if exist('FeatureMatrix','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_' num2str(Neonate) '_Session_' num2str(Session) ],'FeatureMatrix')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end
    
    function Saving_A(Annotations,savefolder, Neonate,win)
        if exist('Annotations','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_' num2str(Neonate)],'Annotations')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end    
    
    function Saving_Session_A(Annotations,savefolder, Neonate,Session)
        if exist('Annotations','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_' num2str(Neonate) '_Session_' num2str(Session) ],'Annotations')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end
    

% NameNumber={...
%         'BpE';...
%         'LL';...
%         'aLL';...
%         'NN10'; 'NN20';'NN30';'NN50';...
%         'pNN10'; 'pNN20';'pNN30';'pNN50';...
%         'RMSSD';...
%         'SDaLL';...
%         'SDANN';...
%         'SDLL';...
%         'SDNN';... 
%         'pDEC';...
%         'SDDEC';...               
%         'HF';...
%         'HFnorm';...
%         'LF';...
%         'LFnorm';...
%         'ratioLFHF';...
%         'sHF';...
%         'sHFnorm';...
%         'totpow';...
%         'uHF';...
%         'uHFnorm';...
%         'VLF';...
%         'HFR';...
%         'HFnormR';...
%         'LFnormR';...
%         'MFR';...
%         'MFnormR';...
%         'ratioLFHFR';...
%         'ratioMFHFR';...
%         'totpowR';...   
%         'SampEn';...
%         'QSE';...
%         'SEAUC';...
%         'LZNN';...
%         'LZECG';... 
%         'LZEDR';...
% %         'QSE_EDR';...
% %         'SampEn_EDR';...
% %         'SEAUC_EDR';...
%         'Age_diff';...
%         'Birthweight';...
%         'CA';...
%         'GA';...
%         };