function sp = Spctr_comp(data, S, freq, f_S, sg_power)

% Algorithm for calculating the power spectral densities of the data, using
% algorithms from the the Neurospec 20 package. It plots them along with
% the spectra (S) from the MAR model. 
% sg_power is the segment length (specified as power of 2) for the Fourier
% analysis.
% Output: sp = spectra of all data arrays (stacked columnwise)

% In the frequency array produced by Neurospec, find where (approximately)
% is the user's maximum frequency.........
steps=2^sg_power/2;                                                         % # of frequencies for the Fourier analysis (=half the segment length)
fmax=f_S/2;                                                                 % maximum frequency = Nyquist frequency
Df=fmax/steps;                                                              % length of frequency steps for the Fourier analysis
f_fin=round(freq(end)/Df);                                                  % location on the frequency array of the maximum frequency 
..........................................
m=size(data,2);                                                             % Number of variables (electrodes).
sp=zeros(f_fin,m);                                                          % Allocate memory for the spectra.

% Calculate spectra and plot along with the model-spectra (probably can be
% done much more simply but it works)......................
figure
v=-1;  % These are set...
k=2;   % in case m = 2
l=1;

if m > 2
    k=floor(m/2);
    if rem(m,2) == 1
        k=k+1;
    end
    l=k;
    for v = 1:2:m-2
        [f,t,cl] = sp2a2_m1(0,data(:,v),data(:,v+1),f_S,sg_power,'h');      % Use Neurospec function sp2a2_m1 to calculate spectra
        subplot(k,l,v);
        plot(f(1:f_fin,1),f(1:f_fin,2)+log10(2*pi));                        % Plot them over frequencies (WITH the missing 2pi term!)
        hold on;
        plot(freq,squeeze(log10(abs(S(v,v,:)))),'r');                       % Plot the VAR spectra as well. 
        xlabel('Frequencies (Hz)');ylabel('log(Power Spectral Density)');title(['Electrode ',num2str(v)]);

        subplot(k,l,v+1);
        plot(f(1:f_fin,1),f(1:f_fin,3)+log10(2*pi));
        hold on;
        plot(freq,squeeze(log10(abs(S(v+1,v+1,:)))),'r');
        xlabel('Frequencies (Hz)');ylabel('log(Power Spectral Density)');title(['Electrode ',num2str(v+1)]);
        
        sp(:,v:v+1) = f(1:f_fin,2:3);                                       % Store the spectra.
    end
end

if rem(m,2) == 0
    [f,t,cl] = sp2a2_m1(0,data(:,v+2),data(:,v+3),f_S,sg_power,'h');
    subplot(k,l,v+2);
    plot(f(1:f_fin,1),f(1:f_fin,2)+log10(2*pi));
    hold on;
    plot(freq,squeeze(log10(abs(S(v+2,v+2,:)))),'r');
    xlabel('Frequencies (Hz)');ylabel('log(Power Spectral Density)');title(['Electrode ',num2str(v+2)]);

    subplot(k,l,v+3);
    plot(f(1:f_fin,1),f(1:f_fin,3)+log10(2*pi));
    hold on;
    plot(freq,squeeze(log10(abs(S(v+3,v+3,:)))),'r');
    xlabel('Frequencies (Hz)');ylabel('log(Power Spectral Density)');title(['Electrode ',num2str(v+3)]);
    
    sp(:,v+2:v+3) = f(1:f_fin,2:3);
else
    [f,t,cl] = sp2a2_m1(0,data(:,v+1),data(:,v+2),f_S,sg_power,'h');
    subplot(k,l,v+2);
    plot(f(1:f_fin,1),f(1:f_fin,3)+log10(2*pi));
    hold on;
    plot(freq,squeeze(log10(abs(S(v+2,v+2,:)))),'r');
    xlabel('Frequencies (Hz)');ylabel('log(Power Spectral Density)');title(['Electrode ',num2str(v+2)]);
    
    sp(:,v+2) = f(1:f_fin,3);
end

clear f t cl
