function varargout = Several_PSD(varargin)
% SEVERAL_PSD MATLAB code for Several_PSD.fig
%      SEVERAL_PSD, by itself, creates a new SEVERAL_PSD or raises the existing
%      singleton*.
%
%      H = SEVERAL_PSD returns the handle to a new SEVERAL_PSD or the handle to
%      the existing singleton*.
%
%      SEVERAL_PSD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEVERAL_PSD.M with the given input arguments.
%
%      SEVERAL_PSD('Property','Value',...) creates a new SEVERAL_PSD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Several_PSD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Several_PSD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Several_PSD

% Last Modified by GUIDE v2.5 17-Feb-2016 12:01:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Several_PSD_OpeningFcn, ...
    'gui_OutputFcn',  @Several_PSD_OutputFcn, ...
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

% --------------------------------------------------------------------
function cla_button_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to cla_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in cla_button.
cla(handles.getaxe)
handles.p = [];
handles.var_for_legend = {};
handles.compteur_plot = 0;
guidata(hObject, handles);
legend('off')


% --- Executes just before Several_PSD is made visible.
function Several_PSD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Several_PSD (see VARARGIN)

% Choose default command line output for Several_PSD
handles.output = hObject;
clc

%%%%%%%%%%%%%%%  creation de la liste de couleur  %%%%%%%%%%%%%%%%%%%%
Data(1).name = 'red';         Data(1).Color  = [255 0 0];
Data(2).name = 'orange';      Data(2).Color  = [255 128 0];
Data(3).name = 'yellow';      Data(3).Color  = [255 255 0];
Data(4).name = 'green/yellow';Data(4).Color  = [128 255 0];
Data(5).name = 'green';       Data(5).Color  = [0 255 0];
Data(6).name = 'green/cyan';  Data(6).Color  = [0 255 128];
Data(7).name = 'cyan';        Data(7).Color  = [0 255 255];
Data(8).name = 'blue/cyan';   Data(8).Color  = [0 128 255];
Data(9).name = 'blue';        Data(9).Color  = [0 0 255];
Data(10).name = 'purple';     Data(10).Color = [128 0 255];
Data(11).name = 'magenta';    Data(11).Color = [255 0 255];
Data(12).name = 'black';      Data(12).Color = [0 0 0];
Data(13).name = 'grey';       Data(13).Color = [128 128 128];

pre = '<HTML><FONT color="';
post = '</FONT></HTML>';
listboxStr = cell(numel( Data ),1);
for i = 1:numel( Data )
   str = [pre rgb2Hex( Data(i).Color ) '">' Data(i).name post];
   listboxStr{i} = str;
