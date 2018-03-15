import argparse
import matplotlib.pyplot as plt


parser=argparse.ArgumentParser()
parser.add_argument('--logfile', type=str, help='absolute path of logfile')


args = parser.parse_args()

def read(log):
    with open(log, 'r') as f:
        data = f.readlines()
        date=[]
        loss=[]
        count=[]
        loss_temp=0
        count_temp=1
        for line in data:
            line = line.strip('\n')
            [a,b,c,d]=line.split(" ")
            num=b[10]
            if num == "0":
                date_old=b[0:8]
            date_new=b[0:8]
            if date_new==date_old:
                loss_temp=loss_temp+float(d)
                count_temp=count_temp+1
            else:
                loss_final=loss_temp
                count_final=count_temp
                date.append(date_old)
                loss.append(loss_final)
                count.append(count_final)
                date_old=date_new
                count_temp=1
                loss_temp=0
        date.append(date_old)
        loss.append(loss_temp)
        count.append(count_temp)
    return date,loss




def main(log):

    [date,loss]=read(log)

    for i in range(0,len(date)):

        print ('the loss of {} is {}'.format(date[i],loss[i]))

    plt.figure()
    plt.plot(loss)
    plt.savefig('test_error.png')
    plt.show()










if (__name__ == '__main__'):

    main(args.logfile)