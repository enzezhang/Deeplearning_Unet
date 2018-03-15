#!/bin/bash


export CUDA_VISIBLE_DEVICES=1

para_file=para.ini
para_py=/home/hlc/codes/PycharmProjects/DeeplabforRS/parameters.py
eo_dir=$(python2 ${para_py} -p ${para_file} codes_dir)
expr=${PWD}
testid=$(basename $expr)

#input_test_dir=$(python2 ${para_py} -p ${para_file} input_test_dir)


work_root=$(python2 ${para_py} -p ${para_file} working_root)
# data_dir is the list of images and label images

#  run our pre-trained model provided by user ,  commit:
#python main.py unsData --resume checkpoint_BN.tar --niter 0 --useBN 
#--cuda


# run train 

#python main.py unsData --worker 1 --batchSize 8 --niter 25 --lr 0.0002 --cuda --useBN --output_name checkpoint_1.tar

#resume 
#python main.py ${data_dir} --worker 1 --batchSize 8 --niter 100 --lr 0.0002 --cuda --useBN --output_name checkpoint_gImg_v4.tar

#exit

### run test


#rm -r test_output
mkdir test_output
rm test_loss.txt
echo "python ${eo_dir}/test.py ${work_root} ${para_file} ./list/test_label.txt --worker 1 --batchSize 1 --cuda --useBN --resume checkpoint_250.tar"
#python ${eo_dir}/test.py ${work_root} ${para_file} ./list/test_label.txt --worker 1 --batchSize 1 --cuda --useBN --resume checkpoint_250.tar
#






##
#### post processing
rm -r post_output
mkdir post_output
rm -r post_porcess_shape
mkdir post_process_shape
cd test_output
    while read test_img
    do
         echo $test_img
         temp1=(`echo $test_img | cut -d '/' -f 9`)

         temp2=${temp1:0:8}
         echo ${temp2}
         #ls *${temp2}*.tif
#        echo $png
#        name_noext=${png%.*}
#        name_org=${name_noext::-5}
#        # -srcwin 0 0 560 400
#        gdal_translate $png ${name_noext}.tif
#        ${eo_dir}/gdalcopyproj.py ../inf_split_images/${name_org}.tif  ${name_noext}.tif
        echo "/home/zez/zez_code/gdal_merge_average.py -o ../post_output/${temp2}_out_temp1.tif *${temp2}*.tif"
        /home/zez/zez_code/gdal_merge_average.py -o ../post_output/${temp2}_out_temp1.tif *${temp2}*.tif


        echo "gdal_translate -of Gtiff -b 1 ../post_output/${temp2}_out_temp1.tif ../post_output/${temp2}_out_result.tif"
        gdal_translate -of Gtiff -b 1 ../post_output/${temp2}_out_temp1.tif ../post_output/${temp2}_out_result.tif

        echo "gdal_translate -of Gtiff -b 2 ../post_output/${temp2}_out_temp1.tif ../post_output/${temp2}_out_wight.tif"
        gdal_translate -of Gtiff -b 2 ../post_output/${temp2}_out_temp1.tif ../post_output/${temp2}_out_wight.tif


        echo "gdal_calc.py -A ../post_output/${temp2}_out_result.tif -B ../post_output/${temp2}_out_wight.tif --outfile=../post_output/${temp2}_out_temp.tif --calc=\"A*28/B\" --NoDataValue=0"
        gdal_calc.py -A ../post_output/${temp2}_out_result.tif -B ../post_output/${temp2}_out_wight.tif --outfile=../post_output/${temp2}_out_temp.tif --type='Float64' --calc="A*28/B" --NoDataValue=0


        echo "gdal_calc.py -A ../post_output/${temp2}_out_temp.tif --outfile=../post_output/${temp2}_out.tif --calc=\"255*(A>17)\" --NoDataValue=0"
        gdal_calc.py -A ../post_output/${temp2}_out_temp.tif --outfile=../post_output/${temp2}_out.tif --calc="255*(A>17)" --NoDataValue=0


        echo "gdal_polygonize.py -8 ../post_output/${temp2}_out.tif -b 1 -f "ESRI Shapefile" ../post_output/${temp2}_out.shp"
        gdal_polygonize.py -8 ../post_output/${temp2}_out.tif -b 1 -f "ESRI Shapefile" ../post_output/${temp2}_out.shp
        python ${eo_dir}/rm_small_polygon.py --input_shape ../post_output/${temp2}_out.shp --output_shape ../post_process_shape/${temp2}_out_post.shp
        #rm ../post_output/${temp2}_out.tif
        rm ../post_output/${temp2}_out_temp1.tif
        rm ../post_output/${temp2}_out_result.tif
        rm ../post_output/${temp2}_out_wight.tif
        rm ../post_output/${temp2}_out.tif
    done <"../list/test.txt"
cd ..
#rm ../post_output/*.tif
##rm -r post_pro_val_result
#mkdir post_pro_val_result
#cd post_pro_val_result
#mv ../test_output/${testid}_out.tif .
## convert to shapefile
#gdal_polygonize.py -8 ${testid}_out.tif -b 1 -f "ESRI Shapefile" ${testid}.shp
#cd ..

#
