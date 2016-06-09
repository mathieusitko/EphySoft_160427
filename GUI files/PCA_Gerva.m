function varargout = PCA_Gerva(varargin)
% PCA_GERVA MATLAB code for PCA_Gerva.fig
%      PCA_GERVA, by itself, creates a new PCA_GERVA or raises the existing
%      singleton*.
%
%      H = PCA_GERVA returns the handle to a new PCA_GERVA or the handle to
%      the existing singleton*.
%
%      PCA_GERVA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCA_GERVA.M with the given input arguments.
%
%      PCA_GERVA('Property','Value',...) creates a new PCA_GERVA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PCA_Gerva_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PCA_Gerva_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PCA_Gerva

% Last Modified by GUIDE v2.5 26-Feb-2016 10:32:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PCA_Gerva_OpeningFcn, ...
    'gui_OutputFcn',  @PCA_Gerva_OutputFcn, ...
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


% --- Executes just before PCA_Gerva is made visible.
function PCA_Gerva_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PCA_Gerva (see VARARGIN)

% Choose default command line output for PCA_Gerva
handles.output = hObject;
clc
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PCA_Gerva wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PCA_Gerva_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function return_main_Callback(hObject, eventdata, handles)
% hObject    handle to return_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EPHYSOFT


% --- Executes on button press in display_button.
function display_button_Callback(hObject, eventdata, handles)
% hObject    handle to display_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath(genpath('Functions'))
set(handles.txt_file,'String','')
set(handles.list_animal,'Value',1);
set(handles.list_session,'Value',1);
set(handles.txt_computeok,'String','')
set(handles.txt_pc1,'string','')
set(handles.txt_pc2,'string','')

folder_pathname = uigetdir;
if folder_pathname==0
    return
end

folder_name = folder_pathname(length(pwd)+2:end);
set(handles.txt_file,'String',folder_name)
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
set(handles.list_session,'String',' ');
guidata(hObject, handles);


% --- Executes on selection change in list_animal.
function list_animal_Callback(hObject, eventdata, handles)
% hObject    handle to list_animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.list_session,'Value',1);
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
set(handles.txt_pc1,'string','')
set(handles.txt_pc2,'string','')
set(handles.list_session,'String',sessions);
set(handles.txt_computeok,'String','');

handles.sessions = sessions;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function list_animal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in list_session.
function list_session_Callback(hObject, eventdata, handles)
% hObject    handle to list_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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

% --- Executes on button press in compute_button.
function compute_button_Callback(hObject, eventdata, handles)
% hObject    handle to compute_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'folder_pathname')
    errordlg('Please Display before');
    return
end
compute_option = get(handles.uibuttongroup1,'SelectedObject');
compute_option_name = compute_option.String;
% return

fech = str2double(get(handles.edit_fech,'String'));
band1 = str2num(get(handles.edit_band1,'String'));
band2 = str2num(get(handles.edit_band2,'String'));
% fmin = str2double(get(handles.edit_band1,'String'));
% fmax = str2double(get(handles.edit_band2,'String'));
nbrSubOct = str2double(get(handles.edit_nbrsuboct,'String'));
subFactor = str2double(get(handles.edit_timefactor,'String'));

set(handles.txt_pc1,'string','')
set(handles.txt_pc2,'string','')
set(handles.txt_computeok,'String','')
pause(0.1)
selected_sessions = get(handles.list_session,'value');
current_folder = pwd;

%%%% Step1: creation d'une fenetre de choix des LFP
Title = 'LFP Choice';
Options.Resize = 'on';
Options.AlignControls = 'on';
Options.Interpreter = 'none';
Prompt = {};
Formats = {};
%%% mettre le nom des sessions choisies en entete
for i = 1:length(selected_sessions)
    tmp_name = handles.sessions{selected_sessions(i)}(1:end-4);
    Prompt(end+1,:) = {tmp_name,[],[]};
    Formats(1,i).type = 'text';
    Formats(1,i).size = [-1 -1];
    clear tmp_*
