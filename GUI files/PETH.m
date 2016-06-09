function varargout = PETH(varargin)
% PETH MATLAB code for PETH.fig
%      PETH, by itself, creates a new PETH or raises the existing
%      singleton*.
%
%      H = PETH returns the handle to a new PETH or the handle to
%      the existing singleton*.
%
%      PETH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PETH.M with the given input arguments.
%
%      PETH('Property','Value',...) creates a new PETH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PETH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PETH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PETH

% Last Modified by GUIDE v2.5 26-Jan-2016 16:40:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PETH_OpeningFcn, ...
    'gui_OutputFcn',  @PETH_OutputFcn, ...
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


% --- Executes just before PETH is made visible.
function PETH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PETH (see VARARGIN)

% Choose default command line output for PETH
handles.output = hObject;
clc
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PETH wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PETH_OutputFcn(hObject, eventdata, handles)
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
EPHYSOFT

% --- Executes on button press in disp_button.
function disp_button_Callback(hObject, eventdata, handles)
% hObject    handle to disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath(genpath('Functions'))
set(handles.txt_filename, 'String', '');
set(handles.listbox_neurons,'Value',1);

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

namesEvent = {};
for i = 1:length(names)
    tmp_var = char(names(i));
    if ~strcmp(tmp_var(1:2),'si') && ~strcmp(tmp_var(1:2),'AD') && ~strcmp(tmp_var(1:2),'Ev') && ~strcmp(tmp_var(1:2),'Ke')
        namesEvent{end+1,1} = tmp_var;
    end
    clear tmp_var
end

set(handles.listbox_neurons, 'String', names_sig);
set(handles.txt_filename, 'String', file);
set(handles.popup_events, 'String', namesEvent);

handles.length_signal = length_signal;
handles.names_sig = names_sig;
handles.namesEvent = namesEvent;
handles.path = path;
handles.file = file;
guidata(hObject, handles);

