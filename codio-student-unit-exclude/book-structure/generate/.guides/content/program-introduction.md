
In this part of the book, you'll improve your programming skills. Programming is a cross-cutting skill needed for all data science work: you must use a computer to do data science; you cannot do it in your head, or with pencil and paper. 


![Figure 21.1](diagrams/data-science-program.png)

**Figure 21.1**

Programming produces code, and code is a tool of communication. Obviously code tells the computer what you want it to do. But it also communicates meaning to other humans. Thinking about code as a vehicle for communication is important because every project you do is fundamentally collaborative. Even if you're not working with other people, you'll definitely be working with future-you! Writing clear code is important so that others (like future-you) can understand why you tackled an analysis in the way you did. That means getting better at programming also involves getting better at communicating. Over time, you want your code to become not just easier to write, but easier for others to read. 

Writing code is similar in many ways to writing prose. One parallel which I find particularly useful is that in both cases rewriting is the key to clarity. The first expression of your ideas is unlikely to be particularly clear, and you may need to rewrite multiple times. After solving a data analysis challenge, it's often worth looking at your code and thinking about whether or not it's obvious what you've done. If you spend a little time rewriting your code while the ideas are fresh, you can save a lot of time later trying to recreate what your code did. But this doesn't mean you should rewrite every function: you need to balance what you need to achieve now with saving time in the long run. (But the more you rewrite your functions the more likely your first attempt will be clear.)

In the following four chapters, you'll learn skills that will allow you to both tackle new programs and to solve existing problems with greater clarity and ease: 

1.  In [pipes], you will dive deep into the __pipe__, `%>%`, and learn more 
    about how it works, what the alternatives are, and when not to use it.

1.  Copy-and-paste is a powerful tool, but you should avoid doing it more than
    twice. Repeating yourself in code is dangerous because it can easily lead 
    to errors and inconsistencies. Instead, in [functions], you'll learn
    how to write __functions__ which let you extract out repeated code so that 
    it can be easily reused.

1.  As you start to write more powerful functions, you'll need a solid
    grounding in R's __data structures__, provided by [vectors]. You must master 
    the four common atomic vectors, the three important S3 classes built on 
    top of them, and understand the mysteries of the list and data frame. 

1.  Functions extract out repeated code, but you often need to repeat the
    same actions on different inputs. You need tools for __iteration__ that
    let you do similar things again and again. These tools include for loops 
    and functional programming, which you'll learn about in [iteration].
