function varargout = phaseLockingNeurons(varargin)
% PHASELOCKINGNEURONS MATLAB code for phaseLockingNeurons.fig
%      PHASELOCKINGNEURONS, by itself, creates a new PHASELOCKINGNEURONS or raises the existing
%      singleton*.
%
%      H = PHASELOCKINGNEURONS returns the handle to a new PHASELOCKINGNEURONS or the handle to
%      the existing singleton*.
%
%      PHASELOCKINGNEURONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHASELOCKINGNEURONS.M with the given input arguments.
%
%      PHASELOCKINGNEURONS('Property','Value',...) creates a new PHASELOCKINGNEURONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before phaseLockingNeurons_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to phaseLockingNeurons_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help phaseLockingNeurons

% Last Modified by GUIDE v2.5 27-Jan-2016 14:40:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @phaseLockingNeurons_OpeningFcn, ...
    'gui_OutputFcn',  @phaseLockingNeurons_OutputFcn, ...
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


% --- Executes just before phaseLockingNeurons is made visible.
function phaseLockingNeurons_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to phaseLockingNeurons (see VARARGIN)

% Choose default command line output for phaseLockingNeurons
handles.output = hObject;
clc
handles.data = [];
handles.dataclean = [];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes phaseLockingNeurons wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = phaseLockingNeurons_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function return_main_Callback(hObject, eventdata, handles)
% hObject    handle to return_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EPHYSOFT

% --------------------------------------------------------------------
function clean_lfp_Callback(hObject, eventdata, handles)
% hObject    handle to clean_lfp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cleanLFP

% --------------------------------------------------------------------
function spindles_Callback(hObject, eventdata, handles)
% hObject    handle to spindles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spindles6080

% --- Executes during object creation, after setting all properties.
function load_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath(genpath('Functions'))
set(handles.listbox_data,'Value',1);
set(handles.listbox_neurons,'Value',1);
set(handles.txt_loadok, 'String', '');
set(handles.txt_phaselockingok,'String','')
set(handles.txt_save,'String','')
set(handles.txt_filename,'String','')
set(handles.txt_nbneurons, 'String', '');

if isfield(handles,'lfp')
    handles = rmfield(handles,'lfp');
    guidata(hObject, handles);
end
if isfield(handles,'clean')
    handles = rmfield(handles,'clean');
    guidata(hObject, handles);
end
[file,path] = uigetfile;

chosenfile = [path file];
if path==0
    return
end
lfp_file = load(chosenfile);
names = fieldnames(lfp_file);
names_nosig = {};
names_sig = {};
nb_neurons = 0;

for i = 1:length(names)
    tmp_var = char(names(i));
    if strcmp(tmp_var(1:2),'si') && length(tmp_var)<9
        names_sig{end+1,1} = tmp_var;
        nb_neurons = nb_neurons+1;
    elseif ~strcmp(tmp_var(1:2),'si')
        names_nosig{end+1,1} = tmp_var;
    end
    clear tmp_var
end

names_AD = {};
for i = 1:length(names)
    if strcmp(names{i}(1:2),'AD') %&& size(names{i})==4
        names_AD{end+1,1} = names{i};
    end
end

set(handles.txt_nbneurons, 'String', nb_neurons);
set(handles.listbox_data, 'String', names_AD);
set(handles.listbox_neurons, 'String', names_sig);
set(handles.txt_filename,'String',file)

handles.filename = [path file];
handles.file = file;
handles.path = path;
handles.names_sig = names_sig;
handles.names_AD = names_AD;

neurons = {};
for i = 1:length(names_sig)
    neurons{i,1} = lfp_file.(eval('char(names_sig(i))'));
end

handles.neurons = neurons;
guidata(hObject, handles);


% --- Executes on button press in real_load_button.
function real_load_button_Callback(hObject, eventdata, handles)
% hObject    handle to real_load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'filename')
    errordlg('Please Disp before');
    return
end
set(handles.txt_save,'String','')
set(handles.txt_loadok, 'String', '');
set(handles.txt_phaselockingok,'String','')

load(handles.filename);
lfp_name = get(handles.edit_lfp,'String');
clean_name = get(handles.edit_clean,'String');
if exist(lfp_name)
    handles.lfp = eval(lfp_name);
    handles.lfp = handles.lfp(:,1);
    if size(handles.lfp,1)<10000
        errordlg('Wrong LFP');
        return
    end
else
    errordlg('Wrong LFP');
    set(handles.txt_loadok, 'String', '');
    return;
end
if exist(clean_name) && size(eval(clean_name),2)==2
    handles.clean = eval(clean_name);
