function [ output_classification_labels ] = classification_labels_from_xlsx( input_xlsx_file, rows, file_id_column, label_column )
%CLASSIFICATION_LABELS_FROM_XLSX
%   Reads an xlsx file and extracts from it the file identifiers and
%   corresponding classification labels.

[~, ~, classification_labels] = xlsread(input_xlsx_file);

if (exist('rows', 'var') == 1)
    if ((exist('file_id_column', 'var') ~= 1) || ...
        (exist('label_column', 'var')   ~= 1))
        error('Second argument (rows) must be accompanied by third and fourth arguments (file_id_column and label_column)');
    else
        classification_labels = {classification_labels{rows, file_id_column}; ...
                                 classification_labels{rows, label_column}};
        
        classification_labels = classification_labels';
    end
end

output_classification_labels = classification_labels;

end

