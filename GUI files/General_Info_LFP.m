function varargout = General_Info_LFP(varargin)
% GENERAL_INFO_LFP MATLAB code for General_Info_LFP.fig
%      GENERAL_INFO_LFP, by itself, creates a new GENERAL_INFO_LFP or raises the existing
%      singleton*.
%
%      H = GENERAL_INFO_LFP returns the handle to a new GENERAL_INFO_LFP or the handle to
%      the existing singleton*.
%
%      GENERAL_INFO_LFP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERAL_INFO_LFP.M with the given input arguments.
%
%      GENERAL_INFO_LFP('Property','Value',...) creates a new GENERAL_INFO_LFP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before General_Info_LFP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to General_Info_LFP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help General_Info_LFP

% Last Modified by GUIDE v2.5 01-Feb-2016 12:15:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @General_Info_LFP_OpeningFcn, ...
    'gui_OutputFcn',  @General_Info_LFP_OutputFcn, ...
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


% --- Executes just before General_Info_LFP is made visible.
function General_Info_LFP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to General_Info_LFP (see VARARGIN)

% Choose default command line output for General_Info_LFP
handles.output = hObject;
clc
% Alternative #1 (hFig = requested figure's handle)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes General_Info_LFP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = General_Info_LFP_OutputFcn(hObject, eventdata, handles)
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
% Alternative #1 (hFig = requested figure's handle)

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


% --- Executes on selection change in popup_whattodo.
function popup_whattodo_Callback(hObject, eventdata, handles)
% hObject    handle to popup_whattodo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_whattodo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_whattodo


% --- Executes during object creation, after setting all properties.
function popup_whattodo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_whattodo (see GCBO)
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
% whattodo = get(handles.popup_whattodo,'String');
if ~isfield(handles,'path')
    errordlg('Please Load before');
    return
end

selection = get(handles.listbox_lfp,'Value');
nbr_sig_selected = size(selection,2);
lfp_file = load([handles.path handles.file]);
r_vect = [1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10]';
c_vect = [1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9  9 10]';
rc = r_vect.*c_vect;
if nbr_sig_selected>max(rc)
    errordlg('Too many data selected');
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

method = get(handles.popup_whattodo,'Value');
if isempty(method)
    return
    
elseif method==1 % Display
    figure('color','w')
    fech = str2double(get(handles.edit_fech,'String'));
    for i = 1:nbr_sig_selected
        lfp_signal = lfp_file.(handles.names_AD{selection(i)});
        lfp_signal(isnan(lfp_signal)) = [];
        time = 0:1/fech:length(lfp_signal)/fech-1/fech;
        ax(i)=subplot(r,c,i);
        plot(time,lfp_signal,'color',[.2 .2 .2]);
        axis tight
        titleplot = handles.names_AD{selection(i)};
        for j = 1:length(titleplot)
            if titleplot(j)=='_'
                titleplot(j)=' ';
            end
        end
        title(titleplot)
        clear lfp_signal titleplot
    end
    linkaxes(ax,'x')
    
elseif method==2 % PSD
    parameters = inputdlg({'fmin (Hz)','fmax (Hz)','nfft'},...
        'Parameters',1,{'0','120','4096'});
    if isempty(parameters)
        return
    else
        fech = str2double(get(handles.edit_fech,'String'));
        fmin = str2double(parameters{1});
        fmax = str2double(parameters{2});
        nfft = str2double(parameters{3});
        figure('color','w')
        for i = 1:nbr_sig_selected
            win = 4096;
            lfp_signal = lfp_file.(handles.names_AD{selection(i)});
            lfp_signal(isnan(lfp_signal)) = [];
            [PSD,freqPSD] = pwelch(lfp_signal,win,[],nfft,fech);
            [~, minfreq] = min(abs(fmin - freqPSD));
            [~, maxfreq] = min(abs(fmax - freqPSD));
            maxPSD(i) = max(10*log10(PSD(minfreq:maxfreq)));
            minPSD(i) = min(10*log10(PSD(minfreq:maxfreq)));
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
        linkaxes(ax,'xy')
        
        maxmaxPSD = max(maxPSD);
        if maxmaxPSD>0
            maxmaxPSD = 0;
        end
        
        for i = 1:nbr_sig_selected
            ylim(ax(i),[minminPSD maxmaxPSD])
        end
    end
    
    
    
