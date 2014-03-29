function varargout = GUI_new(varargin)
% GUI_NEW MATLAB code for GUI_new.fig
%      GUI_NEW, by itself, creates a new GUI_NEW or raises the existing
%      singleton*.
%
%      H = GUI_NEW returns the handle to a new GUI_NEW or the handle to
%      the existing singleton*.
%
%      GUI_NEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_NEW.M with the given input arguments.
%
%      GUI_NEW('Property','Value',...) creates a new GUI_NEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_new_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_new_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_new

% Last Modified by GUIDE v2.5 04-Dec-2012 19:41:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_new_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_new_OutputFcn, ...
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


% --- Executes just before GUI_new is made visible.
function GUI_new_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_new (see VARARGIN)

% Choose default command line output for GUI_new
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_new wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_new_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb4.
function pb4_Callback(hObject, eventdata, handles)
% hObject    handle to pb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addpath('functions');
% check whether the input directory is empty
cb1 = get(handles.cb1,'value');
cb2 = get(handles.cb2,'value');
cb3 = get(handles.cb3,'value');
cb4 = get(handles.cb4,'value');
cb5 = get(handles.cb5,'value');
cb6 = get(handles.cb6,'value');
cb7 = get(handles.cb7,'value');
%fprintf('Processing %s\n', srcName);
% check whether the source, destination images are setted
if cb1==0 & cb2==0 & cb3==0 & cb4==0 & cb5==0 & cb6==0 & cb7==0
     out = 'Please select an function to process.';
     set(handles.edit5, 'string', out);
    return;
end
srcName = get(handles.edit1, 'string');
destName = get(handles.edit2, 'string');
resultDir = get(handles.edit3, 'string');
if strcmp(srcName, 'Source Image Directory')
     out = 'Please select a source image.';
     set(handles.edit5, 'string', out);
    return;
end

if strcmp(resultDir, 'Output Directory')||strcmp(resultDir, '0');
    resultDir = '.\Results';
end
mkdir(resultDir);

