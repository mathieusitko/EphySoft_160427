function [data,m,N,data_names,FileName]=OpenMAT

% Algorithm for opening a user-specified file and choosing the data arrays
% that the user wishes to analyse. If not all arrays have equal length, the
% longer ones are cut down. 
% Output: data = data arrays (stacked columnwise)
%            m = number of arrays (electrodes)
%            N = length of arrays (after cutting down)
%   data_names = string with all the arrays' names
%     FileName = name of the data file

[FileName,PathName] = uigetfile('*.mat','Select the Mat-file with the DATA to be processed'); 
                                                                            % Let user choose the data file
if isequal(FileName,0)
   error('You did not specify a file')
else
   disp(['Opening file: ', fullfile(PathName, FileName)])
end

h = open(fullfile(PathName, FileName))                                      % Open the file
    
data_temp = input('Choose the DATA arrays you want to process [i.e. electrode channel~AD01]\n Write them in a row, separated by spacebars ( ) or commas (,) : ','s');
data_temp = deblank(data_temp);                                             % Write the arrays with the data in a row as a single string...
bars = find(data_temp==' ' | data_temp==',');                               % from the space/commas between them count the number of arrays (m)
m = length(bars)+1;                                                         
data_length=zeros(1,m);                                                     % for the lengths of all data...
data_symb=cell(1,m);                                                        % and for their name.

data_symb{1} = data_temp(1:bars(1)-1);                                      % The 1st array's name is from the 1st letter till the first space/comma
data_names = data_symb{1};                                                  % Store its name...
data_length(1) = length(h.(data_symb{1}));                                  % and length of the corresponding data array
for i=2:m-1                                                                 % For all the other arrays...
    data_symb{i} = data_temp(bars(i-1)+1:bars(i)-1);                        % repeat the procedure
    data_names = [data_names,', ',data_symb{i}];
    data_length(i) = length(h.(data_symb{i}));
end
data_symb{m} = data_temp(bars(end)+1:end);                                  % Similar procedure... 
data_names = [data_names,', ',data_symb{m}];
data_length(end) = length(h.(data_symb{m}));

N = min(data_length);                                                       % Find the shortest array length...
Data = cell(1,m);
for i=1:m
    Data{i} = h.(data_symb{i})(1:N);                                        % Store all data arrays (up intil that shortest length) in cells
end                                                                         % (It's necessary to go through cells, cause it runs out of memory otherwise)
clear h

data = zeros(N,m);                                                          % Alocate memory for the data matrix...
for i=1:m
    data(:,i) = Data{i};                                                    % create the data matrix
end
if any(data_length~=N)==1                                                   % If not all data arrays had equal length
    disp(' ');                                                              % warn the user that they have been cut down.
    disp('The data arrays have different length. Extra elements have been removed so that');
    disp('they all have the same length. If this is not OK, then break the program here!');
end
clear Data