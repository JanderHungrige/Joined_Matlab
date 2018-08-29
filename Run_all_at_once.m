clear
clc
tic


cd('C:\Users\310122653\Documents\GitHub\DNN\Matlab')
CallingHRVfunctions_for_MMC

 t1 = toc;
 dur=datestr(t1/(24*60*60),'DD:HH:MM:SS');
 disp('half time' )
 disp (['Duration: ' dur]);  
 disp('--------------------------------')

cd('C:\Users\310122653\Documents\GitHub\InnerSence\Matlab')
B_CallingHRVfunctions_for_InnerSence


 t2 = toc;
 dur1=datestr(t1/(24*60*60),'DD:HH:MM:SS');
 dur2=datestr(t2/(24*60*60),'DD:HH:MM:SS');

 disp('Finished' )
 disp (['Duration 1: ' dur1]);  
 disp (['Duration 2: ' dur2]);