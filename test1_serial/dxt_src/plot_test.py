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
    
out_path="res/"+TEST+"/membench-timeline.out"
res_path="res/"+TEST+"/membench-timeline.err"

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
time_line=np.arange(0, int(max_time+2), 0.5)
bandwith_list=[]
id_mem_bandwidth=12
id_l3_cache=8
for line in f:
    arr=line.split(" ")
    if( RepresentsInt(arr[0])):
        if(TEST=="MEM"):
            bandwith_list=  append(bandwith_list,float(arr[id_mem_bandwidth]))
        elif (TEST=="L3"):
            bandwith_list=  append(bandwith_list,float(arr[id_l3_cache]))
        
f.close()


# print(time_line)
bandwith_list = np.append(bandwith_list,np.zeros(len(time_line)-len(bandwith_list)))
print(len(time_line))
print(len(bandwith_list))
plt.ylabel(TEST+" bandwidth [MBytes/s]")
plt.xlabel("Time")
# plt.yscale('log')
plt.plot(time_line, bandwith_list, label="membench")

plt.legend()
plt.savefig('plot/plot_bandwith_'+TEST+'.png',dpi=600)
plt.show()
