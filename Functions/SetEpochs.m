function [dataep,ep_times,count_rate,E] = SetEpochs(data,N)

% Algorithm used for splitting the data into experimental epochs. The user
% can set the epoch times otherwise he has to set the number E of epochs.
% Then the arrays are split into E equal parts.
% Output: dataep = cell matrix (1xE) with returned split data
%       ep_times = starting and ending times (Ex2)
%     count_rate = sampling rate 
%              E = the number of epochs.

disp(' ')
disp('You need to define the number of experimental protocol epochs and their times.')
disp(' ')
disp('Do the data contain the "between-epoch" parts?')
disp('(if not (i.e. N), then data between epochs are not included in the data arrays, e.g. BEN\''s data)')
split = input('Y / N: ', 's');
disp(' ')

epstart = input('Specify the starting times of each epoch in a row matrix (use [... ...]): '); % The user specifies the starting times of all epochs
  epend = input('Specify the ending times of each epoch in a row matrix (use [... ...]): ');   % The user specifies the ending times of all epochs 
if any(epstart ~= sort(epstart)) || all(size(epstart)>1) ...                % If they are not given in the right order...
    || any(epend ~= sort(epend)) || all(size(epend)>1) ...                  % or they re not arrays...
    || length(epstart)~=length(epend)                                       % or they are not equal in length
    error('The epoch times were not given correctly')                       % then stop.
end
ep_times = [epstart' epend'];                                               % Arrange the starting and ending times in 2 columns

count_rate = input('Specify LFP sampling rate (in Hz) [DEFAULT = 1KHz]: '); % User-specified sampling rate.
disp(' ');
if isempty(count_rate)
    count_rate=1000;                                                        % Default is 1 kHz
end

if split == 'Y' || split == 'y'
    if ~isempty(ep_times) && any(ep_times(:,2)*count_rate > N)              % Error if the epoch times strech beyond the data time-length
    error(['Some epoch times are too large! They stretch beyond the data time-length = ', num2str(N/count_rate)])
    end
end

if isempty(ep_times)                                                        % If the ep_times were not given by the user...
    E=input('Specify the number of experimental protocol epochs: ');        % he needs to specify the number of epochs.
    if isempty(E)
        error('You NEED to specify an (integer) number of epochs');         % Otherwise stop!
    end
    E=round(E);                                                         
    disp(['The data arrays will be equally split in ', num2str(E), ' parts']);
    disp(' ');
    epoch = floor(N/E);                                                     % Calculate the length of all epochs (except maybe the last one's)
    dataep=cell(1,E);                                                       % Allocate memory for the cell matrix with "epoched" data
    for k = 0:E-2
        dataep{k+1} = data(k*epoch+1:(k+1)*epoch,:);                        % Break down the data in epochs and assign them to cells.
    end
    dataep{E} = data((E-1)*epoch+1:end,:);                                  % The last epoch can be longer! 

    ep_times = zeros(E,2);                                                  % Allocate memory for the starting and ending epoch times
    for i=2:E
        ep_times(i,1) = ep_times(i-1)+epoch/count_rate;                     % Calculate starting times...
        ep_times(i-1,2) = ep_times(i,1);                                    % and corresponding ending times.
    end
    ep_times(E,2) = N/count_rate;                                           % Last ending time.
    
else                                                                        % If the ep_times were given by the user...
    E = size(ep_times,1);                                                   % count the number of epochs...
    NN = ep_times*count_rate;                                               % calculate the data elements that correspond to the ep_times.
    if split == 'N' || split == 'n'                                         % If the elements between epochs were not included in the data...
        cuts=NN(2:end,1)-NN(1:end-1,2);                                     % calculate how many data elements should be missing...
        for i=2:E                                                           % and for each epoch...
            NN(i:end,:) = NN(i:end,:)-cuts(i-1)+1;                          % correct the element matrix aprropriately (unecessarily complicated...
        end                                                                 %                                                         but it works)
    end
    if ep_times(1,1) == 0                                                   % (If the 1st-epoch starting time is 0...
        NN = NN + 1;                                                        % then shift all the elements by one...
    end                                                                     % to start counting time from 0 and not 1msec)
    dataep=cell(1,E);
    for i = 1:E                                                             % for each epoch...
        dataep{i} = data(NN(i,1):NN(i,2),:);                                % split the data array appropriately
    end
end
clear data epstart epend NN
