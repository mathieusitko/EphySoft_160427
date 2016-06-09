function varargout = spindles6080(varargin)
% SPINDLES6080 MATLAB code for spindles6080.fig
%      SPINDLES6080, by itself, creates a new SPINDLES6080 or raises the existing
%      singleton*.
%
%      H = SPINDLES6080 returns the handle to a new SPINDLES6080 or the handle to
%      the existing singleton*.
%
%      SPINDLES6080('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPINDLES6080.M with the given input arguments.
%
%      SPINDLES6080('Property','Value',...) creates a new SPINDLES6080 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spindles6080_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spindles6080_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spindles6080

% Last Modified by GUIDE v2.5 04-Feb-2016 11:12:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @spindles6080_OpeningFcn, ...
    'gui_OutputFcn',  @spindles6080_OutputFcn, ...
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


% --- Executes just before spindles6080 is made visible.
function spindles6080_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spindles6080 (see VARARGIN)

% Choose default command line output for spindles6080
handles.output = hObject;

% Update handles structure
clc
handles.data = [];
handles.dataclean = [];
guidata(hObject, handles);

% UIWAIT makes spindles6080 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = spindles6080_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in disp_button.
function list_box_txt_Callback(hObject, eventdata, handles)
% hObject    handle to disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns disp_button contents as cell array
%        contents{get(hObject,'Value')} returns selected item from disp_button

% --- Executes on selection change in disp_button.
function list_box_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns disp_button contents as cell array
%        contents{get(hObject,'Value')} returns selected item from disp_button


% --- Executes during object creation, after setting all properties.
function disp_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in disp_button.
function disp_button_Callback(hObject, eventdata, handles)
% hObject    handle to disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath(genpath('Functions'))
[file,path] = uigetfile;
set(handles.list_box_txt,'Value',1);

set(handles.compute_txt, 'String', '' );
set(handles.save_txt, 'String', '' );
% set(handles.txt_filename, 'String', '' );

chosenfile = [path file];
if path==0
    return
end
S = load(chosenfile);
names = fieldnames(S);
names_AD = {};
for i = 1:length(names)
    if strcmp(names{i}(1:2),'AD') %&& size(names{i})==4
        names_AD{end+1,1} = names{i};
    end
end

set(handles.list_box_txt, 'String', names_AD);
set(handles.txt_filename, 'String', file );

handles.names_AD = names_AD;
handles.filename = [path file];
handles.file = file;
handles.path = path;
guidata(hObject, handles);


function fech_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fech_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fech_edit as text
%        str2double(get(hObject,'String')) returns contents of fech_edit as a double


% --- Executes during object creation, after setting all properties.
function fech_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fech_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g60_edit_Callback(hObject, eventdata, handles)
% hObject    handle to g60_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g60_edit as text
%        str2double(get(hObject,'String')) returns contents of g60_edit as a double


% --- Executes during object creation, after setting all properties.
function g60_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g60_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g80_edit_Callback(hObject, eventdata, handles)
% hObject    handle to g80_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g80_edit as text
%        str2double(get(hObject,'String')) returns contents of g80_edit as a double


% --- Executes during object creation, after setting all properties.
function g80_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g80_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disp_all_figs_edit_Callback(hObject, eventdata, handles)
% hObject    handle to disp_all_figs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp_all_figs_edit as text
%        str2double(get(hObject,'String')) returns contents of disp_all_figs_edit as a double


% --- Executes during object creation, after setting all properties.
function disp_all_figs_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp_all_figs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fmin_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fmin_edit as text
%        str2double(get(hObject,'String')) returns contents of fmin_edit as a double


% --- Executes during object creation, after setting all properties.
function fmin_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fmax_edit as text
%        str2double(get(hObject,'String')) returns contents of fmax_edit as a double


% --- Executes during object creation, after setting all properties.
function fmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function exc_int_edit_Callback(hObject, eventdata, handles)
% hObject    handle to exc_int_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exc_int_edit as text
%        str2double(get(hObject,'String')) returns contents of exc_int_edit as a double


% --- Executes during object creation, after setting all properties.
function exc_int_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exc_int_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nbr_suboct_edit_Callback(hObject, eventdata, handles)
% hObject    handle to nbr_suboct_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nbr_suboct_edit as text
%        str2double(get(hObject,'String')) returns contents of nbr_suboct_edit as a double


% --- Executes during object creation, after setting all properties.
function nbr_suboct_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbr_suboct_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function analysis_Callback(hObject, eventdata, handles)
% hObject    handle to analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function clean_lfp_menu_Callback(hObject, eventdata, handles)
% hObject    handle to clean_lfp_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cleanLFP


% --------------------------------------------------------------------
function return_menu_Callback(hObject, eventdata, handles)
% hObject    handle to return_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% main_interface
EPHYSOFT



function lfp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lfp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.loadok_txt, 'String', '' );