end
%%% pour chaque sesion choisie on affiche tous les LFP de la session
%%% permet de selectionner un LFP par session
for i = 1:length(selected_sessions)
    set(handles.txt_computeok,'String',['Load ' num2str(i) '/' num2str(length(selected_sessions))])
    pause(0.1)
    cd(handles.folder_pathname)
    tmp_file = load(handles.sessions{selected_sessions(i)});
    tmp_names = fieldnames(tmp_file);
    cd(current_folder)
    tmp_names_LFP = {};
    for j = 1:length(tmp_names)
        if (strcmp(tmp_names{j}(1:2),'AD') && length(tmp_names{j})==4) ...
                || (length(tmp_names{j})>10 && strcmp(tmp_names{j}(end-1:end),'an')) % voir si le nom se termine par _lfp_clean
            tmp_names_LFP{end+1,1} = tmp_names{j};
        end
    end
    champ = ['name' num2str(i)];
    Prompt(end+1,:) = {[],champ,[]};
    Formats(2,i).type = 'list';
    Formats(2,i).style = 'listbox';
    Formats(2,i).format = 'text';
    Formats(2,i).items = tmp_names_LFP;
    Formats(2,i).limits = [0 1];
    Formats(2,i).size = [75 300];
DefAns.(eval('champ')) = Formats(2,i).items(1);
    clear tmp_*
end
[Answer,Cancelled] = inputsdlg(Prompt,Title,Formats,DefAns,Options);
if Cancelled==1
    return;
end
Answer = struct2cell(Answer);
set(handles.txt_computeok,'String','Load OK')

if strcmp(compute_option_name,'Band1: pc1 vs pc2')

    %%% Une fois tous les LFP selectionnés, on calcule pour chaque session la
    %%% WT du LFP et on la concatene dans la Wx_concat
    Wx_concat = [];
    taille = [];
    fmin = band1(1);
    fmax = band1(2);
    for i = 1:length(Answer)
        set(handles.txt_computeok,'String',['Compute ' num2str(i) '/' num2str(length(Answer))])
        pause(0.1)
        cd(handles.folder_pathname)
        tmp_file = load(handles.sessions{selected_sessions(i)});
        tmp_names = fieldnames(tmp_file);
        cd(current_folder)
        tmp_lfp = tmp_file.(eval('char(Answer{i})'));
        tmp_lfp(isnan(tmp_lfp)) = [];
        lfp_for_gerva{i,1} = handles.sessions{selected_sessions(i)}(1:end-4);
        lfp_for_gerva{i,2} = tmp_lfp;
        lfp_for_gerva{i,3} = length(tmp_lfp);
        lfp_for_gerva{i,4} = char(Answer{i});
        tmp_time = (0:1/fech:length(tmp_lfp)/fech-1/fech)';
        [tmp_Wx,tmp_period] = wt([tmp_time tmp_lfp],fmin,fmax,nbrSubOct);
        tmp_Wx = (abs(tmp_Wx)).^2;
        tmp_Wx = 10*log10(tmp_Wx);
        freq = 1./(2.^(log2(tmp_period)))';
        tmp_newlength = round(size(tmp_Wx,2)/subFactor);
        for j = 1:tmp_newlength
            if j*subFactor <= size(tmp_Wx,2)
                tmp_Wxmoy(:,j) = mean(tmp_Wx(:,(j-1)*subFactor+1:j*subFactor),2);
            else
                tmp_Wxmoy(:,j) = mean(tmp_Wx(:,(j-1)*subFactor+1:end),2);
            end
        end
        Wx_concat = [Wx_concat tmp_Wxmoy];
        taille(i,1) = size(Wx_concat,2);
        clear tmp_*
    end
    newTime = (0:1/fech*subFactor:size(Wx_concat,2)/fech*subFactor-1/fech*subFactor)';
