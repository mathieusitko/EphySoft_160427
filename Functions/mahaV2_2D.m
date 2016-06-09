function [maha1, maha2] = mahaV2_2D(x1,y1,x2,y2)

X = [x1,y1 ; x2,y2];
meanRef = [mean(x1) mean(y1)];
covRef = cov([x1,y1]);
objRef = gmdistribution(meanRef,covRef);
maha = mahal(objRef,X);
maha1 = maha(1:length(x1));
maha2 = maha(length(x1)+1:end);