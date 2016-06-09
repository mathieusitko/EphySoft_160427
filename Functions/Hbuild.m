function [R,H] = Hbuild(data,p)

% Calculate the inverse of the covariance matrix, to use it in the
% significance level.
% Output: R = Covariance matrix
%         H = Inverse

m=size(data,2);                                                             % # of variables 
R = cell(p,p);                                                              % Allocate memory for cov. matrix (broken down in cells for each lag)

 % Calculate the 1st row of cells of R.....................................
for lag=0:p-1                                                               % For each lag in the row
    r=zeros(m,m);                                                           % Allocate memory for the cov matrix of that lag
    for i=1:m
        for j=1:m
            r(i,j) = crosscovar(data(:,i),data(:,j),lag);                   % Calculate cross-covariances for all pairs, at that lag
        end
    end
    R{1,lag+1} = r;                                                         % Assign a cell to the cov. matrix
end
% c=cell2mat(rr{:,1});
% r=cell2mat(rr{1,:});
% R=toeplitz(c,r);
%..........................................................................

for i = 2:p                                                                 % For the rest of the cell rows
    for j = 1:i-1                                                           
    R{i,j} = R{j,i}';                                                       % Build the cells before the diagonal (by transposing...)
    end
    R(i,i:p) = R(i-1,i-1:p-1);                                              % And the cells after the diagonal (by copying from the previous row)
end

R=cell2mat(R);                                                              % Turn the cell into a matrix.
H=inv(R);                                                                   % and calculate its inverse.
r=m*ones(1,p);
H = mat2cell(H,r,r);                                                        % Turn the matrix into a cell by breaking it apropriately.
%..........................................................................
%..........................................................................

function [crosscov] = crosscovar(data1,data2,lag)

% Calculate the cross-covariance between 2 data arrays for given lag.

if lag>0                                   % preparation for positive lag case
    data1(end-lag+1:end)=[];
    data2(1:lag)=[];
elseif lag<0                               % preparation for negative lag case
    data2(end-lag+1:end)=[];
    data1(1:lag)=[];
end
crosscov=data1'*data2/length(data1);       % Calculate covariance