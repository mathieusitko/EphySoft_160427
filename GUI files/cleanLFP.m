function varargout = cleanLFP(varargin)
% CLEANLFP MATLAB code for cleanLFP.fig
%      CLEANLFP, by itself, creates a new CLEANLFP or raises the existing
%      singleton*.
%
%      H = CLEANLFP returns the handle to a new CLEANLFP or the handle to
%      the existing singleton*.
%
%      CLEANLFP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLEANLFP.M with the given input arguments.
%
%      CLEANLFP('Property','Value',...) creates a new CLEANLFP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cleanLFP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cleanLFP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cleanLFP

% Last Modified by GUIDE v2.5 22-Jan-2016 16:51:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @cleanLFP_OpeningFcn, ...
    'gui_OutputFcn',  @cleanLFP_OutputFcn, ...
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


% --- Executes just before cleanLFP is made visible.
function cleanLFP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cleanLFP (see VARARGIN)

% Choose default command line output for cleanLFP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
clc

% UIWAIT makes cleanLFP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cleanLFP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadLFP_pushbutton.
function loadLFP_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadLFP_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath(genpath('Functions'))
cla(handles.axe_LFP);
cla(handles.axe_LFP_clean);
cla(handles.axe_for_cleaning1);
set(handles.txt_saveok,'String','')
set(handles.data_listbox, 'Value',1);

handles.zoom = 'off';
[file,path] = uigetfile;
chosenfile = [path file];
filename = file(1:end-4);
if path==0
    return
end

lfp_file = load(chosenfile);
names = fieldnames(lfp_file);

names_AD = {};
for i = 1:length(names)
    tmp_var = char(names(i));
    if strcmp(tmp_var(1:2),'AD') %&& length(tmp_var)<5
        names_AD{end+1,1} = tmp_var;
    end
    clear tmp_var
end

% set(handles.data_listbox, 'String', names);
set(handles.data_listbox, 'String', names_AD);

handles.lfp_file = lfp_file;
set(handles.Name,'String',file)
handles.filename = filename;
handles.names_AD = names_AD;
handles.file = file;
handles.path = path;
guidata(hObject, handles);


