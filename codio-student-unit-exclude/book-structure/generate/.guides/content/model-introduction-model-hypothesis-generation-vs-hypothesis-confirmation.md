
In this book, we are going to use models as a tool for exploration, completing the trifecta of the tools for EDA that were introduced in Part 1. This is not how models are usually taught, but as you will see, models are an important tool for exploration. Traditionally, the focus of modelling is on inference, or for confirming that an hypothesis is true. Doing this correctly is not complicated, but it is hard. There is a pair of ideas that you must understand in order to do inference correctly:

1. Each observation can either be used for exploration or confirmation, 
   not both.

1. You can use an observation as many times as you like for exploration,
   but you can only use it once for confirmation. As soon as you use an 
   observation twice, you've switched from confirmation to exploration.
   
This is necessary because to confirm a hypothesis you must use data independent of the data that you used to generate the hypothesis. Otherwise you will be over optimistic. There is absolutely nothing wrong with exploration, but you should never sell an exploratory analysis as a confirmatory analysis because it is fundamentally misleading. 

If you are serious about doing an confirmatory analysis, one approach is to split your data into three pieces before you begin the analysis:

1.  60% of your data goes into a __training__ (or exploration) set. You're 
    allowed to do anything you like with this data: visualise it and fit tons 
    of models to it.
  
1.  20% goes into a __query__ set. You can use this data to compare models 
    or visualisations by hand, but you're not allowed to use it as part of
    an automated process.

1.  20% is held back for a __test__ set. You can only use this data ONCE, to 
    test your final model. 
    
This partitioning allows you to explore the training data, occasionally generating candidate hypotheses that you check with the query set. When you are confident you have the right model, you can check it once with the test data.

(Note that even when doing confirmatory modelling, you will still need to do EDA. If you don't do any EDA you will remain blind to the quality problems with your data.)