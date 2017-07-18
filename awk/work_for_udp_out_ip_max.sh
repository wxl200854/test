#!/bin/bash
# create by zdm 2017-05-19
# 功能：统计xdr100话单 总量，网内/外 Top排序

function work_for_xdr100(){
    echo "统计网外/网内IP 下载量，请稍后..."
    cat *.csv|awk -F '|'  '
    BEGIN{
        print "type\tsum">"tongji.txt"
        print "YWID\tin_ip\tin_port\tout_ip\tout_port\tup\tdown\tp">"all_out_ip_max.txt" 
        print "YWID\tin_ip\tin_port\tout_ip\tout_port\tup\tdown\tp">"all_out_ip_max_known.txt" 
        print "YWID\tin_ip\tin_port\tout_ip\tout_port\tup\tdown\tp">"all_out_ip_max_unknown.txt"
        print "YWID\tin_ip\tin_port\tout_ip\tout_port\tp\tdown\tcount">"all_out_ip_max_known_deal.txt" 
        print "YWID\tin_ip\tin_port\tout_ip\tout_port\tp\tdown\tcount">"all_out_ip_max_unknown_deal.txt"
    }{
        if($21=="58.31.205.57"){
            print $14"\t"$17"\t"$19"\t"$21"\t"$23"\t"$24/(1024*1024)"\t"$25/(1024*1024)"\t"$20 >>"all_out_ip_max.txt"
            sum_all_out_ip_max+=$25
            if(!($14==3842||$14==1023||$14==1535||$14==2835)){
                known[$14"\t"$17"\t"$19"\t"$21"\t"$23"\t"$20]+=$25;
                count_known+=1;
                
                print $14"\t"$17"\t"$19"\t"$21"\t"$23"\t"$24/(1024*1024)"\t"$25/(1024*1024)"\t"$20 >>"all_out_ip_max_known.txt";
                sum_all_out_ip_max_known+=$25;
            }else{     
                unknown[$14"\t"$17"\t"$19"\t"$21"\t"$23"\t"$20]+=$25;
                count_unknown+=1;
                
                print $14"\t"$17"\t"$19"\t"$21"\t"$23"\t"$24/(1024*1024)"\t"$25/(1024*1024)"\t"$20 >>"all_out_ip_max_unknown.txt";
                sum_all_out_ip_max_unknown+=$25;
            }
        }
        sum_all+=$25 
    }END{
        for(key in known){
            print  key"\t"known[key]/(1024*1024)"\t"count_known >>"all_out_ip_max_known_deal.txt"
        }
        for(key in unknown){
             print  key"\t"unknown[key]/(1024*1024)"\t"count_unknown >>"all_out_ip_max_unknown_deal.txt"
        }
    
        print "sum_all\t"sum_all/(1024*1024) >>"tongji.txt"
        print "sum_all_out_ip_max\t"sum_all_out_ip_max/(1024*1024) >>"tongji.txt"
        print "sum_all_out_ip_max_known\t"sum_all_out_ip_max_known/(1024*1024) >>"tongji.txt"	
        print "sum_all_out_ip_max_unknown\t"sum_all_out_ip_max_unknown/(1024*1024)>>"tongji.txt"     
    }'

    cat all_out_ip_max_known_deal.txt|sort -k 7 -rn |head -n 1000 >all_out_ip_max_known_deal_top1000.txt
    cat all_out_ip_max_unknown_deal.txt|sort -k 7 -rn |head -n 1000 >all_out_ip_max_unknown_deal_top1000.txt
    echo "报告，awk已完成任务" 
}

work_for_xdr100