% Hints: get(hObject,'String') returns contents of lfp_edit as text
%        str2double(get(hObject,'String')) returns contents of lfp_edit as a double


% --- Executes during object creation, after setting all properties.
function lfp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lfp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function clean_edit_Callback(hObject, eventdata, handles)
% hObject    handle to clean_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clean_edit as text
%        str2double(get(hObject,'String')) returns contents of clean_edit as a double


% --- Executes during object creation, after setting all properties.
function clean_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clean_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in spindles_button.
function spindles_button_Callback(hObject, eventdata, handles)
% hObject    handle to spindles_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'filename')
    errordlg('Please Disp before');
    return
end
set(handles.compute_txt, 'String', '' );
set(handles.save_txt, 'String', '' );
set(handles.nbr60_txt, 'String', '');
set(handles.nbr80_txt, 'String', '' );
set(handles.ratio_txt, 'String', '' );
cla(handles.axe_for_wt);
cla(handles.axe_for_lfp);
cla(handles.axe_for_ratiosession)

pause(0.1)

%%% definition des parametres
fech_function = str2double(get(handles.fech_edit,'String'));
g60_band = str2num(get(handles.g60_edit,'String'));
g80_band = str2num(get(handles.g80_edit,'String'));
aff = str2double(get(handles.disp_all_figs_edit,'String'));
fmin = str2double(get(handles.fmin_edit,'String'));
fmax = str2double(get(handles.fmax_edit,'String'));
nbrSubOct = str2double(get(handles.nbr_suboct_edit,'String'));
int_exclu = str2double(get(handles.exc_int_edit,'String'));

%%%%
load(handles.filename);
lfp_name = get(handles.lfp_edit,'String');
clean_name = get(handles.clean_edit,'String');
if exist(lfp_name)
    lfp = eval(lfp_name);
    lfp = lfp(:,1);
else
    errordlg('Wrong LFP');
    return;
end
if exist(clean_name) && size(eval(clean_name),2)==2
    clean_function = eval(clean_name);
%     disp('ici')
else  
    clean_function = [0 size(lfp,1)/fech_function];
%     disp('la')
end
% return

%%% nettoyage du LFP
clean_vect = startstop2vect(clean_function(:,1),clean_function(:,2),fech_function,size(lfp,1));
clean_vect(clean_vect==0) = NaN;
lfp_clean = lfp.*clean_vect;
lfp_clean(isnan(lfp_clean)) = [];
% size(lfp_clean)
% figure;plot(lfp_clean)
% figure;plot(clean_vect)

%%% Spindles
time = (0:1/fech_function:length(lfp_clean)/fech_function-1/fech_function)';
plot(handles.axe_for_lfp,time,lfp_clean,'color',[.8 .8 .8])
xlim(handles.axe_for_lfp,[time(1) time(end)]);
pause(0.1)

% return
% length(lfp_clean)/fech
data_spindles = [time lfp_clean];
spindles = discrimSpindles(data_spindles,g60_band,g80_band,fmin,fmax,nbrSubOct,int_exclu,aff);

