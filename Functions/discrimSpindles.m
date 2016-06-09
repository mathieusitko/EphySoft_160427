function [spindles,pvalGlobal,pmrlGlobal] = discrimSpindles(data,bande1,bande2,fmin,fmax,nbrSubOct,intervalExclusion,aff)

%% PARAMETRES
t = data(:,1);
x = data(:,2);
fech = 1/(t(2)-t(1));
lissage = 35;

bandeD = [0.1 4];
bandeT = [4 12];

orderD = 2;
orderT = 2;
orderG = 8;

%% FILTRAGE
xD = BandPass(x,fech, bandeD(1), bandeD(2),orderD);
xT = BandPass(x,fech, bandeT(1), bandeT(2),orderT);
% x40_120 = BandPass(x,fech, 40, 120,2);
x40_120 = BandPass(x,fech, fmin, fmax,2);


% figure;plot(xG60)

xG60 = BandPass(x40_120,fech, bande1(1), bande1(2),orderG);
xG90 = BandPass(x40_120,fech, bande2(1), bande2(2),orderG);

%% WAVELET TRANSFORMS
[Wx, period] = wt([t x],fmin,fmax,nbrSubOct);Wx = (abs(Wx)).^2;
% figure;plot(xG60)
WxG60 = wt([t xG60],fmin,fmax,nbrSubOct);WxG60 = (abs(WxG60)).^2;
WxG90 = wt([t xG90],fmin,fmax,nbrSubOct);WxG90 = (abs(WxG90)).^2;
freq = 1./(2.^(log2(period)))';

%% MOYENNE DE WT G60-90 SUR 40-120Hz
mean_60 = mean((WxG60(:,:))); %calcul de mean60 sur bandeG60
meanmean_60 = median(mean_60);
std_60 = std(mean_60);

mean_90 = mean((WxG90(:,:))); %calcul de mean90 sur bandeG90
meanmean_90 = median(mean_90);
std_90 = std(mean_90);

threshold60 = 1*std_60+meanmean_60;
threshold90 = 1*std_90+meanmean_90;

[~, loc60 start60 stop60] = extractSpindlesThreshold(mean_60,threshold60);
[~, loc90 start90 stop90] = extractSpindlesThreshold(mean_90,threshold90);
% size(loc60)
% size(loc90)

%% NETTOYAGE DOUBLE DETECTION
mean_Wx = mean((Wx));

mean_Wx = smooth(t,mean_Wx,lissage,'moving');
mean_Wx = mean_Wx';

loc60DoubleDetect = [];
loc90DoubleDetect = [];
startStopDoubleDetect = [];
for i = 1:length(loc90)
    for j = 1:length(loc60)
        if (loc60(j)>=start90(i) && loc60(j)<=stop90(i)) || (loc90(i)>=start60(j) && loc90(i)<=stop60(j))
            loc60DoubleDetect(end+1,1) = loc60(j);
            startStopDoubleDetect(end+1,1) = i;
            loc90DoubleDetect(end+1,1) = loc90(i);
        end
    end
end

index = [];
for i = 1:length(startStopDoubleDetect)
    [maxi, indi] = max(Wx(:,start90(startStopDoubleDetect(i)):stop90(startStopDoubleDetect(i))));
    [~, indiindi] = max(maxi);
    index(i) = indi(indiindi);
    freqPeakDoubleDetect = freq(index);
    clear indi indiindi maxi
end
freqPeakDoubleDetect = freq(index);

ind60ToClean = [];
ind90ToClean = [];

for i = 1:length(freqPeakDoubleDetect)
    if freqPeakDoubleDetect(i)<=bande1(2)
        ind90ToClean(end+1) = i;
    else
        ind60ToClean(end+1) = i;
    end
end

loc60ToClean = loc60DoubleDetect(ind60ToClean);
loc90ToClean = loc90DoubleDetect(ind90ToClean);
clear ind60ToClean ind90ToClean index

loc60Clean = loc60';ind60=[];
for i = 1: length(loc60ToClean)
    ind60(i) = find(loc60ToClean(i)==loc60);
end
if ~isempty(ind60)
    loc60Clean(ind60) = [];
end

loc90Clean = loc90';ind90=[];
for i = 1: length(loc90ToClean)
    ind90(i) = find(loc90ToClean(i)==loc90);
