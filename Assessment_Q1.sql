SELECT 
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits  -- convert from kobo to naira
FROM users_customuser u
JOIN plans_plan p ON p.owner_id = u.id
JOIN savings_savingsaccount s ON s.owner_id = u.id AND s.plan_id = p.id
WHERE s.confirmed_amount > 0
GROUP BY u.id, u.name
HAVING 
    savings_count >= 1
    AND investment_count >= 1
ORDER BY total_deposits DESC;
