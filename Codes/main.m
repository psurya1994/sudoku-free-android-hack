clear all
close all
clc

system('adb shell screencap -p /sdcard/otdraw/screen.png');
system('adb pull /sdcard/otdraw/screen.png');
input = imread('screen.png');
system('adb shell rm /sdcard/otdraw/screen.png');

b = rgb2gray(input);
c = imcrop(b,[1 327 1080-1 1406-327]);
% d = imresize(c,0.3);
d = c;
s1 = size(d,1);
s2 = size(d,2);
bwImage = im2bw(~d,0.5);
linesImage = bwareaopen(bwImage,5000);
numbersImage = bwImage - linesImage;
numbersImage = bwareaopen(numbersImage, 50);

sudokuMatrix = zeros(9,9);

for i = 1:9    
    line = numbersImage(1+round((i-1)*1078/9):round(1078*(i)/9),:);
    results = ocr(line, 'CharacterSet', '123456789', 'TextLayout', 'Line');
    for j = 1:(size(results.CharacterConfidences,1))
        if(~isnan(results.CharacterConfidences(j)))
            index = round(results.CharacterBoundingBoxes(j,1)/120) + 1;
            sudokuMatrix(i, index) = str2num(results.Text(j));
        end
    end
end

bool = 0;
[updatedSudokuMatrix, bool] = solveSudoku(sudokuMatrix, 1);

toFillSudokuMatrix = updatedSudokuMatrix - sudokuMatrix;

numberPositions = [100, 1650; 275, 1650; 450, 1650; 625, 1650; 800, 1650; ...
                   975, 1650; 100, 1825; 275, 1825; 450, 1825];
a = 10;

for i = 1:9
    for j = 1:9
        if(toFillSudokuMatrix(i,j) ~= 0)
            % clicking the block
            y = 327+(1080/9)*i - 1080/18;
            x = (1080/9)*j - 1080/18;
            system(['adb shell input swipe ' num2str(x) ' ' num2str(y) ...
                    ' ' num2str(x) ' ' num2str(y) ' 0']);
            
            % clicking the number
            system(['adb shell input swipe ' num2str(numberPositions(toFillSudokuMatrix(i,j), 1))...
                ' ' num2str(numberPositions(toFillSudokuMatrix(i,j), 2)) ...
                ' ' num2str(numberPositions(toFillSudokuMatrix(i,j), 1)) ...
                ' ' num2str(numberPositions(toFillSudokuMatrix(i,j), 2)) ' 0']);
        end
    end
end


