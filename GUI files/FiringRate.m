function varargout = FiringRate(varargin)
% FIRINGRATE MATLAB code for FiringRate.fig
%      FIRINGRATE, by itself, creates a new FIRINGRATE or raises the existing
%      singleton*.
%
%      H = FIRINGRATE returns the handle to a new FIRINGRATE or the handle to
%      the existing singleton*.
%
%      FIRINGRATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIRINGRATE.M with the given input arguments.
%
%      FIRINGRATE('Property','Value',...) creates a new FIRINGRATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FiringRate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FiringRate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FiringRate

% Last Modified by GUIDE v2.5 29-Jan-2016 16:27:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FiringRate_OpeningFcn, ...
    'gui_OutputFcn',  @FiringRate_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FiringRate is made visible.
function FiringRate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FiringRate (see VARARGIN)

% Choose default command line output for FiringRate
handles.output = hObject;
clc

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FiringRate wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FiringRate_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function returnmain_Callback(hObject, eventdata, handles)
% hObject    handle to returnmain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EPHYSOFT


% --- Executes on button press in disp_button.
function disp_button_Callback(hObject, eventdata, handles)
% hObject    handle to disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath(genpath('Functions'))
set(handles.txt_filename,'String','')
set(handles.listbox_neurons,'Value',1);
set(handles.listbox_event,'Value',1);

% if isfield(handles,'eventvar')
%     handles = rmfield(handles,'eventvar');
%     handles = rmfield(handles,'eventname');
%     guidata(hObject, handles);
% end
% if isfield(handles,'matbin')
%     handles = rmfield(handles,'matbin');
%     guidata(hObject, handles);
% end
% if isfield(handles,'timebin')
%     handles = rmfield(handles,'timebin');
%     guidata(hObject, handles);
% end
% if isfield(handles,'meanFR')
%     handles = rmfield(handles,'meanFR');
%     guidata(hObject, handles);
% end

[file,path] = uigetfile;
chosenfile = [path file];
if path==0
    return
end
lfp_file = load(chosenfile);
names = fieldnames(lfp_file);
names_sig = {};
nb_neurons = 0;
for i = 1:length(names)
    tmp_var = char(names(i));
    if strcmp(tmp_var(1:2),'si') && length(tmp_var)<9
        names_sig{end+1,1} = tmp_var;
        nb_neurons = nb_neurons+1;
    end
    clear tmp_var
end

for i = 1:length(names)
    tmp_var = char(names(i));
    if length(tmp_var)==4 && strcmp(tmp_var(1:2),'AD')
        length_signal = size(lfp_file.(eval('tmp_var')),1);
        break
    end
    clear tmp_var
end

namesEvent = {'<<none>>'};
for i = 1:length(names)
    tmp_var = char(names(i));
    if ~strcmp(tmp_var(1:2),'si') && ~strcmp(tmp_var(1:2),'AD') && ~strcmp(tmp_var(1:2),'Ev') && ~strcmp(tmp_var(1:2),'Ke')
        namesEvent{end+1,1} = tmp_var;
    end
    clear tmp_var
end

set(handles.listbox_neurons, 'String', names_sig);
set(handles.listbox_event, 'String', namesEvent);
set(handles.txt_filename, 'String', file);

handles.length_signal = length_signal;
handles.names_sig = names_sig;
handles.namesEvent = namesEvent;
handles.path = path;
handles.file = file;
guidata(hObject, handles);


