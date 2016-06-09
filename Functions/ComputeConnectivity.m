function output = ComputeConnectivity(input)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calcul de la connectivité entre les 3 structures sur la session entiere de PreTest ou Test
%Possibilité de faire varier la plage de frequence, la taille en seconde des bocs sur lesqeuls est calculée la connectivité
%Possibilité de faire varier l'ordre du modele ainsi que l'overlap entre les different blocs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FileName = input.FileName;
doisave = input.doisave;
fech = input.fech;
freq = input.freq;
delta = input.delta;
theta = input.theta;
G60 = input.G60;
G80 = input.G80;
length_total = input.length_total;
length_bloc = input.length_bloc;
P = input.P;
overlap = input.overlap;

data = input.data;

%%
data = data(1:length_total,:);
% N = size(data,1);
m = size(data,2);
nb_blocs = (length_total/length_bloc-1)/(1-overlap)+1;
nb_blocs = ceil(round(10^2*nb_blocs)/10^2);
debut = zeros(nb_blocs,1);
fin = zeros(nb_blocs,1);
for i = 1:nb_blocs
    debut(i) = (i-1)*(1-overlap)*length_bloc+1;
    fin(i) = ((i-1)*(1-overlap)+1)*length_bloc;
    if fin(i)>length_total
        fin(i) = length_total;
    end
end

debut = double(int64(debut));
fin = double(int64(fin));

