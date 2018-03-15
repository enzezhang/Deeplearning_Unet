from datasetRS import *
from model import Net

import argparse
import torch.optim as optim
import torch.nn.functional as F
import torch.nn as nn
import torch.tensor
import torch.backends.cudnn as cudnn
from torch.autograd import Variable

from PIL import Image

import parameters
import datasetRS_Jan22

from torch.autograd import Variable

#THIS TEST.PY CALCULATE THE TEST ERROR


parser = argparse.ArgumentParser()
parser.add_argument('dataroot', help='path to test dataset ')
parser.add_argument('para', help='path to the parameter file')
parser.add_argument('list', help='path to the list file')

# parser.add_argument('dataroot', default='data', help='path to dataset')
parser.add_argument('--workers', type=int, help='number of data loading workers', default=1)
parser.add_argument('--batchSize', type=int, default=1, help='input batch size')

parser.add_argument('--cuda', action='store_true', help='enables cuda')
parser.add_argument('--resume', default='', type=str, metavar='PATH', help='path to latest checkpoint (default: none)')
parser.add_argument('--useBN', action='store_true', help='enalbes batch normalization')

args = parser.parse_args()
print(args)

parameters.set_saved_parafile_path(args.para)
patch_w = parameters.get_digit_parameters("", "inf_patch_width", None, 'int')
patch_h = parameters.get_digit_parameters("", "inf_patch_height", None, 'int')
overlay_x = parameters.get_digit_parameters("", "inf_pixel_overlay_x", None, 'int')
overlay_y = parameters.get_digit_parameters("", "inf_pixel_overlay_y", None, 'int')

crop_height=parameters.get_digit_parameters("","crop_height_test",None,'int')
crop_width=parameters.get_digit_parameters("","crop_width_test",None,'int')

dataset = RemoteSensingImg(args.dataroot, args.list, patch_w, patch_h, overlay_x,overlay_y, train=False)
train_loader = torch.utils.data.DataLoader(dataset, batch_size=args.batchSize,
                                           num_workers=args.workers, shuffle=False)

model = Net(args.useBN)

if args.cuda:
    model.cuda()
    cudnn.benchmark = True

if args.resume:
    if os.path.isfile(args.resume):
        print("=> loading checkpoint '{}'".format(args.resume))

        if args.cuda == False:
            checkpoint = torch.load(args.resume, map_location={'cuda:0': 'cpu'})
        else:
            checkpoint = torch.load(args.resume)

        args.start_epoch = checkpoint['epoch']

        model.load_state_dict(checkpoint['state_dict'])
        print("=> loaded checkpoint (epoch {}, loss {})"
              .format(checkpoint['epoch'], checkpoint['loss']))
    else:
        print("=> no checkpoint found at '{}'".format(args.resume))
        assert False
else:
    print("Please input the check point files")


def showImg(img, binary=True, fName=''):
    """
    show image from given numpy image
    """
    img = img[0, 0, :, :]

    if binary:
        img = img > 0.5

    img = Image.fromarray(np.uint8(img * 255), mode='L')

    if fName:
        img.save('assets/' + fName + '.png')
    else:
        img.show()


def saveImg(img, patch_info, binary=True, fName=''):
    """
    show image from given numpy image
    """
    img = img[0, 0, :, :]

    if binary:
        img = img > 0.5

    # img = Image.fromarray(np.uint8(img*255), mode='L')
    img = (img * 255).astype(rasterio.uint8)
    org_img_path = patch_info[0][0]
    boundary = patch_info[1]
    boundary = [item[0] for item in boundary]
    xsize = boundary[2]
    ysize = boundary[3]

    window = ((boundary[1], boundary[1] + ysize), (boundary[0], boundary[0] + xsize))

    if fName:
        # img.save('inf_result/'+fName+'.png')
        with rasterio.open(org_img_path) as org:
            profile = org.profile
            new_transform = org.window_transform(window)
        # calculate new transform and update profile (transform, width, height)

        profile.update(dtype=rasterio.uint8, count=1, transform=new_transform, width=xsize, height=ysize)
        # set the block size    , it should be a multiple of 16 (TileLength must be a multiple of 16)
        if profile.has_key('blockxsize') and profile['blockxsize'] > xsize :
            if xsize%16==0:
                profile.update(blockxsize=xsize)
            else:
                profile.update(blockxsize=16)  #  profile.update(blockxsize=16)
        if profile.has_key('blockysize') and profile['blockysize'] > ysize :
            if ysize%16==0:
                profile.update(blockysize=ysize)
            else:
                profile.update(blockysize=16) #  profile.update(blockxsize=16)

        #print(profile['blockxsize'],profile['blockysize'],'xsize:%d ysize:%d'%(xsize,ysize))

        with rasterio.open('test_output/' + fName + '.tif', "w", **profile) as dst:
            dst.write(img, 1)

    else:
        img.show()


model.eval()
train_loader.batch_size = args.batchSize

patch_number = len(train_loader)
loss_fn = nn.MSELoss()
if args.cuda:
    loss_fn = loss_fn.cuda()
for i, (x,y, patch_info) in enumerate(train_loader):
    # print(img_name[0])
    org_img = patch_info[0][0]
    file_name = os.path.splitext(os.path.basename(org_img))[0] + '_' + str(i)
    print("inferece (%.1f%%,%d/%d): %s " % (float(i+1)*100/patch_number,(i+1),patch_number,file_name))

    b_crop = False
    x_shape = x.size()
    if x_shape[2] < crop_height or x_shape[3] < crop_width:
        b_crop = True
        x_expand = torch.zeros(x_shape[0],x_shape[1],crop_height,crop_width)
        x_expand[:,:,:x_shape[2],:x_shape[3]] = x
        y_pred = model(Variable(x_expand.cuda()))
    else:
        # get output
        y_pred = model(Variable(x.cuda()))

    if b_crop is True:
        x = x_expand[:,:,:x_shape[2],:x_shape[3]]
        y_pred = y_pred[:,:,:x_shape[2],:x_shape[3]]

    y_true = Variable(y).cuda()
    # max = np.amax(y_true.cpu().data.numpy())
    # min=np.amin(y_true.cpu().data.numpy())

    saveImg(y_pred.cpu().data.numpy(), patch_info, binary=True, fName=file_name + '_pred')

    # if max==min:
    #     continue
    # else:
    loss = loss_fn(y_pred, y_true)
    out_message='filename: {}, loss: {}'.format(file_name, loss.data[0])
    print(out_message)
    with open("test_loss.txt", 'a') as log:
        log.writelines(out_message + '\n')

    # save original images for checking
    #saveImg(x.numpy(), patch_info, binary=False, fName=file_name)
    # showImg(x.numpy(),binary=False, fName=file_name)
    # showImg(y_pred.cpu().data.numpy(), binary=True, fName=file_name+'_pred')