else
    errordlg('Wrong Clean int.');
    set(handles.txt_loadok, 'String', '');
    return;
end
guidata(hObject, handles);
set(handles.txt_loadok, 'String', 'OK');


% --- Executes on selection change in listbox_data.
function listbox_data_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_data


% --- Executes during object creation, after setting all properties.
function listbox_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_lfp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lfp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lfp as text
%        str2double(get(hObject,'String')) returns contents of edit_lfp as a double

% --- Executes during object creation, after setting all properties.
function edit_lfp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lfp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_clean_Callback(hObject, eventdata, handles)
% hObject    handle to edit_clean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_clean as text
%        str2double(get(hObject,'String')) returns contents of edit_clean as a double


% --- Executes during object creation, after setting all properties.
function edit_clean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_clean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_neurons.
function listbox_neurons_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_neurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_neurons contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_neurons


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



function edit_freqband_Callback(hObject, eventdata, handles)
% hObject    handle to edit_freqband (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_freqband as text
%        str2double(get(hObject,'String')) returns contents of edit_freqband as a double


% --- Executes during object creation, after setting all properties.
function edit_freqband_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_freqband (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in phaselocking_button.
function phaselocking_button_Callback(hObject, eventdata, handles)
% hObject    handle to phaselocking_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'clean') || size(handles.lfp,1)<1000
    errordlg('Please Load before');
    return
end
lfp_name = get(handles.edit_lfp,'String');
plot_histo = get(handles.checkbox_histo,'Value');
set(handles.txt_save,'String','')
set(handles.txt_phaselockingok,'String','')
pause(0.1)
band_char = char(get(handles.edit_freqband,'String'));
for i = 1:size(band_char,1)
    tmp =  str2num(band_char(i,:));
    band(i,1) = tmp(1);
    band(i,2) = tmp(2);
    clear tmp
end

interval = handles.clean;
LFP = handles.lfp;
LFP = LFP(:,1);
freqband = band;
phaseM=zeros(size(freqband,1),length(LFP));
fech = 1000;

for i=1:size(freqband,1)
    H=freqband(i,1)*0.002;
    [h1,h2] = butter(5,H,'high');
    fLFP = filtfilt(h1,h2,LFP);
    L = freqband(i,2)*0.002;
    [l1,l2] = butter(5,L,'low');
    fLFP = filtfilt(l1,l2,fLFP);
    phaseLFP = angle(hilbert(fLFP));
    phaseLFP=5*ceil(2*pi*ceil(20*(phaseLFP)/(2*pi)))/100;
    clean_vect = startstop2vect(interval(:,1),interval(:,2),fech,length(phaseLFP));
    clean_vect(clean_vect==0) = NaN;
    phaseLFP = phaseLFP.*clean_vect;
    phaseM(i,:)=phaseLFP;
end

clear i j n
phase_locking_var = {};
phase_locking_var{1,1} = 'Animal/Session';
phase_locking_var{1,2} = 'AD #';
phase_locking_var{1,3} = 'Sig #';

for i = 1:size(freqband,1)
    phase_locking_var{1,3*i+1} = ['PL ' num2str(freqband(i,1)) '-' num2str(freqband(i,2)) ' Hz'];
    phase_locking_var{1,3*i+2} = 'pval';
    phase_locking_var{1,3*i+3} = 'MRL';
end

for n = 1:length(handles.names_sig)
    if ((plot_histo) == get(handles.checkbox_histo,'Max'))
        fighandle(n) = figure('color','w','name',char(handles.names_sig(n)) );
    end
    for i = 1:size(freqband,1)
        neu = cell2mat(handles.neurons(n));
        phaseneu = phaseM(i,round(neu(neu*fech<length(phaseLFP))*fech));
        [pval,Z] = circTestR(phaseneu(isnan(phaseneu)==0));
        MRL = circResLength(phaseneu(isnan(phaseneu)==0));
        h = hist(phaseneu,20);
        phi = (find(h==max(max(h)))*360/length(h));
        phist(i,n,:) = h;
        ppval(i,n) = pval;
        pmrl(i,n) = MRL;
        pZ(i,n) = Z;
        phase_locking_var{n+1,1} = char(handles.file(1:end-4));
        phase_locking_var{n+1,2} = char(lfp_name);
        phase_locking_var{n+1,3} = char(handles.names_sig(n));
        if pval<0.055
            phase_locking_var{n+1,3*i+1} = 1;
        else
            phase_locking_var{n+1,3*i+1} = 0;
        end
        phase_locking_var{n+1,3*i+2} = pval;
        phase_locking_var{n+1,3*i+3} = MRL;
        
        if ((plot_histo) == get(handles.checkbox_histo,'Max'))
            subplot(1,size(freqband,1),i)
            x = linspace(-pi,3*pi,40);
            b = bar(x,cat(2,hist(phaseneu,20),hist(phaseneu,20))); axis tight
%             rose(phaseneu,20);
            b(1).EdgeColor = 'k';
            b(1).FaceColor = [.8 .8 .8];
            title( sprintf('freqband:%s Rayleigh=%1.3f',num2str(i),ppval(i,n)))
            ax = gca;
            ax.XTick = [-pi,0,pi,2*pi,3*pi];
            ax.XTickLabel = {'-\pi','0','\pi','2\pi','3\pi'};
            xlabel('phase (rad)')
            ylabel('Spike count')
            handles.fighandle = fighandle;
            guidata(hObject, handles);
        end
    end
    set(handles.txt_phaselockingok,'String','OK')
    
end
% save('phaseneu','phaseneu')
for j = 1:size(phase_locking_var,2)
    for i = 1:size(phase_locking_var,1)
        tmp =  phase_locking_var(i,j);
        if isnumeric(cell2mat(tmp))
            phase_locking_var{i,j} = num2str(cell2mat(tmp));
        end
    end
end
set(handles.listbox_results,'FontName','FixedWidth','min',0,'max',1);
formattable(handles.listbox_results,phase_locking_var);

handles.phase_locking_var = phase_locking_var;
handles.freqband = freqband;
guidata(hObject, handles);
            
% --- Executes on selection change in listbox_results.
function listbox_results_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_results contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_results


% --- Executes during object creation, after setting all properties.
function listbox_results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_histo.
function checkbox_histo_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_histo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_histo


% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'fighandle')
%     errordlg('No fig to close');
    return