end
if ~isempty(ind90)
    loc90Clean(ind90) = [];
end
% size(loc60Clean)
% size(loc90Clean)

start60Clean = start60;
stop60Clean = stop60;
start90Clean = start90;
stop90Clean = stop90;
start60Clean(ind60)=[];stop60Clean(ind60)=[];
start90Clean(ind90)=[];stop90Clean(ind90)=[];
clear loc60ToClean  ind60  loc90ToClean ind90 ind90ToClean maxi indi indiindi

for i = 1:length(loc90Clean)
    [~, indi] = max(mean_Wx(:,start90Clean(i):stop90Clean(i)));
    loc90CleanCorrect(i,1) = indi + start90Clean(i);
    clear indi
end


for i = 1:length(loc60Clean)
    interval = fix((stop60Clean(i)-start60Clean(i))/4);
%     interval = 2000;
    [~, indi] = max(mean_Wx(:,start60Clean(i)+interval:stop60Clean(i)-interval));
    if ~isempty(indi)
        loc60CleanCorrect(i) = indi + start60Clean(i)+interval;
    else
        loc60CleanCorrect(i) = start60Clean(i)+interval;
    end
    clear indi interval
end
[start60CleanCorrect, stop60CleanCorrect] = extractSpindlesFromLoc(mean_Wx,loc60CleanCorrect);
[start90CleanCorrect, stop90CleanCorrect] = extractSpindlesFromLoc(mean_Wx,loc90CleanCorrect);

[start60CleanCorrect, idx60CC] = unique(start60CleanCorrect);%enlever les doublons
stop60CleanCorrect = stop60CleanCorrect(idx60CC);
loc60CleanCorrect = loc60CleanCorrect(idx60CC);
[start90CleanCorrect, idx90CC] = unique(start90CleanCorrect);%enlever les doublons
stop90CleanCorrect = stop90CleanCorrect(idx90CC);
loc90CleanCorrect = loc90CleanCorrect(idx90CC);

idxidx = [];
for j = 1:length(loc60CleanCorrect)
    for i =1:length(loc90CleanCorrect)
        if (loc60CleanCorrect(j)>=start90CleanCorrect(i) && loc60CleanCorrect(j)<=stop90CleanCorrect(i))
            idxidx(end+1,1) = j;
        end
    end
end
loc60CleanCorrect(idxidx) = [];
start60CleanCorrect(idxidx) = [];
stop60CleanCorrect(idxidx) = [];


idxidx = [];
for j = 1:length(loc60CleanCorrect)
    for i =1:length(loc90CleanCorrect)
        if (loc90CleanCorrect(i)>=start60CleanCorrect(j) && loc90CleanCorrect(i)<=stop60CleanCorrect(j))
            idxidx(end+1,1) = i;
        end
    end
end
loc90CleanCorrect(idxidx) = [];
start90CleanCorrect(idxidx) = [];
stop90CleanCorrect(idxidx) = [];
stop90CleanCorrect(stop90CleanCorrect>length(x)) = length(x);
stop60CleanCorrect(stop60CleanCorrect>length(x)) = length(x);

%% Intervale d'exclusion autour des spindles
loc60CleanCorrect = loc60CleanCorrect';
for i = 1:length(loc90CleanCorrect)
   taille(i,:) = abs(loc90CleanCorrect(i)-loc60CleanCorrect);
end

taille(taille<intervalExclusion)=0;
idx = [];
for i = 1:length(loc60CleanCorrect)
    if ~all(taille(:,i))
        idx(end+1) = i;
    end
end

loc60CleanCorrect(idx) = [];
start60CleanCorrect(idx) = [];
stop60CleanCorrect(idx) = [];

