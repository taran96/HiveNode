defmodule Hive.Job do
  @moduledoc """
  This module is to encapsulate jobs. These functions are not meant to be run
  directly, even though they are full capable of it. They are merely helper 
  functions for handling jobs.
  """


  require Logger


  @doc """
  The `%Hive.Job{}` struct is to hold jobs with a user defined name
  """
  defstruct( 
    name: "Hello_World",
    job_name: "echo",
    args: ["Hello", "World"],
  )


  @doc """
  This function basically runs the given job from a `%Hive.Job{}` format. It
  extracts the needed information and calls `Hive.Job.run/2`
  """
  def run(%Hive.Job{name: _, job_name: job_name, args: args}) do
    run(job_name, args)
  end


  @doc """
  This function runs the given job. First it finds the function within 
  `Hive.JobList` then it executes it. It returns the status and the return 
  value.
  """
  def run(job_name, args \\ []) do
    case get_func(Hive.JobList.__info__(:functions), job_name) do
      {:found, func} -> {:ok, apply(Hive.JobList, func, args)}
      :not_found -> {:error, :not_found}
    end
  end


  @doc """
  This function validate the job. Basically it checks if the job exists
  """
  def is_valid(job_name) do
    functions = Hive.JobList.__info__(:functions)
    case get_func(functions, job_name) do
      {:found, _func} -> true
      :not_found -> false
    end
  end


  defp get_func([{func, _arity} | tail], func_name) do
    if Atom.to_string(func) == func_name do
      {:found, func }
    else
      get_func(tail, func_name)
    end
  end


  defp get_func([], _func_name) do
    :not_found
  end

  @doc """
  This functions converts a `%Hive.Job{}` to a JSON string
  """
  def to_json(%Hive.Job{} = job) do
    case Poison.encode(job) do
      {:ok, json} -> json
      _ -> :error
    end
  end


  @doc """
  This function converts a JSON string to `%Hive.Job{}`
  """
  def from_json(json_string) when is_bitstring(json_string) do
    case Poison.decode(json_string, as: %Hive.Job{}) do
      {:ok, job} -> job
      {:error, _} -> :error
    end
  end


end
