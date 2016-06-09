function [pr_trains,PC1,f_N,maxtime,mintime,FileName] = Proc_spikes

% Performs PC analysis on preprocessed trains and returns the 1st principal
% component and the trains.
% 1) Loads spike trains gathered in groups
% 2) Convolves trains in each group with a sinc kernel
% 3) Performs PCA for each group

[trains,groups,maxtime,mintime,data_names,FileName] = OpenSpikesMAT;        % Call OpenSpikesMAT to load the spikes gathered in groups.

pr_trains = cell(size(trains));                                             % Allocate memory for processed trains (if not cell->max available variable size)!
PC1 = cell(1,groups);                                                       % Allocate memory for PCs.
PCweights = zeros(groups,size(trains,2));

disp(' ');
f_N = input('Insert the maximum frequency to be analysed (Hz) (Default = 50 Hz): '); % Input the maximum frequency (which will be the Nyquist fr.)
disp(' ');
if isempty(f_N)
    f_N = 50;                                                               % Set 50 for default
end
if f_N <= 0 || ~isscalar(f_N)
    error('The frequency was not given correctly!');
end
f_N=round(f_N+10);                                                          % Increase the Nyquist frequency (to avoid any noise at the high freqs)

m = size(trains,2);                                                         % Count the (maximum) number of trains in each group

for i = 1:groups                                                            % For each group
    disp(['Working on group ',num2str(i)]);
    for j=1:m                                                               % and for each train
        if ~isempty(trains{i,j})                                            % if it is not empty
            disp(['      Processing spike train ',num2str(j)]);
            pr_trains{i,j} = kernel_conv2(trains{i,j},maxtime,mintime,f_N);  % process trains by convolving with a kernel
        else
            pr_trains{i,j} = [];                                            % If it is empty, leave the corresponding processed cell empty
        end
    end
    [score, weights] = pca(cell2mat(pr_trains(i,:)));                                  % Perform PC analysis on each group and get the PC scores.
    PC1{i} = score(:,1);                                                    % Store the 1st Principal Component.
    PCweights(i,1:length(weights)) = weights';                              % Store the PCA weights
end
clear trains

archive.file_name = FileName;
for k = 1:groups
    eval(['archive.channels_group_',num2str(k),'= data_names{k};']);
end
archive.sampling_rate = 2*f_N;
archive.experim_time = [mintime maxtime];
archive.PCAweights = PCweights;

uisave({'archive','PC1','pr_trains'},['Spikes_', FileName])

Plot_spikes(pr_trains,PC1,f_N,maxtime,mintime);

%......................................................

% f_N = input('Insert the desired Nyquist frequency (Hz) (Default = 200 Hz) \n It must be f_N > 100 Hz: ');
% disp(' ');
% if isempty(f_N)
%     f_N = 50;
% end
% 
% f_N = round(f_N);
% if f_N <=50 || ~isscalar(f_N)
%     error('The frequency was not given correctly!');
% end
% 
% maxtime = ceil(max(cellfun(@(x) x(end), data))); % Find the maximum spike-time of all the trains (round up)
% P=20;        % time window length (sec)
% if P >= maxtime
%     error('The time-window is longer than the spike train duration!')
% end
% windows = 0:P:maxtime;
% windows(end) = maxtime; % the last time window will stretch till the last spike time

% prSpikes=cell(size(data));
% 
% for i = 1:size(data,1)*size(data,2)      % for each spike train
%     i
%     for w=2:length(windows)            % for each window
%         t = (data{i} > windows(w-1) & data{i} <= windows(w));
%         tr = data{i}(t);
%         
%         comb = [0:length(windows(w))*2*f_N]';
%         lfp = zeros(length(comb),1);
%         for j = 1:length(tr)
%             k=pi*comb - 2*pi*f_N*tr(j);
%             lfp = lfp + sin(k)./k;
%         end
% 
%         prSpikes{i} = [prSpikes{i};lfp];
% %         plot(windows(w-1)+comb/2*f_N,lfp)
% %         hold on
%     end
% end

