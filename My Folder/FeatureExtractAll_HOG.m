function [numOfBytes,intSizeOfList]=FeatureExtractAll_HOG( fileTrain, fileHOG,fileMatch , fileNo)
%FeatureExtractAll_HOG: Doc fileTrain va extract vector dac trung HOG cho
%moi dong cua fileTrain, ket qua ghi xuong file fileHOG (binary
%format)
% Tra ve: mumOfBytes: Tong so byte ghi xuong
% intSizeofList: so dong (hoac so vector,  moi vector co chieu dai 4752 phan tu 1 byte)
%Thuat toan:
%   Voi moi dong d cua fileTrain
%        clvA=Tinh Vector HOG  cua thanh phan thu 1
%        clvB=Tinh Vector HOG cua thanh phan thu 2
%        clvC=clvA-clvB
%        ghi [clvA, clvB, clvC] xuong fileHOG
tic;
global strPathData;
global strPathWorkingData;


%Doc fileTrain
[fileImgArrayA, fileImgArrayB, annotationArray]=importfileTrain(fileTrain);

%intSizeOfList: so dong cua fileTrain
intSizeOfList=size(fileImgArrayA,1);

%fHist: file Color Histtogram Vector
fHistID = fopen(fileHOG,'w');

%Read fileMatch
fMatchID= fopen(fileMatch,'r');
cellArrList = textscan(fMatchID,'%s');

numBytes=0;
for i=1:size(cellArrList{1,1},1)
    %Lay duong dan den anh cua camera A va trich chon vector dac trung clvA
    j=str2double(cellArrList{1,1}(i));
    strPathA=strcat(strPathData,fileImgArrayA(j));
    HOGvA=FeatureExtract_HOG(strPathA);
    
    %Lay duong dan den anh cua camera B va trich chon vector dac trung clvB
    strPathB=strcat(strPathData,fileImgArrayB(j));
    HOGvB=FeatureExtract_HOG(strPathB);
    
    %Vector clvC= clvA-clvB
    HOGvC = abs(HOGvA-HOGvB);
    
    %Ghi xuong file, ket hop dem so byte ghi xuong, luu trong numBytes
    numBytes=numBytes+fwrite(fHistID,[HOGvA HOGvB HOGvC],'single');
    
end
%Save Number of HOG vector into the file HOGElement.txt
fileNumOfHOGElement='HOGElement.txt';
fileNumOfHOGElement=strcat(strPathWorkingData,fileNumOfHOGElement);
if fileNo==1 
    fileNumOfHOGElementID=fopen(fileNumOfHOGElement,'w');
else
    fileNumOfHOGElementID=fopen(fileNumOfHOGElement,'a');
end;
fprintf(fileNumOfHOGElementID,'%d\n',size(cellArrList{1,1},1));
fclose(fileNumOfHOGElementID);

fclose(fHistID);
fclose(fMatchID);
numOfBytes=numBytes;
toc;
end