out = 'Processing.....';
set(handles.edit5, 'string', out);
if cb1 == 1
    if strcmp(destName, 'Destination Image Directory')
        out = 'Please select an destination image.';
        set(handles.edit5, 'string', out);
        return;
    end
    out = 'Calling Function: Seamless Cloning';
    set(handles.edit5, 'string', out);
    
    resultDir =[resultDir '\1_SeamlessCloningResults\'];
    mkdir(resultDir);
    % decompose the image into RGB channels
    imSrc = imread(srcName);
    imDest = imread(destName);
    [pathS, nameS, ~] = fileparts(srcName);
    [pahtD, nameD, ~] = fileparts(destName);

    [imDestR imDestG imDestB] = decomposeRGB(imDest);
    [imSrcR imSrcG imSrcB] = decomposeRGB(imSrc);

    % get the ROI from the source image 
    out = 'Select 4 points to define the ROI on the source image.';
    set(handles.edit5, 'string', out);
    ROIsrc = GetROI(imSrc);
    out = 'Select 1 point to define the location of pasting the ROI source image on the destination image.';
    set(handles.edit5, 'string', out);
    % get the point for the destination image to paste the ROI
    ROIdest = GetPoint(imDest);

    imTemp = imDest;
    imTemp(ROIdest(2):ROIdest(2)+ROIsrc(4),ROIdest(1):ROIdest(1)+ROIsrc(3),:) = imSrc(ROIsrc(2):ROIsrc(2)+ROIsrc(4),ROIsrc(1):ROIsrc(1)+ROIsrc(3),:);
    figure, imshow(imTemp);

    % get the seamless cloning for each channel
    imNewR = SeamlessCloning(imSrcR, imDestR, ROIsrc, ROIdest);
    imNewG = SeamlessCloning(imSrcG, imDestG, ROIsrc, ROIdest);
    imNewB = SeamlessCloning(imSrcB, imDestB, ROIsrc, ROIdest);

    % compose the new image
    imNew = composeRGB(imNewR, imNewG, imNewB);


    figure, imshow(uint8(imNew));
    outName = fullfile(resultDir, ['SeamlessCloning_Src_' nameS '_Dest_' nameD '_.jpg']);
    imwrite(uint8(imNew), outName, 'jpg');   
    out = 'Finished!';
    set(handles.edit5, 'string', out);
    
elseif cb2 == 1
    if strcmp(destName, 'Destination Image Directory')
        out = 'Please select an destination image.';
        set(handles.edit5, 'string', out);
        return;
    end
    
    out = 'Calling Function: Seamless Cloning with Mask';
    set(handles.edit5, 'string', out);  
    
    resultDir =[resultDir '\2_SeamlessCloningMaskResults\'];
    mkdir(resultDir);
    % decompose the image into RGB channels
    imSrc = imread(srcName);
    imDest = imread(destName);
    
    [pathS, nameS, ~] = fileparts(srcName);
    [pahtD, nameD, ~] = fileparts(destName);
    maskName = fullfile(pathS, [nameS '_mask.jpg']);
    
    imMask = imread(maskName);
    imMask = colorToBinary(imMask,10);
    % decompose the image into RGB channels
    [imDestR imDestG imDestB] = decomposeRGB(imDest);
    [imSrcR imSrcG imSrcB] = decomposeRGB(imSrc);
    
     % get the ROI from the source image 
    out = 'Select 1 point to match the ROI location and the destination location.';
    set(handles.edit5, 'string', out);
    vecSrc = GetPoint(imMask);
    out = 'Select 1 point to match the ROI location and the destination location.';
    set(handles.edit5, 'string', out);
    vecDest = GetPoint(imDest);

    offset = zeros(1,2);
    offset(1) = vecSrc(1) - vecDest(1);
    offset(2) = vecSrc(2) - vecDest(2);

    imNewR = SeamlessCloning_mask(imSrcR, imDestR, imMask, offset);
    imNewG = SeamlessCloning_mask(imSrcG, imDestG, imMask, offset);
    imNewB = SeamlessCloning_mask(imSrcB, imDestB, imMask, offset);

    imNew= composeRGB(imNewR, imNewG, imNewB);
    imTemp = imDest;
    for y = 1:size(imSrc, 1)
        for x = 1:size(imSrc, 2)
            if imMask(y, x) ~= 0
                yDest = y - offset(2);
                xDest = x - offset(1);
                imTemp(yDest, xDest,:) = imSrc(y, x,:);
            end
        end
    end
    figure, imshow(imTemp);title('Simple Cuting and Pating Image Result');
    figure,imshow(uint8(imNew));title('Seamless Cloning with Mask Result');
    outName = fullfile(resultDir, ['SeamlessCloningMask_Src_' nameS '_Dest_' nameD '_.jpg']);
    imwrite(uint8(imNew), outName, 'jpg');
    out = 'Finished!';
    set(handles.edit5, 'string', out);
    
elseif cb3 == 1
    if strcmp(destName, 'Destination Image Directory')
        out = 'Please select an destination image.';
        set(handles.edit5, 'string', out);
        return;
    end
    out = 'Calling Function: Inserting Objects with Holes';
    set(handles.edit5, 'string', out);    
    
    resultDir =[resultDir '\3_InsertHoleObjectResults\'];
    mkdir(resultDir);
    % decompose the image into RGB channels
    imSrc = imread(srcName);
    imDest = imread(destName);
    
    % decompose the image into RGB channels
    [imDestR imDestG imDestB] = decomposeRGB(double(imDest));
    [imSrcR imSrcG imSrcB] = decomposeRGB(double(imSrc));

    % get the ROI from the source image 
    out = 'Select 4 points to define the ROI on the source image.';
    set(handles.edit5, 'string', out);
    ROIsrc = GetROI(imSrc);
    out = 'Select 1 point to define the location of pasting the ROI source image on the destination image.';
    set(handles.edit5, 'string', out);
    % get the point for the destination image to paste the ROI
    ROIdest = GetPoint(imDest);

    imTemp = imDest;
    imTemp(ROIdest(2):ROIdest(2)+ROIsrc(4),ROIdest(1):ROIdest(1)+ROIsrc(3),:) = imSrc(ROIsrc(2):ROIsrc(2)+ROIsrc(4),ROIsrc(1):ROIsrc(1)+ROIsrc(3),:);
    figure, imshow(imTemp);title('Simple Cuting and Pasting.');

    % get the seamless cloning for each channel
    [imROIR, imR] = MixGradient(imSrcR, imDestR, ROIsrc, ROIdest);
    [imROIG, imG] = MixGradient(imSrcG, imDestG, ROIsrc, ROIdest);
    [imROIB, imB] = MixGradient(imSrcB, imDestB, ROIsrc, ROIdest);

    % compose the new image
    imNew = composeRGB(imR, imG, imB);
    figure, imshow(uint8(imNew));title('Mixing Gradient.');
    [pathS, nameS, ~] = fileparts(srcName);
    [pahtD, nameD, ~] = fileparts(destName);
    outName = fullfile(resultDir, ['InsertHoleObject_Src_' nameS '_Dest_' nameD '_.jpg']);
    imwrite(uint8(imNew), outName, 'jpg');
    out = 'Finished!';
    set(handles.edit5, 'string', out);
    
elseif cb4 == 1
    if strcmp(destName, 'Destination Image Directory')
        out = 'Please select an destination image.';
        set(handles.edit5, 'string', out);
        return;
    end
    out = 'Calling Function: Inserting Transparent Objects';
    set(handles.edit5, 'string', out);  
    
    resultDir =[resultDir '\4_InsertTransparentObjectResults\'];
    mkdir(resultDir);
    % decompose the image into RGB channels
    imSrc = imread(srcName);
    imDest = imread(destName);
    
    % decompose the image into RGB channels
    [imDestR imDestG imDestB] = decomposeRGB(double(imDest));
    [imSrcR imSrcG imSrcB] = decomposeRGB(double(imSrc));

    % get the ROI from the source image 
    out = 'Select 4 points to define the ROI on the source image.';
    set(handles.edit5, 'string', out);
    ROIsrc = GetROI(imSrc);
    out = 'Select 1 point to define the location of pasting the ROI source image on the destination image.';
    set(handles.edit5, 'string', out);
    % get the point for the destination image to paste the ROI
    ROIdest = GetPoint(imDest);

    imTemp = imDest;
    imTemp(ROIdest(2):ROIdest(2)+ROIsrc(4),ROIdest(1):ROIdest(1)+ROIsrc(3),:) = imSrc(ROIsrc(2):ROIsrc(2)+ROIsrc(4),ROIsrc(1):ROIsrc(1)+ROIsrc(3),:);
    figure, imshow(imTemp);title('Simple Cuting and Pasting.');

    % get the seamless cloning for each channel
    [imROIR, imR] = MixGradient(imSrcR, imDestR, ROIsrc, ROIdest);
    [imROIG, imG] = MixGradient(imSrcG, imDestG, ROIsrc, ROIdest);
    [imROIB, imB] = MixGradient(imSrcB, imDestB, ROIsrc, ROIdest);

    % compose the new image
    imNew = composeRGB(imR, imG, imB);
    figure, imshow(uint8(imNew));title('Mixing Gradient.');
    [pathS, nameS, ~] = fileparts(srcName);
    [pahtD, nameD, ~] = fileparts(destName);
    outName = fullfile(resultDir, ['InsertTransparentObject_Src_' nameS '_Dest_' nameD '_.jpg']);
    imwrite(uint8(imNew), outName, 'jpg');
    out = 'Finished!';
    set(handles.edit5, 'string', out);
    
    
elseif cb5 == 1
    out = 'Calling Function: Texture Flattening';
    set(handles.edit5, 'string', out);    
    
    resultDir =[resultDir '\5_TextureFlatteningResults\'];
    mkdir(resultDir);
    
    imSrc = imread(srcName);
    % decompose the image into RGB channels
    [imSrcR imSrcG imSrcB] = decomposeRGB(double(imSrc));

    % get the ROI from the source image 
    out = 'Select 4 points to define the ROI on the source image.';
    set(handles.edit5, 'string', out);
    ROIsrc = GetROI(imSrc);

    % get the seamless cloning for each channel
    imR = TextureFlattening(imSrcR, srcName,resultDir, ROIsrc);
    imG = TextureFlattening(imSrcG, srcName,resultDir, ROIsrc);
    imB = TextureFlattening(imSrcB, srcName,resultDir, ROIsrc);

    % compose the new image
    imNew = composeRGB(imR, imG, imB);
    figure, imshow(uint8(imNew));title('Texture Flattened Image');
    [path, name, ext] = fileparts(srcName);

    % save the labeled ROI image
    imLabel = imSrc;
    figure, imshow(imLabel);title('Original Image with Labeled Target Area');
    hold on;
    plot([ROIsrc(1);ROIsrc(1)+ROIsrc(3)],[ROIsrc(2);ROIsrc(2)],'r-');
    plot([ROIsrc(1);ROIsrc(1)+ROIsrc(3)],[ROIsrc(2)+ROIsrc(4);ROIsrc(2)+ROIsrc(4)],'r-');
    plot([ROIsrc(1);ROIsrc(1)],[ROIsrc(2);ROIsrc(2)+ROIsrc(4)],'r-');
    plot([ROIsrc(1)+ROIsrc(3);ROIsrc(1)+ROIsrc(3)],[ROIsrc(2);ROIsrc(2)+ROIsrc(4)],'r-');
    name0 = [name '_labeledROI.jpg'];
    name0 = fullfile(resultDir, name0);
    saveas(gcf,name0,'jpg');

    name1 = [name '_flattening.jpg'];
    name1 = fullfile(resultDir, name1);
    imwrite(uint8(imNew), name1, 'jpg');
    out = 'Finished!';
    set(handles.edit5, 'string', out);
    
elseif cb6 == 1
    out = 'Calling Function: Local Illumination Changes';
    set(handles.edit5, 'string', out);   
    
    resultDir =[resultDir '\6_IlluminationChangeResults\'];
    mkdir(resultDir);
    out = 'Processing...';
    set(handles.edit5, 'string', out);  
    imSrc = imread(srcName);
    % decompose the image into RGB channels
    [imSrcR imSrcG imSrcB] = decomposeRGB(double(imSrc));

    % get the ROI from the source image 
    out = 'Select 4 points to define the ROI on the source image.';
    set(handles.edit5, 'string', out);
    ROIsrc = GetROI(imSrc);
    alpha = get(handles.s1, 'value');
    beta =  get(handles.s2, 'value');
    alpha = fix(alpha*10)/10;
    beta = fix(beta*10)/10;
    extra = 0.0001;
    imR = IlluminationChanges(imSrcR, ROIsrc, alpha, beta, extra);
    imG = IlluminationChanges(imSrcG, ROIsrc, alpha, beta, extra);
    imB = IlluminationChanges(imSrcB, ROIsrc, alpha, beta, extra);

    % compose the new image
    imNew = composeRGB(imR, imG, imB);
    figure, imshow(uint8(imNew));title('Illumination Changed Image');
    [path, name, ext] = fileparts(srcName);

    % save the labeled ROI image
    imLabel = imSrc;
    figure, imshow(imLabel);title('Original Image with Labeled Target Area');
    hold on;
    plot([ROIsrc(1);ROIsrc(1)+ROIsrc(3)],[ROIsrc(2);ROIsrc(2)],'r-');
    plot([ROIsrc(1);ROIsrc(1)+ROIsrc(3)],[ROIsrc(2)+ROIsrc(4);ROIsrc(2)+ROIsrc(4)],'r-');
    plot([ROIsrc(1);ROIsrc(1)],[ROIsrc(2);ROIsrc(2)+ROIsrc(4)],'r-');
    plot([ROIsrc(1)+ROIsrc(3);ROIsrc(1)+ROIsrc(3)],[ROIsrc(2);ROIsrc(2)+ROIsrc(4)],'r-');
    name0 = [name '_labeledROI.jpg'];
    name0 = fullfile(resultDir, name0);
    saveas(gcf,name0,'jpg');

    name1 = [name '_IlluminationChanges_alpha_' num2str(alpha) '_beta_' num2str(beta) '.jpg'];
    name1 = fullfile(resultDir, name1);
    imwrite(uint8(imNew), name1, 'jpg');
    
    out = 'Finished!';
    set(handles.edit5, 'string', out);
    
    
elseif cb7 == 1
    out = 'Calling Function: Seamless Tiling';
    set(handles.edit5, 'string', out);   
    resultDir =[resultDir '\7_SeamlessTilingResults\'];
    mkdir(resultDir);
    out = 'Processing...';
    set(handles.edit5, 'string', out);  
    imSrc = imread(srcName);

    % decompose the image into RGB channels
    [imSrcR imSrcG imSrcB] = decomposeRGB(double(imSrc));

    % get the border conditions
    imBR = BorderManipulation(imSrcR);
    imBG = BorderManipulation(imSrcG);
    imBB = BorderManipulation(imSrcB);

    % conduct the seamless tiling
    imR = SeamlessTiling(imSrcR, imBR);
    imG = SeamlessTiling(imSrcG, imBG);
    imB = SeamlessTiling(imSrcB, imBB);
    imNew = composeRGB(imR, imG, imB);

    % show and save the generated single image
    figure, imshow(uint8(imNew));
    title('Generated Single with Border Manipulation.');
    [path, name, ext] = fileparts(srcName);
    name1 = [name '_SeamlessTiling_single.jpg'];
    name1 = fullfile(resultDir, name1);
    imwrite(uint8(imNew), name1, 'jpg');

    nheight = get(handles.s3, 'value');
    nwidth = get(handles.s4, 'value');
    nheight = fix(nheight);
    nwidth = fix(nwidth);

    imTiling_old = zeros(nheight*size(imSrc, 1), nwidth*size(imSrc, 2), 3);
    imTiling_new = imTiling_old;

    for i=1:nheight
        for j=1:nwidth
            x0 = (j-1)*size(imSrc, 2)+1;
            x1 = j*size(imSrc, 2);
            y0 = (i-1)*size(imSrc, 1)+1;
            y1 = i*size(imSrc, 1);

            imTiling_old(y0:y1, x0:x1, :) = imSrc;
            imTiling_new(y0:y1, x0:x1, :) = imNew;
        end
    end

    figure, imshow(uint8(imTiling_old)); title('Simple Combile Images');
    figure, imshow(uint8(imTiling_new)); title('Seamless Tiling Images');
    name2 = fullfile(resultDir, [name '_SeamlessTiling.jpg']);
    name3 = fullfile(resultDir, [name '_SimpleCombining.jpg']);
    imwrite(uint8(imTiling_old), name3, 'jpg');
    imwrite(uint8(imTiling_new), name2, 'jpg');
    
    out = 'Finished!';
    set(handles.edit5, 'string', out);
    
    
end






function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb1.
function pb1_Callback(hObject, eventdata, handles)
% hObject    handle to pb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.*','Select Input Image');

if (FileName)==0
    return
end

%enableButtons(handles);

FullPathName = [PathName,FileName];
set(handles.edit1, 'string', FullPathName);
%imSrc = imread(FullPathName);
%figure(1), imshow(imSrc);
guidata(hObject,handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb3.
function pb3_Callback(hObject, eventdata, handles)
% hObject    handle to pb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PathName = uigetdir('C:\', 'Select a dir');

%enableButtons(handles);
set(handles.edit3, 'string', PathName);
guidata(hObject,handles);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb2.
function pb2_Callback(hObject, eventdata, handles)
% hObject    handle to pb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.*','Select Input Image');

if (FileName)==0
    return
end

FullPathName = [PathName,FileName];
set(handles.edit2, 'string', FullPathName);
%imSrc = imread(FullPathName);
%figure(1), imshow(imSrc);
guidata(hObject,handles);


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb1.
function cb1_Callback(hObject, eventdata, handles)
% hObject    handle to cb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb1
set(handles.cb1, 'value', 1);
set(handles.cb2, 'value', 0);
set(handles.cb3, 'value', 0);
set(handles.cb4, 'value', 0);
set(handles.cb5, 'value', 0);
set(handles.cb6, 'value', 0);
set(handles.cb7, 'value', 0);

if get(handles.cb1, 'value') == 1
    str1 = ['***Seamless Cloning***', 10, 10];
    str2 = ['Parameters Need to Set:',10, 10];
    str3 = ['1. Choose Source Image', 10, 10];
    str4 = ['2. Choose Destination Image', 10, 10];
    str5 = ['3. (Optional) Choose Saving Directory', 10];
    str = [str1, str2, str3, str4, str5];
    set(handles.edit4, 'string', str);
end




% --- Executes on button press in cb2.
function cb2_Callback(hObject, eventdata, handles)
% hObject    handle to cb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb2
set(handles.cb2, 'value', 1);
set(handles.cb1, 'value', 0);
set(handles.cb3, 'value', 0);
set(handles.cb4, 'value', 0);
set(handles.cb5, 'value', 0);
set(handles.cb6, 'value', 0);
set(handles.cb7, 'value', 0);
if get(handles.cb2, 'value') == 1
    str1 = ['***Seamless Cloning with Mask***', 10, 10];
    str2 = ['Parameters Need to Set:',10, 10];
    str3 = ['1. Choose Source Image (do not need to choose mask)', 10, 10];
    str4 = ['2. Choose Destination Image', 10, 10];
    str5 = ['3. (Optional) Choose Saving Directory', 10];
    str = [str1, str2, str3, str4, str5];
    set(handles.edit4, 'string', str);
end



% --- Executes on button press in cb3.
function cb3_Callback(hObject, eventdata, handles)
% hObject    handle to cb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb3
set(handles.cb3, 'value', 1);
set(handles.cb2, 'value', 0);
set(handles.cb1, 'value', 0);
set(handles.cb4, 'value', 0);
set(handles.cb5, 'value', 0);
set(handles.cb6, 'value', 0);
set(handles.cb7, 'value', 0);
if get(handles.cb3, 'value') == 1
    str1 = ['***Inserting Objects with Holes***', 10, 10];
    str2 = ['Parameters Need to Set:',10, 10];
    str3 = ['1. Choose Source Image', 10, 10];
    str4 = ['2. Choose Destination Image', 10, 10];
    str5 = ['3. (Optional) Choose Saving Directory', 10];
    str = [str1, str2, str3, str4, str5];
    set(handles.edit4, 'string', str);
end



% --- Executes on button press in cb4.
function cb4_Callback(hObject, eventdata, handles)
% hObject    handle to cb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb4
set(handles.cb4, 'value', 1);
set(handles.cb2, 'value', 0);
set(handles.cb3, 'value', 0);
set(handles.cb1, 'value', 0);
set(handles.cb5, 'value', 0);
set(handles.cb6, 'value', 0);
set(handles.cb7, 'value', 0);
if get(handles.cb4, 'value') == 1
    str1 = ['***Inserting Transparent Objects***', 10, 10];
    str2 = ['Parameters Need to Set:',10, 10];
    str3 = ['1. Choose Source Image', 10, 10];
    str4 = ['2. Choose Destination Image', 10, 10];
    str5 = ['3. (Optional) Choose Saving Directory', 10];
    str = [str1, str2, str3, str4, str5];
    set(handles.edit4, 'string', str);
end



% --- Executes on button press in cb5.
function cb5_Callback(hObject, eventdata, handles)
% hObject    handle to cb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb5
set(handles.cb5, 'value', 1);
set(handles.cb2, 'value', 0);
set(handles.cb3, 'value', 0);
set(handles.cb4, 'value', 0);
set(handles.cb1, 'value', 0);
set(handles.cb6, 'value', 0);
set(handles.cb7, 'value', 0);
if get(handles.cb5, 'value') == 1
    str1 = ['***Texture Flattening***', 10, 10];
    str2 = ['Parameters Need to Set:',10, 10];
    str3 = ['1. Choose Source Image', 10, 10];
    str4 = ['2. (Optional) Choose Saving Directory', 10];
    str = [str1, str2, str3, str4];
    set(handles.edit4, 'string', str);
end



% --- Executes on button press in cb6.
function cb6_Callback(hObject, eventdata, handles)
% hObject    handle to cb6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb6
set(handles.cb6, 'value', 1);
set(handles.cb2, 'value', 0);
set(handles.cb3, 'value', 0);
set(handles.cb4, 'value', 0);
set(handles.cb5, 'value', 0);
set(handles.cb1, 'value', 0);
set(handles.cb7, 'value', 0);
if get(handles.cb6, 'value') == 1
    str1 = ['***Local Illumination Changes***', 10, 10];
    str2 = ['Parameters Need to Set:',10, 10];
    str3 = ['1. Choose Source Image', 10, 10];
    str4 = ['2. (Optional) Choose Saving Directory', 10, 10];
    str5 = ['3. (Optional) Select Alpha and Beta Values', 10];
    str6 = ['   (default) alpha = 0.2, beta = 0.4'];
    str = [str1, str2, str3, str4, str5, str6];
    set(handles.edit4, 'string', str);
end




% --- Executes on button press in cb7.
function cb7_Callback(hObject, eventdata, handles)
% hObject    handle to cb7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb7
set(handles.cb7, 'value', 1);
set(handles.cb2, 'value', 0);
set(handles.cb3, 'value', 0);
set(handles.cb4, 'value', 0);
set(handles.cb5, 'value', 0);
set(handles.cb6, 'value', 0);
set(handles.cb1, 'value', 0);
if get(handles.cb7, 'value') == 1
    str1 = ['***Seamless Tiling***', 10, 10];
    str2 = ['Parameters Need to Set:',10, 10];
    str3 = ['1. Choose Source Image', 10, 10];
    str4 = ['2. (Optional) Choose Saving Directory', 10, 10];
    str5 = ['3. (Optional) Select Row & Col Number of Tiling Image', 10];
    str6 = ['   (default) 2 rows & 3 cols',10];
    str = [str1, str2, str3, str4, str5, str6];
    set(handles.edit4, 'string', str);
end



% --- Executes on slider movement.
function s2_Callback(hObject, eventdata, handles)
% hObject    handle to s2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

beta = get(handles.s2, 'value');

out2 =  num2str(fix(beta*10)/10);

set(handles.edit7,'string',out2);

% --- Executes during object creation, after setting all properties.
function s2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function s1_Callback(hObject, eventdata, handles)
% hObject    handle to s1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
alpha = get(handles.s1, 'value');

out1 = num2str(fix(alpha*10)/10);

set(handles.edit6,'string',out1);

% --- Executes during object creation, after setting all properties.
function s1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function s4_Callback(hObject, eventdata, handles)
% hObject    handle to s4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

col = get(handles.s4, 'value');

out2 = num2str(fix(col));
set(handles.edit9,'string',out2);

% --- Executes during object creation, after setting all properties.
function s4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function s3_Callback(hObject, eventdata, handles)
% hObject    handle to s3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = get(handles.s3, 'value');
out1 = num2str(fix(row));
set(handles.edit8,'string',out1);

% --- Executes during object creation, after setting all properties.
function s3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
