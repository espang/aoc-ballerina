import ballerina/io;
import ballerina/regex;

function readInput() returns int[]|error {
    string content = (check io:fileReadString("day7.txt")).trim();
    return regex:split(content, ",").map(it => check int:fromString(it));
}

function fuelForMove(int to, int[] positions, function(int val) returns int costFn) returns int {
    return positions.reduce(
        function(int total, int position) returns int {
            return total + costFn((position-to).abs());
        },0
    );
}

function costPart1(int val) returns int {
    return val;
}

function costPart2(int val) returns int {
    return val * (val+1) / 2;
}

public function solve() returns error? {
    int[] positions = check readInput();
    int smallest = int:MAX_VALUE;
    int largest = int:MIN_VALUE;
    foreach int p in positions {
        smallest = int:min(smallest, p);
        largest = int:max(largest, p);
    }

    int part1 = int:MAX_VALUE;
    int part2 = int:MAX_VALUE;
    foreach int to in smallest..<largest+1 {
        part1 = int:min(part1, fuelForMove(to, positions, costPart1));
        part2 = int:min(part2, fuelForMove(to, positions, costPart2));
    }
    io:println(`day7 part1: ${part1}`);
    io:println(`day7 part2: ${part2}`);
}