%% divide into epoch - WITH START AND STOP
epstart = debut';
epend = fin';
ep_times = [epstart' epend'];
E = size(ep_times,1);                                                   % count the number of epochs...
NN = ep_times;                                               % calculate the data elements that correspond to the ep_times.
if ep_times(1,1) == 0                                                   % (If the 1st-epoch starting time is 0...
    NN = NN + 1;                                                        % then shift all the elements by one...
end
dataep = cell(1,E);
for i = 1:E                                                             % for each epoch...
    dataep{i} = data(NN(i,1):NN(i,2),:);                                % split the data array appropriately
end

%% Allocate memory for variables
Ar = cell(1,E);                                                             % Ar = MVAR coefficients
Af = cell(1,E);                                                             % Af = Fourier transform of Ar
Sigma = cell(1,E);                                                          % Sigma = error covariance matrix
S = cell(1,E);                                                              % S = cross spectral density matrix
H = cell(1,E);                                                              % H = transfer matrix
PDC = cell(1,E);                                                            % PDC
GPDC = cell(1,E);                                                            % GPDC
Signif = cell(1,E);                                                         % Signif = significance level
COH = cell(1,E);                                                            % COH = coherence (take abs for magnitude)
DTF = cell(1,E);                                                            % DTF = directed transfer function
dDTF = cell(1,E);                                                           % dDTF = direct directed transfer function
pCOH = cell(1,E);                                                           % pCOH = partial coherence
% sp = cell(1,E);                                                             % data spectral density (from Neurospec)

for i = 1:E
    mm = mean(dataep{i});                                                   % Calculate the data mean (columnwise)
    mm = repmat(mm,size(dataep{i},1),1);
    dataep{i} = dataep{i} - mm;                                             % and subtract them from the data
end

%% Create MVAR model
for i=1:E
    disp([num2str(i) '/' num2str(E)])
    [AR,~,sigma] = mvar(dataep{i}, P, 2);                                  % Call mvar to perform a MVAR analysis
    
    B = eye(m);
    A = [eye(m),-AR];    % Bring Ar in the appropriate form...
    C = sigma(:,m*P+1:m*(P+1));  % and keep only the last M columns of sigma (noise covariance)
    [AF,s,h,pdc,coh,dtf,pcoh,ddtf,gpdc] = mvfreqz2(B,A,C,freq,fech);   % Call mvfreqz2 (modified by me) to calculate the desired measures
    signif = Significance(dataep{i},AF,C,freq,P,fech);   % Calculate the significance level of PDC
    Ar{i} = AR;
    Af{i} = AF;
    Sigma{i} = sigma;
    S{i} = s;
    H{i} = h;
    PDC{i} = pdc;
    Signif{i} = signif;
    COH{i} = coh;
    DTF{i}= dtf;
    dDTF{i} = ddtf;
    pCOH{i} = pcoh;
    GPDC{i} = gpdc;
end

%% outputs
%%% PSD
PSD_NAC = zeros(length(freq),E);
PSD_BLA = zeros(length(freq),E);
PSD_PFC = zeros(length(freq),E);

%%% PDC
PDC_PFCtoNAC = zeros(length(freq),E);
PDC_PFCtoBLA = zeros(length(freq),E);
PDC_BLAtoNAC = zeros(length(freq),E);
PDC_BLAtoPFC = zeros(length(freq),E);

for i = 1:length(Signif)
    Signif{i} = zeros(size(Signif{i}));
end
for i = 1:E
    PSD_NAC(:,i) = 10*log10(abs(S{i}(1,1,:)));
    PSD_BLA(:,i) = 10*log10(abs(S{i}(2,2,:)));
    PSD_PFC(:,i) = 10*log10(abs(S{i}(3,3,:)));
    PDC_PFCtoNAC(:,i) = PDC{i}(1,3,:)-Signif{i}(1,3,:);
    PDC_PFCtoBLA(:,i) = PDC{i}(2,3,:)-Signif{i}(2,3,:);
    PDC_BLAtoNAC(:,i) = PDC{i}(1,2,:)-Signif{i}(1,2,:);
    PDC_BLAtoPFC(:,i) = PDC{i}(3,2,:)-Signif{i}(3,2,:);
end

%%% Average over delta
output.PDC_PFCtoNAC_meanDelta = mean(PDC_PFCtoNAC(find(freq==delta(1)):find(freq==delta(2)),:));
output.PDC_PFCtoBLA_meanDelta = mean(PDC_PFCtoBLA(find(freq==delta(1)):find(freq==delta(2)),:));
output.PDC_BLAtoNAC_meanDelta = mean(PDC_BLAtoNAC(find(freq==delta(1)):find(freq==delta(2)),:));
output.PDC_BLAtoPFC_meanDelta = mean(PDC_BLAtoPFC(find(freq==delta(1)):find(freq==delta(2)),:));

%%% Average over theta
output.PDC_PFCtoNAC_meanTheta = mean(PDC_PFCtoNAC(find(freq==theta(1)):find(freq==theta(2)),:));
output.PDC_PFCtoBLA_meanTheta = mean(PDC_PFCtoBLA(find(freq==theta(1)):find(freq==theta(2)),:));
output.PDC_BLAtoNAC_meanTheta = mean(PDC_BLAtoNAC(find(freq==theta(1)):find(freq==theta(2)),:));
output.PDC_BLAtoPFC_meanTheta = mean(PDC_BLAtoPFC(find(freq==theta(1)):find(freq==theta(2)),:));

%%% Average over G60
output.PDC_PFCtoNAC_meanG60 = mean(PDC_PFCtoNAC(find(freq==G60(1)):find(freq==G60(2)),:));
output.PDC_PFCtoBLA_meanG60 = mean(PDC_PFCtoBLA(find(freq==G60(1)):find(freq==G60(2)),:));
output.PDC_BLAtoNAC_meanG60 = mean(PDC_BLAtoNAC(find(freq==G60(1)):find(freq==G60(2)),:));
output.PDC_BLAtoPFC_meanG60 = mean(PDC_BLAtoPFC(find(freq==G60(1)):find(freq==G60(2)),:));

%%% Average over G80
output.PDC_PFCtoNAC_meanG80 = mean(PDC_PFCtoNAC(find(freq==G80(1)):find(freq==G80(2)),:));
output.PDC_PFCtoBLA_meanG80 = mean(PDC_PFCtoBLA(find(freq==G80(1)):find(freq==G80(2)),:));
output.PDC_BLAtoNAC_meanG80 = mean(PDC_BLAtoNAC(find(freq==G80(1)):find(freq==G80(2)),:));
output.PDC_BLAtoPFC_meanG80 = mean(PDC_BLAtoPFC(find(freq==G80(1)):find(freq==G80(2)),:));

output.meanmean = [mean(output.PDC_PFCtoNAC_meanDelta)  mean(output.PDC_PFCtoNAC_meanTheta) mean(output.PDC_PFCtoNAC_meanG60)  mean(output.PDC_PFCtoNAC_meanG80) ...
            mean(output.PDC_PFCtoBLA_meanDelta)  mean(output.PDC_PFCtoBLA_meanTheta) mean(output.PDC_PFCtoBLA_meanG60)  mean(output.PDC_PFCtoBLA_meanG80) ...
            mean(output.PDC_BLAtoNAC_meanDelta)  mean(output.PDC_BLAtoNAC_meanTheta) mean(output.PDC_BLAtoNAC_meanG60)  mean(output.PDC_BLAtoNAC_meanG80) ...
            mean(output.PDC_BLAtoPFC_meanDelta)  mean(output.PDC_BLAtoPFC_meanTheta) mean(output.PDC_BLAtoPFC_meanG60)  mean(output.PDC_BLAtoPFC_meanG80)];
        
output.fech = fech;
output.freq = freq;
output.delta = delta;
output.theta = theta;
output.G60 = G60;
output.G80 = G80;
output.length_total = length_total;
output.length_bloc = length_bloc;
output.P = P;
output.overlap = overlap;
output.E = E;

output.PSD_NAC = PSD_NAC;
output.PSD_BLA = PSD_BLA;
output.PSD_PFC = PSD_PFC;
output.PDC_PFCtoNAC = PDC_PFCtoNAC;
output.PDC_PFCtoBLA = PDC_PFCtoBLA;
output.PDC_BLAtoNAC = PDC_BLAtoNAC;
output.PDC_BLAtoPFC = PDC_BLAtoPFC;