axes(handles.axe_for_lfp);
hold on
for i = 1:length(spindles.timePeak60)
    p=plot([time(spindles.start60(i)) time(spindles.stop60(i))],[lfp_clean(spindles.timePeak60(i)) lfp_clean(spindles.timePeak60(i))]);
    set(p,'Color',[0 1 0],'LineWidth',4);hold on
end
for i = 1:length(spindles.timePeak90)
    p=plot([time(spindles.start90(i)) time(spindles.stop90(i))],[lfp_clean(spindles.timePeak90(i)) lfp_clean(spindles.timePeak90(i))]);
    set(p,'Color',[.2 .2 .2],'LineWidth',4);hold on
end

axes(handles.axe_for_wt);
imagesc(time,1:length(spindles.scaleFreq),10*log10(spindles.WT));
caxis([-25 0]);xlim([time(1) time(end)])
pas=4;set(gca,'YTick',1:pas:length(spindles.scaleFreq),'YTickLabel',floor(10^1*(downsample(spindles.scaleFreq,pas)))*10^(-1),'Fontsize',8)
xlim(handles.axe_for_wt,[time(1) time(end)]);

linkaxes([handles.axe_for_lfp handles.axe_for_wt],'x')
set(handles.nbr60_txt, 'String', length(spindles.timePeak60) );
set(handles.nbr80_txt, 'String', length(spindles.timePeak90) );
set(handles.ratio_txt, 'String', round(length(spindles.timePeak60)/length(spindles.timePeak90),3) );
set(handles.compute_txt, 'String', 'OK' );

handles.clean = clean_function;
handles.length_signal = length(lfp_clean);
handles.lfp = lfp_clean;
handles.time = time;
handles.spindles = spindles;
handles.nbr60 = length(spindles.timePeak60);
handles.nbr80 = length(spindles.timePeak90);
handles.ratio6080 = length(spindles.timePeak60)/length(spindles.timePeak90);
guidata(hObject, handles);

% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'file')
    errordlg('Please Compute before');
    return
end
if ~isfield(handles,'nbr60')
    errordlg('Please Compute before');
    return
end
filename = [handles.path handles.file];

lfp_name = get(handles.lfp_edit,'String');
var_name_nbr60 = [lfp_name '_nbr60'];
var_name_nbr80 = [lfp_name '_nbr80'];
var_name_ratio = [ lfp_name '_ratio6080'];
eval([var_name_nbr60 '=' 'handles.nbr60' ';'])
eval([var_name_nbr80 '=' 'handles.nbr80' ';'])
eval([var_name_ratio '=' 'handles.ratio6080' ';'])

% if exist('Results_Spindles','dir')==0
%     mkdir('Results_Spindles')
% end

% cd('Results_Spindles')
% if ~exist([new_filename '.mat'],'file')
%     disp('existe pas')
%     save(new_filename,var_name_nbr60,var_name_nbr80,var_name_ratio,var_name_spindles)
% else
%     disp('existe')
% save(new_filename,var_name_nbr60,var_name_nbr80,var_name_ratio,var_name_spindles,'-append')

save(filename,var_name_nbr60,var_name_nbr80,var_name_ratio,'-append')
file = handles.file(1:end-4);
prefix = file(1:3);
foldername = handles.path(length(pwd)+2:end-1);
if isempty(foldername)
    var_ratio_name = [prefix '_ratio.mat'];
else
    var_ratio_name = [prefix '_ratio.mat'];
end

lfpname = get(handles.lfp_edit,'String');
current_folder = pwd;
cd(handles.path)
if ~exist(var_ratio_name)
    ratio(1,:) = [{'Animal/Session'} {'LFP'} {'Nb60'} {'Nb80'} {'Ratio 60/80'}];
    ratio{end+1,1} = file;
    ratio{end,2} = lfpname;
    ratio{end,3} = handles.nbr60;
    ratio{end,4} = handles.nbr80;
    ratio{end,5} = handles.ratio6080;
    save(var_ratio_name,'ratio')
    cd(current_folder)
