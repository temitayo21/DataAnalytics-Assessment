# DataAnalytics-Assessment
SQL Proficiency


Each SQL file contains a single, well-commented SQL query that solves the assigned question. Below are detailed explanations of how I approached and solved each question.


Question 1: High-Value Customers with Multiple Products

Objective

Identify customers who have at least:
- One funded savings plan
- One funded investment plan

Also show:
- How many savings and investment plans they own
- Their total confirmed deposit amount, sorted by highest total deposits


Approach

1. Join Tables
   - Joined `plans_plan` with `savings_savingsaccount` using `plan_id`
   - Then joined `users_customuser` using `owner_id` to get customer details

2. Classify Plans
   - Used `CASE` inside `COUNT` to separate:
     - Savings plans: `is_regular_savings = 1`
     - Investment plans: `is_a_fund = 1`

3. Filter Valid Transactions
   - Filtered for deposits with `confirmed_amount > 0`

4. Aggregate
   - Used `GROUP BY` on customer ID to:
     - Count how many of each plan type they own
     - Sum `confirmed_amount` to get total deposits
   - Converted deposit amounts from **kobo to naira** by dividing by 100

5. Filter Qualified Customers
   - Used `HAVING` clause to include only those with at least 1 savings and 1 investment plan



Challenges

Issue | Resolution 

Multiple plan types stored in the same table | Used `CASE` to separate logic inside `COUNT` 
Null deposits or failed transactions | Filtered using `confirmed_amount > 0` 
Filtering after aggregation | Used `HAVING` (not `WHERE`) to filter grouped results 



Question 2: Transaction Frequency Analysis

Objective

Categorize customers based on **how often** they transact:
- High Frequency: ≥ 10 transactions/month
- Medium Frequency: 3–9 transactions/month
- Low Frequency: ≤ 2 transactions/month

Output the count of customers in each group and their average transactions per month


Approach

1. Count Deposits
   - Counted all `confirmed_amount` transactions in `savings_savingsaccount`

2. Calculate Tenure
   - Used MySQL's `TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) + 1` to compute how many months the customer has been active

3. Compute Average Transactions
   - `avg_transactions_per_month = total_transactions / tenure_months`

4. Categorize
   - Used `CASE` to assign each customer a frequency category

5. Summarize
   - Grouped by `frequency_category` to count users and compute the **average transaction rate** per group



Challenges

Issue | Resolution 

Time-based grouping without monthly table | Calculated tenure manually using `TIMESTAMPDIFF()` 
Avoiding division errors | Ensured tenure always ≥ 1 and casted properly for decimal division 
Null handling | Used only rows with valid `confirmed_amount` 

Question 3: Account Inactivity Alert

Objective

Find active accounts(savings or investment) that have had no inflow transactions for over 365 days.

Display:
- `plan_id`, `owner_id`, `type` (Savings/Investment)
- Last transaction date
- Number of days since last inflow


Approach

1. Identify Active Plans
   - Joined `plans_plan` with `savings_savingsaccount` via `plan_id`
   - Filtered only `confirmed_amount > 0` (inflows)

2. Get Last Inflow
   - Used `MAX(transaction_date)` to get the most recent inflow per plan

3. Classify Plan Type
   - Used `CASE`:
     - `is_regular_savings = 1 → 'Savings'`
     - `is_a_fund = 1 → 'Investment'`

4. Calculate Inactivity
   - `DATEDIFF(CURDATE(), last_transaction_date)` gives inactivity days

5. Filter Inactive
   - Returned only plans where inactivity days > 365



Challenges

Issue | Resolution 

No inflow records for some plans | Only included funded (inflow-positive) plans 
Need for latest transaction | Used `MAX(transaction_date)` inside `GROUP BY` 
Calculating inactivity in days | Used MySQL’s `DATEDIFF()` function 


Question 4: Customer Lifetime Value (CLV) Estimation

Objective

Estimate **CLV** for each customer using:
CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction

Where:
- `profit_per_transaction = 0.1%` of the transaction value
- All monetary amounts are in **kobo**, so convert to **naira** (`/100`)



Approach

1. Aggregate Transactions
   - Counted number of `confirmed_amount` transactions
   - Summed their values per customer

2. Calculate Tenure
   - Used `TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) + 1` to calculate months

3. Compute Average Profit
   - `average_value = total_value / total_transactions`
   - `profit_per_transaction = 0.001 * (average_value / 100)`

4. Apply CLV Formula
   - Used full formula to compute CLV in **naira**
   - Used `ROUND(..., 2)` to format to 2 decimal places

5. Sort by Value
   - Sorted output by `estimated_clv DESC` to prioritize top customers



Challenges

 Issue | Resolution 

 Combining monetary and behavioral data | Broke down into logical CTEs for clarity 
 Avoiding integer division | Used decimal math and MySQL’s type inference 
 Tenure in months | Used `TIMESTAMPDIFF()` for precision 


Conclusion

This assessment was a great opportunity to demonstrate my SQL skills in realistic business scenarios, such as customer segmentation, inactivity monitoring, and value forecasting. The main themes were **data aggregation, time-based calculations, joins, CASE expressions**, and ensuring monetary precision.

Let me know if you'd like the queries adapted to older MySQL versions (without CTEs).

