function [Annotations_win_300,Annotations_win_30]=SlidingWindow_Annotations(Annotations,Neonate,saving,savefolder,win,S,factor)  
% probelm: if the window reach the end and h is taking over. It could
% happen that e.g. the h=1 value is empty, that is skiped, but than with
% h=2 the index is subtracted 2 (h=2) which will be empty. The new value is
% therefore calculated from win and plus one empty value.
% Is that realy a problem? It could also just be fine. The value is then
% calculated by less values, still kind of correct.

% input: factor; how much is the data moving forward? 30s is classic
        
%%%%%%%%%% removing nans. Due to the RR distance calculation the first value in NAN
% if exist('RR','var') == 1
%    RR(any(isnan(RR)))=[]; %removing nans
% end
% 

%%%%%%%%%%% CREATING Annotations (5min) WINDOWS
% 300s is 5min of data
win_jumps=factor; % Annotations are on 1 second base
Fenster=win; %win=300 


m=1;
uebrig=length(Annotations);  % how many minutes are left           
for k=1:win_jumps:length(Annotations)
   if k+Fenster<length(Annotations) 
    Annotations_win_300{1,m}=Annotations(k:k+Fenster-1,1); 
   elseif k+Fenster>=length(Annotations) && win_jumps<=uebrig && k>win_jumps*(Fenster-(uebrig/win_jumps)*win_jumps)/win_jumps
%            uebrig=(k+Fenster)-length(ECG);  % how many minutes are left           
       rechts=uebrig/win_jumps;% How many epochs are still left 
       links=(Fenster-rechts*win_jumps)/win_jumps; % how many epochs do we have to atahe from the left to get a full 300s window
       Annotations_win_300{1,m}=Annotations(k-win_jumps*links:k+win_jumps*rechts,1);
   elseif k+Fenster>=length(Annotations) && win_jumps>uebrig && k>win_jumps*(Fenster-(uebrig/win_jumps)*win_jumps)/win_jumps
       rechts=uebrig/win_jumps;% How many epochs are still left 
       links=(Fenster-rechts*win_jumps)/win_jumps; % how many epochs do we have to atahe from the left to get a full 300s window
       Annotations_win_300{1,m}=Annotations(k-win_jumps*links:end,1);       
   else         
       Annotations_win_300{1,m}=Annotations(k:end,1);
%            break       % if you want to end with the same length for the clast cell elementas the others use break. But than the ECG_win_300 is one element shorter thatn ECG_win_30    
   end
   m=m+1;
   uebrig=length(Annotations)-(k+win_jumps);  % how many minutes are left              
end


%%%%%%%%%%% CREATING Annotations (30s) WINDOWS
win_jumps=factor;
Fenster=30;
if factor==1
    Annotations_win_30=num2cell(Annotations');
else
    m=1;
    for k=1:win_jumps:length(Annotations)
       if k+Fenster<length(Annotations) 
        Annotations_win_30{1,m}=Annotations(k:k+Fenster-1,1);
       elseif k+Fenster>=length(Annotations) 
           Annotations_win_30{1,m}=Annotations(k:end,1);
           break
       end
       m=m+1;
    end
end

%%%%%%%%%%% Creating one annotation per 5 min window
for L=1:length(Annotations_win_300)
    [a,b]=hist(Annotations_win_300{1,L},[1,2,3,4,5,6]); %61,62,63,64,65]);
    [N,idx]=max(a);
    Annotations_win_300{1,L}=idx;
end

Annotations=Annotations_win_300;
if saving
    Saving(Annotations,savefolder, Neonate, win,S)
end
Annotations=[];
%%%%%%%%%%% Creating one annotation per 30s window
if factor~=1
    for L=1:length(Annotations_win_30)
        [a,b]=hist(Annotations_win_30{1,L},[1,2,3,4,5,6]); %61,62,63,64,65]);
        [N,idx]=max(a);
        Annotations_win_30{1,L}=idx;
    end
end

Annotations=Annotations_win_30;

if saving
    Saving(Annotations,savefolder, Neonate, 30,S)
end
Annotations=[];
%AS=1; QS=2; Wake=3; CareTaking=4; UnknownBedState=5; Transition 61-65

end

%% Nested saving
    function Saving(Annotations,savefolder, Neonate,win,S)
        if exist('Annotations','var')==1
            name=inputname(1); % variable name of function input
            save([savefolder name '_Session_' num2str(S) '_pat_' num2str(Neonate)],'Annotations')
        else
            disp(['saving of ' name ' not possible'])
        end       
    end

