from matplotlib import pyplot as plt
import numpy as np
from os import listdir
from os.path import isfile, join
import sys

from numpy.lib.function_base import append

mypath_out="res/out/"
mypath_err="res/err/"
out_files = [f for f in listdir(mypath_out) if isfile(join(mypath_out, f))]
err_files = [f for f in listdir(mypath_err) if isfile(join(mypath_err, f))]

out_files.sort()
err_files.sort()

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

def get_data_timeline(out_path,err_path):

    f = open(out_path, "r")
    max_time=0
    for line in f:
        arr=line.split(",")
        if("Size:" in arr[0]):
            # print(arr)
            if(RepresentsFloat(arr[3].replace('sec=','')) == True):
                max_time=float(arr[3].replace('sec=',''))
            break

    f.close()

    print(max_time)

    f = open(err_path, "r")
    time_line=np.arange(0, int(max_time)+2, 0.5)
    bandwith_list=[]
    count=len(time_line)
    for line in f:
        arr=line.split(" ")
        if( RepresentsInt(arr[0]) and count!=0):
            bandwith_list=  append(bandwith_list,float(arr[8]))
            count-=1
        if(count==0):
            break


    f.close()
    print(bandwith_list)
    return time_line,bandwith_list


print("Time serial run")
time_line_serial, bandwith_list_serial = get_data_timeline("../../test1_serial/ics_src/res/membench-timeline.out","../../test1_serial/ics_src/res/membench-timeline.err")

print("Time parallel run")
time_line_parallel=[]
bandwith_list_parallel=[]
for i in range(0,len(out_files)):
    print(out_files[i])
    # print(err_files[i])
    time_line_parallel0, bandwith_list_parallel0 = get_data_timeline(mypath_out+out_files[i],mypath_err+err_files[i])
    time_line_parallel.append(time_line_parallel0)
    bandwith_list_parallel.append(bandwith_list_parallel0)
    
# print(time_line_parallel)
max_len_timeline=0
max_timeline=[]
for time_line in time_line_parallel:
      if(len(time_line) >max_len_timeline):
          max_len_timeline=len(time_line)
          max_timeline=time_line


expand_serial=np.append(bandwith_list_serial,np.zeros(max_len_timeline-len(bandwith_list_serial)) ) 
print(max_len_timeline)
expand_parallel=[]
for bandwith in  bandwith_list_parallel:
    expand_parallel.append(np.append( bandwith ,np.zeros(max_len_timeline-len(bandwith)) )) 

plt.ylabel("L3 load bandwidth [MBytes/s]")
plt.xlabel("Time")
# plt.yscale('log')

plt.plot(max_timeline, expand_serial, label="Serial- S0:Core0")
for i in range(0,len(expand_parallel)):
    print(len(expand_parallel[i]))
    plt.plot(max_timeline, expand_parallel[i], label="S0:Core"+str(i))
# plt.plot(time_line_parallel2, expand_parallel2, label="membench-10-run-paralle")
plt.xticks(np.arange(min(max_timeline), max(max_timeline)+1, 3))
plt.legend()
plt.savefig('plot/plot_bandwith.png',dpi=600)
plt.show()
