function [pbic, pfpe,  sbc, fpe] = ModelOrder2(data,pmin,pmax)

% Algorithm for locating the optimal model order according to the Bayesian
% Information Criterion and the Final Prediction Error. It searches between
% orders pmin and pmax.
% Output: pbic = optimal order according to BIC
%         pfpe = optimal order according to FPE
%       logdpbic = det(residual) at pbic
%       logdpfpe = det(residual) at pfpe
%            sbc = BIC for all tested orders
%            fpe = FPE for all tested orders

[N,m] = size(data);

Gamma = zeros(m*(pmax+1));                                                  % Allocate memory
 for v = pmax+1:N                                                           % 
     s = [reshape(flipud(data(v-pmax:v-1,:))',pmax*m,1); data(v,:)'];       % Construct elemnts of the sum used for the Gamma matrix(ARFIT paper,p.39)
     Gamma = Gamma + s*s';                                                  % and add each element of the sum to build Gamma.
 end
 R=chol(Gamma);                                                             % Get the Cholesky factorization of Gamma (eq. 30 of ARFIT paper)

[sbc, fpe, logdp] = arord(R, m, 0, N-pmax, pmin, pmax);                     % Use arord.m of ARFIT for the downdating algirthm...

% figure
% plot(pmin:pmax, sbc, '-ok')
% hold on
% plot(pmin:pmax, fpe, '-sr')
% title('BIC and FPE')

pbic = find(sbc==min(sbc));                                                 % find the order with the minimum BIC (it assumes pmin=1)
pfpe = find(fpe==min(fpe));                                                 % find the order with the minimum FPE (it assumes pmin=1)
% logdpbic = logdp(pbic);                                                     % store the corresponding det(residual)
% logdpfpe = logdp(pfpe);                                                     % for both criteria
pbic = pbic + pmin - 1;                                                     % shift the optimal order by pmin-1
pfpe = pfpe + pmin - 1;