function listbox_neurons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_event (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
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
if ~strcmp(get(gcf,'SelectionType'),'open')
    return;
end
if ~isfield(handles,'path')
    errordlg('Please Disp data');
    return
end
cla(handles.axe_plot)
binsize = str2double(get(handles.edit_binsize,'String'));
tbef = str2double(get(handles.edit_tbef,'String'));
taft = str2double(get(handles.edit_taft,'String'));
fech = str2double(get(handles.edit_fech,'String'));

%%% recuperation de l'intervale de nettoyage
int_tmp = get(handles.edit_timeint,'String');
for i = 1:length(int_tmp)
    if strcmp(int_tmp(i),' ')
        idxspace = i;
    end
end
if ~exist('idxspace')
    errordlg('Wrong Time int.');
    return
end
var1 = str2double(int_tmp(1:idxspace-1));
var2 = int_tmp(idxspace+1:end);
if ~strcmp(var2,'end')
    var2 = str2double(int_tmp(idxspace+1:end));
else
    var2 = handles.length_signal/fech;
end
if var1>=var2 || isnan(var2)
    errordlg('Wrong Time int.');
    return
end
if var2>handles.length_signal/fech
    var2 = handles.length_signal/fech;
end
interval = [var1 var2];


signame = get(hObject, 'Value');
chosenfile = [handles.path handles.file];
file = load(chosenfile);
sigvar = file.(eval('char(handles.names_sig(signame))'));
event_name = handles.namesEvent{get(handles.popup_events,'Value')};
eventvar = file.(eval('event_name'));
[matbin,bintime,tevent,nb_event,matbinbef,matbinaft] = ...
    pethFunction(sigvar,eventvar,binsize,tbef,taft,handles.length_signal,fech,interval);

%%% differents affichage: number of spikes, spikes per second, zscore
method_name = get(handles.popup_methods,'String');
method = method_name(get(handles.popup_methods,'Value'));
switch char(method)
    case 'Number of spikes'
        axes(handles.axe_plot)
        b1 = bar(bintime,matbin, 'histc'); hold on;
        b2 = bar(0,tevent,'r','LineWidth',1.5);
        b1.EdgeColor = 'k';b1.FaceColor = [.8 .8 .8];
        b2.EdgeColor = 'r';b2.FaceColor = [1 0 0];
        xlabel('time (ms)')
        ylabel('Nb spikes')
        
    case 'Spikes / second'
        axes(handles.axe_plot)
        b1 = bar(bintime,matbin/binsize*1000/nb_event, 'histc'); hold on;
        b1.EdgeColor = 'k';b1.FaceColor = [.8 .8 .8];
        b2 = bar(0,max(matbin/binsize*1000/nb_event),'r','LineWidth',1.5);
        b2.EdgeColor = 'r';b2.FaceColor = [1 0 0];
        xlabel('time (ms)')
        ylabel('Spikes per second')
        
    case 'Z-score (After event)'
        meanbinbef = mean(matbinbef);
        stdbinbef = std(matbinbef);
        matbinzscore = (matbin - meanbinbef)/stdbinbef;
        axes(handles.axe_plot)
        b1 = bar(bintime,matbinzscore, 'histc'); hold on;
        b1.EdgeColor = 'k';b1.FaceColor = [.8 .8 .8];
        plot([0 0],[min(matbinzscore) max(matbinzscore)],'r','linewidth',2);hold on
        plot([-tbef taft],[1.96 1.96], 'b:');hold on
        plot([-tbef taft],[-1.96 -1.96], 'b:');hold on
        
    case 'Z-score (Before event)'
        disp('In dev')
        
end
handles.matbin = matbin;
handles.matbinbef = matbinbef;
handles.matbinaft = matbinaft;
handles.bintime = bintime;
handles.binsize = binsize;
handles.nb_event = nb_event;
handles.method = method;
guidata(hObject, handles);

% % --- Executes during object creation, after setting all properties.
% function listbox_event_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to listbox_event (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
%
% % Hint: listbox controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
%

function edit_fech_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fech as text
%        str2double(get(hObject,'String')) returns contents of edit_fech as a double


% --- Executes during object creation, after setting all properties.
function edit_fech_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_binsize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_binsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_binsize as text
%        str2double(get(hObject,'String')) returns contents of edit_binsize as a double


% --- Executes during object creation, after setting all properties.
function edit_binsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_binsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tbef_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tbef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tbef as text
%        str2double(get(hObject,'String')) returns contents of edit_tbef as a double


% --- Executes during object creation, after setting all properties.
function edit_tbef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tbef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_taft_Callback(hObject, eventdata, handles)
% hObject    handle to edit_taft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_taft as text
%        str2double(get(hObject,'String')) returns contents of edit_taft as a double


% --- Executes during object creation, after setting all properties.
function edit_taft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_taft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_timeint_Callback(hObject, eventdata, handles)
% hObject    handle to edit_timeint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_timeint as text
%        str2double(get(hObject,'String')) returns contents of edit_timeint as a double


% --- Executes during object creation, after setting all properties.
function edit_timeint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_timeint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_events.
function popup_events_Callback(hObject, eventdata, handles)
% hObject    handle to popup_events (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_events contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_events


% --- Executes during object creation, after setting all properties.
function popup_events_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_events (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_methods.
function popup_methods_Callback(hObject, eventdata, handles)
% hObject    handle to popup_methods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_methods contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_methods


% --- Executes during object creation, after setting all properties.
function popup_methods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_methods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function extract_fig_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to extract_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'method')
    return
else
    tbef = str2double(get(handles.edit_tbef,'String'));
    taft = str2double(get(handles.edit_taft,'String'));
    if strcmp(handles.method,'Number of spikes')
        figure('color','w')
        b1 = bar(handles.bintime,handles.matbin, 'histc'); hold on;
        b2 = bar(0,max(handles.matbin),'r','LineWidth',1.5);hold on
        b1.EdgeColor = 'k';b1.FaceColor = [.8 .8 .8];
        b2.EdgeColor = 'r';b2.FaceColor = [1 0 0];
        xlabel('time (ms)')
        ylabel('Nb spikes')
    elseif strcmp(handles.method,'Spikes / second')
        figure('color','w')
        b1 = bar(handles.bintime,handles.matbin/handles.binsize*1000/handles.nb_event, 'histc'); hold on;
        b1.EdgeColor = 'k';b1.FaceColor = [.8 .8 .8];
        b2 = bar(0,max(handles.matbin/handles.binsize*1000/handles.nb_event),'r','LineWidth',1.5);
        b2.EdgeColor = 'r';b2.FaceColor = [1 0 0];
        xlabel('time (ms)')
        ylabel('Spikes per second')
        
    elseif strcmp(handles.method,'Z-score (After event)')
        figure('color','w')
        meanbinbef = mean(handles.matbinbef);
        stdbinbef = std(handles.matbinbef);
        matbinzscore = (handles.matbin - meanbinbef)/stdbinbef;
        b1 = bar(handles.bintime,matbinzscore, 'histc'); hold on;
        b1.EdgeColor = 'k';b1.FaceColor = [.8 .8 .8];
        plot([0 0],[min(matbinzscore) max(matbinzscore)],'r','linewidth',2);hold on
        plot([-tbef taft],[1.96 1.96], 'b:');hold on
        plot([-tbef taft],[-1.96 -1.96], 'b:');hold on 
        xlabel('time (ms)')
        ylabel('Z-score')
        
        elseif strcmp(handles.method,'Z-score (Before event)')
        disp('In dev.')

    end
end


% --------------------------------------------------------------------
function disp_allsig_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to disp_allsig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'path')
    errordlg('Please Disp data');
    return
end
fech = str2double(get(handles.edit_fech,'String'));
binsize = str2double(get(handles.edit_binsize,'String'));
chosenfile = [handles.path handles.file];
lfp_file = load(chosenfile);
selection_sig = listdlg('PromptString','Select Neurons:','SelectionMode','multiple','ListString',handles.names_sig);
if isempty(selection_sig)
    return
end
r_vect = [1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10]';
c_vect = [1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9  9 10]';
rc = r_vect.*c_vect;
nbr_sig_selected = length(selection_sig);
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

selection_event = listdlg('PromptString','Select Event:','SelectionMode','single','ListString',handles.namesEvent);
if isempty(selection_event)
    return
end
event_tmp = lfp_file.(char(handles.namesEvent(selection_event)));
while size(event_tmp,2)==0 || size(event_tmp,2)>1
    selection_event = listdlg('PromptString','Select Event:','SelectionMode','single','ListString',handles.namesEvent);
    if isempty(selection_event)
        return
    end
    event_tmp = lfp_file.(char(handles.namesEvent(selection_event)));
end
binsize = str2double(get(handles.edit_binsize,'String'));
tbef = str2double(get(handles.edit_tbef,'String'));
taft = str2double(get(handles.edit_taft,'String'));
fech = str2double(get(handles.edit_fech,'String'));

%%% recuperation de l'intervale de nettoyage
int_tmp = get(handles.edit_timeint,'String');
for i = 1:length(int_tmp)
    if strcmp(int_tmp(i),' ')
        idxspace = i;
    end
end
if ~exist('idxspace')
    errordlg('Wrong Time int.');
    return
end
var1 = str2double(int_tmp(1:idxspace-1));
var2 = int_tmp(idxspace+1:end);
if ~strcmp(var2,'end')
    var2 = str2double(int_tmp(idxspace+1:end));
else
    var2 = handles.length_signal/fech;
end
if var1>=var2 || isnan(var2)
    errordlg('Wrong Time int.');
    return
end
if var2>handles.length_signal/fech
    var2 = handles.length_signal/fech;
end
interval = [var1 var2];

selection_method = listdlg('PromptString','Select Event:','SelectionMode','single','ListString',{'Number spikes';'Spikes/second';'Z-score (After event)';'Z-score (Before event)' });


if selection_method==1
    figure('color','w');
    for i = 1:length(selection_sig)
        ax(i) = subplot(r,c,i);
        sigtmp = lfp_file.(char(handles.names_sig(selection_sig(i))));
        [matbin,bintime,tevent,nb_event] = pethFunction(sigtmp,event_tmp,binsize,tbef,taft,handles.length_signal,fech,interval);
        b1 = bar(bintime,matbin, 'histc'); hold on;
        b2 = bar(0,tevent,'r','LineWidth',1.5);
        b1.EdgeColor = 'k';b1.FaceColor = [.8 .8 .8];
        b2.EdgeColor = 'r';b2.FaceColor = [1 0 0];
        if mod(i-1,c)==0
            ylabel('Number of spikes')
        end
        axis tight
        title(char(handles.names_sig(selection_sig(i))))
        clear sigtmp matbin bintime
    end
elseif selection_method==2
    figure('color','w');
    for i = 1:length(selection_sig)
        ax(i) = subplot(r,c,i);
        sigtmp = lfp_file.(char(handles.names_sig(selection_sig(i))));
        [matbin,bintime,tevent,nb_event] = pethFunction(sigtmp,event_tmp,binsize,tbef,taft,handles.length_signal,fech,interval);
        b1 = bar(bintime,matbin/binsize*1000/nb_event, 'histc'); hold on;
        b2 = bar(0,max(matbin/binsize*1000/nb_event),'r','LineWidth',1.5);
        b1.EdgeColor = 'k';b1.FaceColor = [.8 .8 .8];
        b2.EdgeColor = 'r';b2.FaceColor = [1 0 0];
        if mod(i-1,c)==0
            ylabel('Spikes/second (Hz)')
        end
        axis tight
        title(char(handles.names_sig(selection_sig(i))))
        clear sigtmp matbin bintime
    end
elseif selection_method==3
    disp('zscoreafter')
    figure('color','w');
    for i = 1:length(selection_sig)
        ax(i) = subplot(r,c,i);
        sigtmp = lfp_file.(char(handles.names_sig(selection_sig(i))));
        [matbin,bintime,tevent,nb_event,matbinbef,matbinaft] = pethFunction(sigtmp,event_tmp,binsize,tbef,taft,handles.length_signal,fech,interval);
        meanbinbef = mean(matbinbef);
        stdbinbef = std(matbinbef);
        matbinzscore = (matbin - meanbinbef)/stdbinbef;
        b1 = bar(bintime,matbinzscore, 'histc'); hold on;
        b1.EdgeColor = 'k';b1.FaceColor = [.8 .8 .8];
        plot([0 0],[min(matbinzscore) max(matbinzscore)],'r','linewidth',2);hold on
        plot([-tbef taft],[1.96 1.96], 'b:');hold on
        plot([-tbef taft],[-1.96 -1.96], 'b:');hold on 
        if mod(i-1,c)==0
            ylabel('Z-score')
        end
    end
    
elseif selection_method==4
   disp('In dev')
   
else
    return
end
