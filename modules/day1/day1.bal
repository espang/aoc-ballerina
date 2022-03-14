import ballerina/io;

function readInput() returns int[]|error {
    string[] lines = check io:fileReadLines("day1.txt");
    return lines.map(l => check int:fromString(l));
}

function countIncreases(int[] numbers) returns int {
    int total = 0;
    int previous = int:MAX_VALUE;
    foreach int number in numbers {
        if number > previous {
            total+=1;
        }
        previous = number;
    }
    return total;
}

function slidingWindow(int[] numbers) returns int[] {
    int index = 0;
    if numbers.length() < 3 {
        return [];
    }
    int sum = numbers[0] + numbers[1] + numbers[2];
    int[] result = [sum];
    foreach int i in 3 ..<numbers.length() {
        sum = sum - numbers[i-3] + numbers[i];
        result.push(sum);
    }
    return result;
}

public function solve() returns error? {
    int[] numbers = check readInput();
    int total = countIncreases(numbers);
    io:println(`day1 part1: ${total}`);
    int total2 = countIncreases(slidingWindow(numbers));
    io:println(`day1 part2: ${total2}`);
}