function ADsig_Callback(hObject, eventdata, handles)
% hObject    handle to ADsig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ADsig as text
%        str2double(get(hObject,'String')) returns contents of ADsig as a double
% AD = (get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function ADsig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ADsig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on button press in plot.
% function plot_Callback(hObject, eventdata, handles)
% % hObject    handle to plot (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% if ~isfield(handles,'lfp_file')
%     errordlg('Please Load LFP before');
%     return
% end
% set(handles.nb_noise_zones, 'String', 0);
% set(handles.secondscleaned, 'String', 0);
% set(handles.txt_saveok,'String','')
% 
% fech = str2double(get(handles.fech,'String'));
% AD = get(handles.ADsig,'String');
% if length(AD)<3 || ~isfield(handles.lfp_file,AD)
%     errordlg('Please fill AD field correctly');
%     return;
% end
% cla(handles.axe_LFP);
% cla(handles.axe_LFP_clean);
% cla(handles.axe_for_cleaning1);
% cla(handles.axe_for_cleaning2);
% 
% var1 = ['handles.lfp_file.' AD];
% axes(handles.axe_LFP);
% 
% lfp = eval(var1);lfp = lfp(:,1);
% time = 0:1/fech:length(lfp)/fech-1/fech;
% plot(handles.axe_LFP,time,lfp,'color',[1 0 0])
% xlim(handles.axe_LFP,[time(1) time(end)])
% axis tight
% 
% [Wx, period] = wt([time' lfp],40,60,10);Wx = (abs(Wx)).^2;freq = 1./(2.^(log2(period)))';
% axes(handles.axe_LFP_clean);
% imagesc(time,1:length(freq),10*log10(Wx));
% caxis([-25 10]);xlim([time(1) time(end)])
% pas=4;set(gca,'YTick',1:pas:length(freq),'YTickLabel',floor(10^1*(downsample(freq,pas)))*10^(-1),'Fontsize',8)
% linkaxes([handles.axe_LFP handles.axe_LFP_clean],'x')
% handles.time = time;
% handles.lfp = lfp;
% handles.AD = AD;
% guidata(hObject, handles);


function fech_Callback(hObject, eventdata, handles)
% hObject    handle to fech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fech as text
%        str2double(get(hObject,'String')) returns contents of fech as a double


% --- Executes during object creation, after setting all properties.
function fech_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in no_clean_button.
function no_clean_button_Callback(hObject, eventdata, handles)
% hObject    handle to no_clean_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'lfp_file')
    errordlg('Please Load LFP before');
    return
end
if ~isfield(handles,'time')
    errordlg('Please Plot LFP before');
    return
end
clear handles.clean handles.lfp_clean
cla(handles.axe_LFP_clean);
cla(handles.axe_for_cleaning1);
cla(handles.axe_for_cleaning2);

plot(handles.axe_LFP_clean,handles.time,handles.lfp,'color',[0 0 1])
linkaxes([handles.axe_LFP handles.axe_LFP_clean],'xy');axis tight
xlim(handles.axe_LFP,[handles.time(1) handles.time(end)])
xlim(handles.axe_LFP_clean,[handles.time(1) handles.time(end)])

handles.clean = [0 handles.time(end)];
handles.cleany = ones(length(handles.time),1);

handles.lfp_clean = handles.lfp;
set(handles.nb_noise_zones, 'String', 0);
set(handles.secondscleaned, 'String', 0);

guidata(hObject, handles);

% --- Executes on button press in manualclean_button.
function manualclean_button_Callback(hObject, eventdata, handles)
% hObject    handle to manualclean_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.nb_noise_zones, 'String', 0);
set(handles.secondscleaned, 'String', 0);

if ~isfield(handles,'lfp_file')
    errordlg('Please Load LFP before');
    return
end
if ~isfield(handles,'time')
    errordlg('Please Plot LFP before');
    return
end

clear handles.clean handles.lfp_clean
fech = str2double(get(handles.fech,'String'));
% cla(handles.axe_LFP_clean);
cla(handles.axe_for_cleaning1);
cla(handles.axe_for_cleaning2);

reset(handles.axe_for_cleaning1)

zoneToClean = 'Yes';
xCoord = [];
plot(handles.axe_for_cleaning1,handles.time,handles.lfp,'color',[0 0 0]);axis tight
xlim(handles.axe_for_cleaning1,[handles.time(1) handles.time(end)])

while strcmp(zoneToClean,'Yes')
    zoomIn = questdlg('zoomIn?','zoomIn','Yes','No','No');
    if strcmp(zoomIn,'Yes')
        zoom on;
        linkaxes([handles.axe_LFP handles.axe_LFP_clean handles.axe_for_cleaning1],'x')
        pause();
        zoom off
    end
    [tempX,~] = ginput;
    xCoord = [xCoord;tempX];
    zoom out
    
    %%%%%%%% Test affichage temps réel
    for i = 1:length(xCoord)/2
        start_tmp(i,1) = xCoord(2*(i-1)+1);
        stop_tmp(i,1) = xCoord(2*i);
    end
    start_tmp(start_tmp<0) = 0;
    if stop_tmp(end)*fech>size(handles.lfp,1)
        stop_tmp(end) = size(handles.lfp,1)/fech;
    end
    noisy_manu_tmp = zeros(length(handles.time),1);
    for i = 1:length(start_tmp)
        if i==1
            noisy_manu_tmp(round(start_tmp(i)*fech)+1:round(stop_tmp(i)*fech)) = 1;
        else
            noisy_manu_tmp(round(start_tmp(i)*fech):round(stop_tmp(i)*fech)) = 1;
        end
    end
    cleany_manu_tmp = double(not(noisy_manu_tmp));
    cleany_manu_tmp(cleany_manu_tmp==0) = NaN;
    lfp_clean_tmp = handles.lfp.*cleany_manu_tmp;
    plot(handles.axe_LFP_clean,handles.time,lfp_clean_tmp,'color',[0 0 1]);axis tight
    xlim([handles.time(1) handles.time(end)])
    clear cleany_manu_tmp noisy_manu_tmp stop_tmp start_tmp
    %%%%%%%%%%%%%%%%%%%
    
    zoneToClean = questdlg('zoneToClean?','zoneToClean','Yes','No','No');
    
end

for i = 1:length(xCoord)/2
    start_manu(i,1) = xCoord(2*(i-1)+1);
    stop_manu(i,1) = xCoord(2*i);
end
%%% regle le probleme si zone de bruit en debut de LFP
start_manu(start_manu<0) = 0;

%%% regle le probleme si zone de bruit en fin de LFP
if stop_manu(end)*fech>size(handles.lfp,1)
    stop_manu(end) = size(handles.lfp,1)/fech;
else
end

noisy_manu = zeros(length(handles.time),1);

for i = 1:length(start_manu)
    if i==1
        noisy_manu(round(start_manu(i)*fech)+1:round(stop_manu(i)*fech)) = 1;
    else
        noisy_manu(round(start_manu(i)*fech):round(stop_manu(i)*fech)) = 1;
    end
end
cleany_manu = double(not(noisy_manu));
noisy = noisy_manu;
cleany = cleany_manu;
cleany(cleany==0) = NaN;
lfp_clean = handles.lfp;

cleany_test = cleany;
cleany_test(isnan(cleany_test)) = 0;
signderiv = sign(diff(cleany_test));

%%% creation des vecteurs start et stop pour la matrice 'clean'
if cleany_test(1)==1 && cleany_test(end)==1
    nb_zones_clean = length(find(signderiv==1))+1;
    start = zeros(nb_zones_clean,1);
    stop = zeros(nb_zones_clean,1);
    
    start(2:end) = find(signderiv==1);
    stop(1:end-1) = find(signderiv==-1);
    stop(end) = length(cleany);
    
elseif cleany_test(1)==1 && cleany_test(end)==0
    nb_zones_clean = length(find(signderiv==1))+1;
    start = zeros(nb_zones_clean,1);
    start(2:end) = find(signderiv==1);
    stop = find(signderiv==-1);
    
elseif cleany_test(1)==0 && cleany_test(end)==1
    nb_zones_clean = length(find(signderiv==1));
    stop = zeros(nb_zones_clean,1);
    start = find(signderiv==1);
    stop(1:end-1) = find(signderiv==-1);
    stop(end) = length(cleany);
    
elseif cleany_test(1)==0 && cleany_test(end)==0
    start = find(signderiv==1);
    stop = find(signderiv==-1);
end
clean(:,1) = round(start/fech,3);
clean(:,2) = round(stop/fech,3);

handles.lfp_clean = lfp_clean.*cleany;
handles.clean = clean;
handles.cleany = cleany;

if cleany(1)==1
    nb_zones = length(find(signderiv==-1));
else
    nb_zones = length(find(signderiv==-1))+1;
end

set(handles.nb_noise_zones, 'String', nb_zones);
set(handles.secondscleaned, 'String', round(length(find(noisy==1))/fech,1));

plot(handles.axe_LFP_clean,handles.time,handles.lfp_clean,'color',[0 0 1]);axis tight
xlim(handles.axe_LFP,[handles.time(1) handles.time(end)])
xlim(handles.axe_LFP_clean,[handles.time(1) handles.time(end)])
linkaxes([handles.axe_LFP handles.axe_LFP_clean],'x');axis tight

guidata(hObject, handles);


% --- Executes on button press in auto_clean_button.
function auto_clean_button_Callback(hObject, eventdata, handles)
% hObject    handle to auto_clean_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'lfp_file')
    errordlg('Please Load LFP before');
    return
end
if ~isfield(handles,'time')
    errordlg('Please Plot LFP before');
    return
end

set(handles.nb_noise_zones, 'String', 0);
set(handles.secondscleaned, 'String', 0);
clear handles.clean handles.lfp_clean
cla(handles.axe_for_cleaning1);
cla(handles.axe_for_cleaning2);
threholdOK = 'No';
fech = str2double(get(handles.fech,'String'));

axes(handles.axe_for_cleaning1);
[Wx, period] = wt([(handles.time)' handles.lfp],2,5,15);Wx=(abs(Wx)).^2;freq=1./(2.^(log2(period)))';
mean_filter = mean(Wx);
length_max = size(Wx,2);

semilogy(handles.time,mean_filter,'k');hold on;axis tight
while strcmp(threholdOK,'No')
    [~,threshold_high] = ginput(1);% choix du seuil au curseur
    plot(handles.axe_for_cleaning1,[handles.time(1) handles.time(end)],[threshold_high threshold_high]);hold on
    threholdOK = questdlg('Threshold OK?','Threshold','Yes','No','Yes');
end
hold off

[~, loc] = findpeaks(mean_filter,fech,'minpeakheight',threshold_high);
x = diff(sign(diff(mean_filter)));
idxUP = find(x<0);
idxDOWN = find(x>0);
for i = 1:numel(loc)
    idxCorres(i) = find(round(loc(i)*fech) == idxUP);
end
idxCorres(idxCorres==1)=2;
start_auto = idxDOWN(idxCorres-1)/fech;
stop_auto = idxDOWN(idxCorres)/fech;
long = stop_auto-start_auto;
for i = 1:length(start_auto)
    start_auto(i) = loc(i)-0.25*long(i);
    stop_auto(i) = loc(i)+0.5*long(i);
end
start_auto(start_auto<0) = 0.001;
stop_auto(stop_auto>length_max) = length_max;

lfp_clean = handles.lfp;
for i = 1:length(loc)
    lfp_clean(round(start_auto(i)*fech:stop_auto(i)*fech)) = NaN;
end

plot(handles.axe_for_cleaning2,handles.time,lfp_clean,'k');axis tight
xlim(handles.axe_for_cleaning2,[handles.time(1) handles.time(end)])

noise_auto(:,1) = start_auto;
noise_auto(:,2) = stop_auto;

for i = 1:size(noise_auto,1)
    long(i) = stop_auto(i)-start_auto(i);
end
noisy_auto = zeros(length(handles.time),1);
for i = 1:length(start_auto)
    noisy_auto(round(start_auto(i)*fech):round(stop_auto(i)*fech)) = 1;
end
cleany_auto = double(not(noisy_auto));

if cleany_auto(1)==1
    nb_zones = length(find(sign(diff(cleany_auto))==-1));
else
    nb_zones = length(find(sign(diff(cleany_auto))==-1))+1;
end

set(handles.nb_noise_zones, 'String', nb_zones);
set(handles.secondscleaned, 'String', round(sum(long),1));

linkaxes([handles.axe_LFP handles.axe_for_cleaning1 handles.axe_for_cleaning2],'x')


choice_manual = questdlg('Manual cleaning?','Manual cleaning','Yes','No','No');
switch choice_manual
    case 'Yes'
        zoneToClean = 'Yes';
        xCoord = [];
        while strcmp(zoneToClean,'Yes')
            zoomIn = questdlg('zoomIn?','zoomIn','Yes','No','No');
            if strcmp(zoomIn,'Yes')
                zoom on;pause();zoom off
                linkaxes([handles.axe_LFP handles.axe_LFP_clean handles.axe_for_cleaning1],'x')
            end
            [tempX,~] = ginput;
            xCoord = [xCoord;tempX];
            zoom out
            
            %%%%%%%% Test affichage temps réel
            for i = 1:length(xCoord)/2
                start_tmp(i,1) = xCoord(2*(i-1)+1);
                stop_tmp(i,1) = xCoord(2*i);
            end
            start_tmp(start_tmp<0) = 0;
            if stop_tmp(end)*fech>size(handles.lfp,1)
                stop_tmp(end) = size(handles.lfp,1)/fech;
            end
            noisy_manu_tmp = zeros(length(handles.time),1);
            for i = 1:length(start_tmp)
                if i==1
                    noisy_manu_tmp(round(start_tmp(i)*fech)+1:round(stop_tmp(i)*fech)) = 1;
                else
                    noisy_manu_tmp(round(start_tmp(i)*fech):round(stop_tmp(i)*fech)) = 1;
                end
            end
            cleany_manu_tmp = double(not(noisy_manu_tmp));
            cleany_manu_tmp(cleany_manu_tmp==0) = NaN;
            lfp_clean_tmp = handles.lfp.*cleany_manu_tmp;
            plot(handles.axe_LFP_clean,handles.time,lfp_clean_tmp,'color',[0 0 1]);axis tight
            xlim([handles.time(1) handles.time(end)])
            clear cleany_manu_tmp noisy_manu_tmp stop_tmp start_tmp
            %%%%%%%%%%%%%%%%%%%
            
            zoneToClean = questdlg('zoneToClean?','zoneToClean','Yes','No','No');
        end
        
        for i = 1:length(xCoord)/2
            start_manu(i,1) = xCoord(2*(i-1)+1);
            stop_manu(i,1) = xCoord(2*i);
        end
        start_manu(start_manu<0) = 0;
        noisy_manu = zeros(length(handles.time),1);
        
        for i = 1:length(start_manu)
            if i==1
                noisy_manu(round(start_manu(i)*fech)+1:round(stop_manu(i)*fech)) = 1;
            else
                noisy_manu(round(start_manu(i)*fech):round(stop_manu(i)*fech)) = 1;
            end
        end
        cleany_manu = double(not(noisy_manu));
        noisy = double(or(noisy_auto,noisy_manu));
        cleany = double(and(cleany_auto,cleany_manu));
        cleany(cleany==0) = NaN;
        lfp_clean = lfp_clean.*cleany;
        handles.lfp_clean = lfp_clean;
        set(handles.secondscleaned, 'String', round(length(find(noisy==1))/fech,1) );
        plot(handles.axe_LFP_clean,handles.time,handles.lfp_clean,'color',[0 0 1]);axis tight
        xlim(handles.axe_LFP,[handles.time(1) handles.time(end)])
        xlim(handles.axe_LFP_clean,[handles.time(1) handles.time(end)])
        linkaxes([handles.axe_LFP handles.axe_LFP_clean],'x');axis tight
        
        cleany_test = cleany;
        cleany_test(isnan(cleany_test)) = 0;
        signderiv = sign(diff(cleany_test));
        if cleany_test(1)==1
            nb_zones = length(find(signderiv==-1));
        else
            nb_zones = length(find(signderiv==-1))+1;
        end
        set(handles.nb_noise_zones, 'String', nb_zones);
        
        if cleany_test(1)==1 && cleany_test(end)==1
            nb_zones_clean = length(find(signderiv==1))+1;
            start = zeros(nb_zones_clean,1);
            stop = zeros(nb_zones_clean,1);
            
            start(2:end) = find(signderiv==1);
            stop(1:end-1) = find(signderiv==-1);
            stop(end) = length(cleany);
            
        elseif cleany_test(1)==1 && cleany_test(end)==0
            nb_zones_clean = length(find(signderiv==1))+1;
            start = zeros(nb_zones_clean,1);
            start(2:end) = find(signderiv==1);
            stop = find(signderiv==-1);
            
        elseif cleany_test(1)==0 && cleany_test(end)==1
            nb_zones_clean = length(find(signderiv==1));
            stop = zeros(nb_zones_clean,1);
            start = find(signderiv==1);
            stop(1:end-1) = find(signderiv==-1);
            stop(end) = length(cleany);
            
        elseif cleany_test(1)==0 && cleany_test(end)==0
            start = find(signderiv==1);
            stop = find(signderiv==-1);
        end
        
        clean(:,1) = round(start/fech,3);
        clean(:,2) = round(stop/fech,3);
        handles.clean = clean;
        handles.cleany = cleany;
        guidata(hObject, handles);
        
    case 'No'
        noisy = noisy_auto;
        cleany = cleany_auto;
        cleany(cleany==0) = NaN;
        handles.lfp_clean = lfp_clean;
        plot(handles.axe_LFP_clean,handles.time,handles.lfp_clean,'color',[0 0 1]);axis tight
        xlim(handles.axe_LFP,[handles.time(1) handles.time(end)])
        xlim(handles.axe_LFP_clean,[handles.time(1) handles.time(end)])
        linkaxes([handles.axe_LFP handles.axe_LFP_clean],'x');axis tight
        
        cleany_test = cleany;
        cleany_test(isnan(cleany_test)) = 0;
        signderiv = sign(diff(cleany_test));
        
        if cleany_test(1)==1 && cleany_test(end)==1
            nb_zones_clean = length(find(signderiv==1))+1;
            start = zeros(nb_zones_clean,1);
            stop = zeros(nb_zones_clean,1);
            
            start(2:end) = find(signderiv==1);
            stop(1:end-1) = find(signderiv==-1);
            stop(end) = length(cleany);
            
        elseif cleany_test(1)==1 && cleany_test(end)==0
            nb_zones_clean = length(find(signderiv==1))+1;
            start = zeros(nb_zones_clean,1);
            start(2:end) = find(signderiv==1);
            stop = find(signderiv==-1);
            
        elseif cleany_test(1)==0 && cleany_test(end)==1
            nb_zones_clean = length(find(signderiv==1));
            stop = zeros(nb_zones_clean,1);
            start = find(signderiv==1);
            stop(1:end-1) = find(signderiv==-1);
            stop(end) = length(cleany);
            
        elseif cleany_test(1)==0 && cleany_test(end)==0
            start = find(signderiv==1);
            stop = find(signderiv==-1);
        end
        clean(:,1) = round(start/fech,3);
        clean(:,2) = round(stop/fech,3);
        
        handles.clean = clean;
        handles.cleany = cleany;
        guidata(hObject, handles);
        return
end


% --- Executes on button press in existing_clean_button.
function existing_clean_button_Callback(hObject, eventdata, handles)
% hObject    handle to existing_clean_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axe_for_cleaning1)
cla(handles.axe_for_cleaning2)

if ~isfield(handles,'filename')
    errordlg('Please Load LFP before');
    return
end
fech = str2double(get(handles.fech,'String'));
filename = [handles.path handles.file];
if exist(filename)
    S = load(filename);
    names = fieldnames(S);
    
    %%% ne proposer que les noms en rapport aux LFP AD pour les clean
    %%% existant
    names_AD = {};
    for i = 1:length(names)
        tmp_var = char(names(i));
%         if strcmp(tmp_var(1:2),'AD')
            names_AD{end+1,1} = tmp_var;
%         end
        clear tmp_var
    end
    
    selection = listdlg('PromptString','Select Clean:','SelectionMode','single','ListString',names_AD);
    if ~isempty(selection)
        clean = S.(char(names_AD(selection)));
        if size(clean,2)~=2 || size(clean,1)>10000
            errordlg('Wrong selection');
            return
        end
        lfp = handles.lfp;
        cleany = startstop2vect(clean(:,1),clean(:,2),fech,length(lfp));
        cleany(cleany==0) = NaN;
        lfp_clean = lfp.*cleany;
        plot(handles.axe_for_cleaning1,handles.time,lfp_clean,'k');
        axis tight;xlim([handles.time(1) handles.time(end)])
        linkaxes([handles.axe_LFP handles.axe_LFP_clean handles.axe_for_cleaning1],'x')
        
        choice = questdlg('Clean Interval OK?','Clean Interval','Yes','No','Yes');
        switch choice
            case 'Yes'
                plot(handles.axe_LFP_clean,handles.time,lfp_clean,'b');
                axis tight;xlim([handles.time(1) handles.time(end)])
                linkaxes([handles.axe_LFP handles.axe_LFP_clean handles.axe_for_cleaning1],'x')
                handles.lfp_clean = lfp_clean;
                handles.clean = clean;
                handles.cleany = cleany;
                guidata(hObject, handles);
                
                cleany_test = cleany;
                cleany_test(isnan(cleany_test)) = 0;
                signderiv = sign(diff(cleany_test));
                if cleany(1)==1
                    nb_zones = length(find(signderiv==-1));
                else
                    nb_zones = length(find(signderiv==-1))+1;
                end
                set(handles.nb_noise_zones, 'String', nb_zones);
                set(handles.secondscleaned, 'String', round(length(find(cleany_test==0))/fech,1) );
                
            case 'No'
                cla(handles.axe_for_cleaning1)
                return
        end
    else
        return
    end
else
    errordlg('No data saved');
    return
end

% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'lfp_clean')
    errordlg('Please Clean LFP before');
    return
end
filename = [handles.path handles.file];
var_name_lfp = [ handles.AD '_lfp_clean'];
var_name_clean = [ handles.AD '_clean'];
var_name_cleany = [ handles.AD '_cleany'];

eval([var_name_lfp '=' 'handles.lfp_clean' ';'])
eval([var_name_clean '=' 'handles.clean' ';'])
eval([var_name_cleany '=' 'handles.cleany' ';'])

save(filename,var_name_clean,var_name_lfp,'-append')
% save(filename,var_name_lfp,var_name_clean,var_name_cleany,'-append')
% save(filename,var_name_clean,var_name_cleany,'-append')

set(handles.txt_saveok,'String','OK')


% --------------------------------------------------------------------
function analysis_menu_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function spindles_gui_Callback(hObject, eventdata, handles)
% hObject    handle to spindles_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spindles6080


% --------------------------------------------------------------------
function return_menu_Callback(hObject, eventdata, handles)
% hObject    handle to return_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EPHYSOFT


% --------------------------------------------------------------------
function phaselocking_Callback(hObject, eventdata, handles)
% hObject    handle to phaselocking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
phaseLockingNeurons


% --- Executes on selection change in data_listbox.
function data_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to data_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~strcmp(get(gcf,'SelectionType'),'open')
    return;
end
if ~isfield(handles,'path')
    errordlg('Please Disp data');
    return
end
set(handles.nb_noise_zones, 'String', 0);
set(handles.secondscleaned, 'String', 0);
set(handles.txt_saveok,'String','');
cla(handles.axe_LFP);
cla(handles.axe_LFP_clean);
cla(handles.axe_for_cleaning1);
cla(handles.axe_for_cleaning2);

file = handles.lfp_file;
fech = str2double(get(handles.fech,'String'));
lfp_name = get(hObject, 'Value');
lfp = file.(eval('char(handles.names_AD(lfp_name))'));
lfp = lfp(:,1);
axes(handles.axe_LFP);
time = 0:1/fech:length(lfp)/fech-1/fech;
plot(handles.axe_LFP,time,lfp,'color',[1 0 0])
xlim(handles.axe_LFP,[time(1) time(end)])
% axis tight
ylim([min(lfp) max(lfp)])
[Wx, period] = wt([time' lfp],40,60,10);Wx = (abs(Wx)).^2;freq = 1./(2.^(log2(period)))';
axes(handles.axe_LFP_clean);
imagesc(time,1:length(freq),10*log10(Wx));
caxis([-25 10]);xlim([time(1) time(end)])
pas=2;set(gca,'YTick',1:pas:length(freq),'YTickLabel',floor(10^1*(downsample(freq,pas)))*10^(-1),'Fontsize',8)
linkaxes([handles.axe_LFP handles.axe_LFP_clean],'x')
handles.time = time;
handles.lfp = lfp;
lfp_name = char(handles.names_AD(lfp_name));
handles.AD = lfp_name(1:4);
guidata(hObject, handles);
ylim(handles.axe_LFP,[min(lfp) max(lfp)])


% --- Executes during object creation, after setting all properties.
function data_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function msnfsi_Callback(hObject, eventdata, handles)
% hObject    handle to msnfsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
neuronsClassification


% --------------------------------------------------------------------
function psd_button_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to psd_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'path')
    errordlg('Please Load a file');
    return
end
S = load([handles.path handles.file]);
names = fieldnames(S);
fech = str2double(get(handles.fech,'String'));
lfp = {};
for i = 1:length(names)
    vartmp = names{i};
    if strcmp(vartmp(1:2),'AD') && length(vartmp)>2 && length(vartmp)<5
        lfp{end+1,1} = vartmp;
        lfp{end,2} = S.(eval('vartmp'));
    end
end

r_vect = [1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10]';
c_vect = [1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9  9 10]';
rc = r_vect.*c_vect;
nbr_sig_selected = size(lfp,1);
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

figure;
for i = 1:size(lfp,1)
    win = 4096;
    nfft = 4096;
    xlfp = lfp{i,2};
    [PSD,freqPSD] = pwelch(xlfp,win,[],nfft,fech);
    ax(i)=subplot(r,c,i);
    plot(freqPSD,10*log10(PSD));xlim([0 120])
    title(lfp{i,1})
    clear PSD freqPSD
end
linkaxes(ax,'x')
