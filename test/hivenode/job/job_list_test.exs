defmodule HiveNodeTest.JobListTest do
  use ExUnit.Case

  test "echo test" do
    assert {:ok, "Hello World"} == HiveNode.JobList.echo("Hello", "World")
  end

  @tag :serial_device_required
  test "write to TTY" do
    tty = case Nerves.UART.enumerate |> Map.to_list do
      [{tty, _} | _tail ] -> tty
      [] -> assert false, "There are no TTY devices to test with"
    end
    assert :ok == HiveNode.JobList.write_to_tty(tty, "Hello")
  end

  test "write to non existing TTY" do
    assert {:error, :enoent} == HiveNode.JobList.write_to_tty("Doesnotexist", "Hello")
  end

  test "write to non device but existing TTY" do
    assert {:error, :einval} == HiveNode.JobList.write_to_tty("/dev/tty", "hello")
  end

end
