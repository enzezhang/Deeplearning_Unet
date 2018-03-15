#!/bin/bash
#cp /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/whole_process.sh ./
cp /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/para.ini ./
cp /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/preparing_inference.sh ./
cp /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/preparing_traindata.sh ./

cp /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/exe_test.sh ./
cp /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/exe_train.sh ./
cp /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/draw_loss.py ./
cp /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/evaluate_test_error.py ./
cp /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/vector_features.py ./
cp /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/polygon_post_process.py ./
cp /home/zez/test_deep_learning/u_net/Unet_pytorch-master_Dec5/cut_shape.sh ./
#bash cut_shape.sh ~/test_deep_learning/u_net/test16/post_process_shape ~/test_deep_learning/u_net/test16/cut_polygon.gmt /home/zez/test_deep_learning/u_net/test16/in_polygon_calving_front/smooth
# python draw_loss.py --logfile train_loss.txt --imagefile loss.png
#python evaluate_test_error.py --logfile test_loss.txt
#bash preparing_traindata.sh
#bash preparing_inference.sh

#nohup bash exe_train.sh > log.txt &

#bash exe_test.sh  >log_test.txt
