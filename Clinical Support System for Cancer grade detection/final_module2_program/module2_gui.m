function varargout = module2_gui(varargin)
% MODULE2_GUI MATLAB code for module2_gui.fig
%      MODULE2_GUI, by itself, creates a new MODULE2_GUI or raises the existing
%      singleton*.
%
%      H = MODULE2_GUI returns the handle to a new MODULE2_GUI or the handle to
%      the existing singleton*.
%
%      MODULE2_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODULE2_GUI.M with the given input arguments.
%
%      MODULE2_GUI('Property','Value',...) creates a new MODULE2_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before module2_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to module2_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help module2_gui

% Last Modified by GUIDE v2.5 28-Apr-2017 16:01:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @module2_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @module2_gui_OutputFcn, ...
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


% --- Executes just before module2_gui is made visible.
function module2_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to module2_gui (see VARARGIN)

handles.segmentationColors = [255, 255, 255, 0,          NaN; ...
                              255,   0, 255, 0,          NaN; ...
                                0,   0, 255, 1, (9.0 / 12.0)];

handles.imageDatasetDirectory = '';
handles.imageDatasetFiles = dir('');
handles.currentImageSelection = 0;
handles.currentImage = uint8(zeros(512, 512, 3));
handles.currentSegmentationSelection = 1;
handles.currentSegmentationFull = uint8(zeros(512, 512, 3));
handles.currentSegmentationColor = uint8(zeros(512, 512, 3));
handles.currentSegmentationColorNoFill = uint8(zeros(512, 512, 3));
handles.currentSegmentationWatershed = uint8(zeros(512, 512, 3));
handles.featureMatrixFile = '';
handles.featureMatrix = cell(0);
handles.featureMatrixClasses = cell(0);
handles.trainingFeatureMatrix = cell(0);
handles.trainingFeatureRank = [];
handles.trainingFeatureMatrixCached = cell(0);
handles.trainingFeatureRankCached = cell(0);
handles.selectedImageFeatures = [];
handles.selectedImageLabel = '';
handles.currentFeatures = cell(0);
handles.currentClass = '';
handles.fuzziness = 2.0;
handles.watershedBlur = 2.0;
handles.fixedNucleiHue = 270.0;
handles.currentFeatureSelection = 0;
handles.currentFeatureViewSelection = 1;
handles.foldIndices = cell(0);
handles.testingFold = 0;
handles.classifierSelection = 1;
handles.classifierViewSelection = 1;

handles.knnFeatureCountRange = [];
handles.knnKRange = [];
handles.knnPerformanceAcc = [];
handles.knnPerformanceKappa = [];
handles.knnBestFeatureCount = [];
handles.knnBestK = [];
handles.knnCVPerformance = nan(10, 1);
handles.knnEVPerformance = nan(10, 1);

handles.netFeatureCountRange = [];
handles.netNeuronCountRange = [];
handles.netPerformanceAcc = [];
handles.netPerformanceKappa = [];
handles.netBestFeatureCount = [];
handles.netBestNeuronCount = [];
handles.netCVPerformance = nan(10, 1);
handles.netEVPerformance = nan(10, 1);

handles.svmFeatureCountRange = [];
handles.svmRBFSigmaRange = [];
handles.svmPerformanceAcc = [];
handles.svmPerformanceKappa = [];
handles.svmBestFeatureCount = [];
handles.svmBestRBFSigma = [];
handles.svmCVPerformance = nan(10, 1);
handles.svmEVPerformance = nan(10, 1);

handles.imageFeaturesAxesLegend = [];
handles.imageClassificationAxesColorbar = [];

set(handles.fixedNucleiHueSlider, ...
    'BackgroundColor', ...
    hsv2rgb([handles.fixedNucleiHue./360, 1, 1]));

imshow(handles.currentImage, 'Parent', handles.imageSelectionAxes);
imshow(handles.currentSegmentationFull, 'Parent', handles.imageSegmentationAxes);

cla(handles.imageFeaturesAxes);
cla(handles.imageClassificationAxes);

linkaxes([handles.imageSelectionAxes, ...
          handles.imageSegmentationAxes], ...
          'xy');

% Choose default command line output for module2_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes module2_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = module2_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in imageDatasetDirectoryButton.
function imageDatasetDirectoryButton_Callback(hObject, eventdata, handles)
% hObject    handle to imageDatasetDirectoryButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uigetdir_return = uigetdir(handles.imageDatasetDirectory, 'Select Image Dataset Directory');

if (length(uigetdir_return) > 1)
    handles.imageDatasetDirectory = uigetdir_return;

    set(handles.imageDatasetDirectoryEdit, 'String', handles.imageDatasetDirectory);
    
    handles.imageDatasetFiles = dir(strcat(handles.imageDatasetDirectory, '/*.png'));
    
    if (length(handles.imageDatasetFiles) >= 1)
        imageSelectionPopUpMenuItems = cell(length(handles.imageDatasetFiles), 1);
        
        for i = 1:length(imageSelectionPopUpMenuItems)
            imageSelectionPopUpMenuItems{i} = handles.imageDatasetFiles(i).name;
        end
        
        set(handles.imageSelectionPopUpMenu, 'Value', 1);
        set(handles.imageSelectionPopUpMenu, 'String', imageSelectionPopUpMenuItems);
        
        handles.currentImageSelection = 1;
        handles.currentImage = imread(strcat(handles.imageDatasetDirectory, ...
                                             '/', ...
                                             handles.imageDatasetFiles(1).name));
        
        handles.testingFold = determineTestingFold(handles);
        [handles.trainingFeatureMatrix, ...
         handles.trainingFeatureRank] = getTrainingFeatureMatrix(handles);

        if (handles.testingFold > 0)
            handles.trainingFeatureMatrixCached{handles.testingFold} = ...
                handles.trainingFeatureMatrix;
            handles.trainingFeatureRankCached{handles.testingFold} = ...
                handles.trainingFeatureRank;
        end
        
        [handles.selectedImageFeatures, ...
         handles.selectedImageLabel] = getSelectedImageInfo(handles);
    else
        set(handles.imageSelectionPopUpMenu, 'Value', 1);
        set(handles.imageSelectionPopUpMenu, 'String', '<No Image Dataset>');
        
        handles.currentImageSelection = 0;
        handles.currentImage = uint8(zeros(512, 512, 3));
        handles.currentSegmentationFull = uint8(zeros(512, 512, 3));
        handles.currentSegmentationColor = uint8(zeros(512, 512, 3));
        handles.currentSegmentationColorNoFill = uint8(zeros(512, 512, 3));
        handles.currentSegmentationWatershed = uint8(zeros(512, 512, 3));
    end
    
    imshow(handles.currentImage, 'Parent', handles.imageSelectionAxes);
end

drawFeatureAxes(hObject, handles);
handles = guidata(hObject);

guidata(hObject, handles);

function imageDatasetDirectoryEdit_Callback(hObject, eventdata, handles)
% hObject    handle to imageDatasetDirectoryEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imageDatasetDirectoryEdit as text
%        str2double(get(hObject,'String')) returns contents of imageDatasetDirectoryEdit as a double


% --- Executes during object creation, after setting all properties.
function imageDatasetDirectoryEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageDatasetDirectoryEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function featureMatrixEdit_Callback(hObject, eventdata, handles)
% hObject    handle to featureMatrixEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of featureMatrixEdit as text
%        str2double(get(hObject,'String')) returns contents of featureMatrixEdit as a double


% --- Executes during object creation, after setting all properties.
function featureMatrixEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featureMatrixEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in featureMatrixButton.
function featureMatrixButton_Callback(hObject, eventdata, handles)
% hObject    handle to featureMatrixButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prev_feature_matrix_file = handles.featureMatrixFile;

[temp_file, temp_folder] = uigetfile(handles.featureMatrixFile, 'Select Feature Matrix File');

if ((length(temp_file)   > 1) && ...
    (length(temp_folder) > 1))
    handles.featureMatrixFile = strcat(temp_folder, temp_file);

    set(handles.featureMatrixEdit, 'String', handles.featureMatrixFile);

    try
        load(handles.featureMatrixFile, '-mat', 'feature_matrix');

        handles.featureMatrix = feature_matrix;
        handles.trainingFeatureMatrixCached = cell(0);
        handles.trainingFeatureRankCached = cell(0);

        clear feature_matrix;
        
        featureNameList = cell(length(handles.featureMatrix{2}), 1);
        
        for i = 1:length(featureNameList)
            featureNameList{i} = sprintf('%d. %s', i, handles.featureMatrix{2}{i});
        end
        
        set(handles.featureSelectionPopUpMenu, 'Value', 1);
        set(handles.featureSelectionPopUpMenu, 'String', featureNameList);
        
        handles.currentFeatureSelection = 1;
        
        featureMatrixClasses = cell(0);
        
        for i = 1:length(handles.featureMatrix{3})
            temp_class = handles.featureMatrix{3}{i};
            if (~any(strcmpi(temp_class, featureMatrixClasses)))
                featureMatrixClasses = [featureMatrixClasses; temp_class];
            end
        end
        
        handles.featureMatrixClasses = featureMatrixClasses;
        
        if (handles.currentImageSelection > 0)
            for j = 1:length(handles.featureMatrix{4})
                if (strcmpi(handles.imageDatasetFiles(handles.currentImageSelection).name, ...
                            handles.featureMatrix{4}{j}))
                    handles.currentFeatures = handles.featureMatrix{1}(j, :);
                    handles.currentClass = handles.featureMatrix{3}{j};
                    break;
                end
            end
        end
        
        clearClassifierResults(hObject, handles);
        handles = guidata(hObject);
    catch
        msgbox({'File does not contain a valid feature matrix:', ...
                sprintf('%s', handles.featureMatrixFile)}, ...
               'Invalid Feature Matrix File', ...
               'error');

        handles.featureMatrixFile = prev_feature_matrix_file;

        set(handles.featureMatrixEdit, 'String', handles.featureMatrixFile);
        
        set(handles.featureSelectionPopUpMenu, 'Value', 1);
        set(handles.featureSelectionPopUpMenu, 'String', '<No Feature Matrix>');
        
        handles.currentFeatureSelection = 0;
    end
end

handles.foldIndices = splitFolds(handles);
handles.testingFold = determineTestingFold(handles);
[handles.trainingFeatureMatrix, ...
 handles.trainingFeatureRank] = getTrainingFeatureMatrix(handles);

if (handles.testingFold > 0)
    handles.trainingFeatureMatrixCached{handles.testingFold} = ...
        handles.trainingFeatureMatrix;
    handles.trainingFeatureRankCached{handles.testingFold} = ...
        handles.trainingFeatureRank;
end

[handles.selectedImageFeatures, ...
 handles.selectedImageLabel] = getSelectedImageInfo(handles);
        
drawFeatureAxes(hObject, handles);
handles = guidata(hObject);

guidata(hObject, handles);

% --- Executes on button press in featureMatrixGenerateButton.
function featureMatrixGenerateButton_Callback(hObject, eventdata, handles)
% hObject    handle to featureMatrixGenerateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cancel = false;

