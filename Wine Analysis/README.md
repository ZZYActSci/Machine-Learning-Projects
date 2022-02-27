# Wine Analysis
 Enterprise Team Project

# Team Profile

## Product Owners/Project Managers
- Zhi Cheng (Zack) Tan ; @ZCTan762
- Matthew Lundrigan ; @mattlundrigan

## Data Analysts
- Ziye Zhang ; @ZZYActSci
- Gautami Edara ; @gautamiedara
- Erik Moore ; @moorerik

## Data Scientists
- Kelly Agnew ; @kelly-agnew
- Vaibhav Vishal ; @vvaibhav11
- Jiahua Liang ; @Jhliang3


# Business Cases

## Finding the factors that affect wine prices (Stakeholders - Vineyard)
Use prediction modelling to identify the type of grapes vineyard owners should grow in order to maximize profit and meet market demands, taking into account their country and climate. 

## Inventory Management & Pricing (Stakeholders - Retailers)
Using Causal Inference and prediction modeling to see how strongly certain factors (such as origin of wine) influence control/treatment factors (such as vintage) in predicting price of wine. This will allow retailers to mix and match predictors to identify which wines to import to maximize profit while ensuring a diverse enough product range. The prediction model could also be used to help retailers price new wines at a rate that would be competitive with the market. 

## Recommendation System (Stakeholders - Customers) - To be covered in the next course 
Helping customers select wine based on their preferred attributes (e.g. fruity, spicy) and at their specified price points.

# Dataset

The dataset used for this project along with a description of the variables can be found at: https://www.kaggle.com/zynicide/wine-reviews. The dataset originally contained roughly 130'000 wines. However, upon exploration the team discovered that roughly 10'000 of these were duplicates. After removing the duplicates the dataset left for analysis contained approximately 120'000 unique wines.

# Project Overview

## Data Exploration
The team performed an in-depth analysis of the dataset. This included checking for missing values, correlation between variables, and visualizing the distribution of variables along with their relationship with price. The team also checked the level of cardinality (number of unique instances) of the dataset. 

## Data Pre-processing
This section will provide a high level overview of the pre-processing steps taken with each of the variables in the dataset. A pipeline for each variable was built and then combined into one larger pipeline that handles the pre-processing for the entire dataset. The team also investigated using min-max scaling and standard z-score scaling prior to feeding the pre-processed data to the prediction models, and found that z-score performed better across the board. Data pre-processing is a crucial and necessary step in the prediction process as it can drastically improve improve model performance. 

### Description

Using the wine aroma and non-aroma wheel, the team used natural language processing techniques to extract key attributes of each wine from their descriptions, represented in a TF-IDF vectorization format. This step will help the team identify wine attributes that are more associated with higher price points, as well as help when building the recommendation model in the second course.  

### Region 2

This variable was empty for over 60% of the dataset, so a binary representation was used indicating whether or not Region 2 was filled in for a specific wine, as opposed to the region 2 value itself. 

### Taster Name
This column had a high cardinality, so the top 5 tasters by frequency were kept, with the rest being mapped to 'Other'.

### Title
All of the information within this column was already captured in other columns of the dataset witht he exception of the vintage (the year the wine was produced). This was then extracted for use in causal analysis and prediction modelling. For instances where the title didn't contain a year, the mean of the dataset was imputed.

### Variety, Region 1 and Province 
These columns had a very high cardinality, the top 20 by frequency were kept with the rest being mapped to 'Other'. 

### Country
This column also had a very high cardinality, so the top 10 by frequency were kept with the rest being mapped to 'Other'.

## Modeling
As the price prediction is one of the primary focuses of this project, the main performance metrics for modelling were Root Mean Squared Error (RMSE) and Mean Average Error (MAE). Basic linear regression, decision tree, random forest, gradient boosting, support vector machine and multi-layer perceptron (MLP) regression models were trained and evaluated based on the performance metrics outlined above as well as runtimes. 

In addition to the prediction modeling, random forest was used to identify feature importances.

### Model Refinement

The team used GridSearchCV and RandomSearchCV on the two most promising algorithms (Random Forest and Gradient Boosting) to determine the optimal hyperparameters. Due to the size of the dataset and computing constraints, smaller grids were used for this optimization process. 

## Causal Analysis
The team used Causal ML to investigate the Average Treatment Effect of the wine vintage (year it was produced) and the points (quality score on a 100 point scale graded by a sommelier). Two models were generated for each treatment, one using the LGBM regressor with an S-Learner, and one using a T-Learner with an XGBT regressor. The shapley plots were also generated to see how the effect of the treatments varies based on other attributes of the wine.   