elseif method==3 %Coherence
    refLFP =  listdlg('PromptString','Select a reference LFP:','SelectionMode','single','ListString',handles.names_AD);
    if isempty(refLFP)
        return
    end
    parameters = inputdlg({'fmax (Hz)','nfft'},'Parameters',1,{'120','1024'});
    if isempty(parameters)
        return
    end
    
    refLFP_signal = lfp_file.(handles.names_AD{refLFP});
    refLFP_signal(isnan(refLFP_signal)) = [];
    
    fech = str2double(get(handles.edit_fech,'String'));
    fmax = str2double(parameters{1});
    nfft = str2double(parameters{2});
    window = 4096;
    f = figure('color','w');
    for i = 1:nbr_sig_selected
        lfp_signal = lfp_file.(handles.names_AD{selection(i)});
        lfp_signal(isnan(lfp_signal)) = [];
        if size(lfp_signal,1) == size(refLFP_signal,1)
            ax(i)=subplot(r,c,i);
            [Cxy,freq] = mscohere(refLFP_signal,lfp_signal,window,[],nfft,fech);
            plot(freq,Cxy,'color',[.3 .3 .3]);hold on
            h = area(freq,Cxy);hold on
            h.FaceColor = [.8 .8 .8];    alpha(0.5)
            axis([0 fmax 0 1])
            titleplot = [handles.names_AD{selection(i)} ' (ref ' handles.names_AD{refLFP} ')'];
            for j = 1:length(titleplot)
                if titleplot(j)=='_'
                    titleplot(j)=' ';
                end
            end
            title(titleplot)
            clear lfp_signal Cxy freq titleplot j
        else
            errordlg('LFP with different length')
            close(f)
            return
        end
    end
    if exist('ax')
        linkaxes(ax,'x')
    end
    
elseif method==4 %Spectrogram
    parameters = inputdlg({'fmin (Hz)','fmax (Hz)','window time','window freq.','Minimum power (dB)','Maximum power (dB)'},...
        'Parameters',1,{'0','120','1024','1024','-30','30'});
    if isempty(parameters)
        return
    else
        fech = str2double(get(handles.edit_fech,'String'));
        fmin = str2double(parameters{1});
        fmax = str2double(parameters{2});
        win_time = str2double(parameters{3});
        win_freq = str2double(parameters{4});
        caxis_min = str2double(parameters{5});
        caxis_max = str2double(parameters{6});
        if fmin>=fmax
            errordlg('fmax > fmin')
            return
        end
        figure('color','w')
        for i = 1:nbr_sig_selected
            lfp_signal = lfp_file.(handles.names_AD{selection(i)});
            lfp_signal(isnan(lfp_signal)) = [];
            [s,f,t] = spectrogram(lfp_signal,win_time,[],win_freq,fech,'yaxis');
            s = abs(s).^2;
            ax(i)=subplot(r,c,i);
            imagesc(t,f,10*log10(s))
            ylim([fmin fmax])
            caxis([caxis_min caxis_max])
            set(gca,'Ydir','normal')
            titleplot = handles.names_AD{selection(i)};
            for j = 1:length(titleplot)
                if titleplot(j)=='_'
                    titleplot(j)=' ';
                end
            end
            title(titleplot)
            clear lfp_signal s f t
        end
        linkaxes(ax,'x')
    end
    
elseif method==5 %Wavelet
    
    parameters = inputdlg({'fmin (Hz)','fmax (Hz)','Nbr Sub Oct (5->25)','Additional Sub Ech. (1->4)','Minimum power (dB)','Maximum power (dB)'},...
        'Parameters',1,{'1','120','15','1','-25','0'});
    if isempty(parameters)
        return
    else
        fech = str2double(get(handles.edit_fech,'String'));
        fmin = str2double(parameters{1});
        fmax = str2double(parameters{2});
        nbrSubOct = str2double(parameters{3});
        subEchFactor = str2double(parameters{4});
        caxis_min = str2double(parameters{5});
        caxis_max = str2double(parameters{6});
        
        if fmin==0
            errordlg('fmin ~= 0')
            return
        end
        if fmin>=fmax
            errordlg('fmax > fmin')
            return
        end
        figure('color','w')
        for i = 1:nbr_sig_selected
            lfp_signal = lfp_file.(handles.names_AD{selection(i)});
            lfp_signal(isnan(lfp_signal)) = [];
            time = (0:1/fech:length(lfp_signal)/fech-1/fech)';
            new_lfp = lfp_signal(1:subEchFactor:end);
            new_time = time(1:subEchFactor:end);
            [Wx, period] = wt([new_time new_lfp],fmin,fmax,nbrSubOct);
            Wx = (abs(Wx)).^2;
            freq = 1./(2.^(log2(period)))';
            %             freq(9)
            %             freq(15)
            %             freq(11)
            %             freq(17)
            %             freq(18)
            
            
            ax(i)=subplot(r,c,i);
            imagesc(new_time,1:length(freq),10*log10(Wx))
            caxis([caxis_min caxis_max]);
            xlim([new_time(1) new_time(end)])
            pas=5;set(gca,'YTick',1:pas:length(freq),'YTickLabel',floor(10^1*(downsample(freq,pas)))*10^(-1),'Fontsize',8)
            
            titleplot = handles.names_AD{selection(i)};
            for j = 1:length(titleplot)
                if titleplot(j)=='_'
                    titleplot(j)=' ';
                end
            end
            title(titleplot)
            clear lfp_signal s f t
        end
        linkaxes(ax,'x')
    end
    
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