% %% FREQUENCE ET PUISSANCE AU PIC
% [peakPow60 idx60] = max(WxG60(:,loc60CleanCorrect));
% peakFreq60 = freq(idx60);clear idx60
% [peakPow90 idx90] = max(WxG90(:,loc90CleanCorrect));
% peakFreq90 = freq(idx90);clear idx90
% 
% %% CRETES
% crete60 = cell(length(loc60CleanCorrect),1);
% for i = 1:length(loc60CleanCorrect)
%     for j = start60CleanCorrect(i):stop60CleanCorrect(i)
%         [maxi,ind]=max(Wx(:,j));
%         crete60{i,1}(end+1,1)=freq(ind);
%     end
% end
% crete90 = cell(length(loc90CleanCorrect),1);
% for i = 1:length(loc90CleanCorrect)
%     for j = start90CleanCorrect(i):stop90CleanCorrect(i)
%         [maxi,ind]=max(Wx(:,j));
%         crete90{i,1}(end+1,1)=freq(ind);
%     end
% end
% 
% %% TEMPS AUX PICS DE VOLTAGE SUR SIGNAL BRUT
% %%% Gamma60
% for i = 1:length(loc60CleanCorrect)
%     [maxi indi] = max(x(start60CleanCorrect(i):stop60CleanCorrect(i)));
%     tpsPeakVoltage60(i,1) = start60CleanCorrect(i) + indi -1;
% end
% 
% %%% Gammma90
% for i = 1:length(loc90CleanCorrect)
%     [maxi indi] = max(x(start90CleanCorrect(i):stop90CleanCorrect(i)));
%     tpsPeakVoltage90(i,1) = start90CleanCorrect(i) + indi -1;
% end

%% DELTA PHASE processing / THETA PHASE processing
phaseD = angle(hilbert(xD));
phaseT = angle(hilbert(xT));

prefD_G60 = phaseD(loc60CleanCorrect);
prefD_G90 = phaseD(loc90CleanCorrect);
prefT_G60 = phaseT(loc60CleanCorrect);
prefT_G90 = phaseT(loc90CleanCorrect);

pval_D_G60 = circTestR(prefD_G60);
MRL_D_G60 = circResLength(prefD_G60);
pval_D_G80 = circTestR(prefD_G90);
MRL_D_G80 = circResLength(prefD_G90);

pval_T_G60 = circTestR(prefT_G60);
MRL_T_G60 = circResLength(prefT_G60);
pval_T_G80 = circTestR(prefT_G90);
MRL_T_G80 = circResLength(prefT_G90);

% figure;
% subplot(221);hist(cat(1,prefD_G60-2*pi,prefD_G60,prefD_G60+2*pi),30);title(['phase pref bandD / band' num2str(bande1(1)) '-' num2str(bande1(2)) 'Hz']);
% subplot(222);hist(cat(1,prefD_G90-2*pi,prefD_G90,prefD_G90+2*pi),30);title(['phase pref bandD / band' num2str(bande2(1)) '-' num2str(bande2(2)) 'Hz']);
% subplot(223);hist(cat(1,prefT_G60-2*pi,prefT_G60,prefT_G60+2*pi),30);title(['phase pref bandT / band' num2str(bande1(1)) '-' num2str(bande1(2)) 'Hz']);
% subplot(224);hist(cat(1,prefT_G90-2*pi,prefT_G90,prefT_G90+2*pi),30);title(['phase pref bandT / band' num2str(bande2(1)) '-' num2str(bande2(2)) 'Hz']);
    
    
pvalGlobal = [pval_D_G60 pval_D_G80 pval_T_G60 pval_T_G80];
pmrlGlobal = [MRL_D_G60 MRL_D_G80 MRL_T_G60 MRL_T_G80];

% %% PUISSANCE DANS LE FUSEAU ENTIER
% spindlesPower60 = zeros(length(loc60CleanCorrect),1);
% spindlesPower90 = zeros(length(loc90CleanCorrect),1);
% 
% for i = 1:length(loc60CleanCorrect)
%     spindlesPower60(i,1) = sum(sum(Wx(:,start60CleanCorrect(i):stop60CleanCorrect(i))));
% end
% 
% for i = 1:length(loc90CleanCorrect)
%     spindlesPower90(i,1) = sum(sum(Wx(:,start90CleanCorrect(i):stop90CleanCorrect(i))));
% end