end
set(handles.listbox_color,'String',listboxStr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%  creation de la liste de couleur  %%%%%%%%%%%%%%%%%%%%
motif{1} = 'Line  -';
motif{2} = 'Dotted line  :';
motif{3} = 'Dashed line  --';
motif{4} = 'Dash-dot line  -.';

set(handles.listbox_symbol,'String',motif)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Several_PSD wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Several_PSD_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function list_animal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function list_session_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function list_lfp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_lfp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function return1_Callback(hObject, eventdata, handles)
% hObject    handle to return1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% main_interface
EPHYSOFT


% --- Executes on button press in display_button.
function display_button_Callback(hObject, eventdata, handles)
% hObject    handle to display_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath(genpath('Functions'))
set(handles.txt_foldername,'String','')
set(handles.list_animal,'Value',1);
set(handles.list_session,'Value',1);
set(handles.list_lfp,'Value',1);
handles.compteur_plot = 0;
handles.var_for_legend = [];

choice = questdlg('Display on CURRENT AXE or on NEW FIGURE?','Axe or Figure','CURRENT AXE','NEW FIGURE','CURRENT AXE');
if strcmp(choice,'NEW FIGURE')
    figure('color','w');
    handles.getaxe = gca;
elseif strcmp(choice,'CURRENT AXE')
    handles.getaxe = handles.axe_plot;
else
    return
end

folder_pathname = uigetdir;
if folder_pathname==0
    return
end

folder_name = folder_pathname(length(pwd)+2:end);
set(handles.txt_foldername,'String',folder_name)
S = what(folder_pathname);
names = sort(lower(S.mat));
animals_names = {};
animalsessionnames = {};
for i = 1:length(names)
    name_tmp = names{i}(1:5);
    idx = regexp(name_tmp,'\w{3}\d{2}', 'once');
    if ~isempty(idx)
        animals_names{end+1,1} =  name_tmp;
        animalsessionnames{end+1,1} = names{i};
    end
end
animals_names = unique(animals_names);
set(handles.list_animal,'String',animals_names);

handles.folder_name = folder_name;
handles.animals_names = animals_names;
handles.animalsessionnames = animalsessionnames;
handles.folder_pathname = folder_pathname;

guidata(hObject, handles);
set(handles.list_lfp,'String',' ');
set(handles.list_session,'String',' ');

% --- Executes on selection change in list_animal.
function list_animal_Callback(hObject, eventdata, handles)
% hObject    handle to list_animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.list_session,'Value',1);
set(handles.list_lfp,'Value',1);
% cla(handles.axe_plot)
if ~strcmp(get(gcf,'SelectionType'),'open')
    return;
end
if ~isfield(handles,'folder_name')
    return
end

if isfield(handles,'names_AD')
    handles = rmfield(handles,'names_AD');
    handles = rmfield(handles,'session_selected_name');
end
if isfield(handles,'sessions')
    handles = rmfield(handles,'sessions');
end

names = get(hObject, 'String');
animal_selected_name = names{get(hObject, 'Value')};
sessions = {};
for i = 1:length(handles.animalsessionnames)
    if strcmp(handles.animalsessionnames{i}(1:5),animal_selected_name)
        sessions{end+1,1} =  handles.animalsessionnames{i};
    end
end
set(handles.list_session,'String',sessions);
handles.sessions = sessions;
guidata(hObject, handles);
set(handles.list_lfp,'String',' ');

% --- Executes on selection change in list_session.
function list_session_Callback(hObject, eventdata, handles)
% hObject    handle to list_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.list_lfp,'Value',1);
if ~strcmp(get(gcf,'SelectionType'),'open')
    return;
end
if ~isfield(handles,'sessions')
    return
end

if isfield(handles,'names_AD')
    handles = rmfield(handles,'names_AD');
    handles = rmfield(handles,'session_selected_name');
end

names = get(hObject, 'String');
session_selected_name = names{get(hObject, 'Value')};
current_folder = pwd;
cd(handles.folder_pathname)
load(session_selected_name)
cd(current_folder)
data = who;
names_AD = {};
for i = 1:length(data)
    if (strcmp(data{i}(1:2),'AD') && length(data{i})==4) ...
            || (length(data{i})>10 && strcmp(data{i}(end-1:end),'an')) % voir si le nom se termine par _lfp_clean
        names_AD{end+1,1} = data{i};
    end
end
set(handles.list_lfp,'String',names_AD);
handles.names_AD = names_AD;
handles.session_selected_name = session_selected_name;
guidata(hObject, handles);

% --- Executes on selection change in list_lfp.
function list_lfp_Callback(hObject, eventdata, handles)
% hObject    handle to list_lfp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~strcmp(get(gcf,'SelectionType'),'open')
    return;
end
if ~isfield(handles,'names_AD')
    return
end
session_for_legend = handles.session_selected_name(1:end-4);
handles.compteur_plot = handles.compteur_plot+1;
current_folder = pwd;
cd(handles.folder_pathname)
load(handles.session_selected_name)
cd(current_folder)

names = get(hObject, 'String');
lfp_selected_name = names{get(hObject, 'Value')};
lfp = eval(lfp_selected_name);
lfp(isnan(lfp)) = [];

