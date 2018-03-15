#!/usr/bin/env bash


para_file=para.ini
para_py=/home/hlc/codes/PycharmProjects/DeeplabforRS/parameters.py


root=$(python2 ${para_py} -p ${para_file} working_root)


mkdir ${root}/list
cp /home/zez/lingcao_script/DeeplabforRS-master/bash_script/extract_fileid.sh ./list
find ${root}/train/figure/*.tif > list/image_list.txt
find ${root}/train/label_figure/*.tif > list/label_list.txt
paste list/image_list.txt list/label_list.txt | awk ' { print $1 " " $2 }' > list/temp.txt
cp list/temp.txt list/train_aug.txt


#while read image <&3 && read label <&4
#do
#    #echo $image
#  #  echo $label
#    size_image=$(gdalinfo ${image} | grep "Size is" )
#    width_image=$(echo $size_image | cut -d' ' -f 3 )
#    width_image=${width_image::-1}
#    height_image=$(echo $size_image | cut -d' ' -f 4 )
#   # echo "*****width,height of image *****:" $width_image , $height_image
#    size_label=$(gdalinfo ${label} | grep "Size is" )
#    width_label=$(echo $size_label | cut -d' ' -f 3 )
#    width_label=${width_label::-1}
#    height_label=$(echo $size_label | cut -d' ' -f 4 )
#   # echo "*****width,height of label *****:" $width_label , $height_label
#    if [ "$width_image" -ne "$width_label" -o "$height_image" -ne "$height_label" ];then
#    echo "gdal_translate -srcwin 0 0 $width_image $height_image -a_nodata 0 $label ${root}/train/label_figure/temp.tif"
#    gdal_translate -srcwin 0 0 $width_image $height_image -a_nodata 0 $label ${root}/train/label_figure/temp.tif
#    echo "mv ${root}/train/label_figure/temp.tif $label"
#    mv ${root}/train/label_figure/temp.tif $label
#    fi
##        echo $img
##        gdal_translate -srcwin 0 0 $out_w $out_h -a_nodata 0 $img temp.tif
##        mv temp.tif $img
##
#
#done 3<"list/image_list.txt" 4<"list/label_list.txt"

