%-----------------------------------------------------------------------
% FUNCTION: aks_plotcausality.m
% PURPOSE:  plot causal connectivity given a matrix of Granger causalities
% 
% INPUTS:   M:  matrix significant Granger causality interactions
%               OR corresponding log F-statistics
%           ntype: if 1, sig Granger causalities, if 2, F-stat values
%           nodename: vector of node labels (optional)
%
% OUTPUT:   none
%          
%           Written by Anil K Seth, March 2004
%           Updated AKS August 2004
%           Updated AKS December 2005
%           Ref: Seth, A.K. (2005) Network: Comp. Neural. Sys. 16(1):35-55
%-----------------------------------------------------------------------
function aks_plotcausality(M,ntype,nodenames, epoch);

%   check input
if(nargin == 1)
    ntype = 1;  % assumed GC matrix
    nodenames = [];
elseif(nargin == 2)
    nodenames = [];
end

FAC = 2;    % scaling factor for F-statistic values
hold off;

% plot nodes
nvar = length(M);
set(gca,'XTickLabel',[]);
angle = (2*pi)/nvar;
X = zeros(nvar,1); Y = zeros(nvar,1);
for i=1:nvar
    X(i) = cos(angle*(i-1));
    Y(i) = sin(angle*(i-1));
end
for i=1:nvar
    h=plot(X(i),Y(i),'.');
    set(h,'Color','k');
    set(h,'MarkerSize',20);
    hold on;
end
XX=X*1.1;
YY=Y*1.1;

% find reciprocal edges
temp = M.*M';
[toinx,frominx] = find(temp);
R = [toinx frominx];
for i=1:length(toinx),
    xf = X(frominx(i)); yf = Y(frominx(i));
    xt = X(toinx(i)); yt = Y(toinx(i));
    h = line([xf xt],[yf yt]);
    if(ntype == 1)
        set(h,'LineWidth',1);
    else
        set(h,'LineWidth',(log(M(toinx(i),frominx(i))))./FAC);
    end
    set(h,'Color',[1 0 0]); % red for reciprocal edge
    %arrowh([xf (xf+xt)/2 ],[yf (yf+yt)/2],'r',300,50);
end
% label nodes
for i=1:nvar
    if(isempty(nodenames))
        h=text(XX(i),YY(i),num2str(i));
    else
        h=text(XX(i),YY(i),nodenames{i});
    end
    set(h,'FontSize',8);
end
set(gca,'Box','off');
axis('square');
axis off;

% find non-reciprocal edges
[x2,y2] = find(M);
nonR = [x2 y2];
nonR = setdiff(nonR,R,'rows');
toinx = nonR(:,1);
frominx = nonR(:,2);

for i=1:length(toinx),
    xf = X(frominx(i)); yf = Y(frominx(i));
    xt = X(toinx(i)); yt = Y(toinx(i));
    h = line([xf xt],[yf yt]);
    if(ntype == 1)
        set(h,'LineWidth',1);
    else
        set(h,'LineWidth',(log(M(toinx(i),frominx(i))))./FAC);
    end
    set(h,'Color',[0 1 0]); % green for non-recip edges
    aks_arrowh([xf (xf+xt)/2 ],[yf (yf+yt)/2],'g',300,50);
end
for i=1:nvar
    if(isempty(nodenames))
        h=text(XX(i),YY(i),num2str(i));
    else
        h=text(XX(i),YY(i),nodenames{i});
    end
    set(h,'FontSize',8);
end
set(gca,'Box','off');
axis('square');
axis off;
if ntype == 1,
    text(-1,-1.25,['Epoch: ', num2str(epoch)]);  % TO ALLAXA AYTO!!!!!!!!!!!
else
    text(-1,-1.25,'weighted by F');
end
xlim([-1.4 1.4]);
ylim([-1.4 1.4]);