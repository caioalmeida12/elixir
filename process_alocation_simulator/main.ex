defmodule SimProcess do
  defstruct process_id: nil, cpu_cycles: nil, priority: nil, arrival: nil, ran_for: nil

  defimpl String.Chars, for: SimProcess do
    def to_string(process) do
      "Process ID: #{process.process_id}, " <>
        "CPU Cycles: #{process.cpu_cycles}, " <>
        "Priority: #{process.priority}"
    end
  end
end

defmodule ProcessAlocationSimulator do
  @amount_of_processes 10
  @amount_of_cpus 2

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

  defp first_come_first_served(processes, @amount_of_cpus) do
    processes
    |> Enum.sort(fn a, b -> Map.get(a, :arrival) < Map.get(b, :arrival) end)
  end

  def allocate_processes do
    allocate_processes(generate_processes(), @amount_of_cpus)
  end

  def allocate_processes(processes, cpus) do
    first_come_first_served(processes, cpus)

    available_cpus = 0..cpus

    case is_integer(available_cpus |> Enum.at(0)) do
      true -> available_cpus |> Enum.drop() |> IO.puts()
      false -> nil
    end
  end
end

ProcessAlocationSimulator.allocate_processes() |> IO.inspect()