% %% POWER NEXT & PREV SPINDLES
% t60 = loc60CleanCorrect;
% t90 = loc90CleanCorrect;
% 
% %%% idxPrevNext60
% idxPrevNext60 = zeros(length(t60),2);
% for i = 1:length(t60)
%     [~, idxMinClose] = max(t90(t90<t60(i)));
%     idxMaxClose = find(t90>t60(i),1);
%     if isempty(idxMinClose)
%         idxPrevNext60(i,:) = [NaN idxMaxClose];
%     elseif isempty(idxMaxClose)
%         idxPrevNext60(i,:) = [idxMinClose NaN];
%     else
%         idxPrevNext60(i,:) = [idxMinClose idxMaxClose];
%     end
%     clear idxMinClose idxMaxClose
% end
% 
% %%% idxPrevNext90
% idxPrevNext90 = zeros(length(t90),2);
% for i = 1:length(t90)
%     [~, idxMinClose] = max(t60(t60<t90(i)));
%     idxMaxClose = find(t60>t90(i),1);
%     if isempty(idxMinClose)
%         idxPrevNext90(i,:) = [NaN idxMaxClose];
%     elseif isempty(idxMaxClose)
%         idxPrevNext90(i,:) = [idxMinClose NaN];
%     else
%         idxPrevNext90(i,:) = [idxMinClose idxMaxClose];
%     end
%     clear idxMinClose idxMaxClose
% end
% 
% %%% PowerPrevNext60
% powerPrevNext60 = zeros(size(idxPrevNext60,1),2);
% for i = 1:size(idxPrevNext60,1)
%     if ~isnan(idxPrevNext60(i,1))
%         powerPrevNext60(i,1) = spindlesPower90(idxPrevNext60(i,1));
%     elseif isnan(idxPrevNext60(i,1))
%         powerPrevNext60(i,1) = NaN;
%     end
%     
%     if ~isnan(idxPrevNext60(i,2))
%         powerPrevNext60(i,2) = spindlesPower90(idxPrevNext60(i,2));
%     elseif isnan(idxPrevNext60(i,2))
%         powerPrevNext60(i,2) = NaN;
%     end
% end
% 
% %%% PowerPrevNext90
% powerPrevNext90 = zeros(size(idxPrevNext90,1),2);
% for i = 1:size(idxPrevNext90,1)
%     if ~isnan(idxPrevNext90(i,1))
%         powerPrevNext90(i,1) = spindlesPower60(idxPrevNext90(i,1));
%     elseif isnan(idxPrevNext90(i,1))
%         powerPrevNext90(i,1) = NaN;
%     end
%     
%     if ~isnan(idxPrevNext90(i,2))
%         powerPrevNext90(i,2) = spindlesPower60(idxPrevNext90(i,2));
%     elseif isnan(idxPrevNext90(i,2))
%         powerPrevNext90(i,2) = NaN;
%     end
% end
% 
% %%% Time Prev & Next G60 Spindles (ref G90)
% for i = 1:size(idxPrevNext90,1)
%     if ~isnan(idxPrevNext90(i,1))
%         timePrev90(i,1) = t(loc60CleanCorrect(idxPrevNext90(i,1)));
%     else
%         timePrev90(i,1) = NaN;
%     end
% end
% 
% for i = 1:size(idxPrevNext90,1)
%     if ~isnan(idxPrevNext90(i,2))
%         timeNext90(i,1) = t(loc60CleanCorrect(idxPrevNext90(i,2)));
%     else
%         timeNext90(i,1) = NaN;
%     end
% end
% 
% %%% Time Prev & Next G90 Spindles (ref G60)
% for i = 1:size(idxPrevNext60,1)
%     if ~isnan(idxPrevNext60(i,1))
%         timePrev60(i,1) = t(loc90CleanCorrect(idxPrevNext60(i,1)));
%     else
%         timePrev60(i,1) = NaN;
%     end
% end
% 
% for i = 1:size(idxPrevNext60,1)
%     if ~isnan(idxPrevNext60(i,2))
%         timeNext60(i,1) = t(loc90CleanCorrect(idxPrevNext60(i,2)));
%     else
%         timeNext60(i,1) = NaN;
%     end
% end
% 
% %% Density
% density1=zeros(round(2*pi*10),round(2*pi*10));
% density2=zeros(round(2*pi*10),round(2*pi*10));
% 
% for i=round(-pi*10):round(pi*10)
%     for j=round(-pi*10):round(pi*10)
%         density1(i+round(pi*10)+1,j+round(pi*10)+1)=length(find(round(prefD_G60*10)==i & round(prefT_G60*10)==j));
%         density2(i+round(pi*10)+1,j+round(pi*10)+1)=length(find(round(prefD_G90*10)==i & round(prefT_G90*10)==j));
%     end
% end


