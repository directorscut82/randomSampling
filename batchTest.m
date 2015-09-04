%run different methods on batch datasets with two sampling strategy
% to avoid out of memory problem, please increase the virtual memory
close all, 
clear, 
myCluster = parcluster('local');
myCluster.NumWorkers = 6;
saveProfile(myCluster);
numWorkers = matlabpool('size');
isPoolOpen = (numWorkers > 0);
if(~isPoolOpen)
    matlabpool;
end
<<<<<<< HEAD
%  batch('..\data\remote sensing data', '*_gt.mat', @(x)KNNSpatialFeatureRandomSampling(x,10));
%  batch('..\data\remote sensing data', '*_gt.mat', @(x)NonlinearSVMSpatialFeatureRandomSampling(x,1));


% batch('..\data\remote sensing data', '*.mat', @(x)LinearSVMSpectralFeatureRandomSampling(x, 1));
% batch('..\data\remote sensing data', '*.mat', @(x)LinearSVMSpectralFeatureRegionSampling(x, 1));
batch('..\data\remote sensing data', '*.mat', @(x)NonlinearSVMSpectralFeatureRandomSampling(x, 10));
% batch('..\data\remote sensing data', '*.mat', @(x)NonlinearSVMSpectralFeatureRegionSampling(x, 10));

% batch('..\data\remote sensing data', '*.mat', @(x)LinearSVMMorphologyRandomSampling(x,1));
% batch('..\data\remote sensing data', '*.mat', @(x)LinearSVMMorphologyRegionSampling(x,1));
% batch('..\data\remote sensing data', '*.mat', @(x)NonlinearSVMMorphologyRandomSampling(x,10));
% batch('..\data\remote sensing data', '*.mat', @(x)NonlinearSVMMorphologyRegionSampling(x,10));
=======
batch('..\data\remote sensing data', '*_gt.mat', @(x)KNNSpatialFeatureRandomSampling(x,10));
batch('..\data\remote sensing data', '*_gt.mat', @(x)NonlinearSVMSpatialFeatureRandomSampling(x,10));


batch('..\data\remote sensing data', '*.mat', @(x)LinearSVMSpectralFeatureRandomSampling(x, 10));
batch('..\data\remote sensing data', '*.mat', @(x)LinearSVMSpectralFeatureRegionSampling(x, 10));

batch('..\data\remote sensing data', '*.mat', @(x)LinearSVMMorphologyRandomSampling(x,10));
batch('..\data\remote sensing data', '*.mat', @(x)LinearSVMMorphologyRegionSampling(x,10));

batch('..\data\remote sensing data', '*.mat', @(x)LinearSVM3DDWTRandomSampling(x,10));
batch('..\data\remote sensing data', '*.mat', @(x)LinearSVM3DDWTRegionSampling(x,10));
>>>>>>> aee42b625a57ea09adddde35fad777cc649878bd


 

