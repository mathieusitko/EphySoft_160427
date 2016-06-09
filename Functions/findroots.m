function [z] = findroots(AR,m,P)

% Finds the magnitude of the eigenvalues of the AR matrix (for MAINPDC to
% check for model stability). The eigenvalues are rounded to the 3rd decimal.

A=[AR; eye((P-1)*m), zeros((P-1)*m,m)];                      % Create the A matrix from all the MAR coefficients (Lutkepohl, eq. 2.1.8, p-15)
z = abs(eig(A));                                             % Calculate the magnitude of its eigenvalues.
z = round(z*1000)/1000;                                      % Round it on the third decimal point             
