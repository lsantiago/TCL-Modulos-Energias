set data1 "This is Data1 Value\t"
set data2  "This is Data2 Value"
set data3  "\tThis is Data3 Value\t"

set fo [open test.txt w]
foreach different_content {data1 data2 data3} {
    puts $fo [set $different_content]
}
close $fo