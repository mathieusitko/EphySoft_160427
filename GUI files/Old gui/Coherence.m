function varargout = Coherence(varargin)
% COHERENCE MATLAB code for Coherence.fig
%      COHERENCE, by itself, creates a new COHERENCE or raises the existing
%      singleton*.
%
%      H = COHERENCE returns the handle to a new COHERENCE or the handle to
%      the existing singleton*.
%
%      COHERENCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COHERENCE.M with the given input arguments.
%
%      COHERENCE('Property','Value',...) creates a new COHERENCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Coherence_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Coherence_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Coherence

% Last Modified by GUIDE v2.5 29-Jan-2016 11:10:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Coherence_OpeningFcn, ...
                   'gui_OutputFcn',  @Coherence_OutputFcn, ...
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


% --- Executes just before Coherence is made visible.
function Coherence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Coherence (see VARARGIN)

% Choose default command line output for Coherence
handles.output = hObject;
clc
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Coherence wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Coherence_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Return_Callback(hObject, eventdata, handles)
% hObject    handle to Return (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
main_interface



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


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txt_file,'String','')
set(handles.listbox_lfp,'Value',1);
set(handles.popup_ref,'Value',1);

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
%         disp('ici')
        names_AD{end+1,1} = names{i};
    end
end
set(handles.listbox_lfp,'String',names_AD);
set(handles.popup_ref,'String',names_AD);
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


% --- Executes on selection change in popup_ref.
function popup_ref_Callback(hObject, eventdata, handles)
% hObject    handle to popup_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_ref contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_ref


% --- Executes during object creation, after setting all properties.
function popup_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_ref (see GCBO)
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
    errordlg('Please Load before');
    return
end

selection = get(handles.listbox_lfp,'Value');
nbr_sig_selected = size(selection,2);
lfp_file = load([handles.path handles.file]);
fech = str2double(get(handles.edit_fech,'String'));
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

lfp_ref_name = handles.names_AD{get(handles.popup_ref,'Value')};
lfp_ref = lfp_file.(eval('lfp_ref_name'));
lfp_ref(isnan(lfp_ref)) = [];

window = 4096;

figure('color','w');
for i = 1:nbr_sig_selected
    lfp_signal = lfp_file.(handles.names_AD{selection(i)});
    lfp_signal(isnan(lfp_signal)) = [];

    if size(lfp_signal,1) == size(lfp_ref,1)
        ax(i)=subplot(r,c,i);
        [Cxy,freq] = mscohere(lfp_ref,lfp_signal,window,[],nfft,fech);
        plot(freq,Cxy,'color',[.3 .3 .3]);hold on
        h = area(freq,Cxy);hold on
        h.FaceColor = [.8 .8 .8];    alpha(0.5)
        axis([0 fmax 0 1])
        titleplot = [handles.names_AD{selection(i)} ' (ref ' lfp_ref_name ')'];
        for j = 1:length(titleplot)
            if titleplot(j)=='_'
                titleplot(j)=' ';
            end
        end
        title(titleplot)
        clear lfp_signal Cxy freq titleplot j
    else
        errordlg('LFP with different length')
        return
    end
end
if exist('ax')
    linkaxes(ax,'x')
end
