
> "There are no routine statistical questions, only questionable statistical
> routines." --- Sir David Cox

> "Far better an approximate answer to the right question, which is often
> vague, than an exact answer to the wrong question, which can always be made
> precise." --- John Tukey

Your goal during EDA is to develop an understanding of your data. The easiest way to do this is to use questions as tools to guide your investigation. When you ask a question, the question focuses your attention on a specific part of your dataset and helps you decide which graphs, models, or transformations to make.

EDA is fundamentally a creative process. And like most creative processes, the key to asking _quality_ questions is to generate a large _quantity_ of questions. It is difficult to ask revealing questions at the start of your analysis because you do not know what insights are contained in your dataset. On the other hand, each new question that you ask will expose you to a new aspect of your data and increase your chance of making a discovery. You can quickly drill down into the most interesting parts of your data---and develop a set of thought-provoking questions---if you follow up each question with a new question based on what you find.

There is no rule about which questions you should ask to guide your research. However, two types of questions will always be useful for making discoveries within your data. You can loosely word these questions as:

1. What type of variation occurs within my variables?

1. What type of covariation occurs between my variables?

The rest of this chapter will look at these two questions. I'll explain what variation and covariation are, and I'll show you several ways to answer each question. To make the discussion easier, let's define some terms: 

*   A __variable__ is a quantity, quality, or property that you can measure. 

*   A __value__ is the state of a variable when you measure it. The value of a
    variable may change from measurement to measurement.
  
*   An __observation__ is a set of measurements made under similar conditions
    (you usually make all of the measurements in an observation at the same 
    time and on the same object). An observation will contain several values, 
    each associated with a different variable. I'll sometimes refer to 
    an observation as a data point.

*   __Tabular data__ is a set of values, each associated with a variable and an
    observation. Tabular data is _tidy_ if each value is placed in its own
    "cell", each variable in its own column, and each observation in its own 
    row. 

So far, all of the data that you've seen has been tidy. In real-life, most data isn't tidy, so we'll come back to these ideas again in [tidy data].
