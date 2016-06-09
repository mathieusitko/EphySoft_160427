function [signif]=Significance(data,AF,C,freq,P,Fs)

% Calculate the significance level of PDC according to eqs. (13,17) of
% Schelter et al (2005). The covariance matrix is calculated directly from
% the data.
% Output: signif = the significance level arranged in a (mxmxf) matrix as
%                  is the data matrix.


[N,m]=size(data);
[R,H] = Hbuild(data,P);                                                     % Use Hbuild to build the H matrix

f_len = length(freq);                                                       % (freq = array of frequencies)
CC = zeros(m,m,f_len);                                                      % Allocate memory for the C_ij coefficients (m = # of data arrays)
signif = zeros(m,m,f_len);                                                  % Allocate memory for the significance measure
q = 3.841459;                                                               % Calculate the 0.95 quantile of the chi-square distribution

for i=1:m                                                                   % For every pair...
    for j=1:m                                                               % of data arrays...
        for f = 1:f_len                                                     % and every frequency...
            S=0;
            for k=1:P
                for l=1:P
                    S = S + H{k,l}(j,j)*cos(2*pi*freq(f)*(k-l)/Fs);           % build the quantity in the bracket of eq. (13)... 
                end
            end
            CC(i,j,f) = C(i,i)*S;                                           % and calculate the C_ij(f) coefficient...
            signif(i,j,f) = CC(i,j,f)*q /(sum(abs(AF(:,j,f)).^2));          % and the significance level: (abs(...))=(abs(AF(i,j,f))/PDC(i,j,f))^2
            signif(i,j,f) = sqrt(signif(i,j,f)/N);
        end
    end
end