else
   S=load(var_ratio_name);
   ratio = S.ratio;
   ratio{end+1,1} = file;
   ratio{end,2} = lfpname;
   ratio{end,3} = handles.nbr60;
   ratio{end,4} = handles.nbr80;
   ratio{end,5} = handles.ratio6080;
   save(var_ratio_name,'ratio')
   cd(current_folder)
end
set(handles.save_txt, 'String', 'OK' );




% --- Executes on key press with focus on lfp_edit and none of its controls.
function lfp_edit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to lfp_edit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'names_AD')
    return
end
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
    set(handles.lfp_edit,'str',data);
end
handles.data = data;
guidata(hObject, handles);


% --- Executes on key press with focus on clean_edit and none of its controls.
function clean_edit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to clean_edit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'names_AD')
    return
end
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
    set(handles.clean_edit,'str',dataclean);
end
handles.dataclean = dataclean;
guidata(hObject, handles);


% --- Executes on button press in checkbox_isi.
function checkbox_isi_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_isi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_isi


% --- Executes on button press in raster_button.
function raster_button_Callback(hObject, eventdata, handles)
% hObject    handle to raster_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'spindles')
    errordlg('Please Compute Before')
    return
end
cla(handles.axe_for_ratiosession)
plot_isi = get(handles.checkbox_isi,'Value');
fech_function = str2double(get(handles.fech_edit,'String'));
timeG60 = handles.spindles.timePeak60/fech_function;
timeG80 = handles.spindles.timePeak90/fech_function;

%%% Spindles Rates over Session
binsize_raster = str2double(get(handles.edit_binraster,'String'));
binsize_raster = fech_function*binsize_raster;
[matbin60,timebin60] = firingRateOverSession(timeG60,binsize_raster,handles.length_signal,fech_function);
[matbin80,timebin80] = firingRateOverSession(timeG80,binsize_raster,handles.length_signal,fech_function);
maxi = max(max(matbin60),max(matbin80));
matbinRatioNorm = (matbin60/maxi)./(matbin80/maxi);
matbinRatioNorm = matbinRatioNorm/max(matbinRatioNorm);
% matbinRatio = (matbin60)./(matbin80);

colour = {[0 .8 0],[.5 .5 .5]};
% axes(handles.axe_for_ratiosession)
figure('color','w')
BarSpecial([(matbin60/maxi)' (matbin80/maxi)'],.95,colour);
pas = str2double(get(handles.edit_pasaxis,'String'));
set(gca,'xtick',1:pas:length(timebin60))
set(gca,'xticklabel',timebin60(1:pas:end))
hold on
plot((1:1:length(timebin60))+0.5,matbinRatioNorm,'b+:','linewidth',1,'markerfacecolor','b');hold on
axis tight