%% OUTPUT
spindles.scaleFreq = freq;
spindles.timePeak60 = loc60CleanCorrect;
spindles.timePeak90 = loc90CleanCorrect;
spindles.start60 = start60CleanCorrect';
spindles.stop60 = stop60CleanCorrect';
spindles.start90 =start90CleanCorrect';
spindles.stop90 = stop90CleanCorrect';
% spindles.powerPeak60 = peakPow60';
% spindles.powerPeak90 = peakPow90';
% spindles.freqPeak60 = peakFreq60;
% spindles.freqPeak90 = peakFreq90;
spindles.prefD_G60 = prefD_G60;
spindles.prefD_G90 = prefD_G90;
spindles.prefT_G60 = prefT_G60;
spindles.prefT_G90 = prefT_G90;
spindles.WT = Wx;
% spindles.crete60 = crete60;
% spindles.crete90 = crete90;
% spindles.timePeakVolt60 = tpsPeakVoltage60;
% spindles.timePeakVolt90 = tpsPeakVoltage90;
% spindles.power60 = spindlesPower60;
% spindles.power90 = spindlesPower90;
% spindles.powerIn90PrevNext60 = powerPrevNext60;
% spindles.powerIn60PrevNext90 = powerPrevNext90;
% spindles.timeof60Prev90 = timePrev90;
% spindles.timeof60Next90 = timeNext90;
% spindles.timeof90Prev60 = timePrev60;
% spindles.timeof90Next60 = timeNext60;
% spindles.idx90Avant60 = idxPrevNext60(:,1);
% spindles.idx90Apres60 = idxPrevNext60(:,2);
% spindles.idx60Avant90 = idxPrevNext90(:,1);
% spindles.idx60Apres90 = idxPrevNext90(:,2);
spindles.bande1 = bande1;
spindles.bande2 = bande2;

%% AFFICHAGE
if aff
%     figure;
%     axe1(1) = subplot(411);
%     imagesc(t,1:length(freq),10*log10(Wx));
%     caxis([-25 0]);xlim([t(1) t(end)])
%     xlabel('t (sec)');ylabel('freq (Hz)');title(['WT signal filtered in ' num2str(fmin) '-' num2str(fmax) 'Hz'])
%     pas=4;set(gca,'YTick',1:pas:length(freq),'YTickLabel',floor(10^1*(downsample(freq,pas)))*10^(-1),'Fontsize',8)
%     
%     axe1(2) = subplot(412);
%     plot(t,mean_Wx,'k');xlim([t(1) t(end)]);hold on
%     p=plot(t(loc90),mean_Wx(loc90),'o','markerfacecolor',[.2 .2 .2],'markersize',5);set(p,'Color',[.2 .2 .2],'LineWidth',1);
%     p=plot(t(loc60),mean_Wx(loc60),'o','markerfacecolor',[0 1 0],'markersize',5);set(p,'Color',[0 1 0],'LineWidth',1);
%     title(['Peaks Band ' num2str(bande1(1)) '-' num2str(bande1(2)) 'Hz / Band '  num2str(bande2(1)) '-' num2str(bande2(2))  'Hz with double detection'])
%     
%     axe1(3) = subplot(413);
%     plot(t,mean_Wx,'k');xlim([t(1) t(end)]);hold on
%     p=plot(t(loc60CleanCorrect),mean_Wx(loc60CleanCorrect),'o','markerfacecolor',[0 1 0],'markersize',5);hold on;set(p,'Color',[0 1 0],'LineWidth',1);
%     p=plot(t(loc90CleanCorrect),mean_Wx(loc90CleanCorrect),'o','markerfacecolor',[.2 .2 .2],'markersize',5);hold on;set(p,'Color',[.2 .2 .2],'LineWidth',1);
%     p=plot(t(start60CleanCorrect),mean_Wx(loc60CleanCorrect),'>','markerfacecolor',[0 0 1],'markersize',3);hold on;set(p,'Color',[0 0 1],'LineWidth',1);
%     p=plot(t(stop60CleanCorrect),mean_Wx(loc60CleanCorrect),'<','markerfacecolor',[1 0 0],'markersize',3);hold on;set(p,'Color',[1 0 0],'LineWidth',1);
%     plot(t,mean_Wx,'k');xlim([t(1) t(end)]);hold on
%     p=plot(t(start90CleanCorrect),mean_Wx(loc90CleanCorrect),'>','markerfacecolor',[0 0 1],'markersize',3);hold on;set(p,'Color',[0 0 1],'LineWidth',1);
%     p=plot(t(stop90CleanCorrect),mean_Wx(loc90CleanCorrect),'<','markerfacecolor',[1 0 0],'markersize',3);hold on;set(p,'Color',[1 0 0],'LineWidth',1);
%     title(['Peaks Band ' num2str(bande1(1)) '-' num2str(bande1(2)) 'Hz / Band '  num2str(bande2(1)) '-' num2str(bande2(2))  'Hz: duplicates removed'])
%     
%     axe1(4) = subplot(414);
%     p=plot(t,x,'k');xlim([t(1) t(end)]);title('Spindles on raw spindles');set(p,'Color',[0.8 0.8 0.8],'LineWidth',1);hold on
%     for i = 1:length(loc60CleanCorrect)
%         p=plot([t(start60CleanCorrect(i)) t(stop60CleanCorrect(i))],[x(loc60CleanCorrect(i)) x(loc60CleanCorrect(i))]);set(p,'Color',[0 1 0],'LineWidth',4);hold on
%     end
%     for i = 1:length(loc90CleanCorrect)
%         p=plot([t(start90CleanCorrect(i)) t(stop90CleanCorrect(i))],[x(loc90CleanCorrect(i)) x(loc90CleanCorrect(i))]);set(p,'Color',[.2 .2 .2],'LineWidth',4);hold on
%     end
%     linkaxes(axe1,'x')
    
    
    figure;
    subplot(121);
    hist(peakFreq60,10);hold on
    hist(peakFreq90,10);hold off;
    title('hist peaks frequencies');xlim([fmin fmax]);
    xlabel('freq(Hz)');ylabel('count')
    h = findobj(gca,'Type','patch');
    set(h(1),'FaceColor',[0.2 0.2 0.2],'EdgeColor',[0.2 0.2 0.2])
    set(h(2),'facecolor',[0 1 0],'EdgeColor',[0 1 0]);
    axis square
    
