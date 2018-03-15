#!/usr/bin/env bash


para_file=para.ini
para_py=/home/hlc/codes/PycharmProjects/DeeplabforRS/parameters.py


root=$(python2 ${para_py} -p ${para_file} working_root)


find ${root}/test/figure/*.tif > list/test.txt
find ${root}/test/label/*.tif > list/label_test.txt
paste list/test.txt list/label_test.txt | awk ' { print $1 " " $2 }' > list/test_label.txt
