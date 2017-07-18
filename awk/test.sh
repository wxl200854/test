#!/bin/bash
cat udp_0606_s23h20.txt|awk -F '\t' '
BEGIN{
}{
    if($2=="113.121.95.87"||$4=="113.121.95.87"){
        print $0>"unknown_113.121.95.87.txt";
        sum+=$7;
    }
}END{
    print "sum\t"sum > "tongji.txt"
}
' 

