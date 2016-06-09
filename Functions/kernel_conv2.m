function [pr_sp] = kernel_conv2(spikes,maxtime,mintime,f_N)

% Convolve spike train with a sinc kernel (Nyquist frequency f_N) 
% and sample it at rate f_N.

lcomb = ceil((maxtime-mintime)*2*f_N)+1;                                    % Set the "Dirac comb" length (the +1 is for the 1st point: 0*Dx)
pr_sp = zeros(lcomb,1);                                                     % Allocate memory for convolved spikes

k = round(2*f_N*(spikes-mintime)*1e4)/1e4;                                  % Calculate expression 2*f_N*t_i (rounded) and...

probl = find(rem(k,1)==0);                                                  % find the positions of problematic sampling points and spikes.
if ~isempty(probl)                                                          % If there are any...
    j_probl = k(probl);                                                     % Keep the problematic points
end

k = pi*k;                                                                   % Replace 2*f_N*t_i with pi*(2*f_N*t_i)
sin_spikes = sin(k);                                                        % Compute the sin(2 pi f_N t) for all spikes

if isempty(probl)                                                           % If there aren't any problematic j's
    for j = 0 : lcomb-1                                                     % For each sampling point
        den = pi*j - k;                                                     % Calculate denominator matrix (eq. 3 - Peterka et al 1978)
        kern = sin_spikes./den;                                             % Calculate the sinc fraction of the kernel
        pr_sp(j+1) = (-1)^(j+1)*sum(kern);                                  % Compute the processed spike function at that point
    end
    
else                                                                        % If there are problematic j's
    i=1;
    for j = 0 : lcomb-1                                                     % For each sampling point
        den = pi*j - k;                                                     % Calculate denominator matrix
        
        if j == j_probl(i)                                                  % If j is the i-th problematic point
            den(probl(i)) = 1;                                              % Set the denominator-matrix at the corresponding spike equal to 1;
            kern = sin_spikes./den;                                         % Calculate the fraction (without problems now)
            kern(probl(i)) = (-1)^(j+1);                                    % Correct the problematic element (set it equal to 1)
            if i < length(probl)
                i = i+1;                                                    % Search for the next problematic point
            end
        else
            kern = sin_spikes./den;                                         % Otherwise if j is not problematic, calculate the fraction directly
        end
        pr_sp(j+1) = (-1)^(j+1)*sum(kern);                                   % Compute the processed spike function at that point
    end
end