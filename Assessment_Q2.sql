WITH customer_monthly_txn AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,

        (YEAR(CURDATE()) - YEAR(MIN(u.date_joined))) * 12 + (MONTH(CURDATE()) - MONTH(MIN(u.date_joined))) + 1 AS tenure_months,

        ROUND(COUNT(*) / ((YEAR(CURDATE()) - YEAR(MIN(u.date_joined))) * 12 + (MONTH(CURDATE()) - MONTH(MIN(u.date_joined))) + 1), 2) AS avg_txn_per_month
    FROM savings_savingsaccount s
    JOIN users_customuser u ON s.owner_id = u.id
    GROUP BY s.owner_id
),

categorized_customers AS (
    SELECT 
        owner_id,
        total_transactions,
        tenure_months,
        avg_txn_per_month,
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_monthly_txn
)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
        ELSE 4
    END;
