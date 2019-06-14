
The broom package provides three general tools for turning models into tidy data frames:

1.  `broom::glance(model)` returns a row for each model. Each column gives a 
    model summary: either a measure of model quality, or complexity, or a 
    combination of the two.
   
1.  `broom::tidy(model)` returns a row for each coefficient in the model. Each 
    column gives information about the estimate or its variability.
    
1.  `broom::augment(model, data)` returns a row for each row in `data`, adding
    extra values like residuals, and influence statistics.