end
idx = isvalid(handles.fighandle);
close(handles.fighandle(idx==1))


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'path')
    errordlg('Please Compute before');
    return
end
set(handles.txt_save,'String','')

% filename = [handles.path handles.file];
lfp_name = get(handles.edit_lfp,'String');
% 
% var_name_freqband = 'freqband_for_phase_locking';
% var_name_phase_locking_var = ['phase_locking_var_' lfp_name];
% eval([var_name_freqband '=' 'handles.freqband' ';'])
% eval([var_name_phase_locking_var '=' 'handles.phase_locking_var' ';'])
% 
% save(filename,var_name_freqband,var_name_phase_locking_var,'-append')
% set(handles.txt_save,'String','OK')
% foldername = handles.path(length(pwd)+2:end-1)
file = handles.file(1:end-4);
prefix = file(1:3);
var_PL_name = [prefix '_phase_locking.mat'];
var_name_freqband = 'freqband_for_phase_locking';
var_name_phase_locking_var = 'phase_locking';
eval([var_name_freqband '=' 'handles.freqband' ';'])
eval([var_name_phase_locking_var '=' 'handles.phase_locking_var' ';'])
current_folder = pwd;
cd(handles.path)

if ~exist(var_PL_name)
    save(var_PL_name,var_name_freqband,var_name_phase_locking_var)
    cd(current_folder)
else
    S=load(var_PL_name);
    PL = S.(eval('var_name_phase_locking_var'));
    var2concat = eval(var_name_phase_locking_var);
    if size(PL,2)==size(var2concat(2:end,:),2)
        PL = [PL ;var2concat(2:end,:)];
    else
        disp('else')
        cd(current_folder)
        return
    end
    eval([var_name_phase_locking_var '=' 'PL' ';'])
    save(var_PL_name,var_name_freqband,var_name_phase_locking_var)
    cd(current_folder)

end
set(handles.txt_save,'String','OK')



% --------------------------------------------------------------------
function msnfsi_Callback(hObject, eventdata, handles)
% hObject    handle to msnfsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
neuronsClassification


% --- Executes on key press with focus on edit_lfp and none of its controls.
function edit_lfp_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_lfp (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'names_AD')
    return
end
if isfield(handles,'lfp')
    handles = rmfield(handles,'lfp');
    guidata(hObject, handles);
end
if isfield(handles,'clean')
    handles = rmfield(handles,'clean');
    guidata(hObject, handles);
end
set(handles.txt_loadok,'string','');
set(handles.txt_phaselockingok,'string','');

