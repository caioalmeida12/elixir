defmodule SimProcess do
  @moduledoc """
  Defines a simulation process structure and its string representation.
  """

  @typedoc """
  Represents a simulation process with various attributes.
  """
  @type t :: %__MODULE__{
          process_id: integer() | nil,
          cpu_cycles: integer() | nil,
          priority: integer() | nil,
          arrival: integer() | nil,
          ran_for: integer() | nil
        }

  defstruct process_id: nil, cpu_cycles: nil, priority: nil, arrival: nil, ran_for: nil

  @doc """
  Returns a string representation of the SimProcess struct.
  """
  defimpl String.Chars, for: SimProcess do
    def to_string(process) do
      "Process ID: #{process.process_id}, " <>
        "CPU Cycles: #{process.cpu_cycles}, " <>
        "Priority: #{process.priority}, " <>
        "Arrival: #{process.arrival}, " <>
        "Ran For: #{process.ran_for}"
    end
  end
end

defmodule SimCPU do
  @moduledoc """
  Defines a simulation CPU structure and its string representation.
  """

  @typedoc """
  Represents a simulation CPU with an ID and an optional allocation to a process.
  """
  @type t :: %__MODULE__{
          cpu_id: integer() | nil,
          allocated_to: integer() | nil
        }

  defstruct cpu_id: nil, allocated_to: nil

  @doc """
  Checks if a CPU is available (not allocated to any process).
  """
  @spec available?(t) :: boolean()
  def available?(cpu), do: cpu.allocated_to == nil

  @doc """
  Returns a string representation of the SimCPU struct.
  """
  defimpl String.Chars, for: SimCPU do
    def to_string(cpu) do
      "CPU ID: #{cpu.cpu_id}, " <>
        "Allocated to: #{if(cpu.allocated_to, do: cpu.allocated_to, else: "None")}"
    end
  end
end

defmodule ProcessAllocationSimulator do
  @moduledoc """
  Simulates process allocation to CPUs using a first-come, first-served strategy.
  """

  @amount_of_processes 10
  @amount_of_cpus 2

  @doc """
  Generates a list of simulation processes with random attributes.
  """
  @spec generate_processes() :: [SimProcess.t()]
  def generate_processes do
    1..@amount_of_processes
    |> Enum.map(fn _ ->
      %SimProcess{
        process_id: :rand.uniform(1000) |> round,
        cpu_cycles: :rand.uniform(10) |> round,
        priority: :rand.uniform(10) |> round,
        arrival: :rand.uniform(1000) |> round,
        ran_for: 0
      }
    end)
  end

  @doc """
  Generates a list of simulation CPUs.
  """
  @spec generate_cpus() :: [SimCPU.t()]
  def generate_cpus do
    1..@amount_of_cpus
    |> Enum.map(fn _ ->
      %SimCPU{
        cpu_id: :rand.uniform(1000) |> round,
        allocated_to: nil
      }
    end)
  end

  @doc false
  defp first_come_first_served(processes, _cpus) do
    Enum.sort_by(processes, &(&1.arrival))
  end

  @doc """
  Allocates processes to CPUs based on a first-come, first-served strategy.
  """
  @spec allocate_processes([SimProcess.t()], [SimCPU.t()]) :: [SimCPU.t()]
  def allocate_processes(processes, cpus) do
    processes = first_come_first_served(processes, cpus)

    Enum.reduce(processes, cpus, fn process, cpus ->
      available_cpu = Enum.find(cpus, &SimCPU.available?/1)

      if available_cpu do
        updated_cpu = %{available_cpu | allocated_to: process.process_id}

        List.replace_at(
          cpus,
          Enum.find_index(cpus, fn cpu -> cpu.cpu_id == available_cpu.cpu_id end),
          updated_cpu
        )
      else
        cpus
      end
    end)
  end
end

# Example usage
processes = ProcessAllocationSimulator.generate_processes()
cpus = ProcessAllocationSimulator.generate_cpus()
allocated_cpus = ProcessAllocationSimulator.allocate_processes(processes, cpus)
IO.inspect(allocated_cpus)
