function [trains,groups,maxtime,mintime,data_names,FileName] = OpenSpikesMAT

% Opens the data file specified by the user, and loads the spike trains
% that belong to each group.
% Output: trains = cell array (groups x m) with the spike times.
%                  (m is the lenght of the longest group)
%         groups = # of groups
%        mintime = minimum spike time
%        maxtime = maximum spike time
%     data_names = string with all the arrays' names
%       FileName = name of the data file

[FileName,PathName] = uigetfile('*.mat','Select the Mat-file with the spike DATA to be processed'); % Let user choose the data file

if isequal(FileName,0)
   error('You did not specify a file')
else
   disp(['Opening file: ', fullfile(PathName, FileName)])
end

h = open(fullfile(PathName, FileName))                                      % Open the file

groups = input('How many groups of spike trains will you process?: ');
groups = round(groups);
data_names = cell(groups,1);                                                % Allocate cell array with the data names (each group has 1 row)
trains = cell(groups,1);                                                    % Allocate SOME memory for the data matrix (will need more columns)...
                                                                            % (Since groups may not have same # of arrays, some cells can be empty)
                                                                            
for j = 1:groups                                                            % For each group
    data_temp = input(['Choose the spike DATA arrays that belong to group ',num2str(j),'\n Write them in a row, separated by spacebars ( ) or commas (,) : '],'s');
    data_temp = deblank(data_temp);
    bars = find(data_temp==' ' | data_temp==',');                           % Write the arrays with the data in a row as a single string...
    m = length(bars)+1;                                                     % from the space/commas between them count the number of arrays (m)

    data_symb = data_temp(1:bars(1)-1);                                     % The 1st array's name is from the 1st letter till the first space/comma
    names = data_symb;                                                      % Store its name.
    trains{j,1} = h.(data_symb);                                            % Assign a cell to it...
    first_spike(j,1) = trains{j,1}(1);                                      % and store the first spike-time
    last_spike(j,1) = trains{j,1}(end);                                     % and the last spike-time
    for i=2:m-1                                                             % For all the other arrays...
        data_symb = data_temp(bars(i-1)+1:bars(i)-1);                       % repeat the procedure.
        names = [names,', ',data_symb];
        trains{j,i} = h.(data_symb);             
        first_spike(j,i) = trains{j,i}(1); 
        last_spike(j,i) = trains{j,i}(end);                                        
    end
    data_symb = data_temp(bars(end)+1:end);                                 % Similar procedure
    names = [names,', ',data_symb];
    trains{j,m} = h.(data_symb);                                         
    first_spike(j,m) = trains{j,m}(1);  
    last_spike(j,m) = trains{j,m}(end);          
    
    data_names{j} = names;                                                  % Store the list of names in a cell
    clear names
end
mintime = min(min(nonzeros(first_spike)));                                  % Find the minimum spike-time
maxtime = max(max(last_spike));                                             % Find the maximum spike-time
                                                                            % (Cant do: ceil(max(max(cellfun(@(x) x(end), trains)))) cause of empty cells)
clear data_temp bars data_symb