if (isempty(handles.imageDatasetFiles))
    msgbox('Please specify an image dataset directory with one or more PNG images', ...
           'Generate Feature Matrix Error', ...
           'error');
    
    cancel = true;
end

classification_labels = cell(0);

if (~cancel)
    dialog_result = ...
        questdlg('Use spreadsheet to specify image classification labels?', ...
            'Specify Image Classification Labels', ...
            'Yes...', 'Use File Names', 'Cancel', 'Cancel');

    switch dialog_result
        case 'Yes...'
            [temp_file, temp_folder] = uigetfile({'*.xlsx'; '*.xls'; '*.xlsm'; '*.xltx'; '*.xltm'}, 'Select Image Classification Labels Spreadsheet');

            if ((length(temp_file)   > 1) && ...
                (length(temp_folder) > 1))
                temp_classification_labels_file = strcat(temp_folder, temp_file);

                try
                    [~, ~, classification_labels] = xlsread(temp_classification_labels_file);

                    input_result = inputdlg({'Spreadsheet Row Range (MATLAB syntax):', ...
                                             'Spreadsheet File ID Column:', ...
                                             'Spreadsheet Label Column:'}, ...
                                            'Specify Label Location in Spreadsheet', ...
                                            1, ...
                                            {sprintf('2:%d', size(classification_labels, 1)), '1', '4'});

                    classification_labels = {classification_labels{str2num(input_result{1}), str2num(input_result{2})}; ...
                                             classification_labels{str2num(input_result{1}), str2num(input_result{3})}};

                    classification_labels = classification_labels';
                catch
                    msgbox({'Failed to read image classification labels spreadsheet:', ...
                            sprintf('%s', temp_classification_labels_file)}, ...
                           'Read Image Classification Labels Spreadsheet Error', ...
                           'error');

                    cancel = true;
                end
            else
                cancel = true;
            end
        case 'Use File Names'
        case 'Cancel'
            cancel = true;
    end
end

if (~cancel)
    [temp_file, temp_folder] = uiputfile('*.mat', 'Generate Feature Matrix');

    if ((length(temp_file)   > 1) && ...
        (length(temp_folder) > 1))
        temp_feature_matrix_file = strcat(temp_folder, temp_file);

        feature_matrix = cell(4, 1);
        feature_matrix{1} = [];
        feature_matrix{2} = cell(0);
        feature_matrix{3} = cell(0);
        feature_matrix{4} = cell(0);

        i = 1;

        for file = handles.imageDatasetFiles'

            filepattern = regexp(file.name, '^([a-zA-Z0-9\-]+)_(\d+)', 'tokens');

            if (length(filepattern) >= 1)
                if (length(filepattern{1}) >= 2)

                    input_image = imread(strcat(handles.imageDatasetDirectory, '/', file.name));

                    output_features = histopath_features( ...
                        histopath_seg( ...
                            handles.segmentationColors, ...
                            input_image, ...
                            2, ...
                            handles.fuzziness, ...
                            handles.watershedBlur), ...
                        input_image);

                    feature_matrix{1} = [feature_matrix{1}; ...
                                         output_features{1}];

                    feature_matrix{2} = output_features{2};

                    if (isempty(classification_labels))
                        feature_matrix{3} = [feature_matrix{3}; ...
                                             filepattern{1}{1}];
                    else
                        labelled = false;

                        for j = 1:size(classification_labels, 1)
                            if (strcmpi(filepattern{1}{1}, classification_labels{j, 1}))
                                feature_matrix{3} = [feature_matrix{3}; ...
                                                     classification_labels{j, 2}];
                                labelled = true;
                                break;
                            end
                        end

                        if (~labelled)
                            % Label not present for this image (should not occur)
                            feature_matrix{3} = [feature_matrix{3}; ...
                                                 'N/A'];

                            disp(sprintf('Warning: label missing for %s (%d/%d)', file.name, i, length(handles.imageDatasetFiles)));
                        end
                    end

                    feature_matrix{4} = [feature_matrix{4}; ...
                                         file.name];

                    disp(sprintf('Generated feature vector for %s (%d/%d)', file.name, i, length(handles.imageDatasetFiles)));
                    
                    i = i + 1;
                end
            end
        end

        try
            save(temp_feature_matrix_file, 'feature_matrix');
        catch
            msgbox({'Failed to generate feature matrix in file:', ...
                    sprintf('%s', temp_feature_matrix_file)}, ...
                   'Generate Feature Matrix Error', ...
                   'error');
            
            cancel = true;
        end
        
        if (~cancel)
            msgbox({'Feature matrix generated successfully at the following location:', ...
                    temp_feature_matrix_file}, ...
                   'Generate Feature Matrix Success', ...
                   'help')
        end
    end
end

% --- Executes on selection change in imageSelectionPopUpMenu.
function imageSelectionPopUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to imageSelectionPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imageSelectionPopUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imageSelectionPopUpMenu

if (get(hObject, 'Value') <= length(handles.imageDatasetFiles))
    handles.currentImageSelection = get(hObject, 'Value');
else
    handles.currentImageSelection = 0;
end

if (handles.currentImageSelection > 0)
    handles.currentImage = imread(strcat(handles.imageDatasetDirectory, ...
                                         '/', ...
                                         handles.imageDatasetFiles(handles.currentImageSelection).name));
    
    imshow(handles.currentImage, 'Parent', handles.imageSelectionAxes);
    
    if (~isempty(handles.featureMatrix))
        if (length(handles.featureMatrix) >= 4)
            for j = 1:length(handles.featureMatrix{4})
                if (strcmpi(handles.imageDatasetFiles(handles.currentImageSelection).name, ...
                            handles.featureMatrix{4}{j}))
                    handles.currentFeatures = handles.featureMatrix{1}(j, :);
                    handles.currentClass = handles.featureMatrix{3}{j};
                    break;
                end
            end
        end
    end
end

handles.testingFold = determineTestingFold(handles);
[handles.trainingFeatureMatrix, ...
 handles.trainingFeatureRank] = getTrainingFeatureMatrix(handles);

if (handles.testingFold > 0)
    handles.trainingFeatureMatrixCached{handles.testingFold} = ...
        handles.trainingFeatureMatrix;
    handles.trainingFeatureRankCached{handles.testingFold} = ...
        handles.trainingFeatureRank;
end

[handles.selectedImageFeatures, ...
 handles.selectedImageLabel] = getSelectedImageInfo(handles);

drawFeatureAxes(hObject, handles);
handles = guidata(hObject);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function imageSelectionPopUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageSelectionPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in imageSelectionNextButton.
function imageSelectionNextButton_Callback(hObject, eventdata, handles)
% hObject    handle to imageSelectionNextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.currentImageSelection + 1 <= length(handles.imageDatasetFiles))
    handles.currentImageSelection = handles.currentImageSelection + 1;

    set(handles.imageSelectionPopUpMenu, 'Value', handles.currentImageSelection);

    handles.currentImage = imread(strcat(handles.imageDatasetDirectory, ...
                                         '/', ...
                                         handles.imageDatasetFiles(handles.currentImageSelection).name));

    imshow(handles.currentImage, 'Parent', handles.imageSelectionAxes);
else
    handles.currentImageSelection = 0;
end
        
if (handles.currentImageSelection > 0)
    if (~isempty(handles.featureMatrix))
        if (length(handles.featureMatrix) >= 4)
            for j = 1:length(handles.featureMatrix{4})
                if (strcmpi(handles.imageDatasetFiles(handles.currentImageSelection).name, ...
                            handles.featureMatrix{4}{j}))
                    handles.currentFeatures = handles.featureMatrix{1}(j, :);
                    handles.currentClass = handles.featureMatrix{3}{j};
                    break;
                end
            end
        end
    end
end

handles.testingFold = determineTestingFold(handles);
[handles.trainingFeatureMatrix, ...
 handles.trainingFeatureRank] = getTrainingFeatureMatrix(handles);

if (handles.testingFold > 0)
    handles.trainingFeatureMatrixCached{handles.testingFold} = ...
        handles.trainingFeatureMatrix;
    handles.trainingFeatureRankCached{handles.testingFold} = ...
        handles.trainingFeatureRank;
end

[handles.selectedImageFeatures, ...
 handles.selectedImageLabel] = getSelectedImageInfo(handles);

drawFeatureAxes(hObject, handles);
handles = guidata(hObject);

guidata(hObject, handles);

% --- Executes on button press in imageSelectionPrevButton.
function imageSelectionPrevButton_Callback(hObject, eventdata, handles)
% hObject    handle to imageSelectionPrevButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (length(handles.imageDatasetFiles) > 0)
    if (handles.currentImageSelection - 1 >= 1)
        handles.currentImageSelection = handles.currentImageSelection - 1;

        set(handles.imageSelectionPopUpMenu, 'Value', handles.currentImageSelection);

        handles.currentImage = imread(strcat(handles.imageDatasetDirectory, ...
                                             '/', ...
                                             handles.imageDatasetFiles(handles.currentImageSelection).name));

        imshow(handles.currentImage, 'Parent', handles.imageSelectionAxes);
    else
        handles.currentImageSelection = 1;
    end
else
    handles.currentImageSelection = 0;
end
        
if (handles.currentImageSelection > 0)
    if (~isempty(handles.featureMatrix))
        if (length(handles.featureMatrix) >= 4)
            for j = 1:length(handles.featureMatrix{4})
                if (strcmpi(handles.imageDatasetFiles(handles.currentImageSelection).name, ...
                            handles.featureMatrix{4}{j}))
                    handles.currentFeatures = handles.featureMatrix{1}(j, :);
                    handles.currentClass = handles.featureMatrix{3}{j};
                    break;
                end
            end
        end
    end
end

handles.testingFold = determineTestingFold(handles);
[handles.trainingFeatureMatrix, ...
 handles.trainingFeatureRank] = getTrainingFeatureMatrix(handles);

if (handles.testingFold > 0)
    handles.trainingFeatureMatrixCached{handles.testingFold} = ...
        handles.trainingFeatureMatrix;
    handles.trainingFeatureRankCached{handles.testingFold} = ...
        handles.trainingFeatureRank;
end

[handles.selectedImageFeatures, ...
 handles.selectedImageLabel] = getSelectedImageInfo(handles);

drawFeatureAxes(hObject, handles);
handles = guidata(hObject);

guidata(hObject, handles);

% --- Executes on slider movement.
function fuzzinessSlider_Callback(hObject, eventdata, handles)
% hObject    handle to fuzzinessSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.fuzziness = get(hObject, 'Value');

handles.fuzziness = round(handles.fuzziness .* 2.0) ./ 2.0;

set(handles.fuzzinessText, ...
    'String', ...
    sprintf('Fuzziness: %.1f', handles.fuzziness));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fuzzinessSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fuzzinessSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function watershedBlurSlider_Callback(hObject, eventdata, handles)
% hObject    handle to watershedBlurSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.watershedBlur = get(hObject, 'Value');

handles.watershedBlur = round(handles.watershedBlur .* 2.0) ./ 2.0;

set(handles.watershedBlurText, ...
    'String', ...
    sprintf('Watershed Blur: %.1f', handles.watershedBlur));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function watershedBlurSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to watershedBlurSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in imageSegmentationPopUpMenu.
function imageSegmentationPopUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to imageSegmentationPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imageSegmentationPopUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imageSegmentationPopUpMenu

handles.currentSegmentationSelection = get(hObject, 'Value');

linkaxes([handles.imageSelectionAxes, ...
          handles.imageSegmentationAxes], ...
          'off');

if (handles.currentSegmentationSelection == 1)
    imshow(handles.currentSegmentationFull, 'Parent', handles.imageSegmentationAxes);
elseif (handles.currentSegmentationSelection == 2)
    imshow(handles.currentSegmentationColor, 'Parent', handles.imageSegmentationAxes);
elseif (handles.currentSegmentationSelection == 3)
    imshow(handles.currentSegmentationColorNoFill, 'Parent', handles.imageSegmentationAxes);
else
    imshow(handles.currentSegmentationWatershed, 'Parent', handles.imageSegmentationAxes);
end

linkaxes([handles.imageSelectionAxes, ...
          handles.imageSegmentationAxes], ...
          'xy');

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function imageSegmentationPopUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageSegmentationPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fuzzinessCheckBox.
function fuzzinessCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to fuzzinessCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fuzzinessCheckBox

if (get(hObject, 'Value'))
    set(handles.fuzzinessSlider, 'Enable', 'on');
    set(handles.fuzzinessText, 'Enable', 'on');
else
    handles.fuzziness = 1.0;
    set(handles.fuzzinessSlider, 'Value', handles.fuzziness);
    set(handles.fuzzinessSlider, 'Enable', 'off');
    set(handles.fuzzinessText, 'String', sprintf('Fuzziness: %.1f', handles.fuzziness));
    set(handles.fuzzinessText, 'Enable', 'off');
end

guidata(hObject, handles);

% --- Executes on button press in watershedBlurCheckBox.
function watershedBlurCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to watershedBlurCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of watershedBlurCheckBox

if (get(hObject, 'Value'))
    set(handles.watershedBlurSlider, 'Enable', 'on');
    set(handles.watershedBlurText, 'Enable', 'on');
else
    handles.watershedBlur = 10.0;
    set(handles.watershedBlurSlider, 'Value', handles.watershedBlur);
    set(handles.watershedBlurSlider, 'Enable', 'off');
    set(handles.watershedBlurText, 'String', sprintf('Watershed Blur: %.1f', handles.watershedBlur));
    set(handles.watershedBlurText, 'Enable', 'off');
end

guidata(hObject, handles);

% --- Executes on button press in fixedNucleiHueCheckBox.
function fixedNucleiHueCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to fixedNucleiHueCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fixedNucleiHueCheckBox

if (get(hObject, 'Value'))
    handles.segmentationColors(3, 5) = double(handles.fixedNucleiHue) ./ 360.0;
    set(handles.fixedNucleiHueSlider, 'Enable', 'on');
    set(handles.fixedNucleiHueText, 'Enable', 'on');
else
    handles.fixedNucleiHue = 270.0;
    handles.segmentationColors(3, 5) = nan(1);
    set(handles.fixedNucleiHueSlider, 'Value', handles.fixedNucleiHue);
    set(handles.fixedNucleiHueSlider, 'Enable', 'off');
    set(handles.fixedNucleiHueText, 'String', sprintf('Fixed Nuclei Hue: %d', handles.fixedNucleiHue));
    set(handles.fixedNucleiHueText, 'Enable', 'off');
end

set(handles.fixedNucleiHueSlider, ...
    'BackgroundColor', ...
    hsv2rgb([handles.fixedNucleiHue./360, 1, 1]));

guidata(hObject, handles);

% --- Executes on slider movement.
function fixedNucleiHueSlider_Callback(hObject, eventdata, handles)
% hObject    handle to fixedNucleiHueSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.fixedNucleiHue = get(hObject, 'Value');

handles.fixedNucleiHue = round(handles.fixedNucleiHue ./ 5.0) .* 5.0;

set(handles.fixedNucleiHueText, ...
    'String', ...
    sprintf('Fixed Nuclei Hue: %d', handles.fixedNucleiHue));

set(handles.fixedNucleiHueSlider, ...
    'BackgroundColor', ...
    hsv2rgb([handles.fixedNucleiHue./360, 1, 1]));

handles.segmentationColors(3, 5) = double(handles.fixedNucleiHue) ./ 360.0;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fixedNucleiHueSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedNucleiHueSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in resetToDefaultsButton.
function resetToDefaultsButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetToDefaultsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.fuzziness = 2.0;

set(handles.fuzzinessCheckBox, ...
    'Value', ...
    1);

set(handles.fuzzinessSlider, ...
    'Enable', ...
    'on');

set(handles.fuzzinessText, ...
    'Enable', ...
    'on');

set(handles.fuzzinessSlider, ...
    'Value', ...
    handles.fuzziness);

set(handles.fuzzinessText, ...
    'String', ...
    sprintf('Fuzziness: %.1f', handles.fuzziness));

handles.watershedBlur = 2.0;

set(handles.watershedBlurCheckBox, ...
    'Value', ...
    1);

set(handles.watershedBlurSlider, ...
    'Enable', ...
    'on');

set(handles.watershedBlurText, ...
    'Enable', ...
    'on');

set(handles.watershedBlurSlider, ...
    'Value', ...
    handles.watershedBlur);

set(handles.watershedBlurText, ...
    'String', ...
    sprintf('Watershed Blur: %.1f', handles.watershedBlur));

handles.fixedNucleiHue = 270.0;

set(handles.fixedNucleiHueCheckBox, ...
    'Value', ...
    1);

set(handles.fixedNucleiHueSlider, ...
    'Enable', ...
    'on');

set(handles.fixedNucleiHueText, ...
    'Enable', ...
    'on');

set(handles.fixedNucleiHueSlider, ...
    'Value', ...
    handles.fixedNucleiHue);

set(handles.fixedNucleiHueText, ...
    'String', ...
    sprintf('Fixed Nuclei Hue: %d', handles.fixedNucleiHue));

set(handles.fixedNucleiHueSlider, ...
    'BackgroundColor', ...
    hsv2rgb([handles.fixedNucleiHue./360, 1, 1]));

handles.segmentationColors(3, 5) = double(handles.fixedNucleiHue) ./ 360.0;

guidata(hObject, handles);

% --- Executes on selection change in featureSelectionPopUpMenu.
function featureSelectionPopUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to featureSelectionPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns featureSelectionPopUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from featureSelectionPopUpMenu

if (~isempty(handles.featureMatrix))
    if (length(handles.featureMatrix) >= 2)
        if (get(hObject, 'Value') <= length(handles.featureMatrix{2}))
            handles.currentFeatureSelection = get(hObject, 'Value');
        else
            handles.currentFeatureSelection = 0;
        end
    else
        handles.currentFeatureSelection = 0;
    end
else
    handles.currentFeatureSelection = 0;
end

drawFeatureAxes(hObject, handles);
handles = guidata(hObject);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function featureSelectionPopUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featureSelectionPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in featureViewPopUpMenu.
function featureViewPopUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to featureViewPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns featureViewPopUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from featureViewPopUpMenu

handles.currentFeatureViewSelection = get(hObject,'Value');

drawFeatureAxes(hObject, handles);
handles = guidata(hObject);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function featureViewPopUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featureViewPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in classifierPopUpMenu.
function classifierPopUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to classifierPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns classifierPopUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from classifierPopUpMenu

handles.classifierSelection = get(hObject, 'Value');

if (handles.classifierViewSelection == 1)
    if (handles.classifierSelection == 1)
        if (~isempty(handles.knnPerformanceAcc))
            [x, y] = meshgrid(handles.knnFeatureCountRange, handles.knnKRange);

            drawClassifierPerformance(hObject, handles, ...
                handles.knnPerformanceAcc, ...
                x, y, ...
                [handles.knnBestFeatureCount, handles.knnBestK], ...
                'Feature Count', 'K Neighbors', ...
                'KNN Parameter Accuracy Heatmap');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    elseif (handles.classifierSelection == 2)
        if (~isempty(handles.netPerformanceAcc))
            [x, y] = meshgrid(handles.netFeatureCountRange, handles.netNeuronCountRange);

            drawClassifierPerformance(hObject, handles, ...
                handles.netPerformanceAcc, ...
                x, y, ...
                [handles.netBestFeatureCount, handles.netBestNeuronCount], ...
                'Feature Count', 'Hidden Layer Node Count', ...
                'Neural Net Parameter Accuracy Heatmap');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    else
        if (~isempty(handles.svmPerformanceAcc))
            [x, y] = meshgrid(handles.svmFeatureCountRange, handles.svmRBFSigmaRange);

            drawClassifierPerformance(hObject, handles, ...
                handles.svmPerformanceAcc, ...
                x, y, ...
                [handles.svmBestFeatureCount, handles.svmBestRBFSigma], ...
                'Feature Count', 'RBF Sigma', ...
                'SVM (RBF) Parameter Accuracy Heatmap');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    end
elseif (handles.classifierViewSelection == 2)
    if (handles.classifierSelection == 1)
        if (any(and(~isnan(handles.knnCVPerformance), ~isnan(handles.knnEVPerformance))))
            drawClassifierEV(hObject, handles, ...
                    handles.knnCVPerformance, ...
                    handles.knnEVPerformance, ...
                    'Cross Validation Accuracy', 'External Validation Accuracy', ...
                    'KNN CV vs. EV (Predictability)');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    elseif (handles.classifierSelection == 2)
        if (any(and(~isnan(handles.netCVPerformance), ~isnan(handles.netEVPerformance))))
            drawClassifierEV(hObject, handles, ...
                    handles.netCVPerformance, ...
                    handles.netEVPerformance, ...
                    'Cross Validation Accuracy', 'External Validation Accuracy', ...
                    'Neural Net CV vs. EV (Predictability)');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    else
        if (any(and(~isnan(handles.svmCVPerformance), ~isnan(handles.svmEVPerformance))))
            drawClassifierEV(hObject, handles, ...
                    handles.svmCVPerformance, ...
                    handles.svmEVPerformance, ...
                    'Cross Validation Accuracy', 'External Validation Accuracy', ...
                    'SVM (RBF) CV vs. EV (Predictability)');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    end
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function classifierPopUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to classifierPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in classifierGraphTypePopUpMenu.
function classifierGraphTypePopUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to classifierGraphTypePopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns classifierGraphTypePopUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from classifierGraphTypePopUpMenu

handles.classifierViewSelection = get(hObject,'Value');

