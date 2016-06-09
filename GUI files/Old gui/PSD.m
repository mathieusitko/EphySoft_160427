function varargout = PSD(varargin)
% PSD MATLAB code for PSD.fig
%      PSD, by itself, creates a new PSD or raises the existing
%      singleton*.
%
%      H = PSD returns the handle to a new PSD or the handle to
%      the existing singleton*.
%
%      PSD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PSD.M with the given input arguments.
%
%      PSD('Property','Value',...) creates a new PSD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PSD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PSD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PSD

% Last Modified by GUIDE v2.5 28-Jan-2016 14:54:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PSD_OpeningFcn, ...
                   'gui_OutputFcn',  @PSD_OutputFcn, ...
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


% --- Executes just before PSD is made visible.
function PSD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PSD (see VARARGIN)

% Choose default command line output for PSD
handles.output = hObject;
clc
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PSD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PSD_OutputFcn(hObject, eventdata, handles) 
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
main_interface


% --- Executes on button press in load_file.
function load_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txt_file,'String','')
set(handles.listbox_lfp,'Value',1);

[file,path] = uigetfile;
chosenfile = [path file];
if path==0
    return
end
set(handles.txt_file,'String',file)
lfp_file = load(chosenfile);
names = fieldnames(lfp_file);
names_AD = {};
for i = 1:length(names)
    if (strcmp(names{i}(1:2),'AD') && length(names{i})==4) ...
            || (length(names{i})>10 && strcmp(names{i}(end-3:end),'lean')) % voir si le nom se termine par _lfp_clean
        names_AD{end+1,1} = names{i};
    end
end


set(handles.listbox_lfp,'String',names_AD);
handles.file = file;
handles.path = path;
handles.names_AD = names_AD;

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


% --- Executes on button press in compute_button.
function compute_button_Callback(hObject, eventdata, handles)
% hObject    handle to compute_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'path') 
    errordlg('Please Load before');
    return
end
selection = get(handles.listbox_lfp,'Value');
nbr_sig_selected = size(selection,2);
lfp_file = load([handles.path handles.file]);
fech = str2double(get(handles.edit_fech,'String'));
fmin = str2double(get(handles.edit_fmin,'String'));
fmax = str2double(get(handles.edit_fmax,'String'));
nfft = str2double(get(handles.edit_nfft,'String'));

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

figure('color','w');
for i = 1:nbr_sig_selected
    win = 4096;
    lfp_signal = lfp_file.(handles.names_AD{selection(i)});
    lfp_signal(isnan(lfp_signal)) = [];
    [PSD,freqPSD] = pwelch(lfp_signal,win,[],nfft,fech);
    ax(i)=subplot(r,c,i);
    plot(freqPSD,10*log10(PSD),'color',[.2 .2 .2]);
    axis tight
    xlim([fmin fmax])
    titleplot = handles.names_AD{selection(i)};
    for j = 1:length(titleplot)
        if titleplot(j)=='_'
            titleplot(j)=' ';
        end
    end
    title(titleplot)
    clear PSD freqPSD lfp_signal
end
linkaxes(ax,'x')


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
