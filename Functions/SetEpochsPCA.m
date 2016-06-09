function [dataep,ep_times,E] = SetEpochsPCA(data,bins)

% Algorithm used for splitting the 1st PCs into experimental epochs. The user
% can set the epoch times otherwise he has to set the number E of epochs.
% Then the arrays are split into E equal parts.
% Input:    data = data matrix (PC1)
%           bins = bins times [starttimes endtimes]
% Output: dataep = cell matrix (1xE) with returned split data 
%       ep_times = starting and ending times (Ex2)
%     count_rate = sampling rate 
%              E = the number of epochs.

disp(' ')
disp('You need to define the number of experimental protocol epochs and their times.')
disp(' ')

epstart = input('Specify the starting times of each epoch in a row matrix (use [... ...]): '); % The user specifies the starting times of all epochs
  epend = input('Specify the ending times of each epoch in a row matrix (use [... ...]): ');   % The user specifies the ending times of all epochs 
if any(epstart ~= sort(epstart))==1 || all(size(epstart)>1)==1 ...          % If they are not given in the right order...
    || any(epend ~= sort(epend))==1 || all(size(epend)>1)==1 ...            % or they re not arrays...
    || length(epstart)~=length(epend)                                       % or they are not equal in length
    error('The epoch times were not given correctly')                       % then stop.
end
ep_times = [epstart' epend'];                                               % Arrange the starting and ending times in 2 columns

bins = mean(bins,2);                                                        % Replace the bins with their mean time
startime = bins(1);                                                         % Store the first
exptime = bins(end);                                                        % and the last mean bin-time.

if isempty(ep_times)                                                        % If the ep_times were not given by the user...
    E=input('Specify the number of experimental protocol epochs: ');        % he needs to specify the number of epochs.
    if isempty(E)
        error('You NEED to specify an (integer) number of epochs');         % Otherwise stop!
    end
    E=round(E);                                                         
    disp(['The data arrays will be equally split in ', num2str(E), ' parts'])
    disp(' ')
    
    epoch = floor((exptime-startime)/E);                                    % Calculate the length of all epochs (except maybe the last one's)
    ep_times = zeros(E,2);                                                  % Allocate memory for the starting and ending epoch times
    dataep=cell(1,E);                                                       % Allocate memory for the cell matrix with "epoched" data
    for i = 1:E
        dataep{i} = [];                                                     % Set all cells as empty matrices
    end
    
    ep_times(1) = startime;
    for i = 1:E-1
        ep_times(i,2) = ep_times(i,1)+epoch;                                % Calculate starting times...
        ep_times(i+1,1) = ep_times(i,2);                                    % and corresponding ending times.
        
        t = (bins >= ep_times(i,1) &  bins <= ep_times(i,2));               % Find the bins within the epoch (holds if all groups have same bins)
        for j = 1:length(data)
            dataep{i} = [dataep{i} data{j}(t)];                             % Add the corresponding data to the epoch-cell
        end
    end
    ep_times(E,2) = exptime;                                                % Last epoch ending time is the last bin.
    t = (bins >= ep_times(E,1));                                            % Find all the remaining bins      
    for j = 1:length(data)
            dataep{E} = [dataep{E} data{j}(t)];
    end

else                                                                        % If the ep_times were given by the user...
    E = size(ep_times,1);                                                   % count the number of epochs...
    dataep=cell(1,E);                                                       % Allocate memory for the cell matrix with "epoched" data
    for i=1:E
        dataep{i} = []; 
        t = (bins >= ep_times(i,1) &  bins <= ep_times(i,2));               % Find the bins within the epoch (holds if all groups have same bins)
        for j = 1:length(data)
            dataep{i} = [dataep{i} data{j}(t)];                             % Add the corresponding data to the epoch-cell
        end
    end
end

clear data epstart epend
