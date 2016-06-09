function varargout = neuronsClassification(varargin)
% NEURONSCLASSIFICATION MATLAB code for neuronsClassification.fig
%      NEURONSCLASSIFICATION, by itself, creates a new NEURONSCLASSIFICATION or raises the existing
%      singleton*.
%
%      H = NEURONSCLASSIFICATION returns the handle to a new NEURONSCLASSIFICATION or the handle to
%      the existing singleton*.
%
%      NEURONSCLASSIFICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEURONSCLASSIFICATION.M with the given input arguments.
%
%      NEURONSCLASSIFICATION('Property','Value',...) creates a new NEURONSCLASSIFICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before neuronsClassification_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to neuronsClassification_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help neuronsClassification

% Last Modified by GUIDE v2.5 28-Jan-2016 09:15:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @neuronsClassification_OpeningFcn, ...
    'gui_OutputFcn',  @neuronsClassification_OutputFcn, ...
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


% --- Executes just before neuronsClassification is made visible.
function neuronsClassification_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to neuronsClassification (see VARARGIN)

% Choose default command line output for neuronsClassification
handles.output = hObject;
clc
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes neuronsClassification wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = neuronsClassification_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function analysis_Callback(hObject, eventdata, handles)
% hObject    handle to analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function cleanLFP_Callback(hObject, eventdata, handles)
% hObject    handle to cleanLFP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cleanLFP

% --------------------------------------------------------------------
function spindles6080_Callback(hObject, eventdata, handles)
% hObject    handle to spindles6080 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spindles6080

% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EPHYSOFT


% --------------------------------------------------------------------
function phaselocking_Callback(hObject, eventdata, handles)
% hObject    handle to phaselocking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
phaseLockingNeurons



% --- Executes on button press in disp_button.
function disp_button_Callback(hObject, eventdata, handles)
% hObject    handle to disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txt_dirname,'String','')
set(handles.txt_computeok,'String', '')
set(handles.txt_computename,'String', '')
addpath(genpath('Functions'))
folder_pathname = uigetdir;
if folder_pathname==0
    %     errordlg('Please select a file');
    return
end
folder_name = folder_pathname(length(pwd)+2:end);
set(handles.txt_dirname,'String',folder_name)
S = what(folder_pathname);
animals_names = S.mat;
set(handles.listbox_animals,'String',animals_names)
handles.animals_names = animals_names;
handles.folder_pathname = folder_pathname;
handles.folder_name = folder_name;

guidata(hObject, handles);

% --- Executes on selection change in listbox_animals.
function listbox_animals_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_animals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_animals contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_animals

if ~strcmp(get(gcf,'SelectionType'),'open')
    return;
end
disp(handles.animals_names(get(hObject, 'Value')))


% --- Executes during object creation, after setting all properties.
function listbox_animals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_animals (see GCBO)
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

% handles.folder_pathname
% handles.animals_names(1)
% load([handles.folder_pathname handles.animals_names(1)])
if ~isfield(handles,'animals_names') 
    errordlg('Please Display before');
    return
end
cla(handles.axe_display)
set(handles.txt_msn_number,'string','');
set(handles.txt_fsi_number,'string','');
set(handles.txt_unclass_number,'string','');

set(handles.txt_computeok,'String', '')
set(handles.txt_computename,'String', '')
var_msnfsi(1,:) = [{'Animal/Session'} {'Neuron'} {'FR'} {'SHW'} {'Type'}];