%         figure;imagesc(Wx_concat)

    %%% Step3: Calcul de la PCA et de la variabilité
    [~,score,latent] = princomp(Wx_concat','econ');
    pc1 = score(:,1);
    pc2 = score(:,2);
    percent_pc1 = round(latent(1)/sum(latent)*100);
    percent_pc1_pc2 = round(latent(1)/sum(latent)*100+latent(2)/sum(latent)*100);
    set(handles.txt_pc1,'string',num2str(percent_pc1))
    set(handles.txt_pc2,'string',num2str(percent_pc1_pc2))
    
    %%% Mise à jour du handles
    handles.new_time = newTime;
    handles.taille = taille;
    handles.pc1 = pc1;
    handles.pc2 = pc2;
    handles.lfp_for_gerva = lfp_for_gerva;
    guidata(hObject, handles);
    set(handles.txt_computeok,'String','Compute OK')
    
elseif strcmp(compute_option_name,'Band1 vs Band2')
    Wx_concat_1 = [];
    taille = [];
    fmin_1 = band1(1);
    fmax_1 = band1(2);
    for i = 1:length(Answer)
        set(handles.txt_computeok,'String',['Compute B1 ' num2str(i) '/' num2str(length(Answer))])
        pause(0.1)
        cd(handles.folder_pathname)
        tmp_file = load(handles.sessions{selected_sessions(i)});
        tmp_names = fieldnames(tmp_file);
        cd(current_folder)
        tmp_lfp = tmp_file.(eval('char(Answer{i})'));
        tmp_lfp(isnan(tmp_lfp)) = [];
        lfp_for_gerva{i,1} = handles.sessions{selected_sessions(i)}(1:end-4);
        lfp_for_gerva{i,2} = tmp_lfp;
        lfp_for_gerva{i,3} = length(tmp_lfp);
        lfp_for_gerva{i,4} = char(Answer{i});
        tmp_time = (0:1/fech:length(tmp_lfp)/fech-1/fech)';
        [tmp_Wx_1,tmp_period] = wt([tmp_time tmp_lfp],fmin_1,fmax_1,nbrSubOct);
        tmp_Wx_1 = (abs(tmp_Wx_1)).^2;
        tmp_Wx_1 = 10*log10(tmp_Wx_1);
        freq = 1./(2.^(log2(tmp_period)))';
        tmp_newlength = round(size(tmp_Wx_1,2)/subFactor);
        for j = 1:tmp_newlength
            if j*subFactor <= size(tmp_Wx_1,2)
                tmp_Wxmoy_1(:,j) = mean(tmp_Wx_1(:,(j-1)*subFactor+1:j*subFactor),2);
            else
                tmp_Wxmoy_1(:,j) = mean(tmp_Wx_1(:,(j-1)*subFactor+1:end),2);
            end
        end
        Wx_concat_1 = [Wx_concat_1 tmp_Wxmoy_1];
        taille(i,1) = size(Wx_concat_1,2);
        clear tmp_*
%         figure;imagesc(Wx_concat_1)
    end
    
    Wx_concat_2 = [];
    fmin_2 = band2(1);
    fmax_2 = band2(2);
    for i = 1:length(Answer)
        set(handles.txt_computeok,'String',['Compute B2 ' num2str(i) '/' num2str(length(Answer))])
        pause(0.1)
        cd(handles.folder_pathname)
        tmp_file = load(handles.sessions{selected_sessions(i)});
        tmp_names = fieldnames(tmp_file);
        cd(current_folder)
        tmp_lfp = tmp_file.(eval('char(Answer{i})'));
        tmp_lfp(isnan(tmp_lfp)) = [];
%         size(tmp_lfp)
        tmp_time = (0:1/fech:length(tmp_lfp)/fech-1/fech)';
        [tmp_Wx_2,tmp_period] = wt([tmp_time tmp_lfp],fmin_2,fmax_2,nbrSubOct);
        tmp_Wx_2 = (abs(tmp_Wx_2)).^2;
        tmp_Wx_2 = 10*log10(tmp_Wx_2);
        freq = 1./(2.^(log2(tmp_period)))';
        tmp_newlength = round(size(tmp_Wx_2,2)/subFactor);
        for j = 1:tmp_newlength
            if j*subFactor <= size(tmp_Wx_2,2)
                tmp_Wxmoy_2(:,j) = mean(tmp_Wx_2(:,(j-1)*subFactor+1:j*subFactor),2);
            else
                tmp_Wxmoy_2(:,j) = mean(tmp_Wx_2(:,(j-1)*subFactor+1:end),2);
            end
        end
        Wx_concat_2 = [Wx_concat_2 tmp_Wxmoy_2];
        clear tmp_*
    end
    newTime = (0:1/fech*subFactor:size(Wx_concat_2,2)/fech*subFactor-1/fech*subFactor)';

    %%% PCA
    [~,score_1,latent_1] = princomp(Wx_concat_1','econ');
    pc1 = score_1(:,1);
    percent_pc1 = round(latent_1(1)/sum(latent_1)*100);

    [~,score_2,latent_2] = princomp(Wx_concat_2','econ');
    pc2 = score_2(:,1);
    percent_pc2 = round(latent_2(1)/sum(latent_2)*100);
    
    set(handles.txt_pc1,'string',num2str(percent_pc1))
    set(handles.txt_pc2,'string',num2str(percent_pc2))
    
    %%% Mise à jour du handles
    handles.new_time = newTime;
    handles.taille = taille;
    handles.pc1 = pc1;
    handles.pc2 = pc2;
    handles.lfp_for_gerva = lfp_for_gerva;
    guidata(hObject, handles);
    set(handles.txt_computeok,'String','Compute OK')
    
    
end

% --- Executes on selection change in list_lfp.
function list_lfp_Callback(hObject, eventdata, handles)
% hObject    handle to list_lfp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_lfp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_lfp


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


% --- Executes on button press in results_button.
function results_button_Callback(hObject, eventdata, handles)
% hObject    handle to results_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'pc1')
    errordlg('Please Compute before');
    return
end
taille = handles.taille;
pc1 = handles.pc1;
pc2 = handles.pc2;
new_time = handles.new_time;
figure('color','w','Name','PC1 vs PC2')
plot(pc1,pc2,'k.')
title('Global plot')
axis square
axis([min(pc1) max(pc1) min(pc2) max(pc2)])

% save('test_pca','pc1','pc2','new_time','taille')
% disp('ok')

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



function edit_band1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_band1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_band1 as text
%        str2double(get(hObject,'String')) returns contents of edit_band1 as a double


% --- Executes during object creation, after setting all properties.
function edit_band1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_band1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_band2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_band2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_band2 as text
%        str2double(get(hObject,'String')) returns contents of edit_band2 as a double


% --- Executes during object creation, after setting all properties.
function edit_band2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_band2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nbrsuboct_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nbrsuboct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nbrsuboct as text
%        str2double(get(hObject,'String')) returns contents of edit_nbrsuboct as a double


% --- Executes during object creation, after setting all properties.
function edit_nbrsuboct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nbrsuboct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_timefactor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_timefactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_timefactor as text
%        str2double(get(hObject,'String')) returns contents of edit_timefactor as a double


% --- Executes during object creation, after setting all properties.
function edit_timefactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_timefactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in subplot_button.
function subplot_button_Callback(hObject, eventdata, handles)
% hObject    handle to subplot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'pc1')
    errordlg('Please Compute before');
    return
end
pc1 = handles.pc1;
pc2 = handles.pc2;
lfp_for_gerva = handles.lfp_for_gerva;
taille = handles.taille;
% if ~isempty(find(selection_plot==2, 1))
prompt = {'Number of rows:','Number of colums:'};
dlg_title = 'Subplot';
num_lines = 1;
defaultans = {'1',num2str(size(lfp_for_gerva,1))};
r = 0;c = 0;
while r*c<size(lfp_for_gerva,1)
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    if isempty(answer)
        return
    end
    r = str2double(answer{1});
    c = str2double(answer{2});
end
figure('color','w','name','By sessions')
name_for_listbox = lfp_for_gerva(:,1);
name_for_listbox{end+1} = 'none';
ax = [];
for i = 1:r*c
    [selection,v] = listdlg('PromptString',['subplot #' num2str(i)],...
        'SelectionMode','single',...
        'ListString',name_for_listbox);
    selected_i = selection;
    if v==0
        return
    end
    if selected_i>size(lfp_for_gerva,1)
        subplot(r,c,i);
        axis off
        axis square
    else
        ax(end+1) = subplot(r,c,i);
        if selected_i == 1
            plot(pc1(1:taille(selected_i)),pc2(1:taille(selected_i)),'.');axis square
        else
            plot(pc1(taille(selected_i-1)+1:taille(selected_i)),pc2(taille(selected_i-1)+1:taille(selected_i)),'.');axis square
        end
        axis square
        tmp_title = lfp_for_gerva{selected_i,1};
        tmp_title(tmp_title == '_') = ' ';
        title(tmp_title)
        clear tmp_title selected_i
    end
end
linkaxes(ax,'xy')
axis([min(pc1) max(pc1) min(pc2) max(pc2)])


% --- Executes on button press in group_button.
function group_button_Callback(hObject, eventdata, handles)
% hObject    handle to group_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'pc1')
    errordlg('Please Compute before');
    return
