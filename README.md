## Regression modelling: step by step
Install and loading packages

    # install.packages("readr", dependencies = TRUE)
    # install.packages("Hmisc", dependencies = TRUE)
    # install.packages("pastecs", dependencies = TRUE)
    # install.packages("psych", dependencies = TRUE)
    # install.packages("skimr", dependencies = TRUE)
    # install.packages("AER", dependencies = TRUE)
    # install.packages("MASS", dependencies = TRUE)
    
    library(AER)
    library(readr)
    library(pastecs)
    library(psych)
    library(skimr)
    library(MASS)
    
    # Load the data
    data(CollegeDistance)
    names(CollegeDistance)
    > names(CollegeDistance)
     [1] "gender"    "ethnicity" "score"     "fcollege"  "mcollege" 
     [6] "home"      "urban"     "unemp"     "wage"      "distance" 
    [11] "tuition"   "education" "income"    "region"

Check the descriptive statistics
# Descriptive statistics

    #Hmisc::describe(CollegeDistance)
    #pastecs::stat.desc(CollegeDistance)
    psych::describe(CollegeDistance)
    skimr::skim(CollegeDistance)
    
    > psych::describe(CollegeDistance)
     vars    n  mean   sd median trimmed   mad   min   max range  skew kurtosis   se
    gender*       1 4739  1.55 0.50   2.00    1.56  0.00  1.00  2.00  1.00 -0.20    -1.96 0.01
    ethnicity*    2 4739  1.55 0.79   1.00    1.43  0.00  1.00  3.00  2.00  0.99    -0.69 0.01
    score         3 4739 50.89 8.70  51.19   50.91 10.24 28.95 72.81 43.86 -0.03    -0.88 0.13
    fcollege*     4 4739  1.21 0.41   1.00    1.14  0.00  1.00  2.00  1.00  1.44     0.07 0.01
    mcollege*     5 4739  1.14 0.34   1.00    1.05  0.00  1.00  2.00  1.00  2.11     2.44 0.01
    home*         6 4739  1.82 0.38   2.00    1.90  0.00  1.00  2.00  1.00 -1.67     0.78 0.01
    urban*        7 4739  1.23 0.42   1.00    1.17  0.00  1.00  2.00  1.00  1.26    -0.40 0.01
    unemp         8 4739  7.60 2.76   7.10    7.32  2.22  1.40 24.90 23.50  1.56     5.40 0.04
    wage          9 4739  9.50 1.34   9.68    9.47  1.17  6.59 12.96  6.37  0.09    -0.26 0.02
    distance     10 4739  1.80 2.30   1.00    1.36  1.04  0.00 20.00 20.00  3.00    13.03 0.03
    tuition      11 4739  0.81 0.34   0.82    0.82  0.45  0.26  1.40  1.15 -0.15    -1.05 0.00
    education    12 4739 13.81 1.79  13.00   13.66  1.48 12.00 18.00  6.00  0.44    -1.23 0.03
    income*      13 4739  1.29 0.45   1.00    1.24  0.00  1.00  2.00  1.00  0.94    -1.12 0.01
    region*      14 4739  1.20 0.40   1.00    1.12  0.00  1.00  2.00  1.00  1.51     0.27 0.01 
    
    > skimr::skim(CollegeDistance) Skim summary statistics
     n obs: 4739 
     n variables: 14 
    
    ── Variable type:factor ───────────────────────────────────────────────────────────────────────────────
      variable missing complete    n n_unique                           top_counts ordered
     ethnicity       0     4739 4739        3 oth: 3050, his: 903, afa: 786, NA: 0   FALSE
      fcollege       0     4739 4739        2            no: 3753, yes: 986, NA: 0   FALSE
        gender       0     4739 4739        2          fem: 2600, mal: 2139, NA: 0   FALSE
          home       0     4739 4739        2            yes: 3887, no: 852, NA: 0   FALSE
        income       0     4739 4739        2          low: 3374, hig: 1365, NA: 0   FALSE
      mcollege       0     4739 4739        2            no: 4088, yes: 651, NA: 0   FALSE
        region       0     4739 4739        2           oth: 3796, wes: 943, NA: 0   FALSE
         urban       0     4739 4739        2           no: 3635, yes: 1104, NA: 0   FALSE
    
    ── Variable type:numeric ──────────────────────────────────────────────────────────────────────────────
      variable missing complete    n  mean   sd    p0   p25   p50   p75  p100     hist
      distance       0     4739 4739  1.8  2.3   0     0.4   1     2.5  20    ▇▂▁▁▁▁▁▁
     education       0     4739 4739 13.81 1.79 12    12    13    16    18    ▇▃▂▂▁▃▁▁
         score       0     4739 4739 50.89 8.7  28.95 43.92 51.19 57.77 72.81 ▁▅▆▇▇▇▃▁
       tuition       0     4739 4739  0.81 0.34  0.26  0.48  0.82  1.13  1.4  ▅▅▂▆▅▂▇▂
         unemp       0     4739 4739  7.6  2.76  1.4   5.9   7.1   8.9  24.9  ▂▇▆▂▁▁▁▁
          wage       0     4739 4739  9.5  1.34  6.59  8.85  9.68 10.15 12.96 ▂▃▅▃▇▁▂▁

