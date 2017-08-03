close all;
clear;
clc;


%% load dataset
%load('../dataset/ORL_Face_img.mat');
%load('../dataset/Brodatz_texture_img_small_set.mat');
%load('../dataset/AR_Face_img_27x20.mat'); 
load('../dataset/AR_Face_img_60x43.mat'); 
%load('../dataset/USPS.mat'); 
%load('../dataset/MNIST.mat');
%load('../dataset/COIL20.mat');
%load('../dataset/COIL100.mat');


% set paramters
eigenface_flag = true;


%% reduce dataset for a quick test if necessary
max_class_num = 10;
max_samples = 5;
[TrainSet, TestSet, train_num, test_num, class_num] = reduce_dataset(TrainSet, TestSet, max_class_num, max_samples);


%% normalize dataset
[TrainSet_normalized.X, TrainSet_normalized.y] = data_normalization(TrainSet.X, TrainSet.y, 'std');        
[TestSet_normalized.X, TestSet_normalized.y] = data_normalization(TestSet.X, TestSet.y, 'std');     


%% SVM
options.verbose = true;
options.eigenface = eigenface_flag;
options.eigenface_dim = 15;
accuracy_svm = svm_classifier(TrainSet, TestSet, train_num, test_num, class_num, options);
fprintf('# SVM: Accuracy = %5.5f\n', accuracy_svm);


%% LSR
lambda = 0.001;
options.verbose = true;
[accuracy_lsr, ~, ~] = lsr(TrainSet, TestSet, train_num, test_num, class_num, lambda, options);
fprintf('# LSR: Accuracy = %5.5f\n', accuracy_lsr);


%% LRC
clear options;
options.verbose = true;
accuracy_lrc = lrc(TrainSet_normalized, TestSet_normalized, test_num, class_num, options);
fprintf('# LRC: Accuracy = %5.5f\n', accuracy_lrc);


%% LDRC
clear options;
options.verbose = true;
reduce_dimension = size(TrainSet_normalized.X, 1);
accuracy_ldrc = ldrc(TrainSet_normalized, TestSet_normalized, train_num, test_num, class_num, reduce_dimension, options);
fprintf('# LDRC: Accuracy = %5.5f\n', accuracy_ldrc);


%% LCDRC
clear options;
options.verbose = true;
reduce_dimension = size(TrainSet_normalized.X, 1);
%reduce_dimension = 470;
accuracy_lcdrc = lcdrc(TrainSet_normalized, TestSet_normalized, train_num, test_num, class_num, reduce_dimension, options);
fprintf('# LCDRC: Accuracy = %5.5f\n', accuracy_lcdrc);


%% CRC
clear options;
dimension = max_class_num*max_samples; % This should not be greater than (max_class_num*max_samples).
lambda = 0.001;
options.verbose = true;
options.eigenface = eigenface_flag;
options.eigenface_dim = max_class_num*max_samples;
accuracy_crc = crc(TrainSet, TestSet, train_num, test_num, class_num, lambda, options);
fprintf('# CRC: Accuracy = %5.5f\n', accuracy_crc);


%% SRC
clear options;
lambda = 0.001;
options.verbose = true;
options.eigenface = eigenface_flag;
options.eigenface_dim = max_class_num*max_samples;
accuracy_src = src(TrainSet, TestSet, train_num, test_num, class_num, lambda, options);
fprintf('# SRC Accuracy = %5.5f\n', accuracy_src);


%% ESRC
clear options;
lambda = 0.001;
options.verbose = true;
options.eigenface = eigenface_flag;
options.eigenface_dim = max_class_num*max_samples;
accuracy_esrc = esrc(TrainSet, TestSet, train_num, test_num, class_num, lambda, options);
fprintf('# ESRC Accuracy = %5.5f\n', accuracy_esrc);


%% RobustPCA-SRC
lambda = 0.001;
options.verbose = true;
options.eigenface = eigenface_flag;
options.eigenface_dim = max_class_num*max_samples;
options.solver_max_iter = 5;
accuracy_robust_pca = rpca_src(TrainSet, TestSet, train_num, test_num, class_num, lambda, options);
fprintf('# RobustPCA-SRC: Accuracy = %5.5f\n', accuracy_robust_pca);


%% display accuracy
fprintf('\n\n## Summary of results\n\n')
fprintf('# SVM: Accuracy = %5.5f\n', accuracy_svm);
fprintf('# LSR: Accuracy = %5.5f\n', accuracy_lsr);
fprintf('# LRC: Accuracy = %5.5f\n', accuracy_lrc);
fprintf('# LDRC: Accuracy = %5.5f\n', accuracy_ldrc);
fprintf('# LCDRC: Accuracy = %5.5f\n', accuracy_lcdrc);
fprintf('# CRC: Accuracy = %5.5f\n', accuracy_crc);
fprintf('# SRC: Accuracy = %5.5f\n', accuracy_src);
fprintf('# ESRC: Accuracy = %5.5f\n', accuracy_esrc);
fprintf('# RobustPC-SRC: Accuracy = %5.5f\n', accuracy_robust_pca);