%     subplot(132);
%     p=plot(peakFreq60,10*log10(peakPow60),'wo','MarkerFaceColor',[0 1 0]);hold on;set(p,'Color',[0 1 0])
%     p=plot(peakFreq90,10*log10(peakPow90),'wo','MarkerFaceColor',[0.2 0.2 0.2]);hold off;set(p,'Color',[.2 .2 .2])
%     xlabel('freq(Hz)');ylabel('pow(dB)');xlim([fmin fmax])
%     axis square
    
    subplot(122);
    p=plot3(peakFreq60,10*log10(peakPow60),t(stop60CleanCorrect)-t(start60CleanCorrect),'wo','MarkerFaceColor',[0 1 0]);hold on;set(p,'Color',[0 1 0])
    p=plot3(peakFreq90,10*log10(peakPow90),t(stop90CleanCorrect)-t(start90CleanCorrect),'wo','MarkerFaceColor',[0.2 0.2 0.2]);hold on;set(p,'Color',[0.2 0.2 0.2])
    xlabel('freq(Hz)');ylabel('pow(dB)');zlabel('spindles width');grid on
    axis square
    
%     mean(peakFreq60)
%     mean(peakFreq90)
%     mean(peakPow60)
%     mean(peakPow90)
%     mean(stop60CleanCorrect-start60CleanCorrect)
%     mean(stop90CleanCorrect-start90CleanCorrect)
%     sum(peakPow60)
%     sum(peakPow90)

    figure;
    subplot(221);hist(cat(1,prefD_G60-2*pi,prefD_G60,prefD_G60+2*pi),30);title(['phase pref bandD / band' num2str(bande1(1)) '-' num2str(bande1(2)) 'Hz']);
    subplot(222);hist(cat(1,prefD_G90-2*pi,prefD_G90,prefD_G90+2*pi),30);title(['phase pref bandD / band' num2str(bande2(1)) '-' num2str(bande2(2)) 'Hz']);
    subplot(223);hist(cat(1,prefT_G60-2*pi,prefT_G60,prefT_G60+2*pi),30);title(['phase pref bandT / band' num2str(bande1(1)) '-' num2str(bande1(2)) 'Hz']);
    subplot(224);hist(cat(1,prefT_G90-2*pi,prefT_G90,prefT_G90+2*pi),30);title(['phase pref bandT / band' num2str(bande2(1)) '-' num2str(bande2(2)) 'Hz']);
    
    
