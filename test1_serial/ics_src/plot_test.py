from matplotlib import pyplot as plt
import numpy as np
import sys

from numpy.lib.function_base import append

def RepresentsInt(s):
    try: 
        int(s)
        return True
    except ValueError:
        return False

def RepresentsFloat(s):
    try: 
        float(s)
        return True
    except ValueError:
        return False
out_path="res/membench-timeline.out"
res_path="res/membench-timeline.err"

f = open(out_path, "r")
max_time=0
for line in f:
    arr=line.split(",")
    if("Size:" in arr[0]):
        if(RepresentsFloat(arr[3].replace('sec=','')) == True):
            max_time=float(arr[3].replace('sec=',''))
        break

f.close()

print(max_time)


f = open(res_path, "r")
time_line=np.arange(0, int(max_time+1), 0.5)
bandwith_list=[]

for line in f:
    arr=line.split(" ")
    if( RepresentsInt(arr[0])):
        bandwith_list=  append(bandwith_list,float(arr[8]))
        
f.close()
print(time_line)
print(bandwith_list)


plt.ylabel("L3 load bandwidth [MBytes/s]")
plt.xlabel("Time")
# plt.yscale('log')
plt.plot(time_line, bandwith_list, label="membench")

plt.legend()
plt.savefig('plot/plot_bandwith.png')
plt.show()
