function varargout = ISI(varargin)
% ISI MATLAB code for ISI.fig
%      ISI, by itself, creates a new ISI or raises the existing
%      singleton*.
%
%      H = ISI returns the handle to a new ISI or the handle to
%      the existing singleton*.
%
%      ISI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ISI.M with the given input arguments.
%
%      ISI('Property','Value',...) creates a new ISI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ISI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ISI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ISI

% Last Modified by GUIDE v2.5 03-Feb-2016 14:51:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ISI_OpeningFcn, ...
                   'gui_OutputFcn',  @ISI_OutputFcn, ...
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


% --- Executes just before ISI is made visible.
function ISI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ISI (see VARARGIN)

% Choose default command line output for ISI
handles.output = hObject;
clc
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ISI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ISI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function returnmain_Callback(hObject, eventdata, handles)
% hObject    handle to returnmain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EPHYSOFT


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txt_file,'String','')
set(handles.listbox_sig,'Value',1);

[file,path] = uigetfile;
chosenfile = [path file];
if path==0
    return
end
set(handles.txt_file,'String',file)
lfp_file = load(chosenfile);
names = fieldnames(lfp_file);
names_sig = {};
for i = 1:length(names)
    if (strcmp(names{i}(1:2),'si') && length(names{i})==7) 
        names_sig{end+1,1} = names{i};
    end
end
set(handles.listbox_sig,'String',names_sig);
handles.file = file;
handles.path = path;
handles.names_sig = names_sig;

guidata(hObject, handles);

% --- Executes on selection change in listbox_sig.
function listbox_sig_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_sig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_sig contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_sig
if ~strcmp(get(gcf,'SelectionType'),'open')
    return;
end
if ~isfield(handles,'path')
    errordlg('Please Disp data');
    return
end
cla(handles.axe_isi)
cla(handles.axe_poincare)

binsize = str2double(get(handles.edit_binsize,'String'));
binmax = str2double(get(handles.edit_max,'String'));

axes(handles.axe_isi)
signame = get(hObject, 'Value');
chosenfile = [handles.path handles.file];
file = load(chosenfile);
neuron = file.(eval('char(handles.names_sig(signame))'));
isi = diff(neuron); 
% isi(isi>0.1) = []; %supprime les ISI plus grand que 100ms
% [counts,centers] = hist(isi,100);% 1bin = 1ms
vector = (0:binsize/1000:10); % regarde les ISI entre 0 et 10 secondes avec le binsize converti en sec
[counts,centers] = hist(isi,vector);
b=bar(centers,counts,'histc');axis tight
xlim([0 binmax/1000])
b.EdgeColor = [0 0 0];
b.FaceColor = [.8 .8 .8];
xlabel('time (ms)')
ylabel('Count')
set(handles.axe_isi,'Xtick',0:0.02:binmax/1000)
set(handles.axe_isi,'Xticklabel',0:20:binmax)

%%% Poincare Maps

isi_ant = isi(1:end-1);
isi_post = isi(2:end);
vector_isi = (0:binsize/1000:binmax/1000)';
jointISI = zeros(length(vector_isi)-1);

for i = 1:size(jointISI,1)
    for j = 1:size(jointISI,2)
        for k = 1:length(isi_ant)
           if  (isi_ant(k)>=vector_isi(j) && isi_ant(k)<vector_isi(j+1)) && (isi_post(k)>=vector_isi(i) && isi_post(k)<vector_isi(i+1))
               jointISI(i,j) = jointISI(i,j)+1;
           end
        end
    end
end
jointISI_filtered = imgaussfilt(jointISI,2);

axes(handles.axe_poincare)
imagesc( (vector_isi(1)+vector_isi(2))/2:binsize/1000:(vector_isi(end-1)+vector_isi(end))/2,...
         (vector_isi(1)+vector_isi(2))/2:binsize/1000:(vector_isi(end-1)+vector_isi(end))/2,...
         jointISI_filtered)
     set(gca,'ydir','normal')
xlabel('ISI n (s)')
ylabel('ISI n+1 (s)')
axis tight
set(handles.axe_poincare,'Xtick',0:0.02:binmax/1000)
set(handles.axe_poincare,'Xticklabel',0:20:binmax)
set(handles.axe_poincare,'Ytick',0:0.02:binmax/1000)
set(handles.axe_poincare,'Yticklabel',0:20:binmax)

