#!/bin/bash


#export CUDA_VISIBLE_DEVICES=1

#  run our pre-trained model provided by user ,  commit:
#python main.py unsData --resume checkpoint_BN.tar --niter 0 --useBN 
#--cuda


# run train using CPU 

python main.py unsData --worker 1 --batchSize 4 --niter 25 --lr 0.0002 --useBN --output_name checkpoint_cpu.tar
