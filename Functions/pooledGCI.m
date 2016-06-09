function [poolGCI] = pooledGCI

GCI=[];                                                                       % Set up empty structures for GCI

[FileName,PathName] = uigetfile('*.mat','Select all the Mat-files with the GCI-results data to be plotted','GCIresults_','MultiSelect','on');
exps = length(FileName);                                                    % Open ALL the results files to pool. Exps is their number.

for i=1:exps                                                                % For each of them...
    h = open(fullfile(PathName, FileName{i}));                              % open the file...
   
    GCITemp = h.GCI;                                                        % get GCI (needed to count the # of channels)...
    E = length(GCITemp);                                                   % Count the number of epochs...
    channels = length(GCITemp{1});                                   % and the number of data arrays
    if i==1                                                                 % For the first experiment...
       ETemp = E;                                                          % in temporary matrices
       channelsTemp = channels;                                            %
    else                                                                    % In the next steps...
        if  E ~= ETemp | channels ~= channelsTemp         % if the new variables are not the same as the previous (Temp) ones.. 
            error('The data files you chose do not have the same number of epochs, or channels') % then stop!
        end                                                                 % cause the epochs,frequencies or # of channels differ in the experimnts
        ETemp = E;                                                          % for the next step comparison
        channelsTemp = channels;                                            %
    end    
    GCI = [GCI; GCITemp];                                                           % Store the new GCI cells
end
poolGCI = cell(1,E);                                                            % Allocate memory for the pooled data
for k=1:E                                                                   % For each epoch...
    poolGCI{k} = zeros(channels,channels) ;                     
end

for j=1:E                                                                   % For each epoch...
    for i=1:exps                                                            % and each experiment
        poolGCI{j} = poolGCI{j} + GCI{i,j};                                       % add the GCI of this experiment to the pooled GCI   
    end
        poolGCI{j} = poolGCI{j}/exps;                                               % and divide by the number of experiments to get the mean
end

plotGCI(poolGCI)      % Call plotPDC to plot the pooled measures.