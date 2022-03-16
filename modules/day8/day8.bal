import ballerina/io;
import ballerina/regex;

type Line record {|
    string[] signal;
    string[] output;
|};

function sortString(string s) returns string|error {
    return string:fromBytes(s.toBytes().sort());
}

function parseLine(string s) returns Line|error {
    string[] splitted = regex:split(s, " \\| ");
    if splitted.length() != 2 {
        return error("unexpected line");
    } else {
        return <Line>{
            signal: regex:split(splitted[0], " ").map(it => check sortString(it)),
            output: regex:split(splitted[1], " ").map(it => check sortString(it))
        };
    }
}

function countOverlapInSortedStrings(string s1, string s2) returns int {
    int i1 = 0;
    int i2 = 0;
    int overlap = 0;
    while i1 < s1.length() && i2 < s2.length() {
        if s1[i1] == s2[i2] {
            overlap += 1;
            i1 += 1;
            i2 += 1;
        } else if s1[i1] > s2[i2] {
            i2 += 1;
        } else {
            i1 += 1;
        }
    }
    return overlap;
}

function readInput() returns Line[]|error {
    string[] lines = check io:fileReadLines("day8.txt");
    return lines.map(it => check parseLine(it));
}

function reducer1(int acc, Line l) returns int {
    var checkFn = function (string s) returns boolean {
        int len = s.length();
        return len == 2 || len == 3 || len == 4 || len == 7;
    };
    return acc + l.output.filter(checkFn).length();
}

function reducer2(int acc, Line l) returns int|error {
    map<int> mapping = check codec(l.signal);
    string[] vs = l.output.reverse();
    int outputValue = 0;
    int multiplier = 1;
    foreach string v in vs {
        outputValue += multiplier * mapping.get(v);
        multiplier *= 10;
    }
    return acc + outputValue;
}

function codec(string[] sortedCodes) returns map<int>|error {
    string len2 = "";
    string len4 = "";
    foreach string s in sortedCodes {
        match s.length() {
            2 => {len2 = s;}
            4 => {len4 = s;}
        }
    }

    map<int> m = {};
    foreach string s in sortedCodes {
        match s.length() {
            2 => {m[s] = 1;}
            3 => {m[s] = 7;}
            4 => {m[s] = 4;}
            5 => {
                //    1  4  7
                // 2 (1, 2, 2) -- 5
                // 3 (2, 3, 3) -- 5
                // 5 (1, 3, 2) -- 5
                match countOverlapInSortedStrings(len2, s) {
                    1 => {
                        match countOverlapInSortedStrings(len4, s) {
                            2 => {m[s] = 2;}
                            3 => {m[s] = 5;}
                            _ => {return error("unknown number with 5 elements (overlap 4)");}
                        }
                    }
                    2 => {m[s] = 3;}
                    _ => {return error("unknown number with 5 elements (overlap 2)");}
                }
            }
            6 => {
                //    1  4  7
                // 0 (2, 3, 3) -- 6
                // 6 (1, 3, 2) -- 6
                // 9 (2, 4, 3) -- 6
                match countOverlapInSortedStrings(len2, s) {
                    1 => {m[s] = 6;}
                    2 => {
                        match countOverlapInSortedStrings(len4, s) {
                            3 => {m[s] = 0;}
                            4 => {m[s] = 9;}
                            _ => {return error("unknown number with 6 elements (overlap 4)");}
                        }
                    }
                    _ => {return error("unknown number with 6 elements (overlap 2)");}
                }
            }
            7 => {
                m[s] = 8;
            }
            _ => {
                return error("unknown number (length)");
            }
        }
    }
    return m;
}

public function solve() returns error? {
    Line[] lines = check readInput();
    int part1 = lines.reduce(reducer1, 0);
    io:println(`day8 part1 ${part1}`);
    int part2 = lines.reduce(reducer2, 0);
    io:println(`day8 part2 ${part2}`);
}

