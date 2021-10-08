import :timer, only: [ sleep: 1 ]

defmodule Counter do

      def start(count) do
            spawn(__MODULE__, :loop, [count])
      end

      def next(counter) do
            ref = make_ref()
            send(counter, {:increase, self(), ref})
            receive do
                  {:ok, ^ref, count} -> count
            end
      end

      def loop(count) do
            receive do
                  {:increase, sender, ref} ->
                        send(sender, {:ok, ref, count})
                        IO.puts("Current count is #{count}")
                        loop(count + 1)
            end
      end
end

counter = Counter.start(1)
Counter.next(counter)
Counter.next(counter)
Counter.next(counter)
sleep(1000)