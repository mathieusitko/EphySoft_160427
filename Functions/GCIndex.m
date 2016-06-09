function [GCI] = GCIndex

[data,channels] = openMAT;                                               % Call openMAT to open the data file and assign variables

disp('Do the data contain the "between-epoch" data?')
disp('(if not (i.e. N), then data between epochs are not included in analysis, e.g. BEN\''s data)')
split = input('Y / N: ', 's');
disp(' ')

count_rate = input('Specify LFP sampling rate (in Hz) [DEFAULT = 1KHz]: '); % User-cpecified sampling rate.
if isempty(count_rate)==1
    disp('Default sampling rate of 1 kHz has been used');                   % Default is... 
    count_rate=1000;                                                        % 1 kHz
end
disp(' ')

[FileName,PathName] = uigetfile('*.mat','Select the Mat-file with the corresponding PDC-results data','PDCresults_');
h = open(fullfile(PathName, FileName));                                     % open a user-specified file of preprocessed data...

ep_times = h.ep_times;
E = size(ep_times,1);                                                       % count the number of epochs...
NN = ep_times*count_rate;                                                   % calculate the data elements that correspond to the ep_times.
if split == 'N' || split == 'n'                                             % If the elements between epochs were not included in the data...
    cuts=NN(2:end,1)-NN(1:end-1,2);                                         % calculate how many data elements should be missing...
    for i=2:size(ep_times,1)                                                % and for each epoch...
        NN(i:end,:) = NN(i:end,:)-cuts(i-1)+1;                              % correct the element matrix aprropriately.
    end
end
if ep_times(1,1) == 0                                                       % (If the 1st-epoch starting time is 0...
    NN = NN + 1;                                                            % then the corresponding data element is the 1st one...
end                                                                         % not the 0th one!)
dataep=cell(1,E);
for i = 1:E                                                                 % for each epoch...
    dataep{i} = data(NN(i,1):NN(i,2),:);                                    % split the data array appropriately
end
%.....................................................

Sigma = h.Sigma;                                                            % Import the noise covariance matrix...
P=size(Sigma{1},2)/channels - 1;                                            % and count the model order 

C=cell(1,E);
GCI = cell(1,E);
for i=1:E
    C{i} = diag(Sigma{i}(:,channels*P+1:channels*(P+1)));                   % Get the variances of the full model for each epoch...
    GCI{i} = zeros(channels,channels);                                      % and allocate memory for the GCIs.
end

for e=1:E                                                                   % For each epoch...
    m = mean(dataep{e});                                                    % Calculate the data's mean (columnwise)
    m = repmat(m,size(dataep{e},1),1);
    dataep{e} = dataep{e} - m;                                              % Rescale data to make them zero-mean
    
    for i=1:channels                                                        % For each variable...
        datatmp=dataep{e};                                                  
        datatmp(:,i)=[];                                                    % Locate the variable's data and remove them. 
        [AR,RC,PE] = mvar(datatmp, P);                                      % Create a new VAR model
        CC = diag(PE(:,(channels-1)*P+1:(channels-1)*(P+1)));               % Store the error variances

        disp('Performing VAR stability test')
        z = findroots(AR,channels-1,P);                                     % Check the model's stability
        if all(z <= 1) == 1
            disp('Stability criterion is satisfied')
        else
            disp('Stability criterion is violated!');
            disp('End of process!')
            return
        end
        
        if i==1                                                             % Insert zeros in the vaairances in the variable's "lost" position
            CC=[0; CC];
        elseif i==channels
            CC=[CC; 0];
        else
            CC=[CC(1:i-1); 0; CC(i:end)];
        end

        GCI{e}(:,i) = log(CC./C{e});                                        % Calculate the GCIs
        GCI{e}(i,i) = 0;
    end
    GCI{e} = round(GCI{e}*100)/100;                                         % Round them in the 2nd decimal
    dataep{e}=[];
end

uisave({'GCI'},'GCIresults_');                                              % Save in a user-specified file
plotGCI(GCI);                                                               % and plot results