if plot_isi == 1
    %%% Interval Inter Spindles
    maxbin = str2double(get(handles.edit_binmaxisi,'String'));
    binsize = str2double(get(handles.edit_binsizeisi,'String'));
    isi60 = diff(timeG60);
    isi80 = diff(timeG80);
    [counts60,centers60] = hist(isi60,0:binsize/1000:maxbin/1000);
    [counts80,centers80] = hist(isi80,0:binsize/1000:maxbin/1000);
    figure('color','w');
    subplot(221);
    b60 = bar(centers60,counts60,'histc');
    xlim([0 maxbin/1000-binsize/1000]);
    title('Inter SpinG60 Int.');xlabel('time (s)')
    subplot(222);
    b80 = bar(centers80,counts80,'histc');
    xlim([0 maxbin/1000-binsize/1000]);title('Inter SpinG80 Int.')
    b60.EdgeColor = [0 0 0]; b60.FaceColor = [0 .8 0];
    b80.EdgeColor = [0 0 0]; b80.FaceColor = [.5 .5 .5];
    xlabel('time (s)')
    
    %%% Poincaré Maps Spindles
    %%%% G60
    isi_ant60 = isi60(1:end-1);
    isi_post60 = isi60(2:end);
    vector_isi60 = (0:binsize/1000:maxbin/1000)';
    jointISI60 = zeros(length(vector_isi60)-1);
    for i = 1:size(jointISI60,1)
        for j = 1:size(jointISI60,2)
            for k = 1:length(isi_ant60)
                if  (isi_ant60(k)>=vector_isi60(j) && isi_ant60(k)<vector_isi60(j+1)) && (isi_post60(k)>=vector_isi60(i) && isi_post60(k)<vector_isi60(i+1))
                    jointISI60(i,j) = jointISI60(i,j)+1;
                end
            end
        end
    end
    jointISI_filtered60 = imgaussfilt(jointISI60,2);

    subplot(223);
    imagesc((vector_isi60(1)+vector_isi60(2))/2:binsize/1000:(vector_isi60(end-1)+vector_isi60(end))/2,...
        (vector_isi60(1)+vector_isi60(2))/2:binsize/1000:(vector_isi60(end-1)+vector_isi60(end))/2,...
        jointISI_filtered60)
    set(gca,'ydir','normal')
    axis tight
    xlabel('Inter Spin. Int. n');ylabel('Inter Spin. Int. n+1')
    set(gca,'Xtick',0:0.2:maxbin/1000)
    set(gca,'Xticklabel',0:200:maxbin)
    set(gca,'Ytick',0:0.2:maxbin/1000)
    set(gca,'Yticklabel',0:200:maxbin)
    clear i j k
    
    %%%% G80
    isi_ant80 = isi80(1:end-1);
    isi_post80 = isi80(2:end);
    vector_isi80 = (0:binsize/1000:maxbin/1000)';
    jointISI80 = zeros(length(vector_isi80)-1);
    for i = 1:size(jointISI80,1)
        for j = 1:size(jointISI80,2)
            for k = 1:length(isi_ant80)
                if  (isi_ant80(k)>=vector_isi80(j) && isi_ant80(k)<vector_isi80(j+1)) && (isi_post80(k)>=vector_isi80(i) && isi_post80(k)<vector_isi80(i+1))
                    jointISI80(i,j) = jointISI80(i,j)+1;
                end
            end
        end
    end
    clear i j k
    jointISI_filtered80 = imgaussfilt(jointISI80,2);
    
    subplot(224);
    imagesc((vector_isi80(1)+vector_isi80(2))/2:binsize/1000:(vector_isi80(end-1)+vector_isi80(end))/2,...
        (vector_isi80(1)+vector_isi80(2))/2:binsize/1000:(vector_isi80(end-1)+vector_isi80(end))/2,...
        jointISI_filtered80)
    set(gca,'ydir','normal')
    axis tight
    xlabel('Inter Spin. Int. n');ylabel('Inter Spin. Int. n+1')
    set(gca,'Xtick',0:0.2:maxbin/1000)
    set(gca,'Xticklabel',0:200:maxbin)
    set(gca,'Ytick',0:0.2:maxbin/1000)
    set(gca,'Yticklabel',0:200:maxbin)
end

function edit_binsizeisi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_binsizeisi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_binsizeisi as text
%        str2double(get(hObject,'String')) returns contents of edit_binsizeisi as a double


% --- Executes during object creation, after setting all properties.
function edit_binsizeisi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_binsizeisi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_binmaxisi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_binmaxisi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_binmaxisi as text
%        str2double(get(hObject,'String')) returns contents of edit_binmaxisi as a double


% --- Executes during object creation, after setting all properties.
function edit_binmaxisi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_binmaxisi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_binraster_Callback(hObject, eventdata, handles)
% hObject    handle to edit_binraster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_binraster as text
%        str2double(get(hObject,'String')) returns contents of edit_binraster as a double


% --- Executes during object creation, after setting all properties.
function edit_binraster_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_binraster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pasaxis_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pasaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pasaxis as text
%        str2double(get(hObject,'String')) returns contents of edit_pasaxis as a double


% --- Executes during object creation, after setting all properties.
function edit_pasaxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pasaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