%%% boucle sur le nombre d'animaux
% for i = 1:2
for i = 1:length(handles.animals_names)
    set(handles.txt_computename,'String', ['File ' num2str(i) '/' num2str(length(handles.animals_names))])
    pause(0.01)
    S = load([handles.folder_pathname '\' char(handles.animals_names(i))]);
    names = fieldnames(S);
    names_wf = {};
    
    %%% Permet de récupérer la taille du signal pour le calcul du firing rate
    for j = 1:length(names)
        tmp_var = char(names(j));
        if length(tmp_var)==4 && strcmp(tmp_var(1:2),'AD')
            length_signal = size(S.(tmp_var),1);
            break
        end
        clear tmp_var
    end
    handles.length_signal = length_signal;
    guidata(hObject, handles);
    
    %%% Permet de recuperer les noms des waveforms
    for j = 1:length(names)
        tmp_var = char(names(j));
        if length(tmp_var)== 10 && strcmp(tmp_var(9:10),'wf')
            names_wf{end+1,1} = tmp_var;
        end
        clear tmp_var
    end
    
    %%% Parcourt les waveforms et retourne le firing rate (FR) et spike half
    %%% width (SHW) avec fech = 1000Hz et fechUnits = 40000
    for j = 1:length(names_wf)
        name_tmp =  char(handles.animals_names(i));
        var_msnfsi{end+1,1} = name_tmp(1:end-4);
        name_tmp_wf = names_wf{j};
        var_msnfsi{end,2} = name_tmp_wf(1:end-3);
        FR{i,j} = size(S.(names_wf{j}),2)/length_signal*1000;
        meanWF = mean(S.(names_wf{j}),2);
        [~,indMin] = min(meanWF);
        [~,indMax] = max(meanWF);
        if indMax<indMin
            clear maxi indMax
            [~,indMax] = max(meanWF(indMin:end));
            indMax = indMax+indMin-1;
        end
        SHW{i,j} = abs(indMax-indMin)/40000*1000*1000;
        var_msnfsi{end,3} = FR{i,j};
        var_msnfsi{end,4} = SHW{i,j};
        %     figure;plot(meanWF);hold on
        %     plot(indMin,mini,'+');hold on
        %     plot(indMax,maxi,'+');hold on
        clear name_tmp name_tmp_wf
    end
    
end
set(handles.txt_computeok,'String', [num2str(size(var_msnfsi,1)) ' neurons'])

var_msnfsi_for_listbox = var_msnfsi;
for j = 1:size(var_msnfsi_for_listbox,2)
    for i = 1:size(var_msnfsi_for_listbox,1)
        tmp =  var_msnfsi_for_listbox(i,j);
        if isnumeric(cell2mat(tmp))
            var_msnfsi_for_listbox{i,j} = num2str(cell2mat(tmp));
        end
    end
end
set(handles.listbox_results,'FontName','FixedWidth','min',0,'max',1);
formattable(handles.listbox_results,var_msnfsi_for_listbox);

handles.var_msnfsi = var_msnfsi;
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


% --- Executes on button press in msnfsi_button.
function msnfsi_button_Callback(hObject, eventdata, handles)
% hObject    handle to msnfsi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'var_msnfsi') 
    errordlg('Please Compute before');
    return
end
cla(handles.axe_display)
set(handles.txt_msn_number,'string','');
set(handles.txt_fsi_number,'string','');
set(handles.txt_unclass_number,'string','');
pause(0.1)

PN_hw_min = 350;
PN_fr_max = 10;
MSN_hw_max = 450;
MSN_fr_min = 0.5;

var_msnfsi = handles.var_msnfsi;
wfForKmeans = cell2mat(var_msnfsi(2:end,3:4));

nbrClusters = 2;
[idx,C,~,distToCentroid] = kmeans(wfForKmeans,nbrClusters,'Distance','cityblock','Replicates',5);
[~,idx_mini] = max(distToCentroid,[],2);
[~,idxMSN] = min(C(:,1));
[~,idxFSI] = max(C(:,1));

for i = 1:size(wfForKmeans,1)
    if wfForKmeans(i,1) < MSN_fr_min && wfForKmeans(i,2) <= PN_hw_min ||...
            wfForKmeans(i,2) >= 1000 ||...
            wfForKmeans(i,1) > PN_fr_max && wfForKmeans(i,2) >= MSN_hw_max
        idx(i)=3;
        idx_mini(i) = 3;
    end
end

for i = 2:size(var_msnfsi,1)
    if idx_mini(i-1)==idxMSN
        var_msnfsi{i,5} = 'MSN';
    elseif idx_mini(i-1)==idxFSI
        var_msnfsi{i,5} = 'FSI';
    else 
        var_msnfsi{i,5} = 'Unclass';
    end
end

var_msnfsi_for_listbox = var_msnfsi;
for j = 1:size(var_msnfsi_for_listbox,2)
    for i = 1:size(var_msnfsi_for_listbox,1)
        tmp =  var_msnfsi_for_listbox(i,j);
        if isnumeric(cell2mat(tmp))
            var_msnfsi_for_listbox{i,j} = num2str(cell2mat(tmp));
        end
    end
end
set(handles.listbox_results,'FontName','FixedWidth','min',0,'max',1);
formattable(handles.listbox_results,var_msnfsi_for_listbox);
set(handles.txt_msn_number,'string',num2str(length(find(idx_mini==idxMSN))));
set(handles.txt_fsi_number,'string',num2str(length(find(idx_mini==idxFSI))));
set(handles.txt_unclass_number,'string',num2str(length(find(idx_mini==3))));

%%% Display kmeans clusters
axes(handles.axe_display)
cla(handles.axe_display)
for i = 1:length(idx)
    if idx(i)==1
        semilogx(wfForKmeans(i,1),wfForKmeans(i,2),'ko','markerfacecolor','b');hold on %semilogx ou loglog
    elseif idx(i)==2
        semilogx(wfForKmeans(i,1),wfForKmeans(i,2),'ko','markerfacecolor','r');hold on %semilogx ou loglog
    elseif idx(i)==3
        semilogx(wfForKmeans(i,1),wfForKmeans(i,2),'kx');hold on %semilogx ou loglog
    end
end
xlabel('FR (Hz)')
ylabel('SHW (us)')

handles.idx_kmeans = idx;
handles.wfForKmeans = wfForKmeans;
handles.var_msnfsi_for_listbox = var_msnfsi_for_listbox;
guidata(hObject, handles);

msn_fsi_neurons = var_msnfsi_for_listbox;
currentfolder = pwd;
prefix = handles.animals_names{1}(1:3);
filename2save = [prefix '_MSN_FSI'];
cd(handles.folder_pathname)
save(filename2save,'msn_fsi_neurons')
cd(currentfolder)


% --------------------------------------------------------------------
function extract_figure_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to extract_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure('color','w')
wfForKmeans = handles.wfForKmeans;
idx = handles.idx_kmeans;
for i = 1:length(idx)
    if idx(i)==1
        semilogx(wfForKmeans(i,1),wfForKmeans(i,2),'ko','markerfacecolor','b');hold on 
    elseif idx(i)==2
        semilogx(wfForKmeans(i,1),wfForKmeans(i,2),'ko','markerfacecolor','r');hold on 
    elseif idx(i)==3
        semilogx(wfForKmeans(i,1),wfForKmeans(i,2),'kx');hold on 
    end
end
xlabel('FR (Hz)')
ylabel('SHW (us)')
