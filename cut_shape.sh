#!/usr/bin/env bash

orginal_shape_path=$1

output_shape_path=$3

polygon_shape_path=$2

cd $orginal_shape_path


file=(`ls *.shp`)
count=${#file[@]}

i=0
while(($i<$count))
do
    temp=${file[i]:0:8}
    ogr2ogr -f 'GMT' ../post_process_gmt/$temp.gmt ${file[i]}
    sed -i 1,11d ../post_process_gmt/$temp.gmt
    echo "python /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/point_in_polygon.py --input ../post_process_gmt/$temp.gmt --polygon $polygon_shape_path --output $output_shape_path/$temp.gmt
"
    python /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/point_in_polygon.py --input ../post_process_gmt/$temp.gmt --polygon $polygon_shape_path --output $output_shape_path/$temp.gmt
    echo "gmt gmt2kml -Fl $output_shape_path/$temp.gmt >$output_shape_path/$temp.kml"
    gmt gmt2kml -Fl $output_shape_path/$temp.gmt >$output_shape_path/$temp.kml
    echo "ogr2ogr -f \"ESRI Shapefile\" $output_shape_path/$temp.shp $output_shape_path/$temp.kml"
    ogr2ogr -f "ESRI Shapefile" $output_shape_path/$temp.shp $output_shape_path/$temp.kml


    i=$[i+1]

done