% --- Executes on selection change in listbox_event.
function listbox_event_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_event (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_event contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_event
if ~strcmp(get(gcf,'SelectionType'),'open')
    return;
end
if ~isfield(handles,'path')
    errordlg('Please Disp data');
    return
end


% --- Executes during object creation, after setting all properties.
function listbox_event_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_event (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function listbox_neurons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_neurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function binsize_Callback(hObject, eventdata, handles)
% hObject    handle to binsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of binsize as text
%        str2double(get(hObject,'String')) returns contents of binsize as a double


% --- Executes during object creation, after setting all properties.
function binsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fech_Callback(hObject, eventdata, handles)
% hObject    handle to fech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fech as text
%        str2double(get(hObject,'String')) returns contents of fech as a double

% --- Executes during object creation, after setting all properties.
function fech_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in method_menu.
function method_menu_Callback(hObject, eventdata, handles)
% hObject    handle to method_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method_menu


% --- Executes during object creation, after setting all properties.
function method_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compute_button.
function compute_button_Callback(hObject, eventdata, handles)
% hObject    handle to compute_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'path')
    errordlg('Please Disp before');
    return
end
method_name = get(handles.method_menu,'String');
method = method_name(get(handles.method_menu,'Value'));
fech = str2double(get(handles.fech,'String'));
binsize = str2double(get(handles.binsize,'String'));
binsize = binsize*fech;
file = load([handles.path handles.file]);

selection_sig = get(handles.listbox_neurons,'Value');
nbr_sig_selected = size(selection_sig,2);

selection_event = get(handles.listbox_event,'Value');
nbr_event_selected = size(selection_event,2);
if nbr_event_selected>7
    errordlg('Select less events')
    return
end

event = {};
names_for_legend = {'sig'};
for i = 1:nbr_event_selected
    if strcmp(handles.namesEvent{selection_event(i)},'<<none>>')
        break;
    else
        event{i,1} = file.(handles.namesEvent{selection_event(i)});
        names_for_legend{end+1,1} = handles.namesEvent{selection_event(i)};
    end
end

r_vect = [1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10]';
c_vect = [1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9  9 10]';
rc = r_vect.*c_vect;
if nbr_sig_selected>max(rc)
    errordlg('Too much neurons');
    return
end
difference = nbr_sig_selected-rc;
idx = find(difference==0);
if ~isempty(idx)
    idxout = idx;
else
    idxneg = find(difference<0);
    idxout = idxneg(1);
    clear idxneg
end
clear idx
r = r_vect(idxout);
c = c_vect(idxout);

switch char(method)
    case 'Spikes per second'
        figure('color','w');
        for i = 1:nbr_sig_selected
            
            neuron = file.(handles.names_sig{selection_sig(i)});
            [matbin,timebin] = firingRateOverSession(neuron,binsize,handles.length_signal,fech);
            ax(i)=subplot(r,c,i);
            spike_per_second = matbin/binsize*fech;
            linearspace = linspace(mean(spike_per_second)-mean(spike_per_second)/2,mean(spike_per_second)+mean(spike_per_second)/2,nbr_event_selected);
            b = bar(timebin,spike_per_second,'histc');axis tight;hold on
            b(1).EdgeColor = 'k';
            b(1).FaceColor = [.8 .8 .8];
            titleplot = handles.names_sig{selection_sig(i)};
            
            if ~isempty(event)
                color = 'rbkgmcy';
                for j = 1:size(event,1)
                    if ~isempty(event{j}) && ~ischar(event{j})
                        plot(event{j},linearspace(j),[color(j) '.']);hold on
                    end
                end
            end
            for j = 1:length(titleplot)
                if titleplot(j)=='_'
                    titleplot(j)=' ';
                end
            end
            title(titleplot)
            if i>=1 && i<=c
                xlabel('time (ms)')
            end
            if mod(i-1,c)==0
                ylabel('Spikes/second')
            end
            clear matbin timebin neuron b
        end
        linkaxes(ax,'x')
        
    case 'Number of Spikes'
        figure('color','w');
        for i = 1:nbr_sig_selected
            neuron = file.(handles.names_sig{selection_sig(i)});
            [matbin,timebin] = firingRateOverSession(neuron,binsize,handles.length_signal,fech);
            ax(i)=subplot(r,c,i);
            number_of_spikes = matbin;
            linearspace = linspace(mean(number_of_spikes)-mean(number_of_spikes)/2,...
                mean(number_of_spikes)+mean(number_of_spikes)/2,nbr_event_selected);
            b = bar(timebin,number_of_spikes,'histc');axis tight;hold on
            b(1).EdgeColor = 'k';
            b(1).FaceColor = [.8 .8 .8];
            titleplot = handles.names_sig{selection_sig(i)};
            
            if ~isempty(event)
                color = 'rbkgmcy';
                for j = 1:size(event,1)
                    if ~isempty(event{j}) && ~ischar(event{j})
                        plot(event{j},linearspace(j),[color(j) '.']);hold on
                    end
                end
            end
            for j = 1:length(titleplot)
                if titleplot(j)=='_'
                    titleplot(j)=' ';
                end
            end
            title(titleplot)
            if i>=1 && i<=c
                xlabel('time (ms)')
            end
            if mod(i-1,c)==0
                ylabel('Nb spikes')
            end
            clear matbin timebin neuron b
        end
        linkaxes(ax,'x')
        
    case 'Z-score'
        figure('color','w');
        for i = 1:nbr_sig_selected
            neuron = file.(handles.names_sig{selection_sig(i)});
            [matbin,timebin] = firingRateOverSession(neuron,binsize,handles.length_signal,fech);
            ax(i)=subplot(r,c,i);
            meanmatbin = mean(matbin);
            stdmatbin =  std(matbin);
            matbinzscore = (matbin-meanmatbin)/stdmatbin;
            linearspace = linspace(0,max(matbinzscore)/2,nbr_event_selected);
            b = bar(timebin,matbinzscore,'histc');axis tight;hold on
            b(1).EdgeColor = 'k';
            b(1).FaceColor = [.8 .8 .8];
            titleplot = handles.names_sig{selection_sig(i)};
            
            if ~isempty(event)
                color = 'rbkgmcy';
                for j = 1:size(event,1)
                    if ~isempty(event{j}) && ~ischar(event{j})
                        plot(event{j},linearspace(j),[color(j) '.']);hold on
                    end
                end
            end
            plot([timebin(1) timebin(end)],[1.96 1.96],'b:');hold on
            plot([timebin(1) timebin(end)],[-1.96 -1.96],'b:');hold on
            for j = 1:length(titleplot)
                if titleplot(j)=='_'
                    titleplot(j)=' ';
                end
            end
            title(titleplot)
            if i>=1 && i<=c
                xlabel('time (ms)')
            end
            if mod(i-1,c)==0
                ylabel('Z-score')
            end
            clear matbin timebin neuron b
        end
        linkaxes(ax,'x')
end


% --- Executes on button press in clear_button.
function clear_button_Callback(hObject, eventdata, handles)
% hObject    handle to clear_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axe_plot)



