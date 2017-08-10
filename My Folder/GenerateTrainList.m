function GenerateTrainList(fileNameGroundTruth,num)
%GenerateTrainList: generate train list (train.lst)
%	Train.lst: Ch?a positive file pair, và negative file pair ???c dùng cho giai ?o?n training.
%	C?t 1: ???ng d?n t? folder Data ??n m?t  file trong folder *A
%	C?t 2: ???ng d?n t? folder Data ??n m?t  file trong folder *B
%	C?t 3: Annotation, ch?a giá tr? 1 n?u là positive pair, 0 n?u là negative pair

%1.Doc du lieu tu file ground_truth_shot_*.csv
global strPathData;
global strPathWorkingData;

% strWorkingDataDir=strcat(strProject,'WorkingData\');


gt_CellArray=importfileCSV(fileNameGroundTruth);
for i=1:size(gt_CellArray,1)
   for j=1: size(gt_CellArray,2)
        gt_CellArray{i,j}=strrep(gt_CellArray{i,j},'"',''); % Bo dau ""
        gt_CellArray{i,j}=strrep(gt_CellArray{i,j},'/','\');
   end
 end
%Tam thoi gan, se tinh lai
p=6;
q=2; %ty le cap anh negative:positive

seqno=num2str(num);
fileTrainName=strcat(strPathWorkingData, 'Train',seqno,'.lst');
fileTrainID = fopen(fileTrainName,'w');
%2. Voi moi dong d doc duoc, tim va phat sinh ngau nhien p positive pair, q
%negative pair
for i=1:size(gt_CellArray,1);
    
% Tinh p, q
% Doc cac dong same_d_A tuong ung voi d tu cameraA
    begin_part_A=strsplit(gt_CellArray{i,1},'_'); %Tach lay phan dau
    strA=strcat(strPathData,begin_part_A{1,1},'_*.png');%xay dung duong dan 
    strA=strrep(strA,'''','');% Go bo ky tu ' 
    strDirA = dir(strA);
% Doc cac dong same_d_B tuong ung voi d tu cameraB    
    begin_part_B=strsplit(gt_CellArray{i,2},'_');
    strB=strcat(strPathData,begin_part_B{1,1},'_*.png');
    strB=strrep(strB,'''','');
    strDirB = dir(strB);
    
% Phat sinh ngau nhien p positive pair va p*q negative pair
    for ii=1:p
        k=randi(length(strDirA)-2);
        fileA=strDirA(k).name;
        h=randi(length(strDirB)-2);
        fileB=strDirB(h).name;
        fprintf(fileTrainID,'%sA\\%s %sB\\%s 1\n',seqno, fileA,seqno,fileB);
        % Phat sinh ngau nhien q cap negative pair
        for jj=1:q
        %Lay 1 file khac tu Camera A
            kk=randi(length(strDirA)-2);
            if k==kk
                kk=randi(length(strDirA)-2);
            end
            fileAA=strDirA(kk).name;
            % Doc cac dong notsame_d_B khac vehicle voi d tu cameraB
            if i < size(gt_CellArray,1) %Lay anh j tu loat anh ke tiep i o cameraB, hy vong se khac loat i
                j=i+1;
            else
                j=1;
            end
            begin_part_C=strsplit(gt_CellArray{j,2},'_');
            strC=strcat(strPathData,begin_part_C{1,1},'_*.png');
            strC=strrep(strC,'''','');
            strDirC = dir(strC);

            hh=randi(length(strDirC)-2);
            fileC=strDirC(hh).name;
            fprintf(fileTrainID,'%sA\\%s %sB\\%s -1\n',seqno,fileAA, seqno,fileC);
        end
    end
    
end;
 fclose(fileTrainID);
end