% --- Executes during object creation, after setting all properties.
function listbox_sig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_sig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in isi_button.
function isi_button_Callback(hObject, eventdata, handles)
% hObject    handle to isi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'path') 
    errordlg('Please Load before');
    return
end
selection = get(handles.listbox_sig,'Value');
nbr_sig_selected = size(selection,2);
file = load([handles.path handles.file]);

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

binsize = str2double(get(handles.edit_binsize,'String'));
binmax = str2double(get(handles.edit_max,'String'));

figure('color','w');
for i = 1:nbr_sig_selected
    neuron = file.(handles.names_sig{selection(i)});
    isi = diff(neuron); %arrondi à la milliseconde
    vector = (0:binsize/1000:10); % regarde les ISI entre 0 et 10 secondes avec le binsize converti en sec
    [counts,centers] = hist(isi,vector);
    ax(i)=subplot(r,c,i);
    b=bar(centers,counts,'histc');axis tight
    xlim([0 binmax/1000])
    b.EdgeColor = [0 0 0];
    b.FaceColor = [.8 .8 .8];
    set(gca,'Xtick',0:0.02:binmax/1000)
    set(gca,'Xticklabel',0:20:binmax)
    if i>=1 && i<=c
        xlabel('time (ms)')
    end
    titleplot = handles.names_sig{selection(i)};
    for j = 1:length(titleplot)
        if titleplot(j)=='_'
            titleplot(j)=' ';
        end
    end
    title(titleplot)
    if mod(i-1,c)==0
        ylabel('Count')
    end
    clear titleplot counts centers isi neuron
end


% --- Executes on button press in poincare_button.
function poincare_button_Callback(hObject, eventdata, handles)
% hObject    handle to poincare_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = get(handles.listbox_sig,'Value');
nbr_sig_selected = size(selection,2);
file = load([handles.path handles.file]);

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
binsize = str2double(get(handles.edit_binsize,'String'));
binmax = str2double(get(handles.edit_max,'String'));

figure('color','w');
for n = 1:nbr_sig_selected
    neuron = file.(handles.names_sig{selection(n)});
    isi = diff(neuron); %arrondi à la milliseconde
    isi_ant = isi(1:end-1);
    isi_post = isi(2:end);
    vector_isi = (0:binsize/1000:binmax/1000)';
    jointISI = zeros(length(vector_isi)-1);
    for i = 1:size(jointISI,1)
        for j = 1:size(jointISI,2)
            for k = 1:length(isi_ant)
                if  (isi_ant(k)>=vector_isi(j) && isi_ant(k)<vector_isi(j+1)) && (isi_post(k)>=vector_isi(i) && isi_post(k)<vector_isi(i+1))
                    jointISI(i,j) = jointISI(i,j)+1;
                end
            end
        end
    end
    jointISI_filtered = imgaussfilt(jointISI,2);
    ax(n)=subplot(r,c,n);
    imagesc( (vector_isi(1)+vector_isi(2))/2:binsize/1000:(vector_isi(end-1)+vector_isi(end))/2,...
        (vector_isi(1)+vector_isi(2))/2:binsize/1000:(vector_isi(end-1)+vector_isi(end))/2,...
        jointISI_filtered)
    set(gca,'ydir','normal')
    axis tight
    set(gca,'Xtick',0:0.02:binmax/1000)
    set(gca,'Xticklabel',0:20:binmax)
    set(gca,'Ytick',0:0.02:binmax/1000)
    set(gca,'Yticklabel',0:20:binmax)
    titleplot = handles.names_sig{selection(n)};
    for n = 1:length(titleplot)
        if titleplot(n)=='_'
            titleplot(n)=' ';
        end
    end
    title(titleplot)
    clear neuron isi isi_ant isi_post vector_isi jointISI i j k jointISI_filtered titleplot
end
linkaxes(ax,'xy')


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



function edit_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_max as text
%        str2double(get(hObject,'String')) returns contents of edit_max as a double


% --- Executes during object creation, after setting all properties.
function edit_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
