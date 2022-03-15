import ballerina/io;

type NumberCount record {|
    int zeroCount = 0;
    int oneCount = 0;
|};

function binaryStrToInt(string s) returns int[]|error {
    int[] result = [];
    foreach string:Char c in s {
        if c == "0" {
            result.push(0);
        } else if c == "1" {
            result.push(1);
        } else {
            return error("unexpected character");
        }
    }
    return result;
}

function readInput() returns int[][]|error {
    string[] lines = check io:fileReadLines("day3.txt");
    return lines.map(l => check binaryStrToInt(l));
}

function binaryToNumber(int[] binary) returns int {
    int total = 0;
    int value = 1;
    int[] reversed = binary.reverse();
    foreach int i in 0..<reversed.length() {
        if reversed[i] == 1 {
            total += value;
        }
        value *= 2;
    }
    return total;
}

function count0and1(int at, int[][] bits) returns NumberCount {
    NumberCount result = <NumberCount>{};
    foreach int i in 0..<bits.length() {
        if bits[i][at] == 0 {
            result.zeroCount += 1;
        } else {
            result.oneCount += 1;
        }
    }
    return result;
}

function mostCommonBit(int at, int[][] bits) returns int {
    NumberCount result = count0and1(at, bits);
    if result.zeroCount > result.oneCount {
        return 0;
    } else {
        return 1;
    }
}

function oxygenStep(int at, int[][] bits) returns int[][] {
    NumberCount count = count0and1(at, bits);
    if count.oneCount >= count.zeroCount {
        return bits.filter(arr => arr[at] == 1);
    }else {
        return bits.filter(arr => arr[at] == 0);
    }
}

function scrubberStep(int at, int[][] bits) returns int[][] {
    NumberCount count = count0and1(at, bits);
    if count.oneCount >= count.zeroCount {
        return bits.filter(arr => arr[at] == 0);
    }else {
        return bits.filter(arr => arr[at] == 1);
    }
}

function repeatSteps(int[][] bits, function(int at, int[][] bits) returns int[][] fn) returns int[]|error {
    int size = bits[0].length();
    int[][] b = bits;
    foreach int i in 0..<size {
        b = fn(i, b);
        if b.length() == 1 {
            return b[0];
        }
        
    }
    return error("no solution found");
}
public function solve() returns error? {
    int[][] data = check readInput();

    // assume the data is consistent and has at least 1 element!
    int size = data[0].length();
    int[] gamma = [];
    int[] epsilon = [];
    foreach int i in 0..<size {
        int mcb = mostCommonBit(i, data);
        gamma.push(mcb);
        epsilon.push(1-mcb);
    }
    int result = binaryToNumber(gamma) * binaryToNumber(epsilon);
    io:println(`day3 part1: ${result}`);

    int[] oxygen = check repeatSteps(data, oxygenStep);
    int[] scrubber = check repeatSteps(data, scrubberStep);
    result = binaryToNumber(oxygen) * binaryToNumber(scrubber);
    io:println(`day3 part2: ${result}`);

}