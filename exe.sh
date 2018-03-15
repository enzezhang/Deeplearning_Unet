#!/bin/bash


export CUDA_VISIBLE_DEVICES=1

#  run our pre-trained model provided by user ,  commit:
#python main.py unsData --resume checkpoint_BN.tar --niter 0 --useBN 
#--cuda


# run train 

#python main.py unsData --worker 1 --batchSize 8 --niter 25 --lr 0.0002 --cuda --useBN --output_name checkpoint_1.tar

#resume 
python main.py unsData --worker 1 --batchSize 8 --niter 75 --lr 0.0002 --cuda --useBN --output_name checkpoint_1_1.tar --resume checkpoint_1.tar
