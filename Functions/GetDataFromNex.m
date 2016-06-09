function GetDataFromNex(filename,s)
%UNTITLED2 Summary of this function goes here
%   Creates a .mat file with AD, units timestamps, waveforms, and events from a .nex file

datafile=readNexFile(filename);

%% Continuous data
if find(s==1)
    if isfield(datafile, 'contvars');
        cont=datafile.contvars;
        for i=1:size(cont,1)
            if cont{i}.ADFrequency<40000
                vartemp=cont{i}.name;
                eval([vartemp '= cont{i}.data;']);
            end
        end
    end
    
    fech = cont{i}.ADFrequency;
    
    clear cont i vartemp
end

%% Units
if find(s==2)
    if isfield(datafile, 'neurons');
        neurons=datafile.neurons;
        for i=1:size(neurons,1)
            vartemp=neurons{i}.name;
            eval([vartemp '= neurons{i}.timestamps;']);
        end
    end
    
    clear neurons i vartemp
    
    if isfield(datafile, 'waves');
        wf=datafile.waves;
        for i=1:size(wf,1)
            vartemp=wf{i}.name;
            eval([vartemp '= wf{i}.waveforms;']);
        end
    end
    
    clear wf i vartemp
end

%% Events + markers
if find(s==3)
    if isfield(datafile, 'events');
        events=datafile.events;
        for i=1:size(events,1)
            vartemp=events{i}.name;
            vartemp(regexp(vartemp, '\W'))=[];
            eval([vartemp '= events{i}.timestamps;']);
        end
    end
    
    if isfield(datafile, 'markers');
        markers=datafile.markers;
        for i=1:size(markers,1)
            vartemp=markers{i}.name;
            vartemp(regexp(vartemp, '\W'))=[];
            eval([vartemp '= markers{i}.timestamps;']);
        end
    end
    
    clear events markers i vartemp
end

%% SAVE
clear datafile s

save(filename(1:end-4), '-regexp', '^(?!filename$).');

end
