import ballerina/io;
import ballerina/regex;

enum Direction {
    FORWARD = "forward",
    DOWN = "down",
    UP = "up"
}

type Command record {|
    Direction dir;
    int amount;
|};

type Position record {|
    int horizontal = 0;
    int depth = 0;
    int aim = 0;
|};

function parseCommand(string s) returns Command|error {
    string[] splitted = regex:split(s, " ");
    if splitted.length() != 2 {
        return error("invalid format in string");
    }
    match splitted[0] {
        FORWARD => {
            return <Command>{
                dir: FORWARD,
                amount: check int:fromString(splitted[1])
            };
        }
        DOWN => {
            return <Command>{
                dir: DOWN,
                amount: check int:fromString(splitted[1])
            };
        }
        UP => {
            return <Command>{
                dir: UP,
                amount: check int:fromString(splitted[1])
            };
        }
        _ => {
            return error("invalid direction");
        }
    }
}

function readInput() returns Command[]|error {
    string[] lines = check io:fileReadLines("day2.txt");
    return lines.map(l => check parseCommand(l));
}

function move(Position p, Command c) returns Position {
    match c.dir {
        FORWARD => {
            p.horizontal += c.amount;
            return p;
        }
        DOWN => {
            p.depth += c.amount;
            return p;
        }
        UP => {
            p.depth -= c.amount;
            return p;
        }
    }
    return p;
}

function move2(Position p, Command c) returns Position {
    match c.dir {
        FORWARD => {
            p.horizontal += c.amount;
            p.depth += p.aim * c.amount;
            return p;
        }
        DOWN => {
            p.aim += c.amount;
            return p;
        }
        UP => {
            p.aim -= c.amount;
            return p;
        }
    }
    return p;
}

public function solve() returns error? {
    Command[] cmds = check readInput();
    Position pos = <Position>{};
    foreach Command cmd in cmds {
        pos = move(pos, cmd);
    }
    int result = pos.horizontal * pos.depth;
    io:println(`day 2 part 1 : ${result}`);
    pos = <Position>{};
    foreach Command cmd in cmds {
        pos = move2(pos, cmd);
    }
    result = pos.horizontal * pos.depth;
    io:println(`day 2 part 2 : ${result}`);
}