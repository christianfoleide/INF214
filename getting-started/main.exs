import :timer, only: [ sleep: 1 ]

defmodule Talker do
      def loopReceive do
            receive do
                  {:greet, name} ->
                        IO.puts("Talker is sleeping for 1 second...")
                        sleep(1000) 
                        IO.puts("Hello, #{name}!");
                  {:praise, name} -> 
                        IO.puts("You are great, #{name}!");
                  {:celebrate, name, newAge} -> 
                        IO.puts("Happy birthday, #{name}! You are now #{newAge} years old!");
                  {:shutdown} -> 
                        exit(:normal);
            end
            loopReceive()
      end
end

defmodule Sender do
      def loopSend(receiver, name) do
            send(receiver, {:greet, name});
            send(receiver, {:praise, name});
            send(receiver, {:celebrate, name, 26});
            sleep(1000);
            loopSend(receiver, name);
      end
end

Process.flag(:trap_exit, true)
recvpid = spawn_link(&Talker.loopReceive/0)
spawn(Sender, :loopSend, [recvpid, "Some guy"]);
sleep(5000)

send(recvpid, {:shutdown})

receive do
      {:EXIT, ^recvpid, reason} -> 
            IO.puts("Actor 'Talker' has exited with reason: #{reason}.");
end