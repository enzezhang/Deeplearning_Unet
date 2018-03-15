#!/bin/bash


export CUDA_VISIBLE_DEVICES=1

para_file=para.ini
para_py=/home/hlc/codes/PycharmProjects/DeeplabforRS/parameters.py
eo_dir=$(python2 ${para_py} -p ${para_file} codes_dir)
expr=${PWD}
testid=$(basename $expr)

#input_train_dir=$(python2 ${para_py} -p ${para_file} input_train_dir)


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
rm -r train_output
mkdir train_output
rm train_loss.txt
#echo "python ${eo_dir}/main.py ${data_dir} --worker 1 --niter 2000 --batchSize 1 --cuda --useBN --ourput_name checkpoint_test1.tar"
#python ${eo_dir}/main.py ${data_dir} --worker 1 --niter 2000 --batchSize 4 --cuda --useBN --output_name checkpoint_test1.tar



echo "python ${eo_dir}/main.py ${work_root} ${para_file} ./list/train_aug.txt --lr 0.0001 --worker 1 --niter 250 --batchSize 4 --cuda --useBN --output_name checkpoint_250.tar"
python ${eo_dir}/main.py ${work_root} ${para_file} ./list/train_aug.txt --lr 0.0001 --worker 1 --niter 250 --batchSize 4 --cuda --useBN --output_name checkpoint_250.tar
#python ${eo_dir}/main.py ${work_root} ${para_file} ./list/train_aug.txt --lr 0.0002 --worker 1 --resume checkpoint_20.tar --edge 1 --start_epoch 20 --niter 20 --batchSize 1 --cuda --useBN --output_name checkpoint_20_20.tar
#mv train_loss.txt train_loss_20_20.txt




