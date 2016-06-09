function GetDataFromPlx( filename, fech, s )
%UNTITLED Summary of this function goes here
%   Creates a .mat file with AD, units timestamps, waveforms, and events from a .plx file

%% CONTINUOUS CHANNELS
if find(s==1)
    [~,adnames] = plx_adchan_names(filename);
    adnames=cellstr(adnames);
    
    for i=1:length(adnames)
        [adfreq, n, ~, ~, ad] = plx_ad(filename, adnames{i});
        if adfreq == fech && n ~= 0  % Seulement les LFP activés
            eval([adnames{i} '= ad;']);
        end
    end
        
    clear adnames i adfreq ad
end

if find(s==4)
    [~,adnames] = plx_adchan_names(filename);
    adnames=cellstr(adnames);
    
    for i=1:length(adnames)
        [adfreq, n, ~, ~, ad] = plx_ad(filename, adnames{i});
        if adfreq > fech && n ~= 0  % Seulement les raw data activés
            eval([adnames{i} '= ad;']);
        end
    end
        
    clear adnames i adfreq ad
end

%% UNITS
if find(s==2)
    unitnames = ('a':'z');
    
    [~,channames] = plx_chan_names(filename);
    channames = cellstr(channames);
    
    for i=1:length(channames)
        for j=1:26
            [n, ~, ts, wave] = plx_waves(filename, channames{i}, j);
            if n > 0
                eval([channames{i,1} unitnames(j) '= ts;']);
                eval([channames{i,1} unitnames(j) '_wf = wave'';']);
            else
                clc
                break
            end
        end
    end
    
    clear unitnames channames i j n ts wave
end

%% EVENTS
if find(s==3)

[~,eventnames] = plx_event_names(filename);
eventnames=cellstr(eventnames);

for i=1:length(eventnames)
    event = eventnames{i};
    [n, ts, ~] = plx_event_ts(filename, eventnames{i});
    event(regexp(event, '\W'))=[];
    if AllEvents == 'y'
        eval([event '= ts;']);
    elseif AllEvents == 'n' %Seulement les événements ayant eu lieu
        if n > 0
            eval([event '= ts;']);
        end
    end
end

clear eventnames i event n ts AllEvents s
end

%% SAVE
save(filename(1:end-4), '-regexp', '^(?!filename$).');

end