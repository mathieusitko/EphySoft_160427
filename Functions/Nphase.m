clear
clc
close all

load('Data\testDataPAC')

channel=input('channel number? use quotes ');
% freqband=[2 5];
freqband=[3 7;8 12;12 25;50 62;70 90];
% freqband = [55 65];
interval=input('time interval for analysis ? use quotes ');
LFP=eval(['AD' channel;]);
phaseM=zeros(size(freqband,1),length(LFP));

for i=1:size(freqband,1)
H=freqband(i,1)*0.002;
[h1,h2] = butter(5,H,'high');
fLFP= filtfilt(h1,h2,LFP);
if i==1
    figure;plot(fLFP,'b');hold on;plot(LFP,'r')
end
L=freqband(i,2)*0.002;
[l1,l2] = butter(5,L,'low');
fLFP = filtfilt(l1,l2,fLFP);
phaseLFP=angle(hilbert(fLFP));
% phaseLFP=10*ceil(2*pi*ceil(10*(phaseLFP)/(2*pi)))/100;
phaseLFP=5*ceil(2*pi*ceil(20*(phaseLFP)/(2*pi)))/100;
fpower=abs(hilbert(fLFP));
tpower=nan(size(fpower));
tpower(find(fpower>(prctile(fpower,80))))= fpower(find(fpower>(prctile(fpower,80))));
if strcmp(interval,'all')==0
    timeint=eval([interval]);
    %dummy=zeros(size(fLFP));
    for j=1:size(timeint,1)-1
        if (timeint(j,2)*1000)<length(phaseLFP)
            phaseLFP(round(timeint(j,1)*1000+1):round(timeint(j,2)*1000),1)=NaN;
        end
        if (timeint(j,2)*1000)>length(phaseLFP)
            phaseLFP(round(timeint(j,1)*1000+1):end,1)=NaN;
        end
    end

    %phaseLFP(find(dummy==0))=NaN;
end
% LFPM(i,:)=fLFP;
phaseM(i,:)=phaseLFP;
end
j=0;
worksp=whos;
for n=1:length(worksp)

    nme=worksp(n,1).name(1,:);

    if length(nme)>=6

        if strcmp(sprintf('sig'),sprintf('%s',nme(1,1:3)))==1;
            j=j+1;
                    figure
            for i=1:size(freqband,1)
            neu=eval([num2str(worksp(n,1).name(1,1:end));]);
            
            phaseneu=phaseM(i,round(neu(find(neu*1000<length(phaseLFP)))*1000));
            [pval,Z]=circTestR(phaseneu(find(isnan(phaseneu)==0)));
            MRL=circResLength(phaseneu(find(isnan(phaseneu)==0)));
            subplot(2,3,i)
            bar(cat(2,hist(phaseneu,20),hist(phaseneu,20))); axis tight
            h=hist(phaseneu,20);
            phi=(find(h==max(max(h)))*360/length(h));
            eval(['pha0' num2str(worksp(n,1).name(1,5:end)) '=[pval,phi(1,1)];']);
            phist(i,j,:)=h;
            ppval(i,j)=pval;
            pmrl(i,j)=MRL;
            pZ(i,j)=Z;
            title(sprintf('neurone %s Rayleigh=%1.3f Phi=%3.0f',num2str(worksp(n,1).name(1,:)),pval,phi(1,1))) 
%             eval(['neu0' num2str(worksp(n,1).name(1,5:end)) '=neu;']);
            end
    end
end
end
clear neu H h1 h2 L l1 l2 angles LFP
