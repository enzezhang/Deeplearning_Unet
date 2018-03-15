import argparse

import numpy as np
parser = argparse.ArgumentParser()
parser.add_argument('--input', help='input gmt file')

parser.add_argument('--output', help='ouput gmt file')


args = parser.parse_args()
print(args)
input_data=np.loadtxt(args.input)

output_data=input_data[0:len(input_data)/2,:]
np.savetxt(args.output,output_data,delimiter=' ',fmt='%10.13f')


# a=np.random.rand(3,2)
# print(a[1:2])
# print('haha')
# b=a[::-1]
# print(b)
# for i in range(100):
#     print('test data')
#     print(i)
#     print(input_data[i,:])
#     print(input_data[len(input_data)-i-1,:])
