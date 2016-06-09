function varargout = main_interface(varargin)
% MAIN_INTERFACE MATLAB code for main_interface.fig
%      MAIN_INTERFACE, by itself, creates a new MAIN_INTERFACE or raises the existing
%      singleton*.
%
%      H = MAIN_INTERFACE returns the handle to a new MAIN_INTERFACE or the handle to
%      the existing singleton*.
%
%      MAIN_INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_INTERFACE.M with the given input arguments.
%
%      MAIN_INTERFACE('Property','Value',...) creates a new MAIN_INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_interface

% Last Modified by GUIDE v2.5 22-Feb-2016 08:35:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_interface_OpeningFcn, ...
                   'gui_OutputFcn',  @main_interface_OutputFcn, ...
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


% --- Executes just before main_interface is made visible.
function main_interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_interface (see VARARGIN)

% Choose default command line output for main_interface
handles.output = hObject;
addpath(genpath('Functions'))
addpath(genpath('GUI files'))
addpath(genpath('Images'))

% X=imread('rat.jpg');
% ax = axes('position',[0 0 1 1]);
% imagesc(X);
% uistack(ax,'bottom');
% set(gca, 'Ydir', 'reverse');
% set(gca, 'XTick', []);
% set(gca, 'YTick', []);
clc

position = getpixelposition(handles.general_button);

bgGeneralInfos = imread('Wavelet.png');
bgGeneralInfos = imresize(bgGeneralInfos, [position(4) position(3)]);
set(handles.general_button,'CData',bgGeneralInfos)

bgPSD = imread('PSD1.png');
bgPSD = imresize(bgPSD, [position(4) position(3)]);
set(handles.severalPSD_button,'CData',bgPSD)

bgCleanLFP = imread('CleanLFP.png');
bgCleanLFP = imresize(bgCleanLFP, [position(4) position(3)]);
set(handles.clean_lfp_button,'CData',bgCleanLFP)

bgISI = imread('ISI.png');
bgISI = imresize(bgISI, [position(4) position(3)]);
set(handles.isi_button,'CData',bgISI)

bgFR = imread('firingrate.jpg');
bgFR = imresize(bgFR, [position(4) position(3)]);
set(handles.firingrate_button,'CData',bgFR)

bgPETH = imread('PETH.png');
bgPETH = imresize(bgPETH, [position(4) position(3)]);
set(handles.peth_button,'CData',bgPETH)

bgMSNFSI = imread('msnfsi.png');
bgMSNFSI = imresize(bgMSNFSI, [position(4) position(3)]);
set(handles.msn_fsi_button,'CData',bgMSNFSI)

bgPETS = imread('pets.png');
bgPETS = imresize(bgPETS, [position(4) position(3)]);
set(handles.pets_button,'CData',bgPETS)

bgSpindles = imread('Spindles.png');
bgSpindles = imresize(bgSpindles, [position(4) position(3)]);
set(handles.spindles_button,'CData',bgSpindles)

bgPL = imread('phaselocking.png');
bgPL = imresize(bgPL, [position(4) position(3)]);
set(handles.phase_locking_neurons,'CData',bgPL)

bgNex = imread('plexon.png');
bgNex = imresize(bgNex, [position(4) position(3)]);
set(handles.nextomat_button,'CData',bgNex)

% X=imread('rat.jpg');
% ax = axes('position',[0 0 1 1]);
% imagesc(X);
% uistack(ax,'bottom');
% set(gca, 'Ydir', 'reverse');
% set(gca, 'XTick', []);
% set(gca, 'YTick', []);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in clean_lfp_button.
function clean_lfp_button_Callback(hObject, eventdata, handles)
% hObject    handle to clean_lfp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cleanLFP


% --- Executes on button press in spindles_button.
function spindles_button_Callback(hObject, eventdata, handles)
% hObject    handle to spindles_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spindles6080


% --- Executes on button press in phase_locking_neurons.
function phase_locking_neurons_Callback(hObject, eventdata, handles)
% hObject    handle to phase_locking_neurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
phaseLockingNeurons


% --- Executes on button press in msn_fsi_button.
function msn_fsi_button_Callback(hObject, eventdata, handles)
% hObject    handle to msn_fsi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
neuronsClassification


% --- Executes on button press in nextomat_button.
function nextomat_button_Callback(hObject, eventdata, handles)
% hObject    handle to nextomat_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nex2mat


% --- Executes on button press in firingrate_button.
function firingrate_button_Callback(hObject, eventdata, handles)
% hObject    handle to firingrate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FiringRate


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% X=imread('Stonehenge.jpg');
% ax = axes('position',[0 0 1 1]);
% imagesc('cdata',X);
% uistack(ax,'bottom');
% set(gca, 'Ydir', 'reverse');

X=imread('rat.jpg');
ax = axes('position',[0 0 1 1]);
imagesc(X);
uistack(ax,'bottom');
set(gca, 'Ydir', 'reverse');
set(gca, 'XTick', []);
set(gca, 'YTick', []);


function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB


% --- Executes on button press in pets_button.
function pets_button_Callback(hObject, eventdata, handles)
% hObject    handle to pets_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in peth_button.
function peth_button_Callback(hObject, eventdata, handles)
% hObject    handle to peth_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PETH

% --- Executes on button press in pl2mat.
function pl2mat_Callback(hObject, eventdata, handles)
% hObject    handle to pl2mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in isi_button.
function isi_button_Callback(hObject, eventdata, handles)
% hObject    handle to isi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ISI

% --- Executes on button press in correlation_sig_lfp_button.
function correlation_sig_lfp_button_Callback(hObject, eventdata, handles)
% hObject    handle to correlation_sig_lfp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in crosscorrel_button.
function crosscorrel_button_Callback(hObject, eventdata, handles)
% hObject    handle to crosscorrel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in general_button.
function general_button_Callback(hObject, eventdata, handles)
% hObject    handle to general_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
General_Info_LFP


% --- Executes on button press in severalPSD_button.
function severalPSD_button_Callback(hObject, eventdata, handles)
% hObject    handle to severalPSD_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Several_PSD


% --------------------------------------------------------------------
function documentation_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to documentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen('Help.pdf')


% --------------------------------------------------------------------
function mathworks_doc_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to mathworks_doc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
url = 'http://www.mathworks.com';
web(url)


% --- Executes during object creation, after setting all properties.
function general_button_CreateFcn(hObject, eventdata, handles,varargin)
% hObject    handle to general_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in PCA_Gerva.
function PCA_Gerva_Callback(hObject, eventdata, handles)
% hObject    handle to PCA_Gerva (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PCA_Gerva
