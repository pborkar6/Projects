% Run color segmentation on a batch of test files

clear all;
clc;

% Set classification colors to white/magenta/blue
colors = [255, 255, 255,   0; ...
          255,   0, 255,   0; ...
            0,   0, 255,   1];
        

files = dir('test/*.png');

% Iterate through test files

index_im=0;
image_names_order={};
for file = files'
    
    index_im=index_im+1;
    
    
    input_image  = imread(sprintf('test/%s', file.name));
    image_names_order={image_names_order,file.name};
    output_image = histopath_seg(colors, input_image, 2, 1);
    output_features=histopath_features(output_image{3},input_image);
    
    features_matrix(index_im,:)=output_features{1,1};
%     output_filename = sprintf('test/test%s.png', filenumber{1});
%     imwrite(output_image, output_filename, 'PNG');
    
    disp(sprintf('Generated %s', file.name));
    
end
y=output_features{1,2};
disp('Batch color segmentation anf feature extractioncomplete!');