import ballerina/io;
import ballerina/regex;

function readInput() returns int[]|error {
    string content = (check io:fileReadString("day6.txt")).trim();
    return regex:split(content, ",").map(it => check int:fromString(it));
}

function doStep(int[] before, int[] after) returns int[] {
    foreach int i in 1..<9 {
        after[i-1] = before[i];
    }
    after[6] += before[0];
    after[8] = before[0];
    return after;
}

function sumr(int acc, int v) returns int {
    return acc + v;
}

function doSteps(int n, int[] fishes) returns int {
    int[] one = [];
    int[] other = [];
    one.setLength(9);
    other.setLength(9);

    foreach int fish in fishes {
        one[fish]+=1;
    }

    int step = 0;
    while step < n {
        if step % 2 == 0 {
            other = doStep(one, other);
        } else {
            one = doStep(other, one);
        }
        step += 1;
    }
    
    if n % 2 == 0 {
        return one.reduce(sumr, 0);
    } else {
        return other.reduce(sumr, 0);
    }
}


public function solve() returns error? {
    int[] fishes = check readInput();
    int part1 = doSteps(80, fishes);
    int part2 = doSteps(256, fishes);
    io:println(`day6 part1: ${part1}`);
    io:println(`day6 part2: ${part2}`);
}