end
pc1 = handles.pc1;
pc2 = handles.pc2;
lfp_for_gerva = handles.lfp_for_gerva;
taille = handles.taille;
name_for_listbox = lfp_for_gerva(:,1);
Prompt = {'Group';'Sess';'Color'};
Formats = struct('type',{'edit','list','list'});
Formats(1).enable = 'on'; % acts as a label
Formats(1).size = [100 -1];
Formats(2).style = 'listbox';
Formats(2).items = name_for_listbox;
Formats(2).limits = [0 2] ;
Formats(2).size = [100 150];
Formats(3).style = 'listbox';
Formats(3).items = {'red';'green';'blue';'black';'cyan';'magenta'};
Formats(3).limits = [0 1] ;
Formats(3).size = [100 100];


Formats = Formats.';
DefAns = cell(size(Prompt,1),1);
for datanr = 1:2
    DefAns{1,datanr} = ['Data' num2str(datanr)];
    DefAns{2,datanr} = 1;
    %     DefAns{3,datanr} = 1;
end
DefAns{3,1} = 3;
DefAns{3,2} = 1;

DefAns = cell2struct(DefAns,Prompt,1);
Prompt = repmat(Prompt,1,2);
Title = 'test';
Options.AlignControls = 'on';
Options.CreateFcn = @(~,~,handles)celldisp(get(handles,'type'));
Options.DeleteFcn = @(~,~,handles)celldisp(get(handles,'type'));
[Answer,Canceled] = inputsdlg(Prompt,Title,Formats,DefAns,Options);
if Canceled==1
    return;