%%% PSD calcul
fech = str2double(get(handles.edit_fech,'String'));
fmin = str2double(get(handles.edit_fmin,'String'));
fmax = str2double(get(handles.edit_fmax,'String'));
nfft = str2double(get(handles.edit_nfft,'String'));

win = 4096;
[PSD,freqPSD] = pwelch(lfp,win,[],nfft,fech);

% axes(handles.axe_plot)
axes(handles.getaxe)

hold on
%%% gestion du motif
name_motif = get(handles.listbox_symbol,'String');
method_motif = get(handles.listbox_symbol,'Value');
motif = name_motif{method_motif}(end-2:end);

%%% gestion de la couleur
name_color = get(handles.listbox_color,'String');
method_color = get(handles.listbox_color,'Value');
color = hex2rgb((name_color{method_color}(20:25)))/255;

plot_smooth = get(handles.checkbox_smooth,'Value');
smooth_value = str2double(get(handles.edit_smooth,'String'));
if plot_smooth == 0
    handles.p(handles.compteur_plot) = plot(freqPSD,10*log10(PSD),...
        motif,'color',color,'linewidth',str2double(get(handles.edit_linewidth,'String')));
elseif plot_smooth == 1
    handles.p(handles.compteur_plot) = plot(freqPSD,smooth(10*log10(PSD),smooth_value,'rloess'),...
        motif,'color',color,'linewidth',str2double(get(handles.edit_linewidth,'String')));
end

axis tight
xlim([fmin fmax])
xlabel('Freq (Hz)')
ylabel('Pow (dB)')
hold on
% handles.var_for_legend = [handles.var_for_legend; num2str(handles.compteur_plot)];
session_for_legend(session_for_legend=='_')=' ';
handles.var_for_legend{end+1} =  session_for_legend;
legend(handles.var_for_legend)
guidata(hObject, handles);
% set(gca,'Color', 'none')




% --------------------------------------------------------------------
function delete_last_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to delete_last (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'compteur_plot')
    return
end
if handles.compteur_plot>0
    axes(handles.getaxe)
    delete(handles.p(handles.compteur_plot))
    handles.p(handles.compteur_plot) = [];
    handles.var_for_legend(handles.compteur_plot) = [];
    handles.compteur_plot = handles.compteur_plot-1;
    if ~isempty(handles.var_for_legend)
        legend(handles.var_for_legend)
    else
      legend('off')
    end

    guidata(hObject, handles);
else
    return
end


% --- Executes on selection change in listbox_color.
function listbox_color_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_color


% --- Executes during object creation, after setting all properties.
function listbox_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_symbol.
function listbox_symbol_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_symbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_symbol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_symbol


% --- Executes during object creation, after setting all properties.
function listbox_symbol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_symbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_linewidth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_linewidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_linewidth as text
%        str2double(get(hObject,'String')) returns contents of edit_linewidth as a double


% --- Executes during object creation, after setting all properties.
function edit_linewidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_linewidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function edit_fmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fmin as text
%        str2double(get(hObject,'String')) returns contents of edit_fmin as a double


% --- Executes during object creation, after setting all properties.
function edit_fmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fmax as text
%        str2double(get(hObject,'String')) returns contents of edit_fmax as a double


% --- Executes during object creation, after setting all properties.
function edit_fmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nfft_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nfft as text
%        str2double(get(hObject,'String')) returns contents of edit_nfft as a double


% --- Executes during object creation, after setting all properties.
function edit_nfft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_smooth.
function checkbox_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_smooth



function edit_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_smooth as text
%        str2double(get(hObject,'String')) returns contents of edit_smooth as a double


% --- Executes during object creation, after setting all properties.
function edit_smooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% X=imread('rat.jpg');
% ax = axes('position',[0 0 1 1]);
% imagesc(X);
% uistack(ax,'bottom');
% set(gca, 'Ydir', 'reverse');
% set(gca, 'XTick', []);
% set(gca, 'YTick', []);
