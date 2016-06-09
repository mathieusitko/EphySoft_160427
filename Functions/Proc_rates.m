function [PC1,Bins,binlen,overlap,FileName] = Proc_rates

% Performs PC analysis on firing rates and returns the 1st principal
% component and the bins times.
% 1) Loads spike trains gathered in groups
% 2) Calculates the firing rates in each group according to some "binning"
% 3) Performs PCA for each group

 
[trains,groups,maxtime,mintime,data_names,FileName] = OpenSpikesMAT;        % Call OpenSpikesMAT to load the spikes gathered in groups.

      PC1 = cell(1,groups);
     Bins = cell(1,groups);
    Rates = cell(1,groups);
PCweights = zeros(groups,size(trains,2));

% Set a "binning" scheme...................................................
binlen = input('Input the length of the bins (in sec): ');                  % User specifies bin length
if ~isscalar(binlen)
    error('The bin length must be just a scalar!')
end

overl = input('Input the bins'' overlap (% percentage): ');                 % User specifies bin overlap
if overl < 0 || overl > 100
    error('The bin overlap must be given as a percentage!')             
end
overlap = binlen*overl/100;                                                 % Turn the percentage into time-overlap
%..........................................................................
   
for k = 1:groups                                                            % For each group
    disp(['Working on group ',num2str(k)])
    [Rates{k},Bins{k}] = FiringRates({trains{k,:}},maxtime,mintime,binlen,overlap);% Call FiringRates to calculate the firing rates
    [score, weights] = pca(Rates{k});                                       % Perform PC analysis on each group and get the PC scores.
    PC1{k} = score(:,1);                                                    % Store the 1st Principal Component.
    PCweights(k,1:length(weights)) = weights';                              % Store the PCA weights
end

% Create the archive and save data.......................................
archive.file_name = FileName;
for k = 1:groups
    eval(['archive.channels_group_',num2str(k),'= data_names{k};']);
end
archive.binning = [binlen, overlap];
archive.PCAweights = PCweights;
uisave({'archive','PC1', 'Rates', 'Bins'},['Rates_', FileName])

Plot_rates(Rates,PC1,Bins);                                                 % Plot PC1s