end
Answer = struct2cell(Answer);

color = {'r';'g';'b';'k';'c';'m'};
color1 = color{Answer{3,1}};
color2 = color{Answer{3,2}};

figure('color','w','Name','Data pooled')
ax3(1) = subplot(131);
selection_1 = Answer{2,1};
for i = 1:length(selection_1)
    hold on
    if selection_1(i) == 1
        plot(pc1(1:taille(selection_1(i))),pc2(1:taille(selection_1(i))),[color1 '.']);axis square
    else
        plot(pc1(taille(selection_1(i)-1)+1:taille(selection_1(i))),pc2(taille(selection_1(i)-1)+1:taille(selection_1(i))),[color1 '.']);axis square
    end
    axis square
    hold on
end
title(Answer{1,1})
axis([min(pc1) max(pc1) min(pc2) max(pc2)])

ax3(2) = subplot(132);
selection_2 = Answer{2,2};
for i = 1:length(selection_2)
    hold on
    if selection_2(i) == 1
        plot(pc1(1:taille(selection_2(i))),pc2(1:taille(selection_2(i))),[color2 '.']);axis square
    else
        plot(pc1(taille(selection_2(i)-1)+1:taille(selection_2(i))),pc2(taille(selection_2(i)-1)+1:taille(selection_2(i))),[color2 '.']);axis square
    end
    axis square
    hold on
end
title(Answer{1,2})
axis([min(pc1) max(pc1) min(pc2) max(pc2)])

ax3(3) = subplot(133);
for i = 1:length(selection_1)
    hold on
    if selection_1(i) == 1
        plot(pc1(1:taille(selection_1(i))),pc2(1:taille(selection_1(i))),[color1 '.']);axis square
    else
        plot(pc1(taille(selection_1(i)-1)+1:taille(selection_1(i))),pc2(taille(selection_1(i)-1)+1:taille(selection_1(i))),[color1 '.']);axis square
    end
    axis square
    hold on
end
for i = 1:length(selection_2)
    hold on
    if selection_2(i) == 1
        plot(pc1(1:taille(selection_2(i))),pc2(1:taille(selection_2(i))),[color2 '.']);axis square
    else
        plot(pc1(taille(selection_2(i)-1)+1:taille(selection_2(i))),pc2(taille(selection_2(i)-1)+1:taille(selection_2(i))),[color2 '.']);axis square
    end
    axis square
    hold on
end
title([Answer{1,1} '/' Answer{1,2}])
axis([min(pc1) max(pc1) min(pc2) max(pc2)])
linkaxes(ax3,'xy')

% --- Executes on button press in custom_button.
function custom_button_Callback(hObject, eventdata, handles)
% hObject    handle to custom_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'pc1')
    errordlg('Please Compute before');
    return
end
pc1 = handles.pc1;
pc2 = handles.pc2;
lfp_for_gerva = handles.lfp_for_gerva;
taille = handles.taille;
name_for_listbox = lfp_for_gerva(:,1);
Title = 'Custom Plot';
Options.Resize = 'on';
Options.AlignControls = 'on';
Prompt = {};
Formats = {};
DefAns = {};

prompt = {'Number of rows:','Number of colums:','Legend'};
dlg_title = 'Subplot';
num_lines = 1;
defaultans = {'1','1','0'};
subplot_r_c = inputdlg(prompt,dlg_title,num_lines,defaultans);
if isempty(subplot_r_c)
    return;
