# hiker_test.tcl --

package require tcltest
namespace import ::tcltest::*

# Software under test
source hiker.tcl

test life_the_universe_and_everything {
    Test: [answer] == 42
} -body {
    answer
} -result 42

cleanupTests