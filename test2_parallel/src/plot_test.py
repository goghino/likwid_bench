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

def get_data_timeline(out_path,err_path):

    f = open(out_path, "r")
    max_time=0
    for line in f:
        arr=line.split(" ")
        # print(arr)
        if("Size:" in arr[0]):
            if(RepresentsFloat(arr[11].replace(',','')) == True):
                max_time=float(arr[11].replace(',',''))
            else:
                max_time=float(arr[9].replace(',',''))
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
    print(count)
    print(bandwith_list)
    return time_line,bandwith_list


print("Time serial run")
time_line_serial, bandwith_list_serial = get_data_timeline("../../test1/src/res/membench-timeline.out","../../test1/src/res/membench-timeline.err")
print("Time parallel run1")
time_line_parallel1, bandwith_list_parallel1 = get_data_timeline("res/out/slurm-1214488_0.out","res/err/slurm-1214488_0.err")
# print("Time parallel run2")
# time_line_parallel2, bandwith_list_parallel2 = get_data_timeline("task_res/test_parallel.out","task_res/test_parallel.err")

expand_serial=np.append(bandwith_list_serial,np.zeros(len(time_line_parallel1)-len(bandwith_list_serial)) ) 
expand_parallel1=np.append(bandwith_list_parallel1,np.zeros(len(time_line_parallel1)-len(bandwith_list_parallel1)) ) 
# expand_parallel2=np.append(bandwith_list_parallel2,np.zeros(len(time_line_parallel2)-len(bandwith_list_parallel2)) ) 
# print(len(expand_serial))
# print(len(expand_parallel))
# print(len(time_line_parallel))
plt.ylabel("L3 load bandwidth [MBytes/s]")
plt.xlabel("Time")
# plt.yscale('log')
plt.plot(time_line_parallel1, expand_serial, label="membench-serial")
plt.plot(time_line_parallel1, expand_parallel1, label="membench-3-run-paralle")
# plt.plot(time_line_parallel2, expand_parallel2, label="membench-10-run-paralle")
plt.xticks(np.arange(min(time_line_parallel1), max(time_line_parallel1)+1, 3))
plt.legend()
plt.savefig('plot/plot_bandwith.png',dpi=600)
plt.show()
