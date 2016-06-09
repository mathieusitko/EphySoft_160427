function [A,Sigma_e] = KalmanFilter(signal,modelOrder)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A: Estimated time-varying parameters, A = [A1 A2 ... Ar]
% signal: (L x CH) data matrix
% modelOrder: Model order
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Kalman Filter...')
signal = signal';
nbrChannels = size(signal,1);
taille = size(signal,2);

%%%Initialization
xh = zeros(nbrChannels*modelOrder,taille);     %Initial a-posteriori states
Px = 0.1*eye(nbrChannels*modelOrder);          %Initial a-posteriori state covariance matrix
R = eye(nbrChannels);
Q = 10*eye(nbrChannels);                       %Initial process noise covariance matrix
B = zeros(nbrChannels*modelOrder,nbrChannels); %Relationship between states and the process noise ( x(k) = F[x(k-1)] + B*v(k) )
B(1:nbrChannels,:) = eye(nbrChannels);         %B = [I 0 ... 0]'
C = B';                                        % Measurement matrix

Ah = zeros(nbrChannels*modelOrder,nbrChannels*modelOrder,taille); %Initial a-posteriori parameters estimates
Ah(1:nbrChannels,1:nbrChannels*modelOrder,modelOrder) = .5*randn(nbrChannels,nbrChannels*modelOrder);
for r = 2 : modelOrder
    Ah((r-1)*nbrChannels+1:r*nbrChannels,(r-2)*nbrChannels+1:(r-1)*nbrChannels, modelOrder) = eye(nbrChannels);
end

Pa = eye(nbrChannels*nbrChannels*modelOrder);% Initial a-posteriori parameters covariance matrix

for r = 1 : modelOrder
    xh((r-1)*nbrChannels+1:r*nbrChannels,modelOrder+1) = signal(:,modelOrder-r+1);
end

Sigma_e = zeros(nbrChannels,nbrChannels,taille);

%%% DEKF
for i = modelOrder+1 : taille
    if mod(i,1000)==0
        disp([num2str(i/1000) '/' num2str(taille/1000)])
    end

    [J_x, J_A] = MVAR_JacCSD(Ah(:,:,i-1),xh(:,i-1),modelOrder); % xh(k) = F(A(k-1) * xh(k-1)) = Ah(k-1) * xh(k-1)
    Ah_ = Ah(:,:,i-1); % Ah_(k) = Ah(k-1)
    %%% EKF 1 ---> States estimation
    %---------- Time Update (EKF1) ----------
    Rv = B * Q * B';                          % According to Haykin's book
    xh_ = Ah_ * xh(:,i-1);                    % xh_(k) = A_h(k-1) * xh(k-1)
    Px_ = J_x * Px * J_x' + Rv;               % Px_(k) = A_h(k-1) * Px(k-1) * A_h(k-1)' + B * Q * B'
    
    %---------- Measurement Update (EKF1) ----------
    Rn = R; %R(:,:,i-1);
    Kx = Px_ * C' / (C * Px_ * C' + Rn);             % Kx(k)  = Px_(k) * C' * inv(C * Px_(k) * C' + R)
    Px = (eye(nbrChannels*modelOrder) - Kx * C) * Px_;  % Px(k)  = (I - Kx(k) * C) * Px_(k)
    e = signal(:,i) - C * xh_;                          % inov(k) = y(k) - C * Ah_(k) * xh(k-1)
    xh(:,i) = xh_ + Kx * e;                             % xh(k)  = xh_(k) + Kx(k) * (y(k) - C * xh_(k))
    
    %%% EKF 2 ---> Parameters estimation
    %---------- Time Update (EKF2) ----------
    ah_ = reshape(Ah_(1:nbrChannels,:)',nbrChannels*nbrChannels*modelOrder,1); % ah_ = vec(Ah(k-1))
    Rr = .02*Pa;                                                               % Rr = lambda * Pa(k-1)
    Pa_ = Pa + Rr;                                                             % Pa_(k) = Pa(k-1) + Rr
    %---------- Measurement Update (EKF2) ----------
    H = C * (-J_A);
    Re = (Rn + Q);
    Ka = Pa_ * H' / (H * Pa_ * H' + Re);                        % Ka(k) = Pa_(k) * H(k) * inv(H(k) * Pa_(k) * H(k)' +R + Q)
    Pa = (eye(nbrChannels*nbrChannels*modelOrder) - Ka * H) * Pa_; % Pa(k) = (I - Ka(k) * H(k)) * Pa_(k)
    ah = ah_ + Ka * (signal(:,i)- C * Ah_ * xh(:,i-1));            % ah(k) = ah_(k) + Ka(k) * (y(k) - yh_(k))
    
    % Re-arrange vector ah(k) into the matrix Ah(k)
    Ah(1:nbrChannels,1:nbrChannels*modelOrder,i) = reshape(ah,nbrChannels*modelOrder,nbrChannels)';
    for r = 2 : modelOrder
        Ah((r-1)*nbrChannels+1:r*nbrChannels,(r-2)*nbrChannels+1:(r-1)*nbrChannels, i) = eye(nbrChannels);
    end
    
    Sigma_e(:,:,i) = C * Px_ * C' + R;
end
A = Ah(1:nbrChannels,:,:);
