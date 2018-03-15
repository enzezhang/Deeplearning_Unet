import torch.utils.data as data
import torch

from scipy.ndimage import imread
import os
import os.path
import glob

import numpy as np

from torchvision import transforms

# def make_dataset(root, train=True):
#
#   dataset = []
#
#   if train:
#     dir = os.path.join(root, 'train')
#
#     for fGT in glob.glob(os.path.join(dir, '*_mask.tif')):
#       fName = os.path.basename(fGT)
#       fImg = fName[:-9] + '.tif'
#
#       dataset.append( [os.path.join(dir, fImg), os.path.join(dir, fName)] )
#
#   return dataset

def make_dataset(root, train=True):

  dataset = []

  if train:
    label_dir = os.path.join(root, 'split_labels')
    image_dir = os.path.join(root, 'split_images')

    for fGT in glob.glob(os.path.join(label_dir, '*.tif')):
      fName = os.path.basename(fGT)
      name_str = fName.split('_')
      flag_name = '_'+ name_str[len(name_str)-3]+'_'+ name_str[len(name_str)-2] + '_'+name_str[len(name_str)-1]

      fImg = glob.glob(os.path.join(image_dir, "*"+flag_name))
      if len(fImg) != 1:
        assert False
        print("Get the image name failed")
      fImg = fImg[0]

      dataset.append( [fImg, fGT] )
  else:
    image_dir = os.path.join(root, 'inf_split_images')
    dataset = glob.glob(os.path.join(image_dir, '*.tif'))
#    for img in glob.glob(os.path.join(image_dir, '*.tif')):
#      dataset.append([img])

  return dataset


def getImg_count(dir):
  files = glob.glob(os.path.join(dir, '*.tif'))
  return len(files)

class kaggle2016nerve(data.Dataset):
  """
  Read dataset of kaggle ultrasound nerve segmentation dataset
  https://www.kaggle.com/c/ultrasound-nerve-segmentation
  """

  def __init__(self, root, transform=None, train=True):
    self.train = train
    self.root = root

    # we cropped the image
    self.nRow = 480
    self.nCol = 480

    if self.train:
      self.train_set_path = make_dataset(root, train)
    else:
      self.train_set_path = make_dataset(root, train)

  def __getitem__(self, idx):
    if self.train:
      img_path, gt_path = self.train_set_path[idx]

      img = imread(img_path)
      #img.resize(self.nRow,self.nCol)
      img = img[0:self.nRow, 0:self.nCol]
      img = np.atleast_3d(img).transpose(2, 0, 1).astype(np.float32)
      if (img.max() - img.min()) < 0.01:
        pass
      else:
        img = (img - img.min()) / (img.max() - img.min())
      img = torch.from_numpy(img).float()

      gt = imread(gt_path)[0:self.nRow, 0:self.nCol]
      gt = np.atleast_3d(gt).transpose(2, 0, 1)
      #gt = gt / 255.0   # we don't need to scale
      gt = torch.from_numpy(gt).float()

      return img, gt
    else:
      img_path = self.train_set_path[idx]
      img_name_noext = os.path.splitext(os.path.basename(img_path))[0]
      img = imread(img_path)
      # img.resize(self.nRow,self.nCol)
      img = img[0:self.nRow, 0:self.nCol]
      img = np.atleast_3d(img).transpose(2, 0, 1).astype(np.float32)
      if (img.max() - img.min()) < 0.01:
        pass
      else:
        img = (img - img.min()) / (img.max() - img.min())
      img = torch.from_numpy(img).float()
      return img,img_name_noext


  def __len__(self):
    if self.train:
      # train image count
      label_dir = os.path.join(self.root, 'split_labels')
      count = getImg_count(label_dir)
      print("Image count for training is %d"%count)
      return count
      # return 5635
      # test image count
    else:
      label_dir = os.path.join(self.root, 'inf_split_images')
      count = getImg_count(label_dir)
      print("Image count for inference is %d"%count)
      return count
      # return 5508   # test image count