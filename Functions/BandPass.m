function singnalFiltered = BandPass(signal,fech, f1, f2,order)
% METTRE LES FREQUENCES DANS L'ORDRE CROISSANT
% f1  = fréquence pour le filtrage passe haut
% f2  = fréquence pour le filtrage passe bas

singnalFiltered = HighPass(signal,fech, f1,order);
singnalFiltered = LowPass(singnalFiltered,fech, f2,order);