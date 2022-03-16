import ballerina/io;

enum Symbol {
    PARENTHESIS,
    BRACKETS,
    CURLYBRACKETS,
    OTHERS
}

final map<int> scores = {
    PARENTHESIS: 3,
    BRACKETS: 57,
    CURLYBRACKETS: 1197,
    OTHERS: 25137
};

final map<int> scores2 = {
    PARENTHESIS: 1,
    BRACKETS: 2,
    CURLYBRACKETS: 3,
    OTHERS: 4
};

function handleLine(string s) returns Symbol[]|Symbol|error {
    Symbol[] opened = [];
    foreach int i in 0..<s.length() {
        string it = s[i];
        match it {
            "(" => {
                Symbol p = PARENTHESIS;
                opened.push(p);
            }
            "[" => {
                Symbol p = BRACKETS;
                opened.push(p);
            }
            "{" => {
                Symbol p = CURLYBRACKETS;
                opened.push(p);
            }
            "<" => {
                Symbol p = OTHERS;
                opened.push(p);
            }
            ")" => {
                if opened.length() == 0 {
                    return PARENTHESIS;
                }
                Symbol p = opened.pop();
                if p != PARENTHESIS {
                    return PARENTHESIS;
                }
            }
            "]" => {
                if opened.length() == 0 {
                    return BRACKETS;
                }
                Symbol p = opened.pop();
                if p != BRACKETS {
                    return BRACKETS;
                }
            }
            "}" => {
                if opened.length() == 0 {
                    return CURLYBRACKETS;
                }
                Symbol p = opened.pop();
                if p != CURLYBRACKETS {
                    return CURLYBRACKETS;
                }
            }
            ">" => {
                if opened.length() == 0 {
                    return OTHERS;
                }
                Symbol p = opened.pop();
                if p != OTHERS {
                    return OTHERS;
                }
            }
            _ => {return error("invalid symbol");}
        }
    }

    return opened;
}

function score(Symbol[] opened) returns int {
    Symbol[] close = opened.reverse();
    int total = 0;

    foreach Symbol s in close {
        total *= 5;
        int? v = scores2[s];
        if v != null {
            total += v;
        }
    }
    return total;
}

public function solve() returns error? {
    string[] lines = check io:fileReadLines("day10.txt");
    int part1 = 0;
    int[] part2 = [];
    foreach string l in lines {
        var result = check handleLine(l);
        if result is Symbol {
            int? v = scores[result];
            if v != null {
                part1 += v;
            }
        } else {
            part2.push(score(result));
        }
    }
    io:println(`day10 part1: ${part1}`);
    part2 = part2.sort();
    io:println(`day10 part2: ${part2[part2.length()/2]}`);
}