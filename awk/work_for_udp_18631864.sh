#!/bin/bash
# create by zdm 2017-05-19
# 功能：统计xdr100话单 总量，网内/外 Top排序

function work_for_xdr100(){
echo "统计网外/网内IP 下载量，请稍后..."
cat *.csv|awk -F '|'  '
BEGIN{
    print "type\tsum">"tongji.txt"
    print "YWID\tin_ip\tin_port\tout_ip\tout_port\tup\tdown\tp">"udp_.txt" 
    print "YWID\tin_ip\tin_port\tout_ip\tout_port\tup\tdown\tp">"udp_18631864_known.txt" 
    print "YWID\tin_ip\tin_port\tout_ip\tout_port\tup\tdown\tp">"udp_18631864_unknown.txt"
}
{
   if(($19==1863||$19==1864||$23==1863||$23==1864)&&($20==1)){
      print $14"\t"$17"\t"$19"\t"$21"\t"$23"\t"$24/(1024*1024)"\t"$25/(1024*1024)"\t"$20 >>"udp_18631864.txt"
      if(!($14==3842||$14==1023||$14==1535||$14==2835)){
        out_down_known[$21]+=$25;
        count_out_known[$21]+=1;
                    
        in_down_known[$17]+=$25;
        count_in_known[$17]+=1;

        sum_down_known+=$25;
        print $14"\t"$17"\t"$19"\t"$21"\t"$23"\t"$24/(1024*1024)"\t"$25/(1024*1024)"\t"$20 >>"udp_18631864_known.txt";
      }else{
        out_down_unknown[$21]+=$25;
        count_out_unknown[$21]+=1;

        in_down_unknown[$17]+=$25;
        count_in_unknown[$17]+=1;
        sum_down_unknown+=$25;
        print $14"\t"$17"\t"$19"\t"$21"\t"$23"\t"$24/(1024*1024)"\t"$25/(1024*1024)"\t"$20 >>"udp_18631864_unknown.txt";
       }
    }
	
    if($14==3842||$14==1023||$14==1535||$14==2835){
      if($19==1863||$19==1864){
         sum_udp_unknown_18631864_in+=$25
      }
      if($23==1863||$23==1864){
         sum_udp_unknown_18631864_out+=$25
      }
      sum_udp_unknown+=$25
    }
     sum_all+=$25 
}END{
    
    print "Out IP\tDown MB\tCount" > "out_udp_18631864_known.txt"
    for (key in out_down_known){
        print key"\t"out_down_known[key]/(1024*1024)"\t"count_out_known[key] >> "out_udp_18631864_known.txt"
    }
                                      
    print "In IP\tDown MB\tCount" > "in_udp_18631864_known.txt"
    for (key in in_down_known){
        print key"\t"in_down_known[key]/(1024*1024)"\t"count_in_known[key] >> "in_udp_18631864_known.txt"
    } 

    print "Out IP\tDown MB\tCount" > "out_udp_18631864_unknown.txt"
    for (key in out_down_unknown){
        print key"\t"out_down_unknown[key]/(1024*1024)"\t"count_out_unknown[key] >> "out_udp_18631864_unknown.txt"
    }
                                      
    print "In IP\tDown MB\tCount" > "in_udp_18631864_unknown.txt"
    for (key in in_down_unknown){
        print key"\t"in_down_unknown[key]/(1024*1024)"\t"count_in_unknown[key] >> "in_udp_18631864_unknown.txt"
    } 

    print "sum_all\t"sum_all/(1024*1024) >>"tongji.txt"
    print "sum_udp_unknown\t"sum_udp_unknown/(1024*1024)>>"tongji.txt"
    print "sum_down_known\t"sum_down_known/(1024*1024) >>"tongji.txt"
    print "sum_down_unknown\t"sum_down_unknown/(1024*1024) >>"tongji.txt"	
    print "sum_udp_unknown_18631864_in\t"sum_udp_unknown_18631864_in/(1024*1024)>>"tongji.txt"
    print "sum_udp_unknown_18631864_out\t"sum_udp_unknown_18631864_out/(1024*1024)>>"tongji.txt"
    
}'

    cat out_udp_18631864_known.txt |sort -k 2 -rn |head -n 1000 >udp_out_top1000_known.txt
    cat in_udp_18631864_known.txt |sort -k 2 -rn |head -n 1000 >udp_in_top1000_known.txt
    cat out_udp_18631864_unknown.txt |sort -k 2 -rn |head -n 1000 >udp_out_top1000_unknown.txt
    cat in_udp_18631864_unknown.txt |sort -k 2 -rn |head -n 1000 >udp_in_top1000_unknown.txt



    echo "报告，awk已完成任务" 
}

work_for_xdr100
