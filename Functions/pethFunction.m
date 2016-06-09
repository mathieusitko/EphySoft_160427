function [matbin,bintime,tevent,nb_event,matbinbef,matbinaft] = pethFunction(sig,event,bin,tbef,taft,lengthAD,fech,interval)


idx = find(event < interval(1) | event > interval(2));
event(idx) = [];

matsig=zeros(1,lengthAD);
matsig(round(sig*fech))=1;
matbefaft=zeros(1,tbef+taft+1);

nb_event = 0;
for i=1:length(event)
    if round(event(i)*fech) > tbef && round(event(i)*fech)+taft < lengthAD
        nb_event = nb_event+1;
        matbefaft=matbefaft+matsig(:,round(event(i)*fech)-tbef:round(event(i)*fech)+taft);
    end
end

clear matsig

%% BIN
%il faut retourner matbef pour éliminer le bin vers -tbef et pas vers 0
matbef=matbefaft(1:tbef);
mataft=matbefaft(end-taft:end);

matbef = fliplr(matbef);
for i = 1:tbef/bin
    if i*bin<=tbef
        matbinbef(i) = sum(matbef((i-1)*bin+1:i*bin));
    elseif i*bin>tbef
        matbinbef(i) = sum(matbef((i-1)*bin+1:end));
    end
end

%reretourner pour remettre dans l'ordre
matbinbef=fliplr(matbinbef);

for i = 1:taft/bin
    if i*bin<=taft
        matbinaft(i) = sum(mataft((i-1)*bin+1:i*bin));
    elseif i*bin>taft
        matbinaft(i) = sum(mataft((i-1)*bin+1:end));
    end
end

matbin = [matbinbef  matbinaft];

bintime= -length(matbinbef):1:length(matbinaft)-1;
bintime = bintime*bin;
tevent = max(matbin)+0.5*mean(matbin);
