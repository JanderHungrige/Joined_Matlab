function [totpowR,LFR,LFnormR,HFR,HFnormR,ratioLFHFR,MFR,MFnormR,ratioMFHFR]=freqdomainEDR (powerspectrum,f)



% frequency domain measures of HRV
% this functioncalculates the frequenc donain features over 30 sec epochs,
% while " freqdomain_single.m"  alculates the features over a non splittet 
% signal,ecept for the states AS,QS,...

%%%%%short term analysis (5min)
% 5min total power (<0.4 Hz) % new (<1.5 Hz)
% VLF power in very low frequency range (adult 0.003-0.04 Hz)
% LF  power in low frequency range (adult 0.04-0.15 Hz)
% LFnorm  LF power in normalized units LF/(total power-vlf)*100 or LF/(LF+HF)*100
% HF power in high frequency range (adult 0.15-0.4 Hz)
% HFnorm HF power in normalized units HF/(total power-vlf)*100 or HF/(LF+HF)*100
% LF/HF Ratio LF/HF

%%%%long term analysis (best 24h) [look at function freqdomainHRV_single]
% total power variance of all NN intervals  (<0.4 Hz)
% ULF power in ultra low frequency range (adults <0.003 Hz)
% VLF power in very low frequency range (adult 0.003-0.04 Hz)
% LF  power in low frequency range (adult 0.04-0.15 Hz)
% HF power in high frequency range (adult 0.15-0.4 Hz)
% alpha SLope linear interpolation of the spectrum in a log-log scale (<0.04 Hz)


 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
    %% total power (1.1 - 0.3 Hz)

upperboundary=1.1;
lowerboundary=0.3;

totpowR=cell(1,length(powerspectrum)); %preallocation
for i=1:length(powerspectrum)
    if isempty(powerspectrum{i,1})==0
        F=f{1,i}<upperboundary;
        F(f{1,i}<lowerboundary)=0;
        totpowR_band{1,i}=powerspectrum{i,1}(F,1);%power
    end
end
totpowR=cellfun(@sum,totpowR_band,'UniformOutput',false);
% totpowR(find([totpowR{:}] == 0))={nan};  % 0 into nan
totpowR=cell2mat(totpowR); %LAAAAAASSSSST entry

clearvars F
disp(' -totpowR calculated')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              
    %% LF  power in low frequency range (adult 0.56-0.3 Hz)
 
upperboundary=0.56;
lowerboundary=0.3;

LFR=cell(1,length(powerspectrum)); %preallocation
for i=1:length(powerspectrum)
    if isempty(powerspectrum{i,1})==0
        F=f{1,i}<upperboundary;
        F(f{1,i}<lowerboundary)=0;
        LFR_band{1,i}=powerspectrum{i,1}(F,1);%power
    end
end
LFR=cellfun(@sum,LFR_band,'UniformOutput',false);
% LFR(find([LFR{:}] == 0))={nan};  % 0 into nan

clearvars F
disp(' -LFR calculated')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% MFnorm  LF power in normalized units LF/(total power-vlf)*100 or LF/(LF+HF)*100

for i=1:length(LFR)
    LFnormR(i)=((cell2mat(LFR(1,i)))./(totpowR(1,i)))*100; % before LFnorm_AS=((cell2mat(LF_AS))./totpowAS)*100;
end

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% HF power in high frequency range (adult 1.1-0.84 Hz)
upperboundary=1.1;
lowerboundary=0.84;
HFR=cell(1,length(powerspectrum)); %preallocation
for i=1:length(powerspectrum)
    if isempty(powerspectrum{i,1})==0
        F=f{1,i}<upperboundary;
        F(f{1,i}<lowerboundary)=0;
        HF_band{1,i}=powerspectrum{i,1}(F,1);% power
    end
end
HFR=cellfun(@sum,HF_band,'UniformOutput',false);
% HFR(find([HFR{:}] == 0))={nan};  % 0 into nan

clearvars F
disp(' -HFR calculated')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% HFnorm HF power in normalized units HF/(total power-vlf)*100 or HF/(LF+HF)*100

for i=1:length(HFR)
    HFnormR(i)=(cell2mat(HFR(1,i)))./(totpowR(1,i)-cell2mat(LFR(1,i)))*100;     
end

disp(' -HFnormR calculated')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% LF/HF Ratio LF/HF 
    
ratioLFHFR=cellfun(@(LFR,HFR) (LFR)/(HFR), LFR,HFR);
ratioLFHFR(isinf(ratioLFHFR))=0;% If HF =0 we devide by 0 creating inf
disp(' -ratioLFHFR calculated')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  MF power in medium frequency range (preterm 0.84-0.56 Hz)

upperboundary=0.84;
lowerboundary=0.56;
MFR=cell(1,length(powerspectrum)); %preallocation
for i=1:length(powerspectrum)
    if isempty(powerspectrum{i,1})==0
        sF=f{1,i}<upperboundary;
        sF(f{1,i}<lowerboundary)=0;
        MFR_band{1,i}=powerspectrum{i,1}(sF,1);% power
    end
end
MFR=cellfun(@sum,MFR_band,'UniformOutput',false);
% MFR(find([MFR{:}] == 0))={nan};  % 0 into nan

clearvars F
disp(' -MFR calculated')
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% MHFnorm sHF power in normalized units HF/(total power-vlf)*100 or HF/(LF+HF)*100

for i=1:length(MFR)
    MFnormR(i)=(cell2mat(MFR(1,i)))./(totpowR(1,i)-cell2mat(LFR(1,i)))*100;     
end

disp(' -MFnormR calculated')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% MF/HF Ratio MF/HF    

ratioMFHFR=cellfun(@(MFR,HFR) (MFR)/(HFR), MFR,HFR); 
ratioMFHFR(isinf(ratioMFHFR))=0;% If HF =0 we devide by 0 creating inf
disp(' -ratioMFHFR calculated')



end
%     function Saving(Feature,savefolder, Neonate, win,Session,S)
%         if exist('Feature','var')==1
%             name=inputname(1); % variable name of function input
%             save([savefolder name '_Session_' num2str(S) '_win_' num2str(win) '_' Session],'Feature')
%         else
%             disp(['saving of ' name ' not possible'])
%         end       
%     end
