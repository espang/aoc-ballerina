import ballerina/io;

import aoc.day1;
import aoc.day2;
import aoc.day3;
import aoc.day4;
import aoc.day5;
import aoc.day6;
import aoc.day7;
import aoc.day8;
import aoc.day9;
import aoc.day10;

configurable int DAY = ?;

public function main() {
    error? err = ();
    match DAY {
        1 => {err = day1:solve();}
        2 => {err = day2:solve();}
        3 => {err = day3:solve();}
        4 => {err = day4:solve();}
        5 => {err = day5:solve();}
        6 => {err = day6:solve();}
        7 => {err = day7:solve();}
        8 => {err = day8:solve();}
        9 => {err = day9:solve();}
        10 => {err = day10:solve();}
        _ => {err = error("unsupported type, use number between 1 and 10");}
    }
    if err is error {
        io:println(`error is ${err}`);
    }
}
