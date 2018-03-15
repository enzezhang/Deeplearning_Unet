import argparse
import matplotlib.pyplot as plt


parser=argparse.ArgumentParser()
parser.add_argument('--logfile', type=str, help='absolute path of logfile')


parser.add_argument('--imagefile', type=str, help='absolute path of image file')
args = parser.parse_args()


def read(log):
    with open(log, 'r') as f:
        data = f.readlines()
        epoch=[]
        loss=[]
        for line in data:
            line = line.strip('\n')
            [a,b,c,d,e]=line.split(" ")
            if (a=='epoch:'):
                epoch.append(float(b.strip(',')))
                loss.append(float(e))


    return epoch,loss


def main(log,image):
    [epoch,loss]=read(log)
    print (len(epoch))
    #print(epoch[0])
    plt.figure()
    plt.plot(epoch, loss)
    plt.savefig(image)
    plt.show()






if (__name__ == '__main__'):

    main(args.logfile,args.imagefile)