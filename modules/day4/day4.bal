import ballerina/io;
import ballerina/regex;

final int[] numbers = [90,4,2,96,46,1,62,97,3,52,7,35,50,28,31,37,74,26,59,53,82,47,83,80,19,40,68,95,34,55,54,73,12,78,30,63,57,93,72,77,56,91,23,67,64,79,85,84,76,10,58,0,29,13,94,20,32,25,11,38,89,21,98,92,42,27,14,99,24,75,86,51,22,48,9,33,49,18,70,8,87,61,39,16,66,71,5,69,15,43,88,45,6,81,60,36,44,17,41,65];

type Value record {|
    int value;
    boolean seen = false;
|};

class Board {
    int width = 5;
    int height = 5;
    Value[][] values = [];

    function sumOfUnmarkedNumbers() returns int {
        int total = 0;
        foreach int row in 0..<self.height{
            foreach int col in 0..<self.width {
                Value v = self.values[row][col];
                if v.seen == false {
                    total += v.value;
                }
            }
        }
        return total;
    }

    function addRow(Value[] values) returns error? {
        if self.values.length() >= self.height {
            return error("too many rows added");
        }
        if values.length() != self.width {
            return error("not the right amount of values");
        }
        self.values.push(values);
    }

    function newValue(int v) returns boolean{
        boolean hasChanged = false;
        foreach int row in 0..<self.height{
            foreach int col in 0..<self.width {
                if self.values[row][col].value == v {
                    if self.values[row][col].seen == false {
                        hasChanged = true;
                    }
                    self.values[row][col].seen = true;
                }
            }
        }
        return hasChanged;
    }

    function checkRows() returns boolean {
        foreach int row in 0..<self.height{
            if self.checkRow(row) {
                return true;
            }
        }
        return false;
    }

    function checkRow(int row) returns boolean {
        foreach int col in 0..<self.width {
            if !self.values[row][col].seen {
                return false;
            }
        }
        return true;
    }

    function checkCols() returns boolean {
        foreach int col in 0..<self.height{
            if self.checkCol(col) {
                return true;
            }
        }
        return false;
    }

    function checkCol(int col) returns boolean {
        foreach int row in 0..<self.width {
            if !self.values[row][col].seen {
                return false;
            }
        }
        return true;
    }

    function hasWon() returns boolean {
        return self.checkCols() || self.checkRows();
    }
}

function readInput() returns Board[]|error {
    string[] lines = check io:fileReadLines("day4.txt");

    Board[] boards = [];
    Board b = new Board();
    foreach string line in lines {
        if line == "" {
            boards.push(b);
            b = new Board();
        } else {
            Value[] values = regex:split(line, " ").
                filter(it => it.length() > 0).
                map(it => check int:fromString(it)).
                map(it => <Value>{value: it});
            check b.addRow(values);
        }
    }
    boards.push(b);
    return boards;
}

function playUntilFirstWin(Board[] boards, int[] numbers) returns int|error {
    foreach int nbr in numbers {
        foreach Board b in boards {
            boolean hasChanged = b.newValue(nbr);
            if hasChanged {
                if b.hasWon() {
                    return b.sumOfUnmarkedNumbers() * nbr;
                }
            }
        }
    }
    return error("no board wins");
}

function playUntilLastWin(Board[] boards, int[] numbers) returns int|error {
    boolean[] hasWon = [];
    foreach Board _ in boards {
        hasWon.push(false);
    }

    int wonBoards = 0;

    foreach int nbr in numbers {
        foreach int i in 0..<boards.length() {
            if !hasWon[i] {
                Board b = boards[i];
                boolean hasChanged = b.newValue(nbr);
                if hasChanged {
                    if b.hasWon() {
                        if wonBoards == boards.length()-1 {
                            return b.sumOfUnmarkedNumbers() * nbr;
                        } else {
                            wonBoards += 1;
                            hasWon[i] = true;
                        }
                    }
                }
            }
        }
    }
    return error("no board wins");
}

public function solve() returns error? {
    Board[] boards = check readInput();
    int part1 = check playUntilFirstWin(boards, numbers);
    io:println(`day4 part1 ${part1}`);
    int part2 = check playUntilLastWin(boards, numbers);
    io:println(`day4 part2 ${part2}`);
}
