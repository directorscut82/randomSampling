function NonlinearSVMSpectralFeatureContinuousSampling(DataFile, timeofRepeatition)
% hyperspectral classification with spectral feature using random sampling
% and nonlinear SVM
addpath('..\data\remote sensing data');
addpath('..\tools\libsvm-3.20\matlab');
rawData = importdata(DataFile);% Load hyperspectral image and groud truth
if ndims(rawData) ~= 3
    return;
end
indexof_= find(DataFile == '_',1);
if isempty(indexof_)
    subfix = DataFile(1:end-4);
else
    subfix = DataFile(1:indexof_-1);
end
resultsFile = ['Jresults\', subfix, '_', mfilename, '.mat']; 
groundTruth = importdata([subfix, '_gt.mat']);
dataCube = normalise(rawData, 'percent',1);
% figure, imagesc(groundTruth);
[m, n, b] = size(rawData);
vdataCube =  reshape(dataCube, [m*n,b]);
vgroundTruth = reshape(groundTruth, [numel(groundTruth),1]);
numofClass = max(groundTruth(:));
trainingIndex = cell(numofClass,1);
testingIndex = cell(numofClass,1);
trainingSamples = cell(numofClass,1);
testingSamples = cell(numofClass,1);
trainingLabels = cell(numofClass,1);
testingLabels = cell(numofClass,1);
numofTest = zeros(numofClass,1);
% accuracyC = zeros(numofClass,3,10);
% accuracy = zeros(3,10); % auto updata
sampleRateList = [0.05, 0.1, 0.25];
for repeat = 1:timeofRepeatition
for i = 1 : length(sampleRateList)
    sampleRate = sampleRateList(i);
    for c = 1: numofClass
        cc  = double(c);
        class = find(vgroundTruth == c);
        if isempty(class)
            continue;
        end
        numofTraining = round(numel(class)*sampleRate);
        randpoint = randi([1,numel(class)-numofTraining],1,1) ;
        trainingIndex{c} = class(randpoint:randpoint + numofTraining-1);
        testingIndex{c} = [class(1:randpoint-1); class(randpoint + numofTraining:end)];
        
        trainingSamples{c} = vdataCube(trainingIndex{c},:);
        trainingLabels{c} = ones(length(trainingIndex{c}),1)*cc;
        testingSamples{c} = vdataCube(testingIndex{c},:);
        testingLabels{c} = ones(length(testingIndex{c}),1)*cc;
        numofTest(c) = numel(testingIndex{c});
    end
    mtrainingData = cell2mat(trainingSamples);
    mtrainingLabels = cell2mat(trainingLabels);
    mtrainingIndex = cell2mat(trainingIndex);
    mtestingData = cell2mat(testingSamples);
    mtestingLabels = cell2mat(testingLabels);
    mtestingIndex = cell2mat(testingIndex); 
    trainingMap = zeros(m*n,1);
    trainingMap(mtrainingIndex) = mtrainingLabels;
%   figure, imagesc(reshape(trainingMap,[m,n])); % check the training samples 
    mtrainingData = double(mtrainingData);
    %select parameters c and g
    log2cList = -1:1:8;
    log2gList = -1:1:8;
    cv = zeros(length(log2cList), length(log2gList) );
    parfor indexC = 1:length(log2cList)
      log2c = log2cList(indexC);
      tempcv = zeros(1,length(log2gList));
      for indexG = 1:length(log2gList)
         log2g =  log2gList(indexG);
         cmd = ['-q -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
         tempcv(indexG) = svmtrain(mtrainingLabels, mtrainingData, cmd);
      end
      cv(indexC,:) = tempcv;
    end
    [~, indexcv]= max(cv(:));
    [bestindexC, bestindexG] = ind2sub(size(cv), indexcv);
    bestc = 2^log2cList(bestindexC);
    bestg = 2^log2gList(bestindexG);
    optPara = [ '-q -c ', num2str(bestc), ' -g ', num2str(bestg)];
    svm = svmtrain(mtrainingLabels, mtrainingData, optPara);    
    mtestingData = double(mtestingData);
    [predicted_labels, ~, ~] = svmpredict(mtestingLabels, mtestingData, svm);  
    resultMap = vgroundTruth;
    resultMap(mtestingIndex) = predicted_labels;
%   figure, imagesc(reshape(resultMap,[m,n]));
    results(i, repeat) = assessment(mtestingLabels, predicted_labels, 'class' ); % calculate OA, kappa, AA  
end
end
save(resultsFile, 'results');