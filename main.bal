import ballerina/io;
import aoc.day1;
import aoc.day2;

public function main() {
    io:println("Hello, World!");
    error? err = day1:solve();
    if err is error {
        io:println(`error is ${err}`);
    }

    err = day2:solve();
    if err is error {
        io:println(`error is ${err}`);
    }
}