if (handles.classifierViewSelection == 1)
    if (handles.classifierSelection == 1)
        if (~isempty(handles.knnPerformanceAcc))
            [x, y] = meshgrid(handles.knnFeatureCountRange, handles.knnKRange);

            drawClassifierPerformance(hObject, handles, ...
                handles.knnPerformanceAcc, ...
                x, y, ...
                [handles.knnBestFeatureCount, handles.knnBestK], ...
                'Feature Count', 'K Neighbors', ...
                'KNN Parameter Accuracy Heatmap');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    elseif (handles.classifierSelection == 2)
        if (~isempty(handles.netPerformanceAcc))
            [x, y] = meshgrid(handles.netFeatureCountRange, handles.netNeuronCountRange);

            drawClassifierPerformance(hObject, handles, ...
                handles.netPerformanceAcc, ...
                x, y, ...
                [handles.netBestFeatureCount, handles.netBestNeuronCount], ...
                'Feature Count', 'Hidden Layer Node Count', ...
                'Neural Net Parameter Accuracy Heatmap');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    else
        if (~isempty(handles.svmPerformanceAcc))
            [x, y] = meshgrid(handles.svmFeatureCountRange, handles.svmRBFSigmaRange);

            drawClassifierPerformance(hObject, handles, ...
                handles.svmPerformanceAcc, ...
                x, y, ...
                [handles.svmBestFeatureCount, handles.svmBestRBFSigma], ...
                'Feature Count', 'RBF Sigma', ...
                'SVM (RBF) Parameter Accuracy Heatmap');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    end
elseif (handles.classifierViewSelection == 2)
    if (handles.classifierSelection == 1)
        if (any(and(~isnan(handles.knnCVPerformance), ~isnan(handles.knnEVPerformance))))
            drawClassifierEV(hObject, handles, ...
                    handles.knnCVPerformance, ...
                    handles.knnEVPerformance, ...
                    'Cross Validation Accuracy', 'External Validation Accuracy', ...
                    'KNN CV vs. EV (Predictability)');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    elseif (handles.classifierSelection == 2)
        if (any(and(~isnan(handles.netCVPerformance), ~isnan(handles.netEVPerformance))))
            drawClassifierEV(hObject, handles, ...
                    handles.netCVPerformance, ...
                    handles.netEVPerformance, ...
                    'Cross Validation Accuracy', 'External Validation Accuracy', ...
                    'Neural Net CV vs. EV (Predictability)');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    else
        if (any(and(~isnan(handles.svmCVPerformance), ~isnan(handles.svmEVPerformance))))
            drawClassifierEV(hObject, handles, ...
                    handles.svmCVPerformance, ...
                    handles.svmEVPerformance, ...
                    'Cross Validation Accuracy', 'External Validation Accuracy', ...
                    'SVM (RBF) CV vs. EV (Predictability)');
        else
            cla(handles.imageClassificationAxes);
            title(handles.imageClassificationAxes, '');
            xlabel(handles.imageClassificationAxes, '');
            ylabel(handles.imageClassificationAxes, '');
            colorbar(handles.imageClassificationAxes, 'off');
            handles.imageClassificationAxesColorbar = [];
        end
    end
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function classifierGraphTypePopUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to classifierGraphTypePopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in drawSegmentationButton.
function drawSegmentationButton_Callback(hObject, eventdata, handles)
% hObject    handle to drawSegmentationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

linkaxes([handles.imageSelectionAxes, ...
          handles.imageSegmentationAxes], ...
          'off');

imshow(false(512, 512), 'Parent', handles.imageSegmentationAxes);

guidata(hObject, handles);

drawnow;

if (handles.currentImageSelection > 0)
    segmentationRegions = ...
        histopath_seg( ...
            handles.segmentationColors, ...
            handles.currentImage, ...
            2, ...
            handles.fuzziness, ...
            handles.watershedBlur);
    
    % Full
    handles.currentSegmentationFull = draw_regions( ...
        handles.segmentationColors(:, 1:3), ...
        segmentationRegions, ...
        1);
    
    % Color
    handles.currentSegmentationColor = draw_regions( ...
        handles.segmentationColors(:, 1:3), ...
        histopath_seg( ...
            handles.segmentationColors, ...
            handles.currentImage, ...
            1, ...
            handles.fuzziness));
        
    % Color No Fill
    handles.currentSegmentationColorNoFill = draw_regions( ...
        handles.segmentationColors(:, 1:3), ...
        histopath_seg( ...
            handles.segmentationColors, ...
            handles.currentImage, ...
            0, ...
            handles.fuzziness));
            
    % Watershed
    gray_image = uint8((double(handles.currentImage(:, :, 1)) + ...
                        double(handles.currentImage(:, :, 2)) + ...
                        double(handles.currentImage(:, :, 3))) ./ 3);

    if (handles.watershedBlur > 0.0)
        watershed_image = logical(watershed(imgaussfilt(gray_image, handles.watershedBlur)) ~= 0);
    else
        watershed_image = logical(watershed(gray_image) ~= 0);
    end

    handles.currentSegmentationWatershed = handles.currentImage;
    handles.currentSegmentationWatershed(:, :, 1) = handles.currentImage(:, :, 1) .* uint8(watershed_image);
    handles.currentSegmentationWatershed(:, :, 2) = handles.currentImage(:, :, 2) .* uint8(watershed_image);
    handles.currentSegmentationWatershed(:, :, 3) = uint8(255 - (uint8(255 - handles.currentImage(:, :, 3)) .* uint8(watershed_image)));

    if (handles.currentSegmentationSelection == 1)
        imshow(handles.currentSegmentationFull, 'Parent', handles.imageSegmentationAxes);
    elseif (handles.currentSegmentationSelection == 2)
        imshow(handles.currentSegmentationColor, 'Parent', handles.imageSegmentationAxes);
    elseif (handles.currentSegmentationSelection == 3)
        imshow(handles.currentSegmentationColorNoFill, 'Parent', handles.imageSegmentationAxes);
    else
        imshow(handles.currentSegmentationWatershed, 'Parent', handles.imageSegmentationAxes);
    end
    
    linkaxes([handles.imageSelectionAxes, ...
              handles.imageSegmentationAxes], ...
              'xy');
else
    msgbox({'No image to segment!', ...
            'Please provide an image dataset directory.'}, ...
           'Invalid Feature Matrix File', ...
           'error');
end

guidata(hObject, handles);

% --- Draw feature histogram
function drawFeatureAxes(hObject, handles)

if (handles.currentFeatureSelection > 0)
    if (handles.currentFeatureViewSelection == 1)
        if ((length(handles.featureMatrixClasses) > 0) && ...
            get(handles.separateClassesCheckBox, 'Value'))
            featureMatrixValuesByClass = cell(length(handles.featureMatrixClasses));
            
            for i = 1:length(handles.trainingFeatureMatrix{3})
                for j = 1:length(featureMatrixValuesByClass)
                    if (strcmpi(handles.featureMatrixClasses{j}, ...
                                handles.trainingFeatureMatrix{3}{i}))
                        featureMatrixValuesByClass{j} = ...
                            [featureMatrixValuesByClass{j}; ...
                             handles.trainingFeatureMatrix{1}(i, handles.currentFeatureSelection)];
                        break;
                    end
                end
            end
            
            h_temp = histogram(handles.imageFeaturesAxes, ...
                               handles.trainingFeatureMatrix{1}(:, handles.currentFeatureSelection));
            
            temp_bin_width = h_temp.BinWidth;
            
            for j = 1:length(featureMatrixValuesByClass)
                histogram(handles.imageFeaturesAxes, ...
                          featureMatrixValuesByClass{j}, ...
                          'BinWidth', temp_bin_width);
                      
                if (j == 1)
                    hold(handles.imageFeaturesAxes, 'on');
                end
            end
            
            hold(handles.imageFeaturesAxes, 'off');
            
            handles.imageFeaturesAxesLegend = legend(handles.imageFeaturesAxes, handles.featureMatrixClasses);
        else
            histogram(handles.imageFeaturesAxes, ...
                      handles.trainingFeatureMatrix{1}(:, handles.currentFeatureSelection));
            
            legend(handles.imageFeaturesAxes, 'off');
            handles.imageFeaturesAxesLegend = [];
        end

        title(handles.imageFeaturesAxes, ...
              [handles.trainingFeatureMatrix{2}{handles.currentFeatureSelection}, ' Histogram'], ...
              'Interpreter', 'none');

        if (handles.currentImageSelection > 0)
            hold(handles.imageFeaturesAxes, 'on');

            for i = 1:length(handles.featureMatrix{4})
                if (strcmpi(handles.imageDatasetFiles(handles.currentImageSelection).name, ...
                            handles.featureMatrix{4}{i}))
                    line(handles.imageFeaturesAxes, ...
                         [handles.featureMatrix{1}(i, handles.currentFeatureSelection), ...
                          handles.featureMatrix{1}(i, handles.currentFeatureSelection)], ...
                         ylim(handles.imageFeaturesAxes), ...
                         'LineWidth', 3, ...
                         'Color', 'red', ...
                         'DisplayName', 'Selected');
                    break;
                end
            end

            hold(handles.imageFeaturesAxes, 'off');
        end
    elseif (handles.currentFeatureViewSelection == 2)
        stem(handles.imageFeaturesAxes, ...
             1:length(handles.trainingFeatureRank), ...
             handles.trainingFeatureRank);

        hold(handles.imageFeaturesAxes, 'on');

        stem(handles.imageFeaturesAxes, ...
             handles.currentFeatureSelection, ...
             handles.trainingFeatureRank(handles.currentFeatureSelection), ...
             'LineWidth', 3, ...
             'Color', 'red', ...
             'Marker', 'o', ...
             'MarkerSize', 9);

        hold(handles.imageFeaturesAxes, 'off');

        title(handles.imageFeaturesAxes, 'Feature Rank (Battacharrya Distance)');
        legend(handles.imageFeaturesAxes, 'off');
        handles.imageFeaturesAxesLegend = [];
        xlim(handles.imageFeaturesAxes, [0, length(handles.trainingFeatureRank) + 1]);
    elseif (handles.currentFeatureViewSelection == 3)
        [~, ordering] = sort(handles.trainingFeatureRank, 'descend');

        reverseOrdering(ordering) = 1:length(handles.trainingFeatureRank);

        stem(handles.imageFeaturesAxes, ...
             1:length(handles.trainingFeatureRank), ...
             handles.trainingFeatureRank(ordering));

        hold(handles.imageFeaturesAxes, 'on');

        stem(handles.imageFeaturesAxes, ...
             reverseOrdering(handles.currentFeatureSelection), ...
             handles.trainingFeatureRank(handles.currentFeatureSelection), ...
             'LineWidth', 3, ...
             'Color', 'red', ...
             'Marker', 'o', ...
             'MarkerSize', 9);

        hold(handles.imageFeaturesAxes, 'off');

        title(handles.imageFeaturesAxes, 'Feature Rank (Battacharrya Distance)');
        legend(handles.imageFeaturesAxes, 'off');
        handles.imageFeaturesAxesLegend = [];
        xlim(handles.imageFeaturesAxes, [0, length(handles.trainingFeatureRank) + 1]);
    else
        cla(handles.imageFeaturesAxes);
        title(handles.imageFeaturesAxes, '');
        legend(handles.imageFeaturesAxes, 'off');
        handles.imageFeaturesAxesLegend = [];
    end
else
    cla(handles.imageFeaturesAxes);
    title(handles.imageFeaturesAxes, '');
    legend(handles.imageFeaturesAxes, 'off');
    handles.imageFeaturesAxesLegend = [];
end

guidata(hObject, handles);

