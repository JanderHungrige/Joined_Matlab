clear
clc
tic



% cd('C:\Users\310122653\Documents\GitHub\DNN\Matlab')
cd('C:\Users\C3PO\Documents\GitHub\DNN\Matlab')
CallingHRVfunctions_for_MMC
t1 = toc;save('C:\Users\C3PO\Documents\GitHub\runnallstuf','t1')

% cd('C:\Users\310122653\Documents\GitHub\InnerSence\Matlab')
cd('C:\Users\C3PO\Documents\GitHub\InnerSence\Matlab')
B_CallingHRVfunctions_for_InnerSence
t2 = toc;save('C:\Users\C3PO\Documents\GitHub\runnallstuf2','t2')

cd('C:\Users\C3PO\Documents\GitHub\cECG-Data-specific')
CallingHRVfunctions_for_cECG
 
load('C:\Users\C3PO\Documents\GitHub\runnallstuf','t1');load('C:\Users\C3PO\Documents\GitHub\runnallstuf2','t2')
cd('C:\Users\C3PO\Documents\GitHub\'); delete 'runnallstuf.mat' 'runnallstuf2.mat'

 t3 = toc;
 dur1=datestr(t1/(24*60*60),'DD:HH:MM:SS');
 dur2=datestr(t2/(24*60*60),'DD:HH:MM:SS');
 dur3=datestr(t3/(24*60*60),'DD:HH:MM:SS');


 disp('Finished' )
 disp (['Duration MMC: '  dur1]);  
 disp (['Duration InSe: ' dur2]);  
 disp (['Duration cECG: ' dur3]);