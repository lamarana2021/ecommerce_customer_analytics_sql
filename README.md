# Project Title: Global E-commerce Customer Analytics (SQL)

## Project Overview
In this project, an  exploratory analysis was performed for an e-commerce company (using a synthetic dataset) to reveal insights into revenue generation, loyalty patterns, customer behaviours and churn characteristics. 

Specifically, the analysis focused on identifying key revenue drivers, evaluating customer value, and exploring patterns  associated with churn and customer retention.

Core areas covered in this project include data exploration, customer profile analysis, customer value analysis, customer segmentation, loyalty analysis, and churn analysis using SQL Server.

## Dataset Description
A synthetic global e-commerce customer dataset of **1,200 customers** obtained from [Kaggle](https://www.kaggle.com/datasets/anasriaz/global-e-commerce-customer-analytics-2024) was used in this project. It includes purchasing behaviour, customer demographics, engagement and target (churn vs retained)

### Key variables
- **Purchase Behaviour:** Revenue, Orders, Average Order Value, Preferred Category, Loyalty Tier, Payment Method
- **Customer Profile:** Country, Gender, Region, Age, Income Bracket
- **Engagement:** Satisfaction Score, Discount Usage, Return Rate, Newsletter Subscription
- **Target Variable:** Churn (1 = churned, 0  = Otherwise)

## Key Business Questions

During the analysis, the following questions were explored:

1. Customer Revenue and Value
   -  Customer segments that generate the highest revenue?
   -  Are there differences in spending behaviours across income groups and loyalty tiers?
  
2. Loyalty Tiers
   - How are customers distributed across loyalty tiers?
   - Which tiers  contribute the most revenue?
   - What purchasing patterns are associated with each loyalty tier?

3. Customer Segmentation
   - How does customer value relate to demographic characteristics?
   - Which customer groups represent high-value segments?

4. Churn Analysis
   - How do churned and retained customers differ in spending behaviour?
   - Are there differences in engagement metrics between churn groups?


## Tools & Technologies used
- SQL Server
- T-SQL
- Common Table Expressions (CTEs)
- Window and Aggregate Functions

## Repository Structure
``` 
ecommerce_customer_analytics/
│   README.md /
│
├───dataset
│       data_dictionary.csv
│       ecommerce_customer_data.csv
│
├───docs
│       placeholder
│
└───scripts
        1_data_quality.sql
        2_customer_profile.sql
        3_customer_value_analysis.sql
        4_customer_segmentation.sql
        5_churn_analysis.sql
        master_file.sql
```
