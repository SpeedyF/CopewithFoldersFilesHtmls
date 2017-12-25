%% Cope with the name of all the files in a directory
% By SpeedyZJF, Email:jfsufeng[at]gmail[dot]com||[at]foxmail[dot]com

close all
clear all
clc

%% Cope with Folders&Files
% Way 1 - InputDialog
prompt = {'Input the full directory path:'};
dlg_title = 'InputDlg';
%num_lines = 1;
dlg_length = [1 50];
def = {'E:\SpeedyFTPSharedFolder\MITKABOUT\thirdparty'};
dd=inputdlg(prompt,dlg_title,dlg_length,def);   %  'on' or 'off'  default: 'off'
if length(dd) ~= length(prompt)
    disp('input error');
    return;
    %exit;   % Warning: it will lead to the exited of the matlab software.
end

%Way 2 - uigetdir(DirectoryChooseDialog)
start_path = 'E:\SpeedyFTPSharedFolder\MITKABOUT\thirdparty';
dialog_title = 'Choose Dir';
folder_name = uigetdir(start_path,dialog_title);
if folder_name == 0
    disp('Operation aborted');
   return; 
end

%Way 3 - Direct default in the program code
%fileFolder=fullfile('E:\SpeedyFTPSharedFolder\MITKABOUT\thirdparty');%ftp://192.168.0.144/MITKABOUT/thirdparty/
fileFolder=fullfile(dd{1});  %fullfile(folder_name)
dirOutput=dir(fullfile(fileFolder,'*'));
fileNamesofDir ={dirOutput.name}';    %the type of cell to store fileNames
fileNamesofDir = fileNamesofDir(3:end);   % remove . and ..

%% Cope with Webs&Files(html,local file for instance)
% [str, status] = urlread('http://mitk.org/download/thirdparty/');
[VarName1,VarName2,VarName3,VarName4,VarName5,VarName6,VarName7] = importHtmlFile('0.Index of _download_thirdparty.html', {'>','<'}, 9, 348);%importHtmlFile(filename, delimiter, startRow, endRow)
fileNamesofWeb = VarName5;

%% Compare and Export
tic
disp('fileNamesofDir +   fileNamesofWeb -');
setdiff(fileNamesofDir,fileNamesofWeb)
disp('fileNamesofWeb +   fileNamesofDir -');
setdiff(fileNamesofWeb, fileNamesofDir)
t0 = toc
tic
for i = 1:1:length(fileNamesofDir)
    Counter = 0;
    for j = 1:1:length(fileNamesofWeb)
        if strcmp(fileNamesofDir{i},fileNamesofWeb{j}) == 1
            Counter = Counter + 1;
            continue;
        end
    end
    if Counter == 0
        fprintf('fileNamesofDir\t%d\t%s\t+\tfileNamesofWeb\t-\n',i,fileNamesofDir{i});
    end
end
for j = 1:1:length(fileNamesofWeb)
    Counter = 0;
    for i = 1:1:length(fileNamesofDir)
        if strcmp(fileNamesofWeb{j},fileNamesofDir{i}) == 1
            Counter = Counter + 1;
            continue;
        end
    end
    if Counter == 0
        fprintf('fileNamesofWeb\t%d\t%s\t+\tfileNamesofDir\t-\n',j,fileNamesofWeb{j}');
    end
end
t1 = toc
