function GetDataFromPl2( filename, fech, s )
%UNTITLED Summary of this function goes here
%	Creates a .mat file with AD, units timestamps, waveforms, and events from a .pl2 file

%% PL2 filename INDEX
pl2 = PL2GetFileIndex(filename);

%% CONTINUOUS CHANNELS
if find(s==1)
    for j=1:length(pl2.AnalogChannels)
        if pl2.AnalogChannels{j, 1}.SamplesPerSecond == fech && pl2.AnalogChannels{j, 1}.NumValues ~= 0  % Seulement les LFP activés
            eval([pl2.AnalogChannels{j, 1}.Name '= PL2Ad(filename, pl2.AnalogChannels{j, 1}.Name);']);
            eval([pl2.AnalogChannels{j, 1}.Name '=' pl2.AnalogChannels{j, 1}.Name '.Values;']);
        end
    end
    
    clear j
end

if find(s==4)
    for j=1:length(pl2.AnalogChannels)
        if pl2.AnalogChannels{j, 1}.SamplesPerSecond > fech && pl2.AnalogChannels{j, 1}.NumValues ~= 0  % Seulement les raw datas activés
            eval([pl2.AnalogChannels{j, 1}.Name '= PL2Ad(filename, pl2.AnalogChannels{j, 1}.Name);']);
            eval([pl2.AnalogChannels{j, 1}.Name '=' pl2.AnalogChannels{j, 1}.Name '.Values;']);
        end
    end
    
    clear j
end

%% UNITS
if find(s==2)
    unitnames = ('a':'z');
    
    for i=1:length(pl2.SpikeChannels)
        if pl2.SpikeChannels{i, 1}.NumberOfUnits > 0
            for j=1:pl2.SpikeChannels{i, 1}.NumberOfUnits
                wave = PL2Waves(filename, pl2.SpikeChannels{i, 1}.Name, j);
                eval([pl2.SpikeChannels{i, 1}.Name unitnames(j) '= wave.Ts;']);
                eval([pl2.SpikeChannels{i, 1}.Name unitnames(j) '_wf = wave.Waves'';']);
            end
        end
    end
    
    clear unitnames i j wave
end

%% EVENTS
if find(s==3)
    for i=1:length(pl2.EventChannels)
        eventname = pl2.EventChannels{i, 1}.Name;
        eventname(regexp(eventname, '\W'))=[];
        if pl2.EventChannels{i, 1}.NumEvents > 0   %Seulement les événements ayant eu lieu
            eval([eventname '= PL2EventTs(filename, eventname);']);
            eval([eventname '=' eventname '.Ts;']);
        end
    end
end

clear i j idx AllEvents eventname


%% SAVE
clear pl2 s

save(filename(1:end-4), '-regexp', '^(?!(filename)$).');

end