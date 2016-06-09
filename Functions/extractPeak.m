function [pks ,loc, start, stop] = extractPeak(data,intExclusion)

[pks,loc] = findpeaks(data,'minpeakdistance',intExclusion);
grad = cat(2,0,diff(data));
x = diff(sign(grad));
idxUP = find(x<0);
idxDOWN = find(x>0);
for i = 1:numel(loc)
    idxCorres(i) = find(loc(i) == idxUP);
end

if max(idxCorres)==length(idxUP)
    idxCorres = idxCorres(1:end-1);
    pks = pks(1:end-1);
    loc = loc(1:end-1);
end
start = idxDOWN(idxCorres);
stop = idxDOWN(idxCorres+1);


