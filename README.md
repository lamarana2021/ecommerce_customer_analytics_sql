

# Project Title: Global E-commerce Customer Analytics (SQL)
![ecommerce_customer_analytics_sql](image/global-ecommerce.webp)
*Source: [Unidigital](https://undigital.com/hs-fs/hubfs/importance-of-global-ecommerce.webp?width=1200&height=675&name=importance-of-global-ecommerce.webp)*


## Project Overview
In this project, an  exploratory analysis was performed for an e-commerce company (using a synthetic dataset) to reveal insights into revenue generation, loyalty patterns, customer behaviours and churn characteristics. 

Specifically, the analysis focused on identifying key revenue drivers, evaluating customer value, and exploring patterns  associated with churn and customer retention.

Core areas covered in this project include data exploration, customer profile analysis, customer value analysis, customer segmentation, loyalty analysis, and churn analysis using SQL Server.

## Dataset Description
A synthetic global e-commerce customer dataset of **1,200 customers** obtained from [Kaggle](https://www.kaggle.com/datasets/anasriaz/global-e-commerce-customer-analytics-2024) was used in this project. It includes purchasing behaviour, customer demographics, engagement and target (churn vs retained)

### Key Variables
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
- Github 
- Common Table Expressions (CTEs)
- Window and Aggregate Functions


## Repository Structure
``` 
ecommerce_customer_analytics
│   README.md 
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

## Structure Description
- **dataset:** This folder contains the *data dictionary*, which includes the variables, data type, and description. It also contains the actual <br>
  *e-commerce customer dataset*.
- **docs:** This would contain the pdf files for the project later on.
- **scripts:** This folder contains the SQL Server queries used for data quality checks, customer profile, customer value,  churn analysis and a master file which is basically a union of all sql files (1-5).

## Data Analysis

### 1. Data Quality
   - Available columns and dataset structure were reviewed
   - Null value checking across columns
   - Verifying remaining data
### 2. Customer Profile
   - Customer profile based on demographic, income and loyalty characteristics to understand the composition of the customer base.
### 3. Customer Value Analysis
   - Evaluated customer value and purchasing behaviour by loyalty tier
   - Identified the top 5 countries in terms of revenue contribution and order volume
   - Ranked countries based on revenue contribution
### 4. Customer Segmentation Analysis
   - Compared spending behaviour and lifetime across age groups
   - Identified the loyalty tier that has the largest number of customers in each income group
   - Identified the top 3 preferred categories in each loyalty tier
   - For each income group, identify the percentage of customers belonging to each loyalty tier
### 5. Churn Analysis
   - Compare lifetime and purchasing behaviour (spending, orders, recency) between churned and retained customers
   - Analyse churn by loyalty tiers, income groups and regions
   - Investigated whether customer engagement factors, including satisfaction, newsletter subscription, discounts, and returns, were associated with churn.

## Key Insights
### Customer Profile Analysis: 
   - Customer profile analysis revealed the distribution of customers across demographic, geographic, and loyalty tiers. Across loyalty tiers, Silver and Gold had       equal numbers of customers, with Platinum slightly fewer and Bronze the fewest.
   - Lower-income groups accounted for approximately **65%** of customers, and **66%** of customers reside in Europe and North America, with the UK, Germany, and       the US having the largest markets.
     
### Customer Value Analysis:
   - Customer value analysis revealed that Platinum customers contributed about **77%** in the dataset, indicating a strong concentration of customers across high-value customers. Moreover, while the US, UK and Germany were found to be the top 3 countries in terms of revenue and number of orders, the average order           value of the UK and Germany was larger than that of the US, suggesting differences in purchasing behaviour across countries

   - Across countries, the average revenue per customer varies significantly, with Spain, the UK, Germany, Australia, and Brazil showing the highest average revenue per customer, and the US showing a low level (ranked 12) of average customer revenue contribution. This clearly shows a difference between market size and   individual customer value, suggesting the need for growth strategies targeting both customer volume and spending behaviour.

### Customer Segmentation Analysis
   - Customer segmentation analysis showed that the Platinum tier recorded the highest number of customers in the higher income brackets, while the Gold tier was the highest in the mid-level income brackets, and the Silver tier was the highest in the lower income bracket.
     
   - Preferred product categories varied across loyalty tiers, with Platinum customers showing stronger preferences for categories such as Clothing & Fashion, Food & Groceries, and Beauty & Personal Care. This suggests opportunities for targeted marketing and personalised product recommendations across customer groups.

### Churn Analysis
   - Churn analysis revealed that approximately **67%** of customers churned, and only about **33%** did not churn. Despite the low number of retained customers,       they contributed about **68%** of average spending. Moreover, retained customers had higher average order volume and lifetime, which suggests that high-value customers are more likely to be retained and vice versa.
   - Lower  loyalty tiers had the highest level of churn, with Bronze having about **88%** churn and contributing to a loss of about  **$28K**. However, Platinum       customers, with a churn rate of about 58%, led to a **2.58M revenue loss**. This highlights the importance of retention strategies that prioritise high-value customers while also reducing churn among lower-value customers.

### Future Improvements
   - Use machine learning techniques to identify customers at a high risk of churn
   - Improve stakeholder reporting and data visualisation by using interactive tools such as Power BI
   - Use a real-world e-commerce dataset to find out whether the behavioural patterns  and churn drivers would generalise to real business environments




## Author
**LAMARANA BAH**  
Data Analyst | Financial Analyst | Business Analyst  
[LinkedIn](https://www.linkedin.com/in/lamaranabah/)