end
r = str2double(subplot_r_c{1});
c = str2double(subplot_r_c{2});
iflegend = str2double(subplot_r_c{3});
ind1 = 1;
ind2 = 1;
ind3 = 1;
for i = 1:r
    for j = 1:c
        %         Prompt(end+1,:) = {['SUBPLOT' num2str(ind1)],[],[]};
        %         Formats(3*i-2,j).type = 'text';
        %         Formats(3*i-2,j).size = [-1 -1];
        %         ind1 = ind1+1;
        Prompt(end+1,:) = {['subplot' num2str(ind1)],['title' num2str(ind1)],[]};
        Formats(3*i-2,j).type = 'edit';
        Formats(3*i-2,j).size = [-1 -1];
        DefAns(1).(eval('[''title'' num2str(ind1)]')) = ['data' num2str(ind1)];
        ind1 = ind1+1;
    end
    for j = 1:c
        Prompt(end+1,:) = {[],['name' num2str(ind2)],[]};
        Formats(3*i-1,j).type = 'list';
        Formats(3*i-1,j).style = 'listbox';
        Formats(3*i-1,j).format = 'text';
        Formats(3*i-1,j).items = name_for_listbox;
        Formats(3*i-1,j).limits = [0 4];
        Formats(3*i-1,j).size = [-1 -1];
        DefAns.(eval('[''name'' num2str(ind2)]')) = Formats(3*i-1,j).items(1);
        ind2 = ind2+1;
    end
    
    for j = 1:c
        Prompt(end+1,:) = {'Color', ['color' num2str(ind3)],[]};
        Formats(3*i,j).type = 'edit';
        Formats(3*i,j).format = 'text';
        Formats(3*i,j).size = [50 -1]; % automatically assign the height
        DefAns(1).(eval('[''color'' num2str(ind3)]')) = 'k';
        ind3 = ind3+1;
    end
end

[Answer,Cancelled] = inputsdlg(Prompt,Title,Formats,DefAns,Options);
if Cancelled==1
    return
end
champ = fieldnames(Answer);
answer_name = {};
answer_color = {};
answer_title = {};

for i = 1:length(champ)
    if strcmp(champ{i}(1:4),'name')
        answer_name{end+1} = Answer.(eval('char(champ(i))'));
    end
    if strcmp(champ{i}(1:5),'color')
        answer_color{end+1} = Answer.(eval('char(champ(i))'));
    end
    if strcmp(champ{i}(1:5),'title')
        answer_title{end+1} = Answer.(eval('char(champ(i))'));
    end
end

% answer_title
figure('color','w')
for i = 1:length(answer_name)
    var_for_legend = {};
    ax(i) = subplot(r,c,i);
    tmp_data = answer_name{i};
    tmp_color = answer_color{i};
    for k = 1:length(tmp_color)
        color{k,1} = tmp_color(k);
    end
    if length(color)<length(tmp_data)
        for m = 1:length(tmp_data)-length(color)
            color{end+1} = 'k';
        end
    end
    
    for j = 1:length(tmp_data)
        tmp_data_name = tmp_data{j};
        tmp_idx = find(strcmp(tmp_data_name,name_for_listbox));
        hold on
        if tmp_idx == 1
            plot(pc1(1:taille(tmp_idx)),pc2(1:taille(tmp_idx)),[color{j} '.']);
            axis square
        else
            plot(pc1(taille(tmp_idx-1)+1:taille(tmp_idx)),pc2(taille(tmp_idx-1)+1:taille(tmp_idx)),[color{j} '.']);
            axis square
        end
        hold on
        var_for_legend{end+1,1} = tmp_data_name;
        clear tmp_data_name tmp_idx
    end
    if iflegend
        legend(var_for_legend, 'Interpreter', 'none')
    end
    title(answer_title{i}, 'Interpreter', 'none')
    axis([min(pc1) max(pc1) min(pc2) max(pc2)])
    clear var_for_legend
end
linkaxes(ax,'xy')


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_band2,'enable','off')
set(handles.text15,'string','PC1 B1 %var')
set(handles.text16,'string','PC2 B1 %var')

guidata(hObject, handles);


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton2
set(handles.edit_band2,'enable','on')
set(handles.text15,'string','PC1 B1 %var')
set(handles.text16,'string','PC1 B2 %var')
guidata(hObject, handles);
