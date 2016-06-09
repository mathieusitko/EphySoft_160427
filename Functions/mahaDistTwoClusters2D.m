function maha = mahaDistTwoClusters2D(x1,y1,x2,y2,aff)
% description de la function

x1mean = mean(x1);
y1mean = mean(y1);
x2mean = mean(x2);
y2mean = mean(y2);

meandiffx = x1mean-x2mean;
meandiffy = y1mean-y2mean;

n1 = length(x1);
n2 = length(x2);
n = n1+n2;

%% center data
x1center = x1-x1mean;
y1center = y1-y1mean;
x2center = x2-x2mean;
y2center = y2-y2mean;

%% covariance
% cov1 = cov(x1center,y1center)
cov1 = 1/(n1)*([x1center y1center]'*[x1center y1center]);
cov2 = 1/(n2)*([x2center y2center]'*[x2center y2center]);

%% pooled covariance matrix
pooledcovmatrix = n1/n*cov1 + n2/n*cov2;
invpooelcovmatrix = inv(pooledcovmatrix);

%% Mahalanobis distance
maha = sqrt([meandiffx;meandiffy]'*invpooelcovmatrix*[meandiffx;meandiffy]);
if aff==1
    figure('color','w');
    subplot(211)
    plot([x1;x2],[y1;y2],'k.')
    axis square
    subplot(212)
    plot(x1,y1,'b.');hold on
    plot(x2,y2,'r.');hold on
    plot(x1mean,y1mean,'ko','linewidth',3,'markerfacecolor','b','markersize',12)
    plot(x2mean,y2mean,'ko','linewidth',3,'markerfacecolor','r','markersize',12)
    axis([min(min(x1),min(x2))-abs(x1mean)/2  max(max(x1),max(x2))+abs(x1mean)/2 min(min(y1),min(y2))-abs(y1mean)/2  max(max(y1),max(y2))+abs(y1mean)/2])
    axis square
    plot([x1mean x2mean],[y1mean y2mean],'k','linewidth',2)
    
    pente = (y2mean-y1mean)/(x2mean-x1mean);
    inclinaison = atand(pente)
    text(mean([x1mean x2mean]),mean([y1mean y2mean]),num2str(round(maha,1)),'rotation',inclinaison,'backgroundcolor','w')
end
