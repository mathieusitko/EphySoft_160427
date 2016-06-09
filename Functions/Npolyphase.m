channel=input('channel number? use quotes ');
n=input('number of neurons: ');
int=input('interval: ');
LFP=eval(['AD' channel;]);
prefix=input('neuron prefix? 4 letters, use quotes ');
nf=100;
ph=zeros(nf,40,n);
tic
fmin = 1;
fmax = 120;
nbrSubOct = 50;
aff = 1;
[Wx,period] = wt(LFP,fmin,fmax,nbrSubOct);
freq = 1./(2.^(log2(period)))';
phaseLFP=zeros(nf,size(Wx,2));
spectLFP=zeros(nf,size(Wx,2));
f=0.5:0.5:nf;
for i=1:length(f)
    [catchf,idx]=min(abs(f(i)-freq*1000));
    linfreq(i,1)=freq(idx)*1000;
    phaseLFP(i,:)=angle(hilbert(real(Wx(idx,:))));
    spectLFP(i,:)=(abs(Wx(idx,:))).^2;
end
clear Wx
toc

worksp=whos;
j=0;
tic

for n=1:length(worksp)
    nme=worksp(n,1).name(1,:);
    if length(nme)>=6
        if strcmp(prefix,sprintf('%s',nme(1,1:4)))==1;
            neu=[];
            proneu=eval([num2str(worksp(n,1).name(1,1:end));]);
            if size(int)>0;
                for s=1:size(int)
                    neu(end+1:end+length(find(proneu>int(s,1) & proneu<int(s,2))))=proneu(find(proneu>int(s,1) & proneu<int(s,2)));
                end
            else
                neu=proneu;
            end
            j=j+1;
            for i=1:size(phaseLFP,1)
                phaseneu=squeeze(phaseLFP(i,round(neu(find(neu*1000<length(phaseLFP(i,:))))*1000)));
                [pval(i,j),Z(i,j)]=circTestR(phaseneu(find(isnan(phaseneu)==0)));
                %             title(sprintf('neurone %s',num2str(worksp(n,1).name(1,:))))
                eval(['neu0' num2str(worksp(n,1).name(1,:)) '=neu;']);
                %             if pval<=0.05
                ph(i,:,j)=squeeze(cat(2,hist(phaseneu,20),hist(phaseneu,20)));
                %             end
            end
            
            figure('Name',sprintf('neurone %s',num2str(worksp(n,1).name(1,:))))
            hold on
            subplot(3,3,[1:2,4:5])
            contourf((squeeze(ph(:,:,j))),50,'lines','none')
            
            set(gca,'yTick',[0 20 40 60 80 100 120 140 160 180 200])
            set(gca,'yTicklabel',f([2 20 40 60 80 100 120 140 160 180 200]))
            subplot(3,3,[7:8])
            contourf((squeeze(ph(1:30,:,j))),50,'lines','none')
            set(gca,'yTick',[10 20 30])
            set(gca,'yTicklabel',f([10 20 30]))
            subplot(3,3,[3,6])
            plot(log(Z(:,j)),linfreq,'r.')
            axis tight
            hold on
            plot([1 1],[f(1) f(end)],':k')
            subplot(3,3,9)
            plot(log(Z(1:30,j)),linfreq(1:30),'r.')
            axis tight
            hold on
            plot([1 1],[f(1) f(30)],':k')
        end
    end
    
    %    imagesc(squeeze(ph(:,:,j)));
end

toc
% clear neu H h1 h2 L l1 l2
% ph=cat(2,ph,ph);