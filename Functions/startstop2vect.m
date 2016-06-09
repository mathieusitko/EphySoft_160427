function vect = startstop2vect(start,stop,fech,lengthRef)
%%% Creation d'un vecteur de 1 et de 0 à partir d'intervalle 
%%% entre start et stop --> 1
%%% sinon entre stop et start --> 0

for i=1:size(start,1)
    if start(i,1)==0
        vect(round(start(i)*fech)+1:round(stop(i)*fech),1) = 1;
    else
        vect(round(start(i)*fech):round(stop(i)*fech),1) = 1;
    end
end

if length(vect)>lengthRef
    vect = vect(1:lengthRef);
else
    vect = [vect ;zeros(lengthRef-length(vect),1)];
end