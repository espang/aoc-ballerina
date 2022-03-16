import ballerina/io;
import ballerina/regex;

type Line record {|
    int x1;
    int y1;
    int x2;
    int y2;
|};

type Point record {|
    int row = 0;
    int col = 0;
|};

function parsePoint(string s) returns Point|error {
    int[] numbers = regex:split(s, ",").map(it => check int:fromString(it));
    if numbers.length() != 2 {
        return error("not the right amount of numbers");
    } else {
        return <Point>{row: numbers[0], col: numbers[1]};
    }
}

function parseLine(string s) returns Line|error {
    Point[] points = regex:split(s, " -> ").map(it => check parsePoint(it));
    if points.length() != 2 {
        return error("not the right amount of numbers");
    } else {
        return <Line>{
            x1: points[0].row,
            y1: points[0].col,
            x2: points[1].row,
            y2: points[1].col
        };
    }
}

function readInput() returns Line[]|error {
    string[] lines = check io:fileReadLines("day5.txt");
    return lines.map(line => check parseLine(line));
}

function toPoints(Line l) returns Point[] {
    int dx = 0;
    if l.x2 - l.x1 != 0 {
        dx = (l.x2 - l.x1) / (l.x2 - l.x1).abs();
    }
    int dy = 0;
    if l.y2 - l.y1 != 0 {
        dy = (l.y2 - l.y1) / (l.y2 - l.y1).abs();
    }
    int x = l.x1;
    int y = l.y1;
    Point[] points = [<Point>{row: x, col: y}];
    while !(x == l.x2 && y == l.y2) {
        x += dx;
        y += dy;
        points.push(<Point>{row: x, col: y});
    }

    return points;
}

class OceanFloor {
    private int[][] points;

    function init() {
        self.points = [];
        self.points.setLength(1000);
        foreach int[] row in self.points {
            row.setLength(1000);
        }
    }

    function addPoint(int row, int col) returns error? {
        if row > 1000 || row < 0 {
            return error("invalid row");
        }
        if col > 1000 || col < 0 {
            return error("invalid col");
        }
        self.points[row][col] += 1;
    }

    function numberOfOverlaps() returns int {
        int total = 0;
        foreach int[] rows in self.points {
            foreach int cell in rows {
                if cell >= 2 {
                    total += 1;
                }
            }
        }
        return total;
    }
}

function considerLine(Line l) returns boolean {
    return l.x1 == l.x2 || l.y1 == l.y2;
}

public function solve() returns error? {
    OceanFloor f = new OceanFloor();
    Line[] lines = check readInput();
    foreach Line line in lines {
        if considerLine(line) {
            Point[] points = toPoints(line);
            foreach Point p in points {
                check f.addPoint(p.row, p.col);
            }
        }
    }   
    io:println(`day5 part1 ${f.numberOfOverlaps()}`);
    f = new OceanFloor();
    foreach Line line in lines {
        Point[] points = toPoints(line);
        foreach Point p in points {
            check f.addPoint(p.row, p.col);
        }
    }   
    io:println(`day5 part2 ${f.numberOfOverlaps()}`);
}