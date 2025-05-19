WITH transaction_stats AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) AS total_transaction_value_kobo
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount IS NOT NULL
    GROUP BY s.owner_id
),

customer_tenure AS (
    SELECT
        u.id AS customer_id,
        u.name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) + 1 AS tenure_months
    FROM users_customuser u
)


SELECT
    c.customer_id,
    c.name,
    c.tenure_months,
    t.total_transactions,
    
    ROUND(
        (t.total_transactions / c.tenure_months) * 12 *
        ((t.total_transaction_value_kobo / t.total_transactions) / 100 * 0.001),
        2
    ) AS estimated_clv
FROM customer_tenure c
JOIN transaction_stats t ON c.customer_id = t.owner_id
ORDER BY estimated_clv DESC;

