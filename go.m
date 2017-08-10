function  go(num)
%go: run the main program
%Parameter:
%num=1: Generate training list (train*.lst) and storing them into $strPathProject\WorkingData
%num=2: Generate color histogram feature vector files (ColorHist*.mat,Label*.mat) and storing them into $strPathProject\WorkingData
%num=3: Train and predict with color histogram feature. The results are saved into $strPathProject\Color\
%num=4: View all the wrong pairs from the result of step 3
%num=5: Generate HOH feature vector files (HOG*.mat) with all the matching pairs from step 3, and storing them into $strPathProject\WorkingData
%num=6: Train and predict with HOG feature with data generated from step 5. The results are saved into $strPathProject\HOG\
%num=7: View all the matching pairs from the result of step 3

%num=4: Generate HOH feature vector files (HOG*.mat) and storing them into $strPathProject\WorkingData
%num=5: Train and predict with HOG feature. The results are saved into $strPathProject\HOG\

%Home project directory
global strPathProject; 

%Data from dataset
global strPathData;

%Working Data 
global strPathWorkingData;

%Results data
global strPathResults;

strPathProject='C:\Projects\VehicleID\';
strPathData=strcat(strPathProject,'Data\');
strPathWorkingData=strcat(strPathProject,'WorkingData\');
strPathResults=strcat(strPathProject,'Results\');

if nargin > 0
switch num
    case 1 %Generating training list (train*.lst) 
        for index=1:5
            fileNameGroundTruth= strcat(strPathData,'ground_truth_shot_',num2str(index),'.csv');
            GenerateTrainList(fileNameGroundTruth,index);
        end;
    case 2 %Generate color histogram feature vector files
       for i=1:5
            fileTrain= strcat(strPathWorkingData,'Train',num2str(i),'.lst');
            fileColorHist= strcat(strPathWorkingData,'ColorHist',num2str(i),'.mat');
            fileLabel=strcat(strPathWorkingData,'Label',num2str(i),'.mat');
            FeatureExtractAll_HistColor(fileTrain,fileColorHist,fileLabel);
        end;
    case 3 %Training with Color Histogram Feature
        for excludeFileNo=1:5;
            strPathToSaveResult=strcat(strPathResults,'Color\L',num2str(excludeFileNo),'\');
            colorHistSVMTrain(excludeFileNo,strPathToSaveResult);
        end;
    case 4
%         strImg='Train2.lst';
%         intSeq=101;
%         strImg=strcat(strPathWorkingData,strImg);
%         showImagePair(strImg,intSeq);
        showPairOfImage();
    case 5
        for i=1:5
            fileTrain= strcat(strPathWorkingData,'Train',num2str(i),'.lst');
            fileHOG= strcat(strPathWorkingData,'HOG',num2str(i),'.mat');
            fileMatch= strcat(strPathWorkingData,'Match',num2str(i),'.lst');
            %fileLabel=strcat('Label',num2str(i),'.mat');
            FeatureExtractAll_HOG(fileTrain,fileHOG,fileMatch,i);
        end;
    case 6 %Training with HOG Feature
         for excludeFileNo=1:5;
            strPathToSaveResult=strcat(strPathResults,'HOG\L',num2str(excludeFileNo),'\');
            HOGTrain(excludeFileNo,strPathToSaveResult);
         end;
end;
end;
end

  %case 4 %Generate HOH feature vector files
%         for i=1:5
%             fileTrain= strcat(strPathWorkingData,'Train',num2str(i),'.lst');
%             fileHOG= strcat(strPathWorkingData,'HOG',num2str(i),'.mat');
%             %fileLabel=strcat('Label',num2str(i),'.mat');
%             FeatureExtractAll_HOG(fileTrain,fileHOG);
%         end;
%     case 5%Training with HOG Feature
%          for excludeFileNo=1:5;
%             strPathToSaveResult=strcat(strPathResults,'HOG\L',num2str(excludeFileNo),'\');
%             HOGTrain(excludeFileNo,strPathToSaveResult);
%          end;
