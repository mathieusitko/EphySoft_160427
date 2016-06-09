function [Af,S,H,PDC,COH,DTF,pCOH,dDTF,GPDC]=mvfreqz2(B,A,C,f,Fs)
% MVFREQZ multivariate frequency response
% [S,H,PDC,COH,DTF,DC,pCOH,dDTF,ffDTF,pCOH2,PDCF] = mvfreqz(B,A,C,N,Fs)
%
% INPUT:
% =======
% A, B	multivariate polynomials defining the transfer function
%
%    a0*Y(n) = b0*X(n) + b1*X(n-1) + ... + bq*X(n-q)
%                          - a1*Y(n-1) - ... - ap*Y(:,n-p)
%
%  A=[a0,a1,a2,...,ap] and B=[b0,b1,b2,...,bq] must be matrices of
%  size  Mx((p+1)*M) and Mx((q+1)*M), respectively.
%
%  C is the covariance of the input noise X (i.e. D'*D if D is the mixing matrix)
%  N if scalar, N is the number of frequencies
%    if N is a vector, N are the designated frequencies.
%  Fs sampling rate [default 2*pi]
%
%  A,B,C and D can by obtained from a multivariate time series
%       through the following commands:
%  [AR,RC,PE] = mvar(Y,P);
%       M = size(AR,1); % number of channels
%       A = [eye(M),-AR];
%       B = eye(M);
%       C = PE(:,M*P+1:M*(P+1));
%       D = sqrtm(C);
%
% OUTPUT:
% =======
% S   	power spectrum
% PDC 	partial directed coherence
% DC  	directed coupling
% COH 	coherency (complex coherence)
% DTF 	directed transfer function
% pCOH 	partial coherence
% dDTF 	direct Directed Transfer function
% ffDTF full frequency Directed Transfer Function
% pCOH2 partial coherence -alternative method
%
%
% see also: FREQZ, MVFILTER, MVAR
%
%
% REFERENCE(S):
% H. Liang et al. Neurocomputing, 32-33, pp.891-896, 2000.
% L.A. Baccala and K. Samashima, Biol. Cybern. 84,463-474, 2001.
% A. Korzeniewska, et al. Journal of Neuroscience Methods, 125, 195-207, 2003.
% Piotr J. Franaszczuk, Ph.D. and Gregory K. Bergey, M.D.
% 	Fast Algorithm for Computation of Partial Coherences From Vector Autoregressive Model Coefficients
%	World Congress 2000, Chicago.
% Nolte G, Bai O, Wheaton L, Mari Z, Vorbach S, Hallett M.
%	Identifying true brain interaction from EEG data using the imaginary part of coherency.
%	Clin Neurophysiol. 2004 Oct;115(10):2292-307.
% Schlogl A., Supp G.
%       Analyzing event-related EEG data with multivariate autoregressive parameters.
%       (Eds.) C. Neuper and W. Klimesch,
%       Progress in Brain Research: Event-related Dynamics of Brain Oscillations.
%       Analysis of dynamics of brain oscillations: methodological advances. Elsevier.


%	$Id: mvfreqz.m,v 1.2 2006/10/06 08:16:13 schloegl Exp $
%	Copyright (C) 1996-2006 by Alois Schloegl <a.schloegl@ieee.org>
%       This is part of the TSA-toolbox. See also
%       http://hci.tugraz.at/schloegl/matlab/tsa/
%       http://octave.sourceforge.net/
%       http://biosig.sourceforge.net/


% This library is free software; you can redistribute it and/or
% modify it under the terms of the GNU Library General Public
% License as published by the Free Software Foundation; either
% Version 2 of the License, or (at your option) any later version.
%
% This library is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% Library General Public License for more details.
%
% You should have received a copy of the GNU Library General Public
% License along with this library; if not, write to the
% Free Software Foundation, Inc., 59 Temple Place - Suite 330,
% Boston, MA  02111-1307, USA.

[K1,K2] = size(A);                  % K1 = m, K2 = m*(p+1)
p = K2/K1-1;                        % model order

[K1,K2] = size(B);                  % K1 = K2 = m !!
q = K2/K1-1;                        % q = 0 !!!!!!

% if nargin<3
%         C = eye(K1,K1);
% end;
% if nargin<4,
%         N = 512;
% end;
% if nargin<5,
%         Fs = 1;
% end;
% if all(size(N)==1),
%         f = (0:N-1)*(Fs/(2*N));
% else
%        f = N;

ff = length(f);
%end;
z = -1i*2*pi/Fs;

Af=zeros(K1,K1,ff);   %I added that
H=zeros(K1,K1,ff);
G=zeros(K1,K1,ff);
S=zeros(K1,K1,ff);
%S1=zeros(K1,K1,ff);
DTF=zeros(K1,K1,ff);
ffDTF=zeros(K1,K1,ff);
COH=zeros(K1,K1,ff);
%COH2=zeros(K1,K1,N);
PDC=zeros(K1,K1,ff);
PDCF = zeros(K1,K1,ff);
GPDC = zeros(K1,K1,ff);
GOPDC = zeros(K1,K1,ff);
OPDC = zeros(K1,K1,ff);
pCOH = zeros(K1,K1,ff);
%pCOH2 = zeros(K1,K1,ff);
tmp1=zeros(1,K1);
tmp2=zeros(1,K1);
invC=inv(C);

%M = zeros(K1,K1,ff);
%detG = zeros(ff,1);

Cd = diag(diag(C)); % Cd is useful for calculation of DC
invCd = abs(inv(Cd));% invCd is useful for calculation of GPDC

for n=1:ff,  % FOR EACH FREQUENCY!!
    
    atmp = zeros(K1);
    for k = 1:p+1,
        atmp = atmp + A(:,k*K1+(1-K1:0))*exp(z*(k-1)*f(n));
    end
    
    % After the loop has finished: atmp = A(f) (=I-Sum(Ar)*exp)
    Af(:,:,n) = atmp;                                           % Added by me
    
    btmp = zeros(K1);
    for k = 1:q+1,
        btmp = btmp + B(:,k*K1+(1-K1:0))*exp(z*(k-1)*f(n));     % For B=eye(K1,K1)=> q = 0 =>....
    end                                                         % after the loop has finished (in one step):  btmp = I
    H(:,:,n)  = atmp\btmp;                                      % H(f) = inv(A(f))*I = H ((density transfer matrix)
    S(:,:,n)  = H(:,:,n)*C*H(:,:,n)';                           % Cross-Spectral density = H*C*H^Herm
    
    for k1 = 1:K1,
        tmp = squeeze(atmp(:,k1));                              % tmp = the k1 column of matrix A(f)
        tmp1(k1) = sqrt(tmp'*tmp);                              % the denominator of PDC(from k1 to anywhere)
        tmp2(k1) = sqrt(tmp'*invCd*tmp);                         % the denominator of PDCf (from k1 to anywhere)
    end
    PDCF(:,:,n) = abs(atmp)./tmp2(ones(1,K1),:);                % abs(PDCF)     (the denominator is copied in K1 rows so
    PDC(:,:,n)  = abs(atmp)./tmp1(ones(1,K1),:);                % abs(PDC)       the ./-operation works correctly!)
    
%     OPDC(:,:,n)  = (real(atmp).*(imag(atmp))./(tmp1(ones(1,K1),:)).^2); % Aij/(sqrt(aj'*aj))

    GPDC(:,:,n)  = sqrt(invCd)*(atmp)./tmp2(ones(1,K1),:); % Aij/(sqrt(aj'*aj))
%     GOPDC(:,:,n)  = (invCd)*(real(atmp).*(imag(atmp))./(tmp2(ones(1,K1),:)).^2); % Aij/(sqrt(aj'*aj))

    g = atmp/btmp;                                              % g = A(f)
    G(:,:,n) = g'*invC*g;                                       % G = A'*inv(C)*A (will be used for pCOH)
end

for k1=1:K1
    DEN=sum(abs(H(k1,:,:)).^2,2);                               % the denominator of the DTF (from k1 to anywhere, but for all frequencies)
    for k2=1:K2
        COH(k1,k2,:) = (S(k1,k2,:))./sqrt(abs(S(k1,k1,:).*S(k2,k2,:)));  % complex-Coherence (need to make abs(COH).^2 for normal coh)
        DTF(k1,k2,:) = abs(H(k1,k2,:))./sqrt(DEN);                       % Directed Transfer Function
        ffDTF(k1,k2,:) = abs(H(k1,k2,:))./sqrt(sum(DEN,3));              % full-frequency DTF (Kus et al 2004)
        pCOH(k1,k2,:) = abs(G(k1,k2,:).^2)./(G(k1,k1,:).*G(k2,k2,:));    % Partial Coherence squared (as given by Bacc-Sam 2001)
        
    end
end
dDTF = abs(pCOH).*ffDTF;                                             % Direct DTF
