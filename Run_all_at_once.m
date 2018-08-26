clear
clc
tic


cd('C:\Users\310122653\Documents\GitHub\DNN\Matlab')
CallingHRVfunctions_for_MMC

cd('C:\Users\310122653\Documents\GitHub\InnerSence\Matlab')
B_CallingHRVfunctions_for_InnerSence


 t1 = toc;
 dur=datestr(t1/(24*60*60),'DD:HH:MM:SS');
 disp('Finished' )
 disp (['Duration: ' dur]);  
