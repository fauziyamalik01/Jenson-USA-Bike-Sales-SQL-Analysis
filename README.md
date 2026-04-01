Jenson-USA-Bike-Sales-SQL-Analysis:-

Advanced SQL project on Jenson USA bike retail data, solving 9+ queries like store-wise sales totals, cumulative product quantities, top revenue items per category, high-spending customers, and median pricing using window functions, CTEs, and joins. Showcases analytical SQL skills for e-commerce insights.

Project Objective:-

Craft SQL queries to derive insights on Customer Behaviour, staff performance, inventory management and store operations

Dataset Details:-

We were provided by 3 files:
1. bikes-create objects.sql
2. bikes-load data.sql
3. bikestores_data_dictionary.pdf

The dataset contains information about stores, customers, products, orders, inventory and staff. Since the dataset was provided in sql script format, I was able to recreate database and perform analysis using SQL

Data cleaning & Exploration:-

I performed initial data validations by checking table record counts and reviewing schema relationships including primary keys and foreign keys. 
Example of checks:
1. Using COUNT(*) which checks row counts and confirms tables are loaded successfully
2. Checking for missing or null values by using IS NULL
3. COUNT(*)>1 to check for duplicates
4. Verifying foreign keys relationship by using JOINs to ensure they are linked together properly

Important findings in data:-

1. Focus marketing efforts on high-performing product categories
2. Improve retention strategies for repeated customers, since they genereate more revenue
3. Optimize inventory by prioritizing high-demand products
 
