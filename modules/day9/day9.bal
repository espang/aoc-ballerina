import ballerina/io;

type Position record {|
    int row;
    int col;
    int val;
|};

type FoundBasin record {|
    int[][] basin;
    int lastSize;
|};

function parseLine(string s) returns int[]|error {
    int[] result = [];
    result.setLength(s.length());
    foreach int i in 0..<s.length() {
        result[i] = check int:fromString(s[i]);
    }
    return result;
}

function readInput() returns int[][]|error {
    string[] lines = check io:fileReadLines("day9.txt");
    return lines.map(it => check parseLine(it));
}

function neighbours(int row, int col, int[][] basin) returns Position[] {
    int height = basin.length();
    int width = basin[0].length();
    Position[] neighbours = [];
    if row > 0 {
        neighbours.push(<Position>{
            row: row-1,
            col: col,
            val: basin[row-1][col]
        });
    }
    if col > 0 {
        neighbours.push(<Position>{
            row: row,
            col: col-1,
            val: basin[row][col-1]
        });
    }
    if row < width - 1 {
        neighbours.push(<Position>{
            row: row+1,
            col: col,
            val: basin[row+1][col]
        });
    }
    if col < height - 1 {
        neighbours.push(<Position>{
            row: row,
            col: col+1,
            val: basin[row][col+1]
        });
    }
    return neighbours;
}

function isLowPoint(int row, int col, int[][] basin) returns boolean {
    Position[] ps = neighbours(row, col, basin);
    int val = basin[row][col];
    foreach Position p in ps {
        if p.val <= val {
            return false;
        }
    }
    return true;
}

function findAndMarkBasin(int row, int col, int[][] basin) returns FoundBasin {
    Position[] stack = [<Position>{row: row, col: col, val: basin[row][col]}];
    int size = 0;
    while stack.length() > 0 {
        Position current = stack.pop();
        if basin[current.row][current.col] == 9 {
            // skip over already handled points
            continue;
        }
        size += 1;
        // Find reachable points
        Position[] ps = neighbours(current.row, current.col, basin).filter(it => it.val < 9);
        foreach Position p in ps {
            stack.push(p);
        }
        // keep track of already visited points
        basin[current.row][current.col] = 9;
    }
    return <FoundBasin>{
        basin: basin,
        lastSize: size
    };
}

function part2(int[][] basin) returns int[] {
    int height = basin.length();
    int width = basin[0].length();
    int[] sizes = [];
    int[][] b = basin;
    foreach int row in 0..<height {
        foreach int col in 0..<width {
            if b[row][col] != 9 {
                FoundBasin fb = findAndMarkBasin(row, col, b);
                if fb.lastSize == 0 {
                    return sizes;
                } else {
                    b = fb.basin;
                    sizes.push(fb.lastSize);
                }
            }        
        }
    }
    return sizes.sort().reverse();
}

public function solve() returns error? {
    int[][] basin = check readInput();
    int height = basin.length();
    int width = basin[0].length();
    int part1 = 0;
    foreach int row in 0..<height {
        foreach int col in 0..<width {
            if isLowPoint(row, col, basin) {
                part1 += 1 + basin[row][col];
            }
        }
    }
    io:println(`day9 part1: ${part1}`);

    int[] sizes = part2(basin);
    io:println(`day9 part2: ${sizes[0] * sizes[1] * sizes[2]}`);
}