data = handles.data;
if isempty(data)
    if ~strcmp(eventdata.Key,'backspace') && ~strcmp(eventdata.Key,'return') && ~strcmp(eventdata.Key,'delete') && ...
            ~strcmp(eventdata.Key,'rightarrow') && ~strcmp(eventdata.Key,'leftarrow') && ~strcmp(eventdata.Key,'uparrow') && ...
            ~strcmp(eventdata.Key,'downarrow') && ~strcmp(eventdata.Key,'space') && ~strcmp(eventdata.Key,'control') && ...
            ~strcmp(eventdata.Key,'shift') && ~strcmp(eventdata.Key,'windows') && ~strcmp(eventdata.Key,'alt')
        data = [data eventdata.Character];
    end
    
else
    if strcmp(eventdata.Key,'backspace')
        data = data(1:end-1);
    elseif strcmp(eventdata.Key,'delete')
        data = data(2:end);
    elseif ~strcmp(eventdata.Key,'backspace') && ~strcmp(eventdata.Key,'return') && ~strcmp(eventdata.Key,'delete') && ...
            ~strcmp(eventdata.Key,'rightarrow') && ~strcmp(eventdata.Key,'leftarrow') && ~strcmp(eventdata.Key,'uparrow') &&...
            ~strcmp(eventdata.Key,'downarrow') && ~strcmp(eventdata.Key,'space') && ~strcmp(eventdata.Key,'control') && ...
            ~strcmp(eventdata.Key,'shift') && ~strcmp(eventdata.Key,'windows') && ~strcmp(eventdata.Key,'alt')
        data = [data eventdata.Character];
    end
end

if strcmp(eventdata.Key,'rightarrow')
    for i = 1:length(handles.names_AD)
        if length(handles.names_AD{i})>=size(data,2)
            idx(i) = strcmp(data,handles.names_AD{i}(1: size(data,2)));
        else
            idx(i) = 0;
        end
    end
    if isempty(min(find(idx==1)))
        data = [];
    else
        data = handles.names_AD{min(find(idx==1))};
    end
    set(handles.edit_lfp,'str',data);
end
handles.data = data;
guidata(hObject, handles);

% --- Executes on key press with focus on edit_clean and none of its controls.
function edit_clean_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_clean (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'names_AD')
    return
end
if isfield(handles,'lfp')
    handles = rmfield(handles,'lfp');
    guidata(hObject, handles);
end
if isfield(handles,'clean')
    handles = rmfield(handles,'clean');
    guidata(hObject, handles);
end
set(handles.txt_loadok,'string','');
set(handles.txt_phaselockingok,'string','');
dataclean = handles.dataclean;
if isempty(dataclean)
    if ~strcmp(eventdata.Key,'backspace') && ~strcmp(eventdata.Key,'return') && ~strcmp(eventdata.Key,'delete') && ...
            ~strcmp(eventdata.Key,'rightarrow') && ~strcmp(eventdata.Key,'leftarrow') && ~strcmp(eventdata.Key,'uparrow') && ...
            ~strcmp(eventdata.Key,'downarrow') && ~strcmp(eventdata.Key,'space') && ~strcmp(eventdata.Key,'control') && ...
            ~strcmp(eventdata.Key,'shift') && ~strcmp(eventdata.Key,'windows') && ~strcmp(eventdata.Key,'alt')
        dataclean = [dataclean eventdata.Character];
    end
    
else
    if strcmp(eventdata.Key,'backspace')
        dataclean = dataclean(1:end-1);
    elseif strcmp(eventdata.Key,'delete')
        dataclean = dataclean(2:end);
    elseif ~strcmp(eventdata.Key,'backspace') && ~strcmp(eventdata.Key,'return') && ~strcmp(eventdata.Key,'delete') && ...
            ~strcmp(eventdata.Key,'rightarrow') && ~strcmp(eventdata.Key,'leftarrow') && ~strcmp(eventdata.Key,'uparrow') &&...
            ~strcmp(eventdata.Key,'downarrow') && ~strcmp(eventdata.Key,'space') && ~strcmp(eventdata.Key,'control') && ...
            ~strcmp(eventdata.Key,'shift') && ~strcmp(eventdata.Key,'windows') && ~strcmp(eventdata.Key,'alt')
        dataclean = [dataclean eventdata.Character];
    end
end

if strcmp(eventdata.Key,'rightarrow')
    for i = 1:length(handles.names_AD)
        if length(handles.names_AD{i})>=size(dataclean,2)
            idx(i) = strcmp(dataclean,handles.names_AD{i}(1: size(dataclean,2)));
        else
            idx(i) = 0;
        end
    end
    if isempty(min(find(idx==1)))
        dataclean = [];
    else
        dataclean = handles.names_AD{min(find(idx==1))};
    end
    set(handles.edit_clean,'str',dataclean);
end
handles.dataclean = dataclean;
guidata(hObject, handles);
