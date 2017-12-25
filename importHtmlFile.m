function [VarName1,VarName2,VarName3,VarName4,VarName5,VarName6,VarName7] = importHtmlFile(filename, delimiter, startRow, endRow)

% Example:
%   [VarName1,VarName2,VarName3,VarName4,VarName5,VarName6,VarName7] =
%   importHtmlFile('0.Index of _download_thirdparty.html',9, 348);
%
%   More info please help TEXTSCAN¡£

%% Initialize
if nargin < 2
    delimiter = {'>','<'};
    startRow = 9;
    endRow = 348;
end

%% import datas with the type of string:
% help or doc TEXTSCAN
formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';

%% Open file
fileID = fopen(filename,'r');

%% Adaptively import the corresponding file
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Colse the file
fclose(fileID);

%% Converts column content containing numeric strings to numeric values
% Replace the non-numeric string with NaN
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

rawData = dataArray{2};
for row=1:size(rawData, 1);
    % Create regular expressions to detect and remove non-numeric prefixes and suffixes
    regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
    try
        result = regexp(rawData{row}, regexstr, 'names');
        numbers = result.numbers;
        
        % The comma is detected in non-thousand-place locations.
        invalidThousandsSeparator = false;
        if any(numbers==',');
            thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
            if isempty(regexp(thousandsRegExp, ',', 'once'));
                numbers = NaN;
                invalidThousandsSeparator = true;
            end
        end
        % Converts a numeric string to a value.
        if ~invalidThousandsSeparator;
            numbers = textscan(strrep(numbers, ',', ''), '%f');
            numericData(row, 2) = numbers{1};
            raw{row, 2} = numbers{1};
        end
    catch me
    end
end

%% The data is divided into numeric columns and cellular columns.
rawNumericColumns = raw(:, 2);
rawCellColumns = raw(:, [1,3,4,5,6,7]);


%% Assign the imported array to the column variable name
VarName1 = rawCellColumns(:, 1);
VarName2 = cell2mat(rawNumericColumns(:, 1));
VarName3 = rawCellColumns(:, 2);
VarName4 = rawCellColumns(:, 3);
VarName5 = rawCellColumns(:, 4);
VarName6 = rawCellColumns(:, 5);
VarName7 = rawCellColumns(:, 6);