% --- Executes on button press in separateClassesCheckBox.
function separateClassesCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to separateClassesCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of separateClassesCheckBox

drawFeatureAxes(hObject, handles);
handles = guidata(hObject);

guidata(hObject, handles);

% --- Executes on button press in classifyButton.
function classifyButton_Callback(hObject, eventdata, handles)
% hObject    handle to classifyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.classifierResultOutputText, ...
    'BackgroundColor', ...
    [0.0, 0.0, 0,0]);

guidata(hObject, handles);

drawnow;

if (handles.classifierSelection == 1)
    computeKNN(hObject, handles);
    handles = guidata(hObject);
elseif (handles.classifierSelection == 2)
    computeNet(hObject, handles);
    handles = guidata(hObject);
else
    computeSVM(hObject, handles);
    handles = guidata(hObject);
end

guidata(hObject, handles);

% --- Assigns each datapoint in the feature matrix to a fold randomly
function foldIndices_out = splitFolds(handles)

foldIndices = cell(0);

if (handles.currentFeatureSelection > 0)
    prevRng = rng;
    rng(40707); % Use same random seed for reproducibility
    randomIndices = randperm(size(handles.featureMatrix{1}, 1));
    rng(prevRng);

    foldSize = ceil(length(randomIndices) ./ 10); % 10-fold
    fold = [];
    j = 1;

    for i = 1:length(randomIndices)
        if (j >= foldSize)
            fold = [fold, randomIndices(i)];
            foldIndices = [foldIndices; fold];
            fold = [];
            j = 1;
        else
            fold = [fold, randomIndices(i)];
            j = j + 1;
        end
    end

    if (j > 1)
        % Add last fold
        foldIndices = [foldIndices; fold];
    end
end

foldIndices_out = foldIndices;

% --- Finds fold that contains current image and makes it the test fold
function testingFold_out = determineTestingFold(handles)

testingFold = 0;

if (handles.currentImageSelection > 0)
    match = false;
    for i = 1:length(handles.foldIndices)
        for j = 1:length(handles.foldIndices{i})
            if (strcmpi(handles.imageDatasetFiles(handles.currentImageSelection).name, ...
                        handles.featureMatrix{4}{handles.foldIndices{i}(j)}))
                testingFold = i;
                match = true;
                break;
            end
        end
        if (match)
            break;
        end
    end
end

testingFold_out = testingFold;

% --- Get subset of rows of feature matrix corresponding to training set
function [trainingFeatureMatrix_out, trainingFeatureRank_out] = getTrainingFeatureMatrix(handles)

trainingFeatureRank   = [];
trainingFeatureMatrix = cell(0);

if (handles.currentFeatureSelection > 0)
    if ((handles.testingFold > 0) && ...
        (length(handles.trainingFeatureMatrixCached) >= handles.testingFold) && ...
        (length(handles.trainingFeatureMatrixCached{handles.testingFold}) > 0))
        % Retrieve cached training feature matrix to avoid recomputing
        trainingFeatureMatrix = handles.trainingFeatureMatrixCached{handles.testingFold};
    else
        trainingFeatureMatrix = cell(4, 1);

        trainingFeatureMatrix{1} = [];

        trainingFeatureMatrix{2} = handles.featureMatrix{2};

        trainingFeatureMatrix{3} = cell(0);

        trainingFeatureMatrix{4} = cell(0);

        for i = 1:length(handles.foldIndices)
            if (i == handles.testingFold)
                % Skip testing fold
            else
                trainingFeatureMatrix{1} = [trainingFeatureMatrix{1}; ...
                                            handles.featureMatrix{1}( ...
                                                handles.foldIndices{i}, :)];

                trainingFeatureMatrix{3} = [trainingFeatureMatrix{3}; ...
                                            handles.featureMatrix{3}( ...
                                                handles.foldIndices{i})];

                trainingFeatureMatrix{4} = [trainingFeatureMatrix{4}; ...
                                            handles.featureMatrix{4}( ...
                                                handles.foldIndices{i})];
            end
        end
    end
    
    if ((handles.testingFold > 0) && ...
        (length(handles.trainingFeatureRankCached) >= handles.testingFold) && ...
        (length(handles.trainingFeatureRankCached{handles.testingFold}) > 0))
        % Retrieve cached training feature rank to avoid recomputing
        trainingFeatureRank = handles.trainingFeatureRankCached{handles.testingFold};
    else
        trainingFeatureRank = rank_features(trainingFeatureMatrix);
    end
end

trainingFeatureRank_out = trainingFeatureRank;

trainingFeatureMatrix_out = trainingFeatureMatrix;

% ---
function [selectedImageFeatures_out, selectedImageLabel_out] = getSelectedImageInfo(handles)

selectedImageFeatures = [];
selectedImageLabel = '';

if (handles.currentFeatureSelection > 0)
    for i = 1:length(handles.featureMatrix{4})
        if (strcmpi(handles.imageDatasetFiles(handles.currentImageSelection).name, ...
                    handles.featureMatrix{4}{i}))
            selectedImageFeatures = handles.featureMatrix{1}(i, :);
            selectedImageLabel    = handles.featureMatrix{3}{i};
            break;
        end
    end
end

selectedImageFeatures_out = selectedImageFeatures;
selectedImageLabel_out    = selectedImageLabel;

% ---
function [] = computeKNN(hObject, handles)

handles.knnKRange = [];

for i = 10:1:40
    handles.knnKRange = unique(round(exp(log(1):(log(240)/i):log(240))));
    if (length(handles.knnKRange) >= 12)
        handles.knnKRange(12) = 240;
        break;
    end
end

handles.knnFeatureCountRange = [];

for i = 10:1:40
    handles.knnFeatureCountRange = unique(round(exp(log(1):(log(246)/i):log(246))));
    if (length(handles.knnFeatureCountRange) >= 12)
        handles.knnFeatureCountRange(12) = 246;
        break;
    end
end

performance = zeros(length(handles.knnFeatureCountRange), length(handles.knnKRange), 2);

[x, y] = meshgrid(handles.knnFeatureCountRange, handles.knnKRange);

% Grid search of optimal parameters
for i = 1:size(x, 1)
    for j = 1:size(x, 2)
        disp(sprintf('Computing parameter combo (%d, %d)', x(i,j), y(i,j)));
        
        tempPerformance = ...
            computeKNNPerformance( ...
                hObject, ...
                handles, ...
                x(i, j), ...
                y(i, j));
        
        performance(i, j, 1) = tempPerformance(1);
        performance(i, j, 2) = tempPerformance(2);
    end
end

handles.knnPerformanceAcc = performance(:, :, 1);
handles.knnPerformanceKappa = performance(:, :, 2);

[~, performanceRanking] = ...
    sort(handles.knnPerformanceAcc(:), 'descend');

performanceDistMin = inf;

bestIndex = performanceRanking(1);

[i_best, j_best] = ind2sub([size(handles.knnPerformanceAcc, 1), size(handles.knnPerformanceAcc, 2)], bestIndex);

handles.knnBestFeatureCount = x(i_best, j_best);
handles.knnBestK            = y(i_best, j_best);

if (handles.classifierViewSelection == 1)
    drawClassifierPerformance(hObject, handles, ...
        handles.knnPerformanceAcc, ...
        x, y, ...
        [handles.knnBestFeatureCount, handles.knnBestK], ...
        'Feature Count', 'K Neighbors', ...
        'KNN Parameter Accuracy Heatmap');
    handles = guidata(hObject);
end

% Compute external validation
testingFold = handles.testingFold;

if (testingFold <= 0)
    testingFold = 1;
end

handles.knnCVPerformance(testingFold) = handles.knnPerformanceAcc(bestIndex);
        
evPerformance = ...
    computeKNNPerformance( ...
        hObject, ...
        handles, ...
        handles.knnBestFeatureCount, ...
        handles.knnBestK, ...
        1); % Set flag for external cross validation

handles = guidata(hObject);

handles.knnEVPerformance(testingFold) = evPerformance(1);

if (handles.classifierViewSelection == 2)
    drawClassifierEV(hObject, handles, ...
        handles.knnCVPerformance, ...
        handles.knnEVPerformance, ...
        'Cross Validation Accuracy', 'External Validation Accuracy', ...
        'KNN CV vs. EV (Predictability)');
    handles = guidata(hObject);
end

guidata(hObject, handles);

% ---
function [] = computeNet(hObject, handles)

handles.netNeuronCountRange = [];

handles.netFeatureCountRange = [];

for i = 10:1:40
    handles.netFeatureCountRange = unique(round(exp(log(1):(log(246)/i):log(246))));
    if (length(handles.netFeatureCountRange) >= 12)
        handles.netFeatureCountRange(12) = 246;
        break;
    end
end

handles.netNeuronCountRange = handles.netFeatureCountRange;

performance = zeros(length(handles.netFeatureCountRange), length(handles.netNeuronCountRange), 2);

[x, y] = meshgrid(handles.netFeatureCountRange, handles.netNeuronCountRange);

% Grid search of optimal parameters
for i = 1:size(x, 1)
    for j = 1:size(x, 2)
        disp(sprintf('Computing parameter combo (%d, %d)', x(i,j), y(i,j)));
        
        tempPerformance = ...
            computeNetPerformance( ...
                hObject, ...
                handles, ...
                x(i, j), ...
                y(i, j));
        
        performance(i, j, 1) = tempPerformance(1);
        performance(i, j, 2) = tempPerformance(2);
    end
end

handles.netPerformanceAcc = performance(:, :, 1);
handles.netPerformanceKappa = performance(:, :, 2);

[~, performanceRanking] = ...
    sort(handles.netPerformanceAcc(:), 'descend');

performanceDistMin = inf;

bestIndex = performanceRanking(1);

[i_best, j_best] = ind2sub([size(handles.netPerformanceAcc, 1), size(handles.netPerformanceAcc, 2)], bestIndex);

handles.netBestFeatureCount = x(i_best, j_best);
handles.netBestNeuronCount  = y(i_best, j_best);

if (handles.classifierViewSelection == 1)
    drawClassifierPerformance(hObject, handles, ...
        handles.netPerformanceAcc, ...
        x, y, ...
        [handles.netBestFeatureCount, handles.netBestNeuronCount], ...
        'Feature Count', 'Hidden Layer Node Count', ...
        'Neural Net Parameter Accuracy Heatmap');
    handles = guidata(hObject);
end

% Compute external validation
testingFold = handles.testingFold;

if (testingFold <= 0)
    testingFold = 1;
end

handles.netCVPerformance(testingFold) = handles.netPerformanceAcc(bestIndex);
        
evPerformance = ...
    computeNetPerformance( ...
        hObject, ...
        handles, ...
        handles.netBestFeatureCount, ...
        handles.netBestNeuronCount, ...
        1); % Set flag for external cross validation

handles = guidata(hObject);

handles.netEVPerformance(testingFold) = evPerformance(1);

if (handles.classifierViewSelection == 2)
    drawClassifierEV(hObject, handles, ...
        handles.netCVPerformance, ...
        handles.netEVPerformance, ...
        'Cross Validation Accuracy', 'External Validation Accuracy', ...
        'Neural Net CV vs. EV (Predictability)');
    handles = guidata(hObject);
