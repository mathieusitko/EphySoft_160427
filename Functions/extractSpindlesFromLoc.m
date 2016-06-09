function [start, stop] = extractSpindlesFromLoc(data,loc)

grad = cat(2,0,diff(data));
x = diff(sign(grad));
idxUP = find(x<0);
idxDOWN = find(x>0);

for i = 1:numel(loc)
    [~,idxCorres(i)] = min(abs(loc(i)-idxUP));
end


% if idxCorres(end)==length(idxDOWN)
%     idxCorres(end)=[];
% end

% start = idxDOWN(idxCorres(1:end));
% stop = idxDOWN(idxCorres+1);


for i = 1:length(loc)
    start(i) = idxDOWN(idxCorres(i));
    if idxCorres(i)+1 > length(idxDOWN)
        stop(i) = idxDOWN(idxCorres(i))+100;
    else
        stop(i) = idxDOWN(idxCorres(i)+1);
    end
end

