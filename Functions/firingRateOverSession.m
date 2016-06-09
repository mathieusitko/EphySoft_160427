function [matbin,timebin] = firingRateOverSession(sig,binsize,length_sig,fech)

%%% calcul le firing "instantané" d'un neuron dans un binsize donné
%%% sig: neuron
%%% binsize en ms
%%% length_sig = nombre de points des LFP
%%% fech  


mattest=zeros(1,length_sig);
mattest(round(sig*fech))=1;

timebin = 0:binsize/fech:length_sig/fech;

for i = 1:length(timebin)
    if i*binsize<length_sig
        matbin(i) = sum(mattest((i-1)*binsize+1:i*binsize));
    elseif i*binsize>length_sig
        matbin(i) = sum(mattest((i-1)*binsize+1:end));
    end
end

clear mattest

% matbin=matbin/binsize*fech;