end

guidata(hObject, handles);

% ---
function [] = computeSVM(hObject, handles)

handles.svmRBFSigmaRange = [];

handles.svmRBFSigmaRange = (exp(log(1):(log(100000*1000)/12):log(100000*1000)))./1000;
handles.svmRBFSigmaRange = handles.svmRBFSigmaRange(1:12);

handles.svmFeatureCountRange = [];

for i = 10:1:40
    handles.svmFeatureCountRange = unique(round(exp(log(1):(log(246)/i):log(246))));
    if (length(handles.svmFeatureCountRange) >= 12)
        handles.svmFeatureCountRange(12) = 246;
        break;
    end
end

performance = zeros(length(handles.svmFeatureCountRange), length(handles.svmRBFSigmaRange), 2);

[x, y] = meshgrid(handles.svmFeatureCountRange, handles.svmRBFSigmaRange);

% Grid search of optimal parameters
for i = 1:size(x, 1)
    for j = 1:size(x, 2)
        disp(sprintf('Computing parameter combo (%d, %e)', x(i,j), y(i,j)));
        
        tempPerformance = ...
            computeSVMPerformance( ...
                hObject, ...
                handles, ...
                x(i, j), ...
                y(i, j));
        
        performance(i, j, 1) = tempPerformance(1);
        performance(i, j, 2) = tempPerformance(2);
    end
end

handles.svmPerformanceAcc = performance(:, :, 1);
handles.svmPerformanceKappa = performance(:, :, 2);

[~, performanceRanking] = ...
    sort(handles.svmPerformanceAcc(:), 'descend');

performanceDistMin = inf;

bestIndex = performanceRanking(1);

[i_best, j_best] = ind2sub([size(handles.svmPerformanceAcc, 1), size(handles.svmPerformanceAcc, 2)], bestIndex);

handles.svmBestFeatureCount = x(i_best, j_best);
handles.svmBestRBFSigma     = y(i_best, j_best);

if (handles.classifierViewSelection == 1)
    drawClassifierPerformance(hObject, handles, ...
        handles.svmPerformanceAcc, ...
        x, y, ...
        [handles.svmBestFeatureCount, handles.svmBestRBFSigma], ...
        'Feature Count', 'RBF Sigma', ...
        'SVM (RBF) Parameter Accuracy Heatmap');
    handles = guidata(hObject);
end

% Compute external validation
testingFold = handles.testingFold;

if (testingFold <= 0)
    testingFold = 1;
end

handles.svmCVPerformance(testingFold) = handles.svmPerformanceAcc(bestIndex);
        
evPerformance = ...
    computeSVMPerformance( ...
        hObject, ...
        handles, ...
        handles.svmBestFeatureCount, ...
        handles.svmBestRBFSigma, ...
        1); % Set flag for external cross validation

handles = guidata(hObject);

handles.svmEVPerformance(testingFold) = evPerformance(1);

if (handles.classifierViewSelection == 2)
    drawClassifierEV(hObject, handles, ...
        handles.svmCVPerformance, ...
        handles.svmEVPerformance, ...
        'Cross Validation Accuracy', 'External Validation Accuracy', ...
        'SVM (RBF) CV vs. EV (Predictability)');
    handles = guidata(hObject);
end

guidata(hObject, handles);

% --- Trains and classifies according to the KNN classifier
function [validationPerformance_out] = ...
    computeKNNPerformance( ...
        hObject, ...
        handles, ...
        featureCount, ...
        kValue, ...
        externalCV)

validationPerformance = zeros(0, 2);

testingFold = handles.testingFold;

if (testingFold <= 0)
    testingFold = 1;
end

if (featureCount > size(handles.featureMatrix{1}, 2))
    featureCount = size(handles.featureMatrix{1}, 2);
elseif (featureCount <= 0)
    featureCount = 1;
end

if (exist('externalCV', 'var') ~= 1)
    externalCV = 0;
end

if (externalCV ~= 0)
    % External cross validation
    testingFeatureMatrix = cell(4, 1);

    testingFeatureMatrix{1} = [];

    testingFeatureMatrix{2} = handles.featureMatrix{2};

    testingFeatureMatrix{3} = cell(0);

    testingFeatureMatrix{4} = cell(0);
    
    testingFeatureMatrix{1} = ...
        handles.featureMatrix{1}( ...
             handles.foldIndices{testingFold}, :);

    testingFeatureMatrix{3} = ...
         handles.featureMatrix{3}( ...
             handles.foldIndices{testingFold});

    testingFeatureMatrix{4} = ...
         handles.featureMatrix{4}( ...
             handles.foldIndices{testingFold});
    
    % Get external training dataset (n-1 folds)
    externalTrainingFeatureMatrix = cell(4, 1);

    externalTrainingFeatureMatrix{1} = [];

    externalTrainingFeatureMatrix{2} = handles.featureMatrix{2};

    externalTrainingFeatureMatrix{3} = cell(0);

    externalTrainingFeatureMatrix{4} = cell(0);

    for i = 1:length(handles.foldIndices)
        if (i == testingFold)
            % Skip testing fold
        else
            externalTrainingFeatureMatrix{1} = ...
                [externalTrainingFeatureMatrix{1}; ...
                 handles.featureMatrix{1}( ...
                     handles.foldIndices{i}, :)];

            externalTrainingFeatureMatrix{3} = ...
                [externalTrainingFeatureMatrix{3}; ...
                 handles.featureMatrix{3}( ...
                     handles.foldIndices{i})];

            externalTrainingFeatureMatrix{4} = ...
                [externalTrainingFeatureMatrix{4}; ...
                 handles.featureMatrix{4}( ...
                     handles.foldIndices{i})];
        end
    end
    
    % Rank and select features
    featureRank = rank_features(externalTrainingFeatureMatrix);
    
    [~, ordering] = sort(featureRank, 'descend');
    
    % Fit KNN model (using only selected features)
    mdl = fitcknn(externalTrainingFeatureMatrix{1}(:, ordering(1:featureCount)), ...
                  externalTrainingFeatureMatrix{3}, ...
                  'NumNeighbors', kValue, ...
                  'Standardize', 1);

    % Evaluate Classifier Performance
    validationLabels = predict(mdl, ...
                               testingFeatureMatrix{1}(:, ordering(1:featureCount)));


    confMatrix = confusionmat(validationLabels, ...
                              testingFeatureMatrix{3});

    [validationAcc, validationKappa] = classifier_accuracy(confMatrix);

    validationPerformance = ...
        [validationPerformance; ...
         validationAcc, validationKappa];
     
    % Get prediction result for selected image
    if (~isempty(handles.selectedImageFeatures))
        selectedImageLabelPrediction = ...
            predict(mdl, handles.selectedImageFeatures(ordering(1:featureCount)));
        
        selectedImageLabelPrediction = selectedImageLabelPrediction{1};

        if (strcmpi(selectedImageLabelPrediction, ...
                    handles.selectedImageLabel))
            set(handles.classifierResultOutputText, ...
                'String', ...
                sprintf('%s == %s (true)', ...
                        selectedImageLabelPrediction, ...
                        handles.selectedImageLabel));

            set(handles.classifierResultOutputText, ...
                'BackgroundColor', ...
                [0.5, 1.0, 0.5]);
        else
            set(handles.classifierResultOutputText, ...
                'String', ...
                 sprintf('%s ~= %s (true)', ...
                         selectedImageLabelPrediction, ...
                         handles.selectedImageLabel));

            set(handles.classifierResultOutputText, ...
                'BackgroundColor', ...
                [1.0, 0.5, 0.5]);
        end
    else
       set(handles.classifierResultOutputText, ...
           'String', ...
           '<No Selected Image>');

           set(handles.classifierResultOutputText, ...
               'BackgroundColor', ...
               [1.0, 0.5, 0.5]);
    end
     
    guidata(hObject, handles);
else
    % Iterate internal cross validation over each fold
    for validationFold = 1:length(handles.foldIndices)
        if (validationFold ~= testingFold)
            % Get internal validation dataset (1 fold)
            validationFeatureMatrix = cell(4, 1);

            validationFeatureMatrix{1} = [];

            validationFeatureMatrix{2} = handles.featureMatrix{2};

            validationFeatureMatrix{3} = cell(0);

            validationFeatureMatrix{4} = cell(0);
            
            validationFeatureMatrix{1} = ...
                handles.featureMatrix{1}( ...
                     handles.foldIndices{validationFold}, :);

            validationFeatureMatrix{3} = ...
                 handles.featureMatrix{3}( ...
                     handles.foldIndices{validationFold});

            validationFeatureMatrix{4} = ...
                 handles.featureMatrix{4}( ...
                     handles.foldIndices{validationFold});
            
            % Get internal training dataset (n-2 folds)
            internalTrainingFeatureMatrix = cell(4, 1);

            internalTrainingFeatureMatrix{1} = [];

            internalTrainingFeatureMatrix{2} = handles.featureMatrix{2};

            internalTrainingFeatureMatrix{3} = cell(0);

            internalTrainingFeatureMatrix{4} = cell(0);

            for i = 1:length(handles.foldIndices)
                if (i == testingFold)
                    % Skip testing fold
                elseif (i == validationFold)
                    % Skip validation fold
                else
                    internalTrainingFeatureMatrix{1} = ...
                        [internalTrainingFeatureMatrix{1}; ...
                         handles.featureMatrix{1}( ...
                             handles.foldIndices{i}, :)];

                    internalTrainingFeatureMatrix{3} = ...
                        [internalTrainingFeatureMatrix{3}; ...
                         handles.featureMatrix{3}( ...
                             handles.foldIndices{i})];

                    internalTrainingFeatureMatrix{4} = ...
                        [internalTrainingFeatureMatrix{4}; ...
                         handles.featureMatrix{4}( ...
                             handles.foldIndices{i})];
                end
            end
            
            % Rank and select features
            featureRank = rank_features(internalTrainingFeatureMatrix);
            
            [~, ordering] = sort(featureRank, 'descend');
            
            % Fit KNN model (using only selected features)
            mdl = fitcknn(internalTrainingFeatureMatrix{1}(:, ordering(1:featureCount)), ...
                          internalTrainingFeatureMatrix{3}, ...
                          'NumNeighbors', kValue, ...
                          'Standardize', 1);

            % Evaluate Classifier Performance
            validationLabels = predict(mdl, ...
                                       validationFeatureMatrix{1}(:, ordering(1:featureCount)));


            confMatrix = confusionmat(validationLabels, ...
                                      validationFeatureMatrix{3});

            [validationAcc, validationKappa] = classifier_accuracy(confMatrix);

            validationPerformance = ...
                [validationPerformance; ...
                 validationAcc, validationKappa];
        end
    end
end

% Return performance as the average of all cross validation
% fold performances minus a standard deviation
validationPerformance_out = zeros(1, 2);

validationPerformance_out(1) = ...
    mean(validationPerformance(:, 1)) - std(validationPerformance(:, 1));

validationPerformance_out(2) = ...
    mean(validationPerformance(:, 2)) - std(validationPerformance(:, 2));