%     figure;
%     subplot(221);
%     plot(prefD_G60,prefT_G60,'.');axis([-pi pi -pi pi]);axis square
%     xlabel('phase pref Delta');ylabel('phase pref Theta');
%     title(['band ' num2str(bande1(1)) '-' num2str(bande1(2)) 'Hz'])
%     
%     subplot(222);
%     plot(prefD_G90,prefT_G90,'.');axis([-pi pi -pi pi]);axis square
%     xlabel('phase pref Delta');ylabel('phase pref Theta');
%     title(['band ' num2str(bande2(1)) '-' num2str(bande2(2)) 'Hz'])
%     
%     subplot(223);
%     contourf(cat(2,cat(1,density1,density1),cat(1,density1,density1))',50,'lines','none');
%     xlabel('preferred Delta phase')
%     ylabel('preferred Theta phase')
%     title(['Density: band ' num2str(bande1(1)) '-' num2str(bande1(2)) 'Hz'])
%     axis square
%     
%     subplot(224);
%     contourf(cat(2,cat(1,density2,density2),cat(1,density2,density2))',50,'lines','none');
%     xlabel('preferred Delta phase')
%     ylabel('preferred Theta phase')
%     title(['Density: band ' num2str(bande2(1)) '-' num2str(bande2(2)) 'Hz'])
%     axis square
%     
    
%     figure;
%     axe2(1) = subplot(211);
%     p=plot(t,x,'k');xlim([t(1) t(end)]);set(p,'Color',[0.8 0.8 0.8],'LineWidth',1);hold on
%     title(['Raw signal with ' num2str(bande1(1)) '-' num2str(bande1(2)) 'Hz & ' num2str(bande2(1)) '-' num2str(bande2(2)) 'Hz spindles']);hold on
%     plot(t(start60CleanCorrect),x(start60CleanCorrect),'>b','markerfacecolor',[0 0 1],'markersize',3);hold on
%     plot(t(stop60CleanCorrect),x(stop60CleanCorrect),'<r','markerfacecolor',[1 0 0],'markersize',3);hold on
%     plot(t(start90CleanCorrect),x(start90CleanCorrect),'>b','markerfacecolor',[0 0 1],'markersize',3);hold on
%     plot(t(stop90CleanCorrect),x(stop90CleanCorrect),'<r','markerfacecolor',[1 0 0],'markersize',3);hold on
%     p=plot(t(tpsPeakVoltage60),x(tpsPeakVoltage60),'o','markerfacecolor',[0 1 0],'markersize',5');set(p,'Color',[0 1 0],'LineWidth',1);hold on
%     p=plot(t(tpsPeakVoltage90),x(tpsPeakVoltage90),'o','markerfacecolor',[0.2 0.2 0.2],'markersize',5');set(p,'Color',[0.2 0.2 0.2],'LineWidth',1);hold on
%     for i = 1:length(loc60CleanCorrect)
%         p=plot([t(start60CleanCorrect(i)) t(stop60CleanCorrect(i))],[x(loc60CleanCorrect(i)) x(loc60CleanCorrect(i))]);set(p,'Color',[0 1 0],'LineWidth',4);hold on
%     end
%     for i = 1:length(loc90CleanCorrect)
%         p=plot([t(start90CleanCorrect(i)) t(stop90CleanCorrect(i))],[x(loc90CleanCorrect(i)) x(loc90CleanCorrect(i))]);set(p,'Color',[.2 .2 .2],'LineWidth',4);hold on
%     end
%     
%     axe2(2) = subplot(212);
%     imagesc(t,1:length(freq),10*log10(Wx));
%     caxis([-25 0]);xlim([t(1) t(end)])
%     xlabel('t (sec)');ylabel('freq (Hz)');title(['WT filtered in ' num2str(fmin) '-' num2str(fmax) 'Hz band'])
%     set(gca,'YTick',1:2:length(freq),'YTickLabel',floor(10^1*(downsample(freq,2)))*10^(-1),'Fontsize',8)
%     linkaxes(axe2,'x')
    
    
end