% --- Executes on selection change in listbox_neurons.
function listbox_neurons_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_neurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox_neurons contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_neurons
if ~strcmp(get(gcf,'SelectionType'),'open')
    return;
end
if ~isfield(handles,'path')
    errordlg('Please Disp data');
    return
end
cla(handles.axe_plot)
method_name = get(handles.method_menu,'String');
method = method_name(get(handles.method_menu,'Value'));
fech = str2double(get(handles.fech,'String'));
binsize = str2double(get(handles.binsize,'String'));
binsize = binsize*fech;
file = load([handles.path handles.file]);
selection_event = get(handles.listbox_event,'Value');
nbr_event_selected = size(selection_event,2);
if nbr_event_selected>7
    errordlg('Select less events')
    return
end

event = {};
names_for_legend = {'sig'};
for i = 1:nbr_event_selected
    if strcmp(handles.namesEvent{selection_event(i)},'<<none>>')
        break;
    else
        event{i,1} = file.(handles.namesEvent{selection_event(i)});
        names_for_legend{end+1,1} = handles.namesEvent{selection_event(i)};
    end
end

signame = get(hObject, 'Value');
neuron = file.(eval('char(handles.names_sig(signame))'));

switch char(method)
    case 'Spikes per second'
        neuron = file.(handles.names_sig{signame});
        [matbin,timebin] = firingRateOverSession(neuron,binsize,handles.length_signal,fech);
        spike_per_second = matbin/binsize*fech;
        linearspace = linspace(mean(spike_per_second)-mean(spike_per_second)/2,mean(spike_per_second)+mean(spike_per_second)/2,nbr_event_selected);
        b = bar(timebin,spike_per_second,'histc');axis tight;hold on
        b(1).EdgeColor = 'k';
        b(1).FaceColor = [.8 .8 .8];
        titleplot = handles.names_sig{signame};
        
        if ~isempty(event)
            color = 'rbkgmcy';
            for j = 1:size(event,1)
                if ~isempty(event{j}) && ~ischar(event{j})
                    plot(event{j},linearspace(j),[color(j) '.']);hold on
                end
            end
        end
        for j = 1:length(titleplot)
            if titleplot(j)=='_'
                titleplot(j)=' ';
            end
        end
        title(titleplot)
        xlabel('time (s)')
        ylabel('Spikes/second')
        clear matbin timebin neuron b
        
    case 'Number of Spikes'
        neuron = file.(handles.names_sig{signame});
        [matbin,timebin] = firingRateOverSession(neuron,binsize,handles.length_signal,fech);
        number_of_spikes = matbin;
        linearspace = linspace(mean(number_of_spikes)-mean(number_of_spikes)/2,...
            mean(number_of_spikes)+mean(number_of_spikes)/2,nbr_event_selected);
        b = bar(timebin,number_of_spikes,'histc');axis tight;hold on
        b(1).EdgeColor = 'k';
        b(1).FaceColor = [.8 .8 .8];
        titleplot = handles.names_sig{signame};
        
        if ~isempty(event)
            color = 'rbkgmcy';
            for j = 1:size(event,1)
                if ~isempty(event{j}) && ~ischar(event{j})
                    plot(event{j},linearspace(j),[color(j) '.']);hold on
                end
            end
        end
        for j = 1:length(titleplot)
            if titleplot(j)=='_'
                titleplot(j)=' ';
            end
        end
        title(titleplot)
        xlabel('time (s)')
        ylabel('Nb spikes')
        clear matbin timebin neuron b
        
        
    case 'Z-score'
        neuron = file.(handles.names_sig{signame});
        [matbin,timebin] = firingRateOverSession(neuron,binsize,handles.length_signal,fech);
        meanmatbin = mean(matbin);
        stdmatbin =  std(matbin);
        matbinzscore = (matbin-meanmatbin)/stdmatbin;
        linearspace = linspace(0,max(matbinzscore)/2,nbr_event_selected);
        b = bar(timebin,matbinzscore,'histc');axis tight;hold on
        b(1).EdgeColor = 'k';
        b(1).FaceColor = [.8 .8 .8];
        titleplot = handles.names_sig{signame};
        
        if ~isempty(event)
            color = 'rbkgmcy';
            for j = 1:size(event,1)
                if ~isempty(event{j}) && ~ischar(event{j})
                    plot(event{j},linearspace(j),[color(j) '.']);hold on
                end
            end
        end
        plot([timebin(1) timebin(end)],[1.96 1.96],'b:');hold on
        plot([timebin(1) timebin(end)],[-1.96 -1.96],'b:');hold on
        for j = 1:length(titleplot)
            if titleplot(j)=='_'
                titleplot(j)=' ';
            end
        end
        title(titleplot)
        clear matbin timebin neuron b
end
