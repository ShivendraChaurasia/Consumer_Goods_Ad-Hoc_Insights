/*
Request 6. Generate a report which contains the top 5 customers who received an
average high pre_invoice_discount_pct for the fiscal year 2021 and in the
Indian market. The final output contains these fields,
customer_code
customer
average_discount_percentage
*/

WITH tbl1 as (
SELECT 
	customer_code AS cust_code_a, 
	AVG(pre_invoice_discount_pct) AS pre_idp 
FROM fact_pre_invoice_deductions
WHERE fiscal_year = 2021
GROUP BY customer_code
),

tbl2 as (
SELECT customer_code AS cust_code_b, customer AS cust FROM dim_customer WHERE market="india"
)

SELECT tbl2.cust_code_b, tbl2.cust, ROUND(tbl1.pre_idp, 4) as average_discount_percentage
FROM tbl1 
JOIN tbl2 
ON tbl1.cust_code_a = tbl2.cust_code_b
ORDER BY average_discount_percentage DESC
LIMIT 5;