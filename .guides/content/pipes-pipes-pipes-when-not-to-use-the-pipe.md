
The pipe is a powerful tool, but it's not the only tool at your disposal, and it doesn't solve every problem! Pipes are most useful for rewriting a fairly short linear sequence of operations. I think you should reach for another tool when:

* Your pipes are longer than (say) ten steps. In that case, create 
  intermediate objects with meaningful names. That will make debugging easier,
  because you can more easily check the intermediate results, and it makes
  it easier to understand your code, because the variable names can help 
  communicate intent.
  
* You have multiple inputs or outputs. If there isn't one primary object
  being transformed, but two or more objects being combined together,
  don't use the pipe.

* You are starting to think about a directed graph with a complex
  dependency structure. Pipes are fundamentally linear and expressing 
  complex relationships with them will typically yield confusing code.
