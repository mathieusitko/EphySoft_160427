function convertNEXtoMATdata(path,file,newFolder)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% datafile=readNexFile([path file]);
%
% if isfield(datafile,'neurons')
%     neurons=datafile.neurons;
%     for i=1:size(neurons,1)
%         vartemp=neurons{i}.name;
%         eval([vartemp '= neurons{i}.timestamps;']);
%     end
% end
%
% if isfield(datafile,'intervals')
%     intervals=datafile.intervals;
%     for i=1:size(intervals,1)
%         if ~isempty(intervals{i}.intStarts)
%             vartemp = intervals{i}.name;
%             eval([vartemp '(:,1)= intervals{i}.intStarts;']);
%             eval([vartemp '(:,2)= intervals{i}.intEnds;']);
%         end
%     end
% end
%
% if isfield(datafile,'contvars')
%     cont=datafile.contvars;
%     for i=1:size(cont,1)
%         vartemp=cont{i}.name;
%         eval([vartemp '= cont{i}.data;']);
%     end
% %     fech = cont{i}.ADFrequency;
% end
%
% %%% Events + markers
% if isfield(datafile, 'events');
%     events=datafile.events;
%     for i=1:size(events,1)
%         vartemp=events{i}.name;
%         vartemp(regexp(vartemp, '\W'))=[];
%         eval([vartemp '= events{i}.timestamps;']);
%     end
% end
%
% if isfield(datafile, 'markers');
%     markers=datafile.markers;
%     for i=1:size(markers,1)
%         vartemp=markers{i}.name;
%         vartemp(regexp(vartemp, '\W'))=[];
%         eval([vartemp '= markers{i}.timestamps;']);
%     end
% end
%
%
% %%% Waveforms
% if isfield(datafile,'waves')
%     wf=datafile.waves;
%     for i=1:size(wf,1)
%         vartemp=wf{i}.name;
%         eval([vartemp '= wf{i}.waveforms;']);
%     end
% end
%
% cd(newFolder)
% nomsave = file(1:end-4);
% clear i j idx datafile path file newFolder markers neurons events cont wf vartemp
% save(nomsave, '-regexp', '^(?!nomsave$).');
%
% cd ..

addpath(genpath(path), genpath('Functions'))
files = dir(path);

s = listdlg('PromptString', 'Extraction de:',...
    'SelectionMode', 'multiple', 'ListString',{'LFP' 'Spikes' 'Events' 'Raw'});

for i=1:length(files)
    current_folder = pwd;
    filename = files(i).name;
    
    if length(filename)>3
        
        ext = filename(end-2:end);
        
        if strcmp(ext,'plx')
            %     fech = inputdlg('LFP Sampling rate');
            fech = {'1000'};
            fech = str2num(cell2mat(fech));
            GetDataFromPlx( [current_folder '\' filename], fech, s )
            
        elseif strcmp(ext,'pl2')
            %     fech = inputdlg('LFP Sampling rate');
            fech = {'1000'};
            fech = str2num(cell2mat(fech));
            GetDataFromPl2( filename, fech, s );
            
        elseif strcmp(ext,'nex')
            GetDataFromNex( filename,s )
        end
    end
end
clear

end
