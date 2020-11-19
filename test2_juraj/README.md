Memory sub-system components contribute significantly to the performance characteristics of an application. As an increasing number of threads or processes share the limited resources of cache capacity and memory bandwidth, the scalability of a threaded application can become constrained. Memory-intensive threaded applications can suffer from memory bandwidth saturation as more threads are introduced. In such cases, the threaded application woun't scale as expected, and performance can be reduced. 

# Running multiple processes
This benchmark suite demonstrates this phenomenon. `test_proc.sh` incrementally launches more processes (single core) running on the same compute node until it is fully occupied. In the output logs we can observe that the sustained memory bandwidth decreases as the number of processes increases. This however applies only for a single socket.

![Multiprocess run](https://github.com/goghino/likwid_bench/edit/master/test2_juraj/results/results_proc.png)

# Running multithreaded process

![Multiprocess run](https://github.com/goghino/likwid_bench/edit/master/test2_juraj/results/results_thread.png)
