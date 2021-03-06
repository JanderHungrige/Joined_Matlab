function pDEC=pDec_F(RR) 
%Input
% RR: 5min RR distance data
% Neonate: Which patient
% saving: If saving is whished
% savefolder: Where to save
% win: Duration of the HRV window. Comon is 5min/300s

for i=1:length(RR)
    if all(isnan(RR{i,1}))
        pDEC{1,i}=nan;
        continue
    end
    pDEC{1,i}=sum(RR{i,1}>nanmean(RR{i,1}))/numel(RR{i,1})*100;
end
    

%%%%%%%%%%%%replace [] with nan
ix=cellfun(@isempty,pDEC);
pDEC(ix)={0};  
end
            
%%%%%%%%%%%% SAVING            
% if saving                     %saving R peaks positions in mat file                 
%     Saving(pDEC,savefolder,Neonate,win,Session,S) 
% end% end if saving 
% 
%     
%   
% end
% 
% %% Nested saving
%     function Saving(Feature,savefolder, Neonate, win,Session,S)
%         if exist('Feature','var')==1
%             name=inputname(1); % variable name of function input
%             save([savefolder name '_Session_' num2str(S) '_win_' num2str(win) '_' Session],'Feature')
%         else
%             disp(['saving of ' name ' not possible'])
%         end       
%     end
%  
 
 

