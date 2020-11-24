from matplotlib import pyplot as plt
import numpy as np
import sys

from numpy.lib.function_base import append

# TEST="MEM"
TEST="L3"
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
            print(arr)
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
        print(line)
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
time_line_serial, bandwith_list_serial = get_data_timeline("../../test1_serial/ics_src/res/membench-timeline.out","../../test1_serial/ics_src/res/membench-timeline.err")
print("Time parallel run1")
time_line_parallel1, bandwith_list_parallel1 = get_data_timeline("res/"+TEST+"/out/slurm-1216045_0.out","res/"+TEST+"/err/slurm-1216045_0.err")
print("Time parallel run2")
time_line_parallel2, bandwith_list_parallel2 = get_data_timeline("task_res/"+TEST+"/test_parallel.out","task_res/"+TEST+"/test_parallel.err")

expand_serial=np.append(bandwith_list_serial,np.zeros(len(time_line_parallel2)-len(bandwith_list_serial)) ) 
expand_parallel1=np.append(bandwith_list_parallel1,np.zeros(len(time_line_parallel2)-len(bandwith_list_parallel1)) ) 
expand_parallel2=np.append(bandwith_list_parallel2,np.zeros(len(time_line_parallel2)-len(bandwith_list_parallel2)) ) 
# print(len(expand_serial))
# print(len(expand_parallel))
# print(len(time_line_parallel))
plt.ylabel(TEST+" access bandwidth [MBytes/s]")
plt.xlabel("Time")
# plt.yscale('log')
plt.plot(time_line_parallel2, expand_serial, label="membench-serial")
plt.plot(time_line_parallel2, expand_parallel1, label="membench-3-run-paralle")
plt.plot(time_line_parallel2, expand_parallel2, label="membench-10-run-paralle")
plt.xticks(np.arange(min(time_line_parallel2), max(time_line_parallel2)+1, 3))
plt.legend()
plt.savefig('plot/plot_bandwith_'+TEST+'.png',dpi=600)
plt.show()