% --- Trains and classifies according to the Neural Net classifier
function [validationPerformance_out] = ...
    computeNetPerformance( ...
        hObject, ...
        handles, ...
        featureCount, ...
        neuronCount, ...
        externalCV)

validationPerformance = zeros(0, 2);

testingFold = handles.testingFold;

if (testingFold <= 0)
    testingFold = 1;
end

if (featureCount > size(handles.featureMatrix{1}, 2))
    featureCount = size(handles.featureMatrix{1}, 2);
elseif (featureCount <= 0)
    featureCount = 1;
end

if (exist('externalCV', 'var') ~= 1)
    externalCV = 0;
end

if (externalCV ~= 0)
    % External cross validation
    testingFeatureMatrix = cell(4, 1);

    testingFeatureMatrix{1} = [];

    testingFeatureMatrix{2} = handles.featureMatrix{2};

    testingFeatureMatrix{3} = cell(0);

    testingFeatureMatrix{4} = cell(0);
    
    testingFeatureMatrix{1} = ...
        handles.featureMatrix{1}( ...
             handles.foldIndices{testingFold}, :);

    testingFeatureMatrix{3} = ...
         handles.featureMatrix{3}( ...
             handles.foldIndices{testingFold});

    testingFeatureMatrix{4} = ...
         handles.featureMatrix{4}( ...
             handles.foldIndices{testingFold});
    
    % Get external training dataset (n-1 folds)
    externalTrainingFeatureMatrix = cell(4, 1);

    externalTrainingFeatureMatrix{1} = [];

    externalTrainingFeatureMatrix{2} = handles.featureMatrix{2};

    externalTrainingFeatureMatrix{3} = cell(0);

    externalTrainingFeatureMatrix{4} = cell(0);

    for i = 1:length(handles.foldIndices)
        if (i == testingFold)
            % Skip testing fold
        else
            externalTrainingFeatureMatrix{1} = ...
                [externalTrainingFeatureMatrix{1}; ...
                 handles.featureMatrix{1}( ...
                     handles.foldIndices{i}, :)];

            externalTrainingFeatureMatrix{3} = ...
                [externalTrainingFeatureMatrix{3}; ...
                 handles.featureMatrix{3}( ...
                     handles.foldIndices{i})];

            externalTrainingFeatureMatrix{4} = ...
                [externalTrainingFeatureMatrix{4}; ...
                 handles.featureMatrix{4}( ...
                     handles.foldIndices{i})];
        end
    end
    
    % Rank and select features
    featureRank = rank_features(externalTrainingFeatureMatrix);
    
    [~, ordering] = sort(featureRank, 'descend');
    
    % Fit Neural Net model (using only selected features)
    net = patternnet(neuronCount, 'trainrp');

    net.trainParam.time = 0.5; % Maximum of 1/2 second to train
    net.trainParam.showWindow = 0;
    
    net = train(net, ...
                externalTrainingFeatureMatrix{1}(:, ordering(1:featureCount))', ...
                getNetLabels(externalTrainingFeatureMatrix{3}, ...
                             handles.featureMatrixClasses)');

    % Evaluate Classifier Performance
    validationLabels = net(testingFeatureMatrix{1}(:, ordering(1:featureCount))');

    [~, validationLabelsResult] = max(validationLabels, [], 1);
    [~, validationLabelsInput]  = max(getNetLabels(testingFeatureMatrix{3}, ...
                                                   handles.featureMatrixClasses)', [], 1);

    confMatrix = confusionmat(validationLabelsResult', ...
                              validationLabelsInput');

    [validationAcc, validationKappa] = classifier_accuracy(confMatrix);

    validationPerformance = ...
        [validationPerformance; ...
         validationAcc, validationKappa];
     
    % Get prediction result for selected image
    if (~isempty(handles.selectedImageFeatures))
        selectedImageLabelPrediction = net(handles.selectedImageFeatures(ordering(1:featureCount))');

        [~, selectedImageLabelPrediction] = max(selectedImageLabelPrediction, [], 1);        
        
        selectedImageLabelPrediction = handles.featureMatrixClasses{selectedImageLabelPrediction};

        if (strcmpi(selectedImageLabelPrediction, ...
                    handles.selectedImageLabel))
            set(handles.classifierResultOutputText, ...
                'String', ...
                sprintf('%s == %s (true)', ...
                        selectedImageLabelPrediction, ...
                        handles.selectedImageLabel));

            set(handles.classifierResultOutputText, ...
                'BackgroundColor', ...
                [0.5, 1.0, 0.5]);
        else
            set(handles.classifierResultOutputText, ...
                'String', ...
                 sprintf('%s ~= %s (true)', ...
                         selectedImageLabelPrediction, ...
                         handles.selectedImageLabel));

            set(handles.classifierResultOutputText, ...
                'BackgroundColor', ...
                [1.0, 0.5, 0.5]);
        end
    else
       set(handles.classifierResultOutputText, ...
           'String', ...
           '<No Selected Image>');

           set(handles.classifierResultOutputText, ...
               'BackgroundColor', ...
               [1.0, 0.5, 0.5]);
    end
     
    guidata(hObject, handles);
else
    % Iterate internal cross validation over each fold
    for validationFold = 1:length(handles.foldIndices)
        if (validationFold ~= testingFold)
            % Get internal validation dataset (1 fold)
            validationFeatureMatrix = cell(4, 1);

            validationFeatureMatrix{1} = [];

            validationFeatureMatrix{2} = handles.featureMatrix{2};

            validationFeatureMatrix{3} = cell(0);

            validationFeatureMatrix{4} = cell(0);
            
            validationFeatureMatrix{1} = ...
                handles.featureMatrix{1}( ...
                     handles.foldIndices{validationFold}, :);

            validationFeatureMatrix{3} = ...
                 handles.featureMatrix{3}( ...
                     handles.foldIndices{validationFold});

            validationFeatureMatrix{4} = ...
                 handles.featureMatrix{4}( ...
                     handles.foldIndices{validationFold});
            
            % Get internal training dataset (n-2 folds)
            internalTrainingFeatureMatrix = cell(4, 1);

            internalTrainingFeatureMatrix{1} = [];

            internalTrainingFeatureMatrix{2} = handles.featureMatrix{2};

            internalTrainingFeatureMatrix{3} = cell(0);

            internalTrainingFeatureMatrix{4} = cell(0);

            for i = 1:length(handles.foldIndices)
                if (i == testingFold)
                    % Skip testing fold
                elseif (i == validationFold)
                    % Skip validation fold
                else
                    internalTrainingFeatureMatrix{1} = ...
                        [internalTrainingFeatureMatrix{1}; ...
                         handles.featureMatrix{1}( ...
                             handles.foldIndices{i}, :)];

                    internalTrainingFeatureMatrix{3} = ...
                        [internalTrainingFeatureMatrix{3}; ...
                         handles.featureMatrix{3}( ...
                             handles.foldIndices{i})];

                    internalTrainingFeatureMatrix{4} = ...
                        [internalTrainingFeatureMatrix{4}; ...
                         handles.featureMatrix{4}( ...
                             handles.foldIndices{i})];
                end
            end
            
            % Rank and select features
            featureRank = rank_features(internalTrainingFeatureMatrix);
            
            [~, ordering] = sort(featureRank, 'descend');
    
            % Fit Neural Net model (using only selected features)
            net = patternnet(neuronCount, 'trainrp');
            
            net.trainParam.time = 0.5; % Maximum of 1/2 second to train
            net.trainParam.showWindow = 0;

            net = train(net, ...
                        internalTrainingFeatureMatrix{1}(:, ordering(1:featureCount))', ...
                        getNetLabels(internalTrainingFeatureMatrix{3}, ...
                                     handles.featureMatrixClasses)');

            % Evaluate Classifier Performance
            validationLabels = net(validationFeatureMatrix{1}(:, ordering(1:featureCount))');

            [~, validationLabelsResult] = max(validationLabels, [], 1);
            [~, validationLabelsInput]  = max(getNetLabels(validationFeatureMatrix{3}, ...
                                                           handles.featureMatrixClasses)', [], 1);
            
            confMatrix = confusionmat(validationLabelsResult', ...
                                      validationLabelsInput');

            [validationAcc, validationKappa] = classifier_accuracy(confMatrix);

            validationPerformance = ...
                [validationPerformance; ...
                 validationAcc, validationKappa];
        end
    end
end

% Return performance as the average of all cross validation
% fold performances minus a standard deviation
validationPerformance_out = zeros(1, 2);

validationPerformance_out(1) = ...
    mean(validationPerformance(:, 1)) - std(validationPerformance(:, 1));

validationPerformance_out(2) = ...
    mean(validationPerformance(:, 2)) - std(validationPerformance(:, 2));

% --- Trains and classifies according to the SVM (RBF) classifier
function [validationPerformance_out] = ...
    computeSVMPerformance( ...
        hObject, ...
        handles, ...
        featureCount, ...
        rbfSigma, ...
        externalCV)

validationPerformance = zeros(0, 2);

testingFold = handles.testingFold;

if (testingFold <= 0)
    testingFold = 1;
end

if (featureCount > size(handles.featureMatrix{1}, 2))
    featureCount = size(handles.featureMatrix{1}, 2);
elseif (featureCount <= 0)
    featureCount = 1;
end

if (exist('externalCV', 'var') ~= 1)
    externalCV = 0;
end

if (externalCV ~= 0)
    % External cross validation
    testingFeatureMatrix = cell(4, 1);

    testingFeatureMatrix{1} = [];

    testingFeatureMatrix{2} = handles.featureMatrix{2};

    testingFeatureMatrix{3} = cell(0);

    testingFeatureMatrix{4} = cell(0);
    
    testingFeatureMatrix{1} = ...
        handles.featureMatrix{1}( ...
             handles.foldIndices{testingFold}, :);

    testingFeatureMatrix{3} = ...
         handles.featureMatrix{3}( ...
             handles.foldIndices{testingFold});

    testingFeatureMatrix{4} = ...
         handles.featureMatrix{4}( ...
             handles.foldIndices{testingFold});
    
    % Get external training dataset (n-1 folds)
    externalTrainingFeatureMatrix = cell(4, 1);

    externalTrainingFeatureMatrix{1} = [];

    externalTrainingFeatureMatrix{2} = handles.featureMatrix{2};

    externalTrainingFeatureMatrix{3} = cell(0);

    externalTrainingFeatureMatrix{4} = cell(0);

    for i = 1:length(handles.foldIndices)
        if (i == testingFold)
            % Skip testing fold
        else
            externalTrainingFeatureMatrix{1} = ...
                [externalTrainingFeatureMatrix{1}; ...
                 handles.featureMatrix{1}( ...
                     handles.foldIndices{i}, :)];

            externalTrainingFeatureMatrix{3} = ...
                [externalTrainingFeatureMatrix{3}; ...
                 handles.featureMatrix{3}( ...
                     handles.foldIndices{i})];

            externalTrainingFeatureMatrix{4} = ...
                [externalTrainingFeatureMatrix{4}; ...
                 handles.featureMatrix{4}( ...
                     handles.foldIndices{i})];
        end
    end
    
    % Rank and select features
    featureRank = rank_features(externalTrainingFeatureMatrix);
    
    [~, ordering] = sort(featureRank, 'descend');
    
    % Fit SVM (RBF) model (using only selected features)
    t = templateSVM('KernelFunction', 'gaussian', 'KernelScale', rbfSigma);
    
    mdl = fitcecoc(externalTrainingFeatureMatrix{1}(:, ordering(1:featureCount)), ...
                   externalTrainingFeatureMatrix{3}, ...
                   'Learners', t);

    % Evaluate Classifier Performance
    validationLabels = predict(mdl, ...
                               testingFeatureMatrix{1}(:, ordering(1:featureCount)));


    confMatrix = confusionmat(validationLabels, ...
                              testingFeatureMatrix{3});

    [validationAcc, validationKappa] = classifier_accuracy(confMatrix);

    validationPerformance = ...
        [validationPerformance; ...
         validationAcc, validationKappa];
     
    % Get prediction result for selected image
    if (~isempty(handles.selectedImageFeatures))
        selectedImageLabelPrediction = ...
            predict(mdl, handles.selectedImageFeatures(ordering(1:featureCount)));
        
        selectedImageLabelPrediction = selectedImageLabelPrediction{1};

        if (strcmpi(selectedImageLabelPrediction, ...
                    handles.selectedImageLabel))
            set(handles.classifierResultOutputText, ...
                'String', ...
                sprintf('%s == %s (true)', ...
                        selectedImageLabelPrediction, ...
                        handles.selectedImageLabel));

            set(handles.classifierResultOutputText, ...
                'BackgroundColor', ...
                [0.5, 1.0, 0.5]);
        else
            set(handles.classifierResultOutputText, ...
                'String', ...
                 sprintf('%s ~= %s (true)', ...
                         selectedImageLabelPrediction, ...
                         handles.selectedImageLabel));

            set(handles.classifierResultOutputText, ...
                'BackgroundColor', ...
                [1.0, 0.5, 0.5]);
        end
    else
       set(handles.classifierResultOutputText, ...
           'String', ...
           '<No Selected Image>');

           set(handles.classifierResultOutputText, ...
               'BackgroundColor', ...
               [1.0, 0.5, 0.5]);
    end
     
    guidata(hObject, handles);
else
    % Iterate internal cross validation over each fold
    for validationFold = 1:length(handles.foldIndices)
        if (validationFold ~= testingFold)
            % Get internal validation dataset (1 fold)
            validationFeatureMatrix = cell(4, 1);

            validationFeatureMatrix{1} = [];

            validationFeatureMatrix{2} = handles.featureMatrix{2};

            validationFeatureMatrix{3} = cell(0);

            validationFeatureMatrix{4} = cell(0);
            
            validationFeatureMatrix{1} = ...
                handles.featureMatrix{1}( ...
                     handles.foldIndices{validationFold}, :);

            validationFeatureMatrix{3} = ...
                 handles.featureMatrix{3}( ...
                     handles.foldIndices{validationFold});

            validationFeatureMatrix{4} = ...
                 handles.featureMatrix{4}( ...
                     handles.foldIndices{validationFold});
            
            % Get internal training dataset (n-2 folds)
            internalTrainingFeatureMatrix = cell(4, 1);

            internalTrainingFeatureMatrix{1} = [];

            internalTrainingFeatureMatrix{2} = handles.featureMatrix{2};

            internalTrainingFeatureMatrix{3} = cell(0);

            internalTrainingFeatureMatrix{4} = cell(0);

            for i = 1:length(handles.foldIndices)
                if (i == testingFold)
                    % Skip testing fold
                elseif (i == validationFold)
                    % Skip validation fold
                else
                    internalTrainingFeatureMatrix{1} = ...
                        [internalTrainingFeatureMatrix{1}; ...
                         handles.featureMatrix{1}( ...
                             handles.foldIndices{i}, :)];

                    internalTrainingFeatureMatrix{3} = ...
                        [internalTrainingFeatureMatrix{3}; ...
                         handles.featureMatrix{3}( ...
                             handles.foldIndices{i})];

                    internalTrainingFeatureMatrix{4} = ...
                        [internalTrainingFeatureMatrix{4}; ...
                         handles.featureMatrix{4}( ...
                             handles.foldIndices{i})];
                end
            end
            
            % Rank and select features
            featureRank = rank_features(internalTrainingFeatureMatrix);
            
            [~, ordering] = sort(featureRank, 'descend');
            
            % Fit SVM (RBF) model (using only selected features)
            t = templateSVM('KernelFunction', 'gaussian', 'KernelScale', rbfSigma);

            mdl = fitcecoc(internalTrainingFeatureMatrix{1}(:, ordering(1:featureCount)), ...
                           internalTrainingFeatureMatrix{3}, ...
                           'Learners', t);

            % Evaluate Classifier Performance
            validationLabels = predict(mdl, ...
                                       validationFeatureMatrix{1}(:, ordering(1:featureCount)));


            confMatrix = confusionmat(validationLabels, ...
                                      validationFeatureMatrix{3});

            [validationAcc, validationKappa] = classifier_accuracy(confMatrix);

            validationPerformance = ...
                [validationPerformance; ...
                 validationAcc, validationKappa];
        end
    end
end

% Return performance as the average of all cross validation
% fold performances minus a standard deviation
validationPerformance_out = zeros(1, 2);

validationPerformance_out(1) = ...
    mean(validationPerformance(:, 1)) - std(validationPerformance(:, 1));

validationPerformance_out(2) = ...
    mean(validationPerformance(:, 2)) - std(validationPerformance(:, 2));

% ---
function [netLabels_out] = getNetLabels(stringLabels, classes)

netLabels = zeros(length(stringLabels), length(classes));

for i = 1:size(netLabels, 1)
    netLabels(i) = 0;
    for j = 1:length(classes)
        if (strcmpi(stringLabels{i}, ...
                    classes{j}))
            netLabels(i, j) = 1;
            break;
        end
    end
end

netLabels_out = netLabels;

% --- Draws the performance of a classifier in a heatmap
function [] = drawClassifierPerformance(hObject, handles, performance, x, y, bestxy, xname, yname, titlename)

surf(handles.imageClassificationAxes, ...
    x, y, performance, ...
    'EdgeColor', 'none', ...
    'FaceColor', 'interp');

if (~isempty(bestxy))
    if (length(bestxy) >= 2)
        hold(handles.imageClassificationAxes, 'on');
        
        scatter3(handles.imageClassificationAxes, ...
            bestxy(1), bestxy(2), 1, ...
            'ro', ...
            'LineWidth', 2);
        
        hold(handles.imageClassificationAxes, 'off');
    end
end

set(handles.imageClassificationAxes, 'xscale', 'log');

set(handles.imageClassificationAxes, 'yscale', 'log');

view(handles.imageClassificationAxes, 2);

axis(handles.imageClassificationAxes, ...
    [min(x(:)), max(x(:)), min(y(:)), max(y(:))]);
    
xlabel(handles.imageClassificationAxes, xname);

ylabel(handles.imageClassificationAxes, yname);

title(handles.imageClassificationAxes, titlename);

handles.imageClassificationAxesColorbar = colorbar(handles.imageClassificationAxes);

guidata(hObject, handles);

drawnow;

% --- Draws the performance of a classifier in a heatmap
function [] = drawClassifierEV(hObject, handles, cvPerformance, evPerformance, xname, yname, titlename)

cvPerformanceTrimmed = cvPerformance(and(~isnan(cvPerformance), ~isnan(evPerformance)));
evPerformanceTrimmed = evPerformance(and(~isnan(cvPerformance), ~isnan(evPerformance)));

scatter(handles.imageClassificationAxes, ...
    cvPerformanceTrimmed, evPerformanceTrimmed, ...
    'rx', ...
    'LineWidth', 2);

hold(handles.imageClassificationAxes, 'on');

plot(handles.imageClassificationAxes, ...
    [0.5, 1], [0.5, 1], ...
    'b--');

hold(handles.imageClassificationAxes, 'off');

axis(handles.imageClassificationAxes, [0.5, 1, 0.5, 1]);
    
xlabel(handles.imageClassificationAxes, xname);

ylabel(handles.imageClassificationAxes, yname);

title(handles.imageClassificationAxes, titlename);

colorbar(handles.imageClassificationAxes, 'off');
handles.imageClassificationAxesColorbar = [];

guidata(hObject, handles);

drawnow;

% --- Resets classifier results (occurs on selection of new feature matrix)
function clearClassifierResults(hObject, handles)

handles.knnFeatureCountRange = [];
handles.knnKRange = [];
handles.knnPerformanceAcc = [];
handles.knnPerformanceKappa = [];
handles.knnBestFeatureCount = [];
handles.knnBestK = [];
handles.knnCVPerformance = nan(10, 1);
handles.knnEVPerformance = nan(10, 1);

handles.netFeatureCountRange = [];
handles.netNeuronCountRange = [];
handles.netPerformanceAcc = [];
handles.netPerformanceKappa = [];
handles.netBestFeatureCount = [];
handles.netBestNeuronCount = [];
handles.netCVPerformance = nan(10, 1);
handles.netEVPerformance = nan(10, 1);

handles.svmFeatureCountRange = [];
handles.svmRBFSigmaRange = [];
handles.svmPerformanceAcc = [];
handles.svmPerformanceKappa = [];
handles.svmBestFeatureCount = [];
handles.svmBestRBFSigma = [];
handles.svmCVPerformance = nan(10, 1);
handles.svmEVPerformance = nan(10, 1);

guidata(hObject, handles);

% --------------------------------------------------------------------
function uisavefig1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uisavefig1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
saveFigure = figure(2);
    
try
    if (exist('./savedaxes', 'dir') ~= 7)
        mkdir('savedaxes');
    end

    copyobj(handles.imageSelectionAxes, saveFigure);

    hgsave(saveFigure, './savedaxes/imageSelectionAxes.fig');
    
    clf(saveFigure);

    copyobj(handles.imageSegmentationAxes, saveFigure);

    hgsave(saveFigure, './savedaxes/imageSegmentationAxes.fig');
    
    clf(saveFigure);
        
    if (~isempty(handles.imageFeaturesAxesLegend))
        copyobj([handles.imageFeaturesAxes, handles.imageFeaturesAxesLegend], saveFigure);
    else
        copyobj(handles.imageFeaturesAxes, saveFigure);
    end

    hgsave(saveFigure, './savedaxes/imageFeaturesAxes.fig');
    
    clf(saveFigure);
    
    axesCopy = copyobj(handles.imageClassificationAxes, saveFigure);

    if (~isempty(handles.imageClassificationAxesColorbar))
        colorbar(axesCopy);
    end

    hgsave(saveFigure, './savedaxes/imageClassificationAxes.fig');
    
    close(saveFigure);
    
    msgbox({'All axes saved successfully at the following location:', ...
            './savedaxes/'}, ...
           'Save Axes Success', ...
           'help');
catch
    close(saveFigure);
    
    msgbox({'Could not save all axes at the following location:', ...
            './savedaxes/'}, ...
           'Save Axes Error', ...
           'error');
end
