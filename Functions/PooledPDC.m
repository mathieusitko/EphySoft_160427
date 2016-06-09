function [S,PDC,COH,Signif,DTF,dDTF,pCOH] = PooledPDC

% Pool results from different data files. The user chooses the files.
% Pooling corresponds to averaging.S

     s = [];                                                                  % Set up empty structures
   pdc = [];                                                                  %
   coh = [];                                                                  %
signif = [];
   dtf = [];
  ddtf = [];
  pcoh = [];
  spec = [];
    
[FileName,PathName] = uigetfile('*.mat','Select all the Mat-files with the PDC-results data to be plotted','PDCresults_','MultiSelect','on');
exps = length(FileName);                                                    % Open ALL the results files to pool. Exps is their number.

for i=1:exps                                                                % For each of them...
    h = open(fullfile(PathName, FileName{i}));                              % open the file...
   
    pdcTemp = h.PDC;                                                        % get PDC (needed to count the # of m)...
    ep_times = h.ep_times;
    freq = h.freq;
    E = size(ep_times,1);                                                   % Count the number of epochs...
    m = length(pdcTemp{1}(:,:,1));                                   % and the number of data arrays
    if i==1                                                                 % For the first experiment...
        freqTemp = freq;                                                    % Store freq, E and m
        ETemp = E;                                                          % in temporary matrices
        mTemp = m;                                            %
    else                                                                    % In the next steps...
        if freq ~= freqTemp | E ~= ETemp | m ~= mTemp         % if the new variables are not the same as the previous (Temp) ones.. 
            error('The data files you chose do not have the same number of epochs, or m, or frequency range') % then stop!
        end                                                                 % cause the epochs,frequencies or # of m differ in the experimnts
        freqTemp = freq;                                                    % Store the new variables as temporary
        ETemp = E;                                                          % for the next step comparison
        mTemp = m;                                            %
    end
        
    s = [s; h.S];                                                           % Store the new S,PDC,COH etc. cells
    pdc = [pdc; pdcTemp];                                                   % under the ones from previous steps
    coh = [coh; h.COH];                                                     %
    signif = [signif; h.Signif];
    dtf = [dtf; h.DTF];
    ddtf = [ddtf; h.dDTF];
    pcoh = [pcoh; h.pCOH];
    spec = [spec; h.sp];
end

     S = cell(1,E);                                                            % Allocate memory for the pooled data
   PDC = cell(1,E);
   COH = cell(1,E);
Signif = cell(1,E);
   DTF = cell(1,E);
  dDTF = cell(1,E);
  pCOH = cell(1,E);
    sp = cell(1,E);
  
for k=1:E                                                                   % For each epoch...
         S{k} = zeros(m,m,length(freq)) ;                                   % the relevant cell has the same dimension as the cell of S etc.
       PDC{k} = zeros(m,m,length(freq)) ;
       COH{k} = zeros(m,m,length(freq)) ;
    Signif{k} = zeros(m,m,length(freq)) ;
       DTF{k} = zeros(m,m,length(freq)) ;
      dDTF{k} = zeros(m,m,length(freq)) ;
      pCOH{k} = zeros(m,m,length(freq)) ;
        sp{k} = zeros(size(h.sp{1}));
end

for j=1:E                                                                   % For each epoch...
    for i=1:exps                                                            % and each experiment
             S{j} = S{j} + s{i,j}/exps;                                     % add the S of this experiment to the pooled S
           PDC{j} = PDC{j} + pdc{i,j}/exps;                                 % same for all the rest.
           COH{j} = COH{j} + coh{i,j}/exps;                                 
        Signif{j} = Signif{j} + signif{i,j}/exps;
           DTF{j} = DTF{j} + dtf{i,j}/exps;
          dDTF{j} = dDTF{j} + ddtf{i,j}/exps;
          pCOH{j} = pCOH{j} + pcoh{i,j}/exps;
            sp{j} = sp{j} + spec{i,j}/exps;
    end
end

archive.file_names = FileName;
archive.epochs = ep_times;
archive.frequencies = freq';

uisave({'archive','S','PDC','Signif','COH','DTF','dDTF','pCOH','sp','ep_times','freq'},'pooledPDCresults_');

PlotPDC(PDC,COH,S,Signif,ep_times,freq,E,m,2)      % Call plotPDC to plot the pooled measures.
