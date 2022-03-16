import ballerina/test;

@test:Config {}
function parseLineTest() {
    string input = "1,2 -> 3,4";
    Line expected = <Line>{
        x1: 1,
        y1: 2,
        x2: 3,
        y2: 4
    };
    test:assertEquals(parseLine(input), expected);
}

@test:Config {}
function toPointsTest() {
    Line input = <Line>{
        x1: 1,
        y1: 1,
        x2: 1,
        y2: 3
    };
    Point[] expected = [
        <Point>{row:1, col:1},
        <Point>{row:1, col:2},
        <Point>{row:1, col:3}
    ];
    test:assertEquals(toPoints(input), expected);
}