function varargout = PETS(varargin)
% PETS MATLAB code for PETS.fig
%      PETS, by itself, creates a new PETS or raises the existing
%      singleton*.
%
%      H = PETS returns the handle to a new PETS or the handle to
%      the existing singleton*.
%
%      PETS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PETS.M with the given input arguments.
%
%      PETS('Property','Value',...) creates a new PETS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PETS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PETS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PETS

% Last Modified by GUIDE v2.5 22-Feb-2016 15:56:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PETS_OpeningFcn, ...
                   'gui_OutputFcn',  @PETS_OutputFcn, ...
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


% --- Executes just before PETS is made visible.
function PETS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PETS (see VARARGIN)

% Choose default command line output for PETS
handles.output = hObject;
clc
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PETS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PETS_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in disp_button.
function disp_button_Callback(hObject, eventdata, handles)
% hObject    handle to disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath(genpath('Functions'))
set(handles.txt_file, 'String', '');
set(handles.listbox_lfp,'Value',1);
set(handles.txt_compute,'string','')

[file,path] = uigetfile;
chosenfile = [path file];
if path==0
    return
end
lfp_file = load(chosenfile);
names = fieldnames(lfp_file);
names_AD = {};
for i = 1:length(names)
    if (strcmp(names{i}(1:2),'AD') && length(names{i})==4) ...
            %|| (length(names{i})>10 && strcmp(names{i}(end-3:end),'lean')) % voir si le nom se termine par _lfp_clean
        names_AD{end+1,1} = names{i};
    end
end
names_clean = {};
for i = 1:length(names)
    if (strcmp(names{i}(1:2),'AD') && length(names{i})==10 && strcmp(names{i}(end-1:end),'an') ) ...
        names_clean{end+1,1} = names{i};
    end
end
names_clean{end+1} = 'no clean';

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

set(handles.listbox_lfp, 'String', names_AD);
set(handles.txt_file, 'String', file);
set(handles.popup_event, 'String', namesEvent);
set(handles.popup_clean, 'String', names_clean);

handles.length_signal = length_signal;
handles.path = path;
handles.file = file;
guidata(hObject, handles);

% --- Executes on selection change in listbox_lfp.
function listbox_lfp_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_lfp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_lfp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_lfp


% --- Executes during object creation, after setting all properties.
function listbox_lfp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_lfp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_event.
function popup_event_Callback(hObject, eventdata, handles)
% hObject    handle to popup_event (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_event contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_event


% --- Executes during object creation, after setting all properties.
function popup_event_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_event (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_clean.
function popup_clean_Callback(hObject, eventdata, handles)
% hObject    handle to popup_clean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_clean contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_clean


% --- Executes during object creation, after setting all properties.
function popup_clean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_clean (see GCBO)
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
if ~isfield(handles,'file')
    errordlg('Please Load LFP before');
    return
end

set(handles.txt_compute,'string','computing...')
pause(0.1)

lfpname = get(handles.listbox_lfp,'String');
lfpname_choice = lfpname{get(handles.listbox_lfp,'Value')};
event_name = get(handles.popup_event,'String');
event_name_choice = event_name{get(handles.popup_event,'Value')};
clean_name = get(handles.popup_clean,'String');
clean_name_choice = clean_name{get(handles.popup_clean,'Value')};
if strcmp(clean_name_choice,'no clean')
    cleaning = 0;
else
    cleaning = 1;
end

fech = str2double(get(handles.edit_fech,'String'));
fmin = str2double(get(handles.edit_fmin,'String'));
fmax = str2double(get(handles.edit_fmax,'String'));
nbrSubOct = str2double(get(handles.edit_nbrsuboct,'String'));
taft = str2double(get(handles.edit_taft,'String'))*1000;
tbef = str2double(get(handles.edit_tbef,'String'))*1000;

S = load([handles.path handles.file]);
event = S.(eval('event_name_choice'));
if ~isa(event,'double')
    event = [];
end

lfp = S.(eval('lfpname_choice'));
if cleaning
    clean_int = S.(eval('clean_name_choice'));
    clean_int = startstop2vect(clean_int(:,1),clean_int(:,2),fech,handles.length_signal);
else
    clean_int = ones(handles.length_signal,1);
end
clean_int(clean_int==0) = NaN;

time = (0:1/fech:length(lfp)/fech-1/fech)';
[Wx,period] = wt([time lfp],fmin,fmax,nbrSubOct);
Wx = 10*log10((abs(Wx)).^2);
freq = 1./(2.^(log2(period)))';
Wx(:,isnan(clean_int)) = NaN;

clear matwt
matwt=zeros(size(freq,1),tbef+taft+1);
for i=1:length(event)
    if round(event(i)*fech) > tbef && round(event(i)*fech)+taft < size(Wx,2)
        tmp=cat(3,matwt,Wx(:,round(event(i)*fech)-tbef:round(event(i)*fech)+taft));
        matwt=nansum(tmp,3);
    end
end
matmeanwt=matwt/length(event);
timeaff=(-tbef:+taft)/1000;
figure('color','w');
imagesc(timeaff,1:length(freq),matmeanwt);
xlim([timeaff(1) timeaff(end)]); pas=4;
set(gca,'YTick',1:pas:length(freq),'YTickLabel',floor(10^1*(downsample(freq,pas)))*10^(-1),'Fontsize',8)
xlabel('time (s)')
ylabel('freq (Hz)')
set(handles.txt_compute,'string','OK')



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
