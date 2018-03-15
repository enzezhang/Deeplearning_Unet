#!/usr/bin/env bash


data_path=/home/zez/test_deep_learning/u_net/test16/calving_data/geoed_node_two_calving_front
output=/home/zez/test_deep_learning/u_net/test16/area_change_another_data.txt

cd $data_path
file=(`ls *.txt`)

count=${#file[@]}
rm $output
i=0
while(($i<$count))
do
    a=(`python /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/calculate_area.py --input ${file[i]}`)
    temp=${file[i]:0:8}
    echo "$a $temp"
    echo "$a  $temp">>$output
    i=$[i+1]
done

