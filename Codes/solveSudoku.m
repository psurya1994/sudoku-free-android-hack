function [ sudokuMatrix, bool ] = solveSudoku( sudokuMatrix, bool )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% updatedSudokuMatrix = sudokuMatrix;
zeroCount = 0;
row = 0;
col = 0;
for i = 1:9
    for j = 1:9
        if(sudokuMatrix(i, j) == 0)
            zeroCount = 1;
            row = i;
            col = j;
            break;
        end
    end
    if(zeroCount == 1)
        break;
    end
end
if(zeroCount == 0)
    bool = 1;
%     updatedSudokuMatrix = sudokuMatrix;
    return
end
for num = 1:9
    boolean = 0;
    for i = 1:9
        if(sudokuMatrix(row, i) == num)
            boolean = 1;
        end
    end
    for i = 1:9
        if(sudokuMatrix(i, col) == num)
            boolean = 1;
        end
    end
    boxStartRow = row - 1 - rem((row-1),3);
    boxStartCol = col - 1 - rem((col-1),3);
    for r = 0:2
        for c = 0:2
            if(sudokuMatrix(r + boxStartRow + 1, c + boxStartCol + 1) ==  num)
                boolean = 1;
            end
        end
    end
    if(boolean == 0)
        sudokuMatrix(row, col) = num;
%         updatedSudokuMatrix = solveSudoku(sudokuMatrix);
        [ sudokuMatrix, bool ]= solveSudoku(sudokuMatrix);
        for i = 1:9
            for j = 1:9
                if(sudokuMatrix(i, j) == 0)
                    bool = 0;
                    break;
                end
            end
            if(bool == 0)
                break;
            end
        end
        if(bool == 1)
            return
        end
        sudokuMatrix(row, col) = 0;
    end

end
bool = 0;


end


