from matplotlib import pyplot as plt
import numpy as np
import sys

from numpy.lib.function_base import append

TEST="MEM"
# TEST="L3"


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
        line=line.strip()
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
    id_mem_bandwidth=12
    id_l3_cache=8
    for line in f:
        arr=line.split(" ")
        if( RepresentsInt(arr[0]) and count!=0):
            if(TEST=="MEM"):
                bandwith_list=  append(bandwith_list,float(arr[id_mem_bandwidth]))
            elif (TEST=="L3"):
                bandwith_list=  append(bandwith_list,float(arr[id_l3_cache]))
            count-=1
        if(count==0):
            break


    f.close()
    # print(count)
    print(bandwith_list)
    return time_line,bandwith_list


print("Time serial run")
time_line_serial, bandwith_list_serial = get_data_timeline("../../test1_serial/dxt_src/res/"+TEST+"/membench-timeline.out","../../test1_serial/dxt_src/res/"+TEST+"/membench-timeline.err")
print("Time parallel run")
if(TEST=="MEM"):
    time_line_parallel1, bandwith_list_parallel1 = get_data_timeline("res/"+TEST+"/out/slurm-833100_0.out","res/"+TEST+"/err/slurm-833100_0.err")
else:
    time_line_parallel1, bandwith_list_parallel1 = get_data_timeline("res/"+TEST+"/out/slurm-833614_0.out","res/"+TEST+"/err/slurm-833614_0.err")
# print("Time parallel run2")
# time_line_parallel2, bandwith_list_parallel2 = get_data_timeline("task_res/test_parallel.out","task_res/test_parallel.err")

expand_serial=np.append(bandwith_list_serial,np.zeros(len(time_line_parallel1)-len(bandwith_list_serial)) ) 
expand_parallel1=np.append(bandwith_list_parallel1,np.zeros(len(time_line_parallel1)-len(bandwith_list_parallel1)) ) 
# expand_parallel2=np.append(bandwith_list_parallel2,np.zeros(len(time_line_parallel2)-len(bandwith_list_parallel2)) ) 
# print(len(expand_serial))
# print(len(expand_parallel))
# print(len(time_line_parallel))
plt.ylabel(TEST+" access bandwidth [MBytes/s]")
plt.xlabel("Time")
# plt.yscale('log')
plt.plot(time_line_parallel1, expand_serial, label="membench-serial S0:0")
plt.plot(time_line_parallel1, expand_parallel1, label="membench-10-run-parallel S0:0")
# plt.plot(time_line_parallel2, expand_parallel2, label="membench-10-run-paralle")
plt.xticks(np.arange(min(time_line_parallel1), max(time_line_parallel1)+1, 15))
plt.legend()
plt.savefig('plot/plot_bandwith_'+TEST+'.png',dpi=600)
plt.show()
