#!/bin/bash
# create by zdm 2017-05-19
# 功能：统计xdr100话单 总量，网内/外 Top排序

function work_for_xdr100(){
echo "统计网外/网内IP 下载量，请稍后..."
cat 123|awk -F '\t'  '
BEGIN{
    print "type\tsum">"tongji.txt"
    print "in_ip\tin_port\tout_ip\tout_port\tup\tdown">"udp_18631864_060620.txt" 
    print "in_ip\tin_port\tout_ip\tout_port\tup\tdown">"udp_18631864_in_060620.txt" 
    print "in_ip\tin_port\tout_ip\tout_port\tup\tdown">"udp_18631864_out_060620.txt"
}
{
    if ($2==1863||$2==1864||$4==1863||$4==1864){
      print $0 >>"udp_18631864_060620.txt"
    }
    if ($2==1863||$2==1864){
        in_down[$1]+=$6;
        count_in[$1]+=1;
        sum_udp_in_down+=$6;
        
        print  $0>>"udp_18631864_in_060620.txt";       
    }
    if ($4==1863||$4==1864){
        out_down[$3]+=$6;
        count_out[$3]+=1;
        sum_udp_out_down+=$6;
        
        print $0>>"udp_18631864_out_060620.txt";
    }
	sum_udp_unknown+=$6;
    
}END{
    
    print "out_ip\tdown MB\tCount">"udp_18631864_out_tongji_060620.txt"
    for (key in out_down){
        print key"\t"out_down[key]/(1024*1024)"\t"count_out[key]>>"udp_18631864_out_tongji_060620.txt"
    }
                                      
    print "in_ip\tdown MB\tCount">"udp_18631864_in_tongji_060620.txt"
    for (key in in_down){
        print key"\t"in_down[key]/(1024*1024)"\t"count_in[key]>>"udp_18631864_in_tongji_060620.txt"
    } 

    print "sum_udp_unknown\t"sum_udp_unknown/(1024*1024) >>"tongji.txt"
    print "sum_udp_out_down\t"sum_udp_out_down/(1024*1024)>>"tongji.txt"
    print "sum_udp_in_down\t"sum_udp_in_down/(1024*1024) >>"tongji.txt"
}'

    cat udp_18631864_out_tongji_060620.txt |sort -k 2 -rn |head -n 1000 >udp_out_top1000.txt
    cat udp_18631864_in_tongji_060620.txt |sort -k 2 -rn |head -n 1000 >udp_in_top1000.txt
   
    echo "报告，awk已完成任务" 
}
work_for_xdr100