**Model selection**

    start.model <- lm(education ~ score + urban + distance + tuition, data = CollegeDistance)
    simple.model <- lm(education ~ 1, data = CollegeDistance)
    MASS::stepAIC(start.model, scope = list(upper = start.model, lower = simple.model), direction = "backward")
    Start:  AIC=4339.19
    education ~ score + urban + distance + tuition
    
               Df Sum of Sq   RSS    AIC
    - urban     1       0.5 11815 4337.4
    <none>                  11815 4339.2
    - tuition   1      10.8 11826 4341.5
    - distance  1      53.3 11868 4358.5
    - score     1    3178.2 14993 5466.2
    
    Step:  AIC=4337.39
    education ~ score + distance + tuition
    
               Df Sum of Sq   RSS    AIC
    <none>                  11815 4337.4
    - tuition   1        11 11826 4339.8
    - distance  1        62 11877 4360.2
    - score     1      3205 15020 5472.8
    
    Call:
    lm(formula = education ~ score + distance + tuition, data = CollegeDistance)
    
    Coefficients:
    (Intercept)        score     distance      tuition  
        9.15680      0.09547     -0.05013     -0.14369

**(Almost) Full  model**

    fmodel <- lm(education ~ gender + ethnicity + score + fcollege + home + urban + wage + + distance + income, data = CollegeDistance) 
    summary(fmodel)  
    
    Call:
    lm(formula = education ~ gender + ethnicity + score + fcollege + 
        home + urban + wage + distance + income, data = CollegeDistance)
    
    Residuals:
        Min      1Q  Median      3Q     Max 
    -3.9950 -1.1381 -0.2271  1.1472  5.2514 
    
    Coefficients:
                      Estimate Std. Error t value Pr(>|t|)    
    (Intercept)        8.94259    0.22566  39.629  < 2e-16 ***
    genderfemale       0.13371    0.04505   2.968  0.00301 ** 
    ethnicityafam      0.34022    0.06749   5.041 4.80e-07 ***
    ethnicityhispanic  0.33940    0.06130   5.537 3.24e-08 ***
    score              0.09084    0.00284  31.986  < 2e-16 ***
    fcollegeyes        0.66089    0.06027  10.965  < 2e-16 ***
    homeyes            0.15746    0.05944   2.649  0.00810 ** 
    urbanyes           0.05119    0.05663   0.904  0.36605    
    wage              -0.03141    0.01695  -1.854  0.06387 .  
    distance          -0.02630    0.01031  -2.552  0.01075 *  
    incomehigh         0.39934    0.05364   7.444 1.15e-13 ***
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
    
    Residual standard error: 1.534 on 4728 degrees of freedom
    Multiple R-squared:  0.266,	Adjusted R-squared:  0.2645 
    F-statistic: 171.4 on 10 and 4728 DF,  p-value: < 2.2e-16

**Breakdown**

    install.packages("devtools", dependencies = TRUE)
    devtools::install_github("pbiecek/breakDown")
    library(breakDown)
    new_observation <- CollegeDistance[1,]
    br <- broken(fmodel, new_observation)
    br
    plot(br)
![enter image description here](https://github.com/haseebmahmud/RegressionStepbyStep/blob/master/1.png)

**jtools model comparison**

    #devtools::install_github("jacob-long/jtools")
    library(jtools)
    
    jtools::summ(fmodel)
    jtools::summ(fmodel, scale = TRUE, vifs = TRUE, part.corr = TRUE, 
                 confint = TRUE, pvals = FALSE)
    
    
    model1 <- lm(education ~ gender + ethnicity + score, data = CollegeDistance)
    model2 <- lm(education ~ gender + ethnicity + score + fcollege + home, data = CollegeDistance)
    model3 <- lm(education ~ gender + ethnicity + score + fcollege + home + urban + wage + 
                   distance + income, data = CollegeDistance)
    
    # coef.names <- c("Gender" = "gender", "Ethnicity" = "ethnicity", )

Model outputs,

    > library(huxtable) > jtools::export_summs(model1, model2, model3, scale = TRUE, transform.response=TRUE) ───────────────────────────────────────────────────────────
                        Model 1       Model 2       Model 3    
                    ───────────────────────────────────────────
      (Intercept)       -0.08 ***     -0.29 ***     -0.33 ***  
                        (0.02)        (0.04)        (0.04)     
      gender             0.06 *        0.07 **       0.07 **   
                        (0.03)        (0.03)        (0.03)     
      ethnicityafam      0.16 ***      0.20 ***      0.19 ***  
                        (0.04)        (0.04)        (0.04)     
      ethnicityhisp      0.13 ***      0.18 ***      0.19 ***  
      anic                                                     
                        (0.03)        (0.03)        (0.03)     
      score              0.49 ***      0.45 ***      0.44 ***  
                        (0.01)        (0.01)        (0.01)     
      fcollege                         0.46 ***      0.37 ***  
                                      (0.03)        (0.03)     
      home                             0.11 **       0.09 **   
                                      (0.03)        (0.03)     
      urban                                          0.03      
                                                    (0.03)     
      wage                                          -0.02      
                                                    (0.01)     
      distance                                      -0.03 *    
                                                    (0.01)     
      income                                         0.22 ***  
                                                    (0.03)     
                    ───────────────────────────────────────────
      N               4739          4739          4739         
      R2                 0.22          0.26          0.27      
    ───────────────────────────────────────────────────────────
      *** p < 0.001; ** p < 0.01; * p < 0.05.                  
    
    Column names: names, Model 1, Model 2, Model 3

Plot comparison, 

    ## Bug: Error: Install the ggstance package to use the plot_coefs function.
    # install.packages("ggstance", dependencies = TRUE)
    library(ggstance)
    plot_summs(model1, model2, model3, scale = TRUE, robust = "HC3")

![enter image description here](https://github.com/haseebmahmud/RegressionStepbyStep/blob/master/2.png)

Distribution plot comparison,

    plot_summs(model3, scale = TRUE, robust = "HC3", plot.distributions = TRUE)

![enter image description here](https://github.com/haseebmahmud/RegressionStepbyStep/blob/master/3.png)

