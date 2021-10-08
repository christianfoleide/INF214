import :timer;

defmodule Parallel do
      def map(collection, func) do 
            parent = self();
            procs = Enum.map(collection,
                  fn(elem) -> 
                        spawn_link(
                              fn() -> 
                                    send(parent, {self(), func . (elem)});
                              end
                        )
                  end
            )
      Enum.map(procs,
            fn(pid) -> 
                  receive do
                        {^pid, result} -> result;
                  end
            end
      )
      end
end

slow_double = fn(x) -> sleep(1000); x*2 end

slow_result = :timer.tc(
      fn() ->
            Enum.map( [1,2,3,4], slow_double ); 
      end
)

parallel_result = :timer.tc(
      fn() ->
            Parallel.map( [1,2,3,4], slow_double );
      end
)

IO.inspect slow_result
IO.inspect parallel_result