function varargout = nex2mat(varargin)
% NEX2MAT MATLAB code for nex2mat.fig
%      NEX2MAT, by itself, creates a new NEX2MAT or raises the existing
%      singleton*.
%
%      H = NEX2MAT returns the handle to a new NEX2MAT or the handle to
%      the existing singleton*.
%
%      NEX2MAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEX2MAT.M with the given input arguments.
%
%      NEX2MAT('Property','Value',...) creates a new NEX2MAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nex2mat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nex2mat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nex2mat

% Last Modified by GUIDE v2.5 19-Jan-2016 17:40:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nex2mat_OpeningFcn, ...
                   'gui_OutputFcn',  @nex2mat_OutputFcn, ...
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


% --- Executes just before nex2mat is made visible.
function nex2mat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nex2mat (see VARARGIN)

% Choose default command line output for nex2mat
handles.output = hObject;
clc
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nex2mat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nex2mat_OutputFcn(hObject, eventdata, handles) 
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
set(handles.listbox_nex,'Value',1);
folder_pathname = uigetdir;
if folder_pathname==0
    return
end
folder_name = folder_pathname(length(pwd)+2:end);
set(handles.txt_display,'String',folder_name)
list = dir(folder_name);
nex_names = {};
for i = 1:length(list)
    if length(list(i).name)>4 && (strcmp( list(i).name(end-3:end),'.nex') ...
            || strcmp( list(i).name(end-3:end),'.pl2') ...
            || strcmp( list(i).name(end-3:end),'.plx'))
        nex_names{end+1,1} = list(i).name;
    end
end
set(handles.listbox_nex,'String',nex_names)

handles.nex_names = nex_names;
handles.folder_pathname = folder_pathname;
handles.folder_name = folder_name;

guidata(hObject, handles);

% --- Executes on selection change in listbox_nex.
function listbox_nex_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_nex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_nex contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_nex


% --- Executes during object creation, after setting all properties.
function listbox_nex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_nex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in convert_button.
function convert_button_Callback(hObject, eventdata, handles)
% hObject    handle to convert_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'nex_names')
    errordlg('Please Display before');
    return
end
set(handles.txt_convertok,'String','')
set(handles.txt_progression,'String','')
pause(0.1)
nex_names = handles.nex_names;
folder_pathname = handles.folder_pathname;
prefix = nex_names{1}(1:3);

% nex_names
pathname = [folder_pathname '\'];
convertNEXtoMATdata(pathname)

% for i = 1:length(nex_names)
% for i = 1:1
%     set(handles.txt_progression,'String',['File ' num2str(i) '/' num2str(length(nex_names))])
%     pause(0.1)
%     pathname = [folder_pathname '\'];
%     filename = nex_names{i};
%     newFolder = ['Data_MAT_from_NEX_' prefix];
%     if ~exist(newFolder)
%         mkdir(newFolder)
%     end  
%     convertNEXtoMATdata(pathname,filename,newFolder)
%     
% end
set(handles.txt_convertok,'String','OK')
