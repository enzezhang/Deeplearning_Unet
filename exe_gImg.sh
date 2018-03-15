#!/bin/bash


export CUDA_VISIBLE_DEVICES=1

para_file=para.ini
para_py=/home/hlc/codes/PycharmProjects/DeeplabforRS/parameters.py
eo_dir=$(python2 ${para_py} -p ${para_file} codes_dir)
expr=${PWD}
testid=$(basename $expr)

data_dir=/home/hlc/Data/Qinghai-Tibet/beiluhe/beiluhe_google_img

#  run our pre-trained model provided by user ,  commit:
#python main.py unsData --resume checkpoint_BN.tar --niter 0 --useBN 
#--cuda


# run train 

#python main.py unsData --worker 1 --batchSize 8 --niter 25 --lr 0.0002 --cuda --useBN --output_name checkpoint_1.tar

#resume 
#python main.py ${data_dir} --worker 1 --batchSize 8 --niter 100 --lr 0.0002 --cuda --useBN --output_name checkpoint_gImg_v4.tar

#exit

### run test
rm -r assets
mkdir assets
python test.py ${data_dir} para.ini inf_list.txt  --worker 1 --batchSize 1 --cuda --useBN --resume checkpoint_gImg_v4.tar

### post processing
cd assets
    for png in *_pred.png
    do
        echo $png
        name_noext=${png%.*}
        name_org=${name_noext::-5}
        # -srcwin 0 0 560 400
        gdal_translate $png ${name_noext}.tif
        ${eo_dir}/gdalcopyproj.py ../inf_split_images/${name_org}.tif  ${name_noext}.tif
    done
    gdal_merge.py -init 0 -n 0 -a_nodata 0 -o ${testid}_out.tif *.tif
cd ..

rm -r post_pro_val_result
mkdir post_pro_val_result
cd post_pro_val_result
mv ../assets/${testid}_out.tif .
# convert to shapefile
gdal_polygonize.py -8 ${testid}_out.tif -b 1 -f "ESRI Shapefile" ${testid}.shp
cd ..


