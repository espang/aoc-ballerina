import ballerina/io;
import aoc.day1;
import aoc.day2;
import aoc.day3;
import aoc.day4;
import aoc.day5;
import aoc.day6;
import aoc.day7;

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

    err = day3:solve();
    if err is error {
        io:println(`error is ${err}`);
    }

    err = day4:solve();
    if err is error {
        io:println(`error is ${err}`);
    }

    err = day5:solve();
    if err is error {
        io:println(`error is ${err}`);
    }

    err = day6:solve();
    if err is error {
        io:println(`error is ${err}`);
    }

    err = day7:solve();
    if err is error {
        io:println(`error is ${err}`);
    }
}
