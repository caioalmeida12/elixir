# Process Allocation Simulator Exercise Requirements

## Objective
Create an Elixir module that simulates the allocation of processes to a set of CPUs. This module should generate random processes, allocate them to CPUs based on a scheduling algorithm, and calculate statistics related to process allocation and CPU utilization.

## Requirements

### 1. Process Generation
- Generate random processes with attributes for process ID, required CPU cycles (to complete the process), and priority level.
- Each process should be a map with keys `:process_id`, `:cpu_cycles`, and `:priority`.
- Implement a function `generate_processes/0` that returns a list of processes, simulating a batch of processes that need to be allocated.

### 2. CPU Allocation
- Simulate a set of CPUs where processes can be allocated. Each CPU can handle one process at a time.
- Implement a function `allocate_processes/2` that takes the list of processes and the number of available CPUs, then allocates processes to CPUs based on a scheduling algorithm (e.g., Round Robin, First Come First Served, Shortest Job First).
- Log each allocation with the format `"Allocating Process ID: X to CPU Y"`.

### 3. Process Scheduling and Execution
- Simulate the execution of processes on each CPU.
- Implement a function `execute_processes/1` that takes the allocation map and simulates the execution of processes, logging the start and completion of each process.
- Upon completion of a process, the CPU becomes available for a new process.

### 4. Allocation and Utilization Statistics
- Calculate and log statistics related to process allocation and CPU utilization, such as average wait time for processes, average CPU idle time, and throughput (processes completed per time unit).
- Implement a function `calculate_statistics/1` that takes the allocation map and returns a map with keys `:avg_wait_time`, `:avg_cpu_idle_time`, and `:throughput`.

### 5. Simulate Process Allocation
- Implement a function `simulate_process_allocation/1` that integrates all components of the simulation, generating processes, allocating them to CPUs, executing them, and calculating and logging statistics.

## Bonus Challenges

### Dynamic Process Generation
- Instead of generating all processes at the start, dynamically generate processes at random intervals, simulating a real system where processes arrive continuously.

### Advanced Scheduling Algorithms
- Implement and compare the performance of different scheduling algorithms, such as Priority Scheduling, Multilevel Queue Scheduling, or Shortest Remaining Time First.

### Concurrency
- Use Elixir's concurrency features to simulate the parallel execution of processes on multiple CPUs in real-time.

### Visualization
- Create a simple visualization of the CPU allocation and process execution, possibly using a web interface or a